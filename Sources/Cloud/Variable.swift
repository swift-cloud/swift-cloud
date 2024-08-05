public class Variable: @unchecked Sendable {
    public let name: String

    public var definition: AnyEncodable

    public init(
        _ name: String,
        definition: AnyEncodable
    ) {
        self.name = name
        self.definition = definition
        Command.Store.track(self)
    }

    internal func pulumiProjectVariables() -> Pulumi.Project.Variables {
        return [
            slugify(name): definition
        ]
    }
}

extension Variable {

    public func keyPath(_ paths: String...) -> String {
        let root = slugify(name)
        let parts = [root] + paths
        return "${\(parts.joined(separator: "."))}"
    }

    public var value: String {
        keyPath()
    }
}
