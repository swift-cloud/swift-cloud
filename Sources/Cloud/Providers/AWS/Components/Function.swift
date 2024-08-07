import Foundation

extension aws {
    public struct Function: Component {
        public let dockerImage: DockerImage
        public let role: Resource
        public let rolePolicyAttachment: Resource
        public let function: Resource
        public let functionUrl: Resource

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

            dockerImage = DockerImage(
                "\(name)-image",
                imageRepository: .shared(options: options),
                dockerFilePath: dockerFilePath,
                options: options
            )

            role = Resource(
                name: "\(name)-role",
                type: "aws:iam:Role",
                properties: [
                    "assumeRolePolicy": Resource.JSON(
                        """
                        {
                            "Version": "2012-10-17",
                            "Statement": [
                                {
                                    "Effect": "Allow",
                                    "Principal": {
                                        "Service": "lambda.amazonaws.com"
                                    },
                                    "Action": "sts:AssumeRole"
                                }
                            ]
                        }
                        """)
                ],
                options: options
            )

            rolePolicyAttachment = Resource(
                name: "\(name)-role-policy-attachment",
                type: "aws:iam:RolePolicyAttachment",
                properties: [
                    "role": "\(role.name)",
                    "policyArn": "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
                ],
                options: options
            )

            function = Resource(
                name: "\(name)",
                type: "aws:lambda:Function",
                properties: [
                    "role": "\(role.arn)",
                    "packageType": "Image",
                    "imageUri": "\(dockerImage.uri)",
                    "architectures": [Architecture.current.lambdaArchitecture],
                    "memorySize": .init(memory),
                    "timeout": timeout.map { .init(Int($0)) },
                    "environment": environment.map { ["variables": $0] },
                    "reservedConcurrentExecutions": .init(reservedConcurrency),
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
                try createFile(atPath: dockerFilePath, contents: dockerFile)
            }

            Context.current.store.build {
                try await $0.builder.buildAmazonLinux(targetName: targetName)
            }
        }
    }
}

extension aws.Function: RoleProvider {}

extension aws.Function: Linkable {
    public var actions: [String] {
        ["lambda:InvokeFunction"]
    }

    public var resources: [String] {
        [function.arn]
    }
}
