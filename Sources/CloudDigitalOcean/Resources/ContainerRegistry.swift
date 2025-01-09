extension DigitalOcean {
    public struct ContainerRegistry: DigitalOceanResourceProvider {
        public let resource: Resource

        var credentials: ContainerRegistryDockerCredentials {
            .init(resource.chosenName, registryName: resource.name, options: resource.options)
        }

        public init(
            _ name: String,
            subscriptionTier: SubscriptionTier = .starter,
            options: Resource.Options? = nil
        ) {
            self.resource = .init(
                name: name,
                type: "digitalocean:ContainerRegistry",
                properties: [
                    "subscriptionTierSlug": subscriptionTier.rawValue
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
