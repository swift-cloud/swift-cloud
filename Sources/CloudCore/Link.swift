public struct Link: Sendable, Linkable {
    public var name: Output<String>

    public var effect: String

    public var actions: [String]

    public var resources: [Output<String>]

    public var properties: LinkProperties?

    public init(
        name: Output<String>,
        effect: String = "Allow",
        actions: [String] = ["*"],
        resources: [Output<String>] = [],
        properties: LinkProperties? = nil
    ) {
        self.name = name
        self.effect = effect
        self.actions = actions
        self.resources = resources
        self.properties = properties
    }
}
