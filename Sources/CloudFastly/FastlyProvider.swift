import CloudCore

extension Provider {
    public static func fastly(
        apiKey: String? = nil
    ) -> Self {
        return .init(
            plugin: .fastly,
            configuration: [
                "apiKey": apiKey
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
            apiKey: String? = nil
        ) {
            resource = Resource(
                name: name,
                type: "pulumi:providers:fastly",
                properties: [
                    "apiKey": apiKey
                ],
                options: nil
            )
        }
    }
}
