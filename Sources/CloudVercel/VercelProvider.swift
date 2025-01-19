import CloudCore

extension Provider {
    public static func vercel(
        apiToken: String? = nil,
        team: String? = nil
    ) -> Self {
        return .init(
            plugin: .vercel,
            configuration: [
                "apiToken": apiToken,
                "team": team,
            ],
            dependencies: []
        )
    }
}

extension Vercel {
    public struct Provider: ResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            apiToken: String? = nil,
            team: String? = nil
        ) {
            resource = Resource(
                name: name,
                type: "pulumi:providers:vercel",
                properties: [
                    "apiToken": apiToken,
                    "team": team,
                ],
                options: nil
            )
        }
    }
}
