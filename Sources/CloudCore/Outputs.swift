public struct Outputs: Sendable {

    private(set) var outputs: [String: any Input<String>]

    public init(_ outputs: [String: any Input<String>] = [:]) {
        self.outputs = outputs
    }

    mutating func merge(_ outputs: [String: any Input<String>]) {
        self.outputs.merge(outputs) { $1 }
    }

    func pulumiProjectOutputs() -> Pulumi.Project.Outputs {
        return outputs.mapValues { .init($0) }
    }
}

extension Outputs: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, any Input<String>)...) {
        let dict = elements.reduce(into: [:]) {
            $0[$1.0] = Output<String>(stringLiteral: "\($1.1)")
        }
        self.init(dict)
    }
}

extension Outputs {
    public static let noOutputs = Self()
}

extension Outputs {
    static let internalPrefix = "_sc:"

    static func isInternalKey(_ key: String) -> Bool {
        key.hasPrefix(internalPrefix)
    }
}
