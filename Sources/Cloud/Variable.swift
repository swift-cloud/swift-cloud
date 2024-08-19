public protocol VariableProvider: Sendable {
    associatedtype Shape

    var variable: Variable { get }
}

public struct Variable: Sendable {
    public let chosenName: String
    public let definition: AnyEncodable

    internal var internalName: String {
        tokenize(Context.current.stage, chosenName)
    }

    public init(name: String, definition: AnyEncodable) {
        self.chosenName = name
        self.definition = definition
        Context.current.store.track(self)
    }

    func pulumiProjectVariables() -> Pulumi.Project.Variables {
        return [
            internalName: definition
        ]
    }
}

extension Variable: VariableProvider {
    public typealias Shape = Any

    public var variable: Variable { self }
}

extension VariableProvider {
    public var output: Output<Shape> {
        .init(variable.internalName)
    }
}

extension Variable {
    public static func function(
        name: String,
        function: String,
        arguments: [String: Any] = [:]
    ) -> Variable {
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
