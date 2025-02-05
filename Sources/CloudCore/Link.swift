public struct Link: Sendable, Linkable {
    public var name: String

    public var effect: String

    public var actions: [String]

    public var resources: [String]

    public var properties: LinkProperties?

    public init(
        _ name: any Input<String>,
        effect: any Input<String> = "Allow",
        actions: [any Input<String>] = ["*"],
        resources: [any Input<String>] = [],
        properties: LinkProperties? = nil
    ) {
        self.name = name.description
        self.effect = effect.description
        self.actions = actions.map(\.description)
        self.resources = resources.map(\.description)
        self.properties = properties
    }
}
