extension AWS {
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
            resource = Resource(
                name: name,
                type: "aws:ecr:Repository",
                properties: [
                    "forceDelete": forceDelete
                ],
                options: options
            )
        }
    }
}

extension AWS.ImageRepository {
    public static func shared(options: Resource.Options? = nil) -> Self {
        return AWS.ImageRepository(
            "shared-image-repository",
            options: .provider(options?.provider)
        )
    }
}
