import Foundation

extension AWS {
    public struct DockerImage: AWSResourceProvider {
        public let resource: Resource

        public var uri: Output<String> {
            output.keyPath("imageUri")
        }

        public init(
            _ name: String,
            imageRepository: ImageRepository,
            dockerFilePath: String,
            dockerContext: String = Context.projectDirectory,
            dockerPlatform: String = Architecture.current.dockerPlatform,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = Resource(
                name: name,
                type: "awsx:ecr:Image",
                properties: [
                    "repositoryUrl": "\(imageRepository.url)",
                    "context": "\(dockerContext)",
                    "dockerfile": "\(dockerFilePath)",
                    "platform": "\(dockerPlatform)",
                    "args": ["DOCKER_BUILDKIT": "1"],
                ],
                options: options,
                context: context
            )
        }
    }
}
