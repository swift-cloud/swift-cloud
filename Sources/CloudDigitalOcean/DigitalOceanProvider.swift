import CloudCore

extension Provider {
    public static func digitalocean(
        apiKey: String? = nil
    ) -> Self {
        return .init(
            plugin: .digitalocean,
            configuration: [
                "apiKey": apiKey
            ],
            dependencies: []
        )
    }
}

extension DigitalOcean {
    public struct Provider: ResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            apiKey: String? = nil
        ) {
            resource = Resource(
                name: name,
                type: "pulumi:providers:digitalocean",
                properties: [
                    "apiKey": apiKey
                ]
            )
        }
    }
}
