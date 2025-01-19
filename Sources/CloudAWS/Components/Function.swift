import Foundation

extension AWS {
    public struct Function: AWSComponent, EnvironmentProvider {
        public let role: Role
        public let rolePolicyAttachment: Resource
        public let function: Resource
        public let functionUrl: Resource?
        public let environment: Environment

        public var name: Output<String> {
            function.name
        }

        public var region: Output<String> {
            getARN(function).region
        }

        public var hostname: Output<String> {
            guard let functionUrl else {
                fatalError("Function created without a url. Please pass `url: .enabled()` to the function constructor.")
            }
            let urlId = functionUrl.output.keyPath("urlId")
            return "\(urlId).lambda-url.\(region).on.aws"
        }

        public var url: Output<String> {
            return "https://\(hostname)"
        }

        public init(
            _ name: String,
            targetName: String,
            url: FunctionURL = .disabled,
            memory: Int = 1769,
            timeout: Duration = .seconds(10),
            reservedConcurrency: Int? = nil,
            environment: [String: any Input<String>]? = nil,
            vpc: VPC.Configuration? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.environment = Environment(environment, shape: .keyValue)

            role = AWS.Role(
                "\(name)-role",
                service: "lambda.amazonaws.com",
                options: options
            )

            rolePolicyAttachment = Resource(
                name: "\(name)-rpa",
                type: "aws:iam:RolePolicyAttachment",
                properties: [
                    "role": "\(role.name)",
                    "policyArn": vpc == nil
                        ? "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
                        : "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
                ],
                options: options,
                context: context
            )

            function = Resource(
                name: name,
                type: "aws:lambda:Function",
                properties: [
                    "role": "\(role.arn)",
                    "packageType": "Zip",
                    "runtime": "provided.al2",
                    "handler": "bootstrap",
                    "code": [
                        "fn::fileArchive": "\(Context.buildDirectory)/lambda/\(targetName)/package.zip"
                    ],
                    "architectures": [Architecture.current.lambdaArchitecture],
                    "memorySize": memory,
                    "timeout": timeout.components.seconds,
                    "environment": [
                        "variables": self.environment
                    ],
                    "reservedConcurrentExecutions": reservedConcurrency,
                    "vpcConfig": vpc.map {
                        [
                            "subnetIds": $0.subnetIds,
                            "securityGroupIds": $0.securityGroupIds,
                        ]
                    },
                ],
                options: options,
                context: context
            )

            functionUrl =
                switch url {
                case .disabled:
                    nil
                case .enabled(let cors, let invokeMode):
                    Resource(
                        name: "\(name)-url",
                        type: "aws:lambda:FunctionUrl",
                        properties: [
                            "functionName": "\(function.name)",
                            "authorizationType": "NONE",
                            "invokeMode": invokeMode.rawValue,
                            "cors": cors
                                ? [
                                    "allowCredentials": true,
                                    "allowOrigins": ["*"],
                                    "allowMethods": ["*"],
                                    "allowHeaders": ["*"],
                                    "maxAge": 86400,
                                ]
                                : nil,
                        ],
                        options: options,
                        context: context
                    )
                }

            context.store.build {
                try await $0.builder.buildAmazonLinux(targetName: targetName)
                try await $0.builder.packageForAwsLambda(targetName: targetName)
            }
        }
    }
}

extension AWS.Function {
    public enum FunctionURL {
        case disabled
        case enabled(cors: Bool = true, invokeMode: FunctionInvokeMode = .buffered)
    }

    public enum FunctionInvokeMode: String {
        case buffered = "BUFFERED"
        case streaming = "RESPONSE_STREAM"
    }
}

extension AWS.Function: RoleProvider {}

extension AWS.Function: Linkable {
    public var actions: [String] {
        ["lambda:InvokeFunction"]
    }

    public var resources: [Output<String>] {
        [function.arn]
    }

    public var properties: LinkProperties? {
        return .init(
            type: "function",
            name: function.chosenName,
            properties: [
                "name": name,
                "url": url,
            ]
        )
    }
}
