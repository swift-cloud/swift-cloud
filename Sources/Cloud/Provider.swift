public struct Provider: Sendable {
    public let plugin: Pulumi.Plugin
    public let configuration: [String: String?]
    public let dependencies: [Pulumi.Plugin]

    public init(
        plugin: Pulumi.Plugin,
        configuration: [String: String?],
        dependencies: [Pulumi.Plugin] = []
    ) {
        self.plugin = plugin
        self.configuration = configuration
        self.dependencies = dependencies
    }
}

extension Provider {
    public var name: String {
        plugin.name
    }
}
