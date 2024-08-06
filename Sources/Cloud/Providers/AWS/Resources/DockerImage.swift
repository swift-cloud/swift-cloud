import Foundation

extension aws {
    public struct DockerImage: ResourceProvider {
        public let resource: Resource

        public var uri: String {
            keyPath("imageUri")
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
                    "context": "\(context ?? currentDirectoryPath())",
                    "dockerfile": "\(dockerFilePath)",
                    "platform": "\(platform ?? Architecture.current.dockerPlatform)",
                ],
                options: options
            )
        }
    }
}
