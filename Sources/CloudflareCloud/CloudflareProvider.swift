import Cloud

extension Provider {
    public static func cloudflare(
        apiToken: String? = nil
    ) -> Self {
        return .init(
            plugin: .cloudflare,
            configuration: [
                "apiToken": apiToken ?? Context.environment["CLOUDFLARE_API_TOKEN"]
            ],
            dependencies: [.cloudflare]
        )
    }
}

extension Cloudflare {
    public struct Provider: ResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            apiToken: String? = nil
        ) {
            resource = Resource(
                name: name,
                type: "pulumi:providers:cloudflare",
                properties: [
                    "apiToken": apiToken
                ]
            )
        }
    }
}
