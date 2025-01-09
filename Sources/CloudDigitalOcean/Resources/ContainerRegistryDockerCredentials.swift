extension DigitalOcean {
    public struct ContainerRegistryDockerCredentials: DigitalOceanResourceProvider {
        public let resource: Resource

        public var dockerCredentials: Output<String> {
            resource.output.keyPath("dockerCredentials")
        }

        public init(
            _ name: String,
            registryName: Output<String>,
            options: Resource.Options? = nil
        ) {
            self.resource = .init(
                name: "\(name)-docker-credentials",
                type: "digitalocean:ContainerRegistry",
                properties: [
                    "registryName": registryName
                ],
                options: options
            )
        }
    }
}
