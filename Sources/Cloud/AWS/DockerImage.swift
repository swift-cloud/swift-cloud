import Foundation

extension aws {
    public class DockerImage: Resource {
        public var uri: String {
            keyPath("imageUri")
        }

        public init(
            _ name: String,
            imageRepository: ImageRepository,
            dockerFilePath: String,
            context: String? = nil,
            platform: String? = nil
        ) {
            super.init(
                name,
                type: "awsx:ecr:Image",
                properties: [
                    "repositoryUrl": "\(imageRepository.url)",
                    "context": "\(context ?? FileManager.default.currentDirectoryPath)",
                    "dockerfile": "\(dockerFilePath)",
                    "platform": "\(platform ?? Architecture.current.dockerPlatform)",
                ]
            )
        }
    }
}
