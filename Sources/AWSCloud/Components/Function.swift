import Foundation

extension AWS {
    public struct Function: AWSComponent, EnvironmentProvider {
        public let dockerImage: DockerImage
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
            memory: Int? = nil,
            timeout: Duration? = nil,
            reservedConcurrency: Int? = nil,
            environment: [String: String]? = nil,
            options: Resource.Options? = nil
        ) {
            let dockerFilePath = Docker.Dockerfile.filePath(name)

            self.environment = Environment(environment, shape: .keyValue)

            dockerImage = DockerImage(
                "\(name)-image",
                imageRepository: .shared(options: options),
                dockerFilePath: dockerFilePath,
                options: options
            )

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
                    "policyArn": "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
                ],
                options: options
            )

            function = Resource(
                name: name,
                type: "aws:lambda:Function",
                properties: [
                    "role": "\(role.arn)",
                    "packageType": "Image",
                    "imageUri": "\(dockerImage.uri)",
                    "architectures": [Architecture.current.lambdaArchitecture],
                    "memorySize": memory,
                    "timeout": timeout?.components.seconds,
                    "environment": [
                        "variables": self.environment
                    ],
                    "reservedConcurrentExecutions": reservedConcurrency,
                ],
                options: options
            )

            functionUrl =
                switch url {
                case .disabled:
                    nil
                case .enabled(let cors):
                    Resource(
                        name: "\(name)-url",
                        type: "aws:lambda:FunctionUrl",
                        properties: [
                            "functionName": "\(function.name)",
                            "authorizationType": "NONE",
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
                        options: options
                    )
                }

            Context.current.store.invoke { _ in
                let dockerFile = Docker.Dockerfile.awsLambda(targetName: targetName)
                try Docker.Dockerfile.write(dockerFile, to: dockerFilePath)
            }

            Context.current.store.build {
                try await $0.builder.buildAmazonLinux(targetName: targetName)
            }
        }
    }
}

extension AWS.Function {
    public enum FunctionURL {
        case enabled(cors: Bool = true)
        case disabled
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

    public var environmentVariables: [String: Output<String>] {
        [
            "function \(function.chosenName) name": name,
            "function \(function.chosenName) url": url,
        ]
    }
}
