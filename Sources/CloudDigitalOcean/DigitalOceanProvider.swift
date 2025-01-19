import CloudCore

extension Provider {
    public static func digitalocean(
        token: String? = nil
    ) -> Self {
        return .init(
            plugin: .digitalocean,
            configuration: [
                "token": token
            ],
            dependencies: []
        )
    }
}

extension DigitalOcean {
    public struct Provider: ResourceProvider {
        public let resource: Resource

        public let token: String?

        public init(
            _ name: String,
            token: String? = nil,
            context: Context = .current
        ) {
            self.token = token

            resource = Resource(
                name: name,
                type: "pulumi:providers:digitalocean",
                properties: [
                    "token": token
                ],
                options: nil,
                context: context
            )
        }
    }
}
