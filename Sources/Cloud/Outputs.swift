public struct Outputs: Sendable {

    private(set) var outputs: [String: Output<String>]

    public init(_ outputs: [String: Output<String>] = [:]) {
        self.outputs = outputs
    }

    mutating func merge(_ outputs: [String: Output<String>]) {
        self.outputs.merge(outputs) { $1 }
    }

    func pulumiProjectOutputs() -> Pulumi.Project.Outputs {
        return outputs
    }
}

extension Outputs: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Output<String>)...) {
        let dict = elements.reduce(into: [:]) {
            $0[$1.0] = $1.1
        }
        self.init(dict)
    }

    public init(dictionaryLiteral elements: (String, CustomStringConvertible)...) {
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
