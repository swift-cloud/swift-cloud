import Foundation

extension AWS {
    public struct Function: Component, EnvironmentProvider {
        public let dockerImage: DockerImage
        public let role: Role
        public let rolePolicyAttachment: Resource
        public let function: Resource
        public let functionUrl: Resource
        public let environment: Environment

        public var name: String {
            function.name
        }

        public var url: String {
            functionUrl.keyPath("functionUrl")
        }

        public init(
            _ name: String,
            targetName: String,
            memory: Int? = nil,
            timeout: TimeInterval? = nil,
            reservedConcurrency: Int? = nil,
            cors: Bool? = nil,
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
                    "timeout": timeout.map { Int($0) },
                    "environment": [
                        "variables": self.environment
                    ],
                    "reservedConcurrentExecutions": reservedConcurrency,
                ],
                options: options
            )

            functionUrl = Resource(
                name: "\(name)-url",
                type: "aws:lambda:FunctionUrl",
                properties: [
                    "functionName": "\(function.name)",
                    "authorizationType": "NONE",
                    "cors": cors == true
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

extension AWS.Function: RoleProvider {}

extension AWS.Function: Linkable {
    public var actions: [String] {
        ["lambda:InvokeFunction"]
    }

    public var resources: [String] {
        [function.arn]
    }

    public var environmentVariables: [String: String] {
        [
            "function:\(function.internalName):name": name,
            "function:\(function.internalName):url": url,
        ]
    }
}
