import Foundation

extension aws {
    public struct Function: Component {
        internal let dockerImage: DockerImage
        internal let role: Resource
        internal let rolePolicyAttachment: Resource
        internal let function: Resource
        internal let functionUrl: Resource

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
                "\(name)-role",
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
                "\(name)-role-policy-attachment",
                type: "aws:iam:RolePolicyAttachment",
                properties: [
                    "role": "\(role.name)",
                    "policyArn": "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
                ],
                options: options
            )

            function = Resource(
                "\(name)-lambda",
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
                "\(name)-url",
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

            Store.current.invoke {
                let dockerFile = Docker.Dockerfile.awsLambda(targetName: targetName)
                try createFile(atPath: dockerFilePath, contents: dockerFile)
            }

            Store.current.build {
                try await $0.buildAmazonLinux(targetName: targetName)
            }
        }
    }
}
