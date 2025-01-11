extension DigitalOcean {
    public struct ContainerRegistryDockerCredentials: DigitalOceanResourceProvider {
        public let resource: Resource

        public var dockerCredentials: Output<String> {
            resource.output.keyPath("dockerCredentials")
        }

        public init(
            _ name: String,
            registryName: any Input<String>,
            options: Resource.Options? = nil
        ) {
            self.resource = .init(
                name: "\(name)-docker-credentials",
                type: "digitalocean:ContainerRegistryDockerCredentials",
                properties: [
                    "registryName": registryName,
                    "write": true,
                ],
                options: options
            )
        }
    }
}
