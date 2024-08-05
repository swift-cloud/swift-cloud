public protocol VariableProvider: Sendable {
    var variable: Variable { get }
}

public struct Variable: Sendable {
    public let name: String

    public let definition: AnyEncodable

    public init(
        _ name: String,
        definition: AnyEncodable
    ) {
        self.name = name
        self.definition = definition
        Store.current.track(self)
    }

    func pulumiProjectVariables() -> Pulumi.Project.Variables {
        return [
            slugify(name): definition
        ]
    }
}

extension Variable: VariableProvider {
    public var variable: Variable { self }
}

extension VariableProvider {

    public func keyPath(_ paths: String...) -> String {
        let root = slugify(variable.name)
        let parts = [root] + paths
        return "${\(parts.joined(separator: "."))}"
    }

    public var value: String {
        keyPath()
    }
}
