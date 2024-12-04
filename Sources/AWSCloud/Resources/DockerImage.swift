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
            context: String? = nil,
            platform: String? = nil,
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: name,
                type: "awsx:ecr:Image",
                properties: [
                    "repositoryUrl": "\(imageRepository.url)",
                    "context": "\(context ?? Context.projectDirectory)",
                    "dockerfile": "\(dockerFilePath)",
                    "platform": "\(platform ?? Architecture.current.dockerPlatform)",
                    "args": ["DOCKER_BUILDKIT": "1"],
                ],
                options: options
            )
        }
    }
}
