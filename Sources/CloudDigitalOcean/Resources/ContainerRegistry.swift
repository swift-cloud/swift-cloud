import CloudCore

extension DigitalOcean {
    public struct ContainerRegistry: DigitalOceanResourceProvider {
        public let resource: Resource

        public var credentials: ContainerRegistryDockerCredentials {
            .init(resource.chosenName, registryName: resource.name, options: resource.options)
        }

        public init(
            _ name: String,
            subscriptionTier: SubscriptionTier = .starter,
            region: Region = .nyc3,
            options: Resource.Options? = nil
        ) {
            self.resource = .init(
                name: name,
                type: "digitalocean:ContainerRegistry",
                properties: [
                    "name": tokenize(Context.current.stage, name),
                    "subscriptionTierSlug": subscriptionTier.rawValue,
                    "region": region.rawValue,
                ],
                options: options
            )
        }
    }
}

extension DigitalOcean.ContainerRegistry {
    public enum SubscriptionTier: String {
        case starter
        case basic
        case professional
    }
}

extension DigitalOcean.ContainerRegistry {
    public static func shared(options: Resource.Options? = nil) -> Self {
        let suffix = options?.provider.map { $0.resource.chosenName } ?? ""
        return .init(
            "shared-image-repository-\(suffix)",
            options: .provider(options?.provider)
        )
    }
}
