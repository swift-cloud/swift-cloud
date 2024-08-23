public protocol VariableProvider: Sendable {
    associatedtype Outputs

    var variable: Variable<Outputs> { get }

    var output: Output<Outputs> { get }

    func pulumiProjectVariables() -> Pulumi.Project.Variables
}

public struct Variable<Outputs>: Sendable {
    public let chosenName: String

    public let definition: AnyEncodable

    var internalName: String {
        tokenize(Context.current.stage, chosenName)
    }

    public init(name: String, definition: AnyEncodable) {
        self.chosenName = name
        self.definition = definition
        Context.current.store.track(self)
    }
}

extension Variable: VariableProvider {
    public var variable: Variable { self }

    public var output: Output<Outputs> {
        .init(prefix: "", root: internalName, path: [])
    }

    public func pulumiProjectVariables() -> Pulumi.Project.Variables {
        return [
            internalName: definition
        ]
    }
}

extension Variable {
    public static func invoke(
        name: String,
        function: String,
        arguments: [String: Any] = [:]
    ) -> Variable<Outputs> {
        .init(
            name: name,
            definition: [
                "fn::invoke": [
                    "function": function,
                    "arguments": arguments,
                ]
            ]
        )
    }
}
