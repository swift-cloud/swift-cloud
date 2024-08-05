import Foundation

extension aws {
    public struct Function: Component {
        internal let imageRepository = ImageRepository.shared
        internal let dockerImage: DockerImage
        internal let role: Resource
        internal let rolePolicyAttachment: Resource
        internal let function: Resource
        internal let functionUrl: Resource

        public var url: String {
            functionUrl.keyPath("functionUrl")
        }

        public init(_ name: String, targetName: String) {
            dockerImage = DockerImage(
                "\(name)-image",
                imageRepository: imageRepository,
                dockerFilePath: dockerFilePath(name)
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
                        """
                    )
                ]
            )
            rolePolicyAttachment = Resource(
                "\(name)-role-policy-attachment",
                type: "aws:iam:RolePolicyAttachment",
                properties: [
                    "role": "\(role.keyPath("name"))",
                    "policyArn": "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
                ]
            )
            function = Resource(
                "\(name)-lambda",
                type: "aws:lambda:Function",
                properties: [
                    "role": "\(role.keyPath("arn"))",
                    "packageType": "Image",
                    "imageUri": "\(dockerImage.uri)",
                    "architectures": [Architecture.current.lambdaString],
                ]
            )
            functionUrl = Resource(
                "\(name)-url",
                type: "aws:lambda:FunctionUrl",
                properties: [
                    "functionName": "\(function.keyPath("name"))",
                    "authorizationType": "NONE",
                ]
            )
            Command.Store.invoke {
                let dockerFile = """
                    FROM public.ecr.aws/lambda/provided:al2023

                    COPY ./.build/aarch64-unknown-linux-gnu/release/\(targetName) /var/runtime/bootstrap

                    CMD [ "\(targetName)" ]
                    """
                try createFile(atPath: dockerFilePath(name), contents: dockerFile)
            }
            Command.Store.build {
                try await $0.buildAmazonLinux(targetName: targetName)
            }
        }
    }
}
