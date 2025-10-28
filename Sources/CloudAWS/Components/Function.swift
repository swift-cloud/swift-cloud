import Foundation

extension AWS {
    public struct Function: AWSComponent, EnvironmentProvider {
        public let role: Role
        public let rolePolicyAttachment: Resource
        public let function: Resource
        public let functionUrl: Resource?
        public let environment: Environment
        public let dockerImage: DockerImage?

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
            packageType: FunctionPackageType = .zip,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            let dockerFilePath = Docker.Dockerfile.filePath(name)

            self.environment = Environment(environment, shape: .keyValue)

            dockerImage =
                switch packageType {
                case .zip:
                    nil
                case .image:
                    DockerImage(
                        "\(name)-image",
                        imageRepository: .shared(options: options),
                        dockerFilePath: dockerFilePath,
                        options: options
                    )
                }

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
                    "packageType": packageType == .zip ? "Zip" : "Image",
                    "runtime": packageType == .zip ? "provided.al2" : nil,
                    "handler": packageType == .zip ? "bootstrap" : nil,
                    "code": packageType == .zip
                        ? ["fn::fileArchive": "\(Context.buildDirectory)/lambda/\(targetName)/package.zip"]
                        : nil,
                    "imageUri": dockerImage.map { "\($0.uri)" },
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
                            "securityGroupIds": [$0.securityGroupId],
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

            // AWS requires a new permission for public function url access
            if functionUrl != nil {
                Resource(
                    name: "\(name)-invoke-permission",
                    type: "aws:lambda:Permission",
                    properties: [
                        "action": "lambda:InvokeFunction",
                        "function": function.arn,
                        "principal": "*",
                            // TODO: Enable when Pulumi supports function url invocation context
                            // "invokedViaFunctionUrl": true,
                    ],
                    options: options,
                    context: context
                )
            }

            context.store.build { ctx in
                try await ctx.builder.buildAmazonLinux(targetName: targetName)
                switch packageType {
                case .zip:
                    try await ctx.builder.packageForAwsLambda(targetName: targetName)
                case .image:
                    let dockerFile = Docker.Dockerfile.awsLambda(targetName: targetName)
                    try Docker.Dockerfile.write(dockerFile, to: dockerFilePath)
                }
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

    public enum FunctionPackageType {
        case zip
        case image
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

extension AWS.Function {
    @discardableResult
    internal func grantInvokePermission(to resource: Resource, principal: String) -> Self {
        return grantInvokePermission(
            name: resource.chosenName,
            arn: resource.arn,
            principal: principal
        )
    }

    @discardableResult
    internal func grantInvokePermission(
        name: any Input<String>,
        arn: any Input<String>,
        principal: String
    ) -> Self {
        _ = Resource(
            name: tokenize(name, function.chosenName, "invoke-permission"),
            type: "aws:lambda:Permission",
            properties: [
                "action": "lambda:InvokeFunction",
                "function": function.name,
                "principal": principal,
                "sourceArn": arn,
            ],
            options: function.options,
            context: function.context
        )
        return self
    }
}
