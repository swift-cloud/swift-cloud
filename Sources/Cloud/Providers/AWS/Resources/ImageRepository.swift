extension aws {
    public struct ImageRepository: ResourceProvider {
        public let resource: Resource

        public var url: String {
            keyPath("repositoryUrl")
        }

        public init(
            _ name: String,
            forceDelete: Bool = true,
            options: Resource.Options? = nil
        ) {
            resource = .init(
                name,
                type: "aws:ecr:Repository",
                properties: [
                    "forceDelete": .init(forceDelete)
                ],
                options: options
            )
        }
    }
}

extension aws.ImageRepository {
    public static func shared(options: Resource.Options? = nil) -> Self {
        return aws.ImageRepository(
            "shared-image-repository",
            options: .provider(options?.provider)
        )
    }
}
