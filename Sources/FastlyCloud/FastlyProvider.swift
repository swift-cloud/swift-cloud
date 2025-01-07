import Cloud

extension Provider {
    public static func fastly(
        apiToken: String? = nil
    ) -> Self {
        return .init(
            plugin: .fastly,
            configuration: [
                "apiToken": apiToken
            ],
            dependencies: []
        )
    }
}

extension Fastly {
    public struct Provider: ResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            apiToken: String? = nil
        ) {
            resource = Resource(
                name: name,
                type: "pulumi:providers:fastly",
                properties: [
                    "apiToken": apiToken
                ]
            )
        }
    }
}
