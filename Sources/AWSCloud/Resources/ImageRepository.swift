extension AWS {
    public struct ImageRepository: ResourceProvider {
        public let resource: Resource

        public var url: Output<String> {
            output.keyPath("repositoryUrl")
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
        let suffix = options?.provider.map { $0.resource.chosenName } ?? ""
        return AWS.ImageRepository(
            "shared-image-repository-\(suffix)",
            options: .provider(options?.provider)
        )
    }
}
