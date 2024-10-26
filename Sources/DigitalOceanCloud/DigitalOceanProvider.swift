import Cloud

extension Provider {
    public static func digitalOcean(
        token: String = ""
    ) -> Self {
        .init(
            plugin: .aws,
            configuration: [
                "token": token
            ],
            dependencies: [.digitalOcean]
        )
    }
}

extension DigitalOcean {
    public struct Provider: ResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            token: String? = nil
        ) {
            resource = Resource(
                name: name,
                type: "pulumi:providers:digitalocean",
                properties: [
                    "token": token
                ]
            )
        }
    }
}
