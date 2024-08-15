public struct Outputs: Sendable {

    var pulumiProjectOutputs: Pulumi.Project.Outputs

    public init(_ outputs: [String: String] = [:]) {
        self.pulumiProjectOutputs = outputs
    }

    mutating func merge(_ outputs: Pulumi.Project.Outputs) {
        pulumiProjectOutputs.merge(outputs) { $1 }
    }
}

extension Outputs {

    public static let noOutputs = Self()
}

extension Outputs {

    public static func isInternal(_ output: String) -> Bool {
        output.hasPrefix("_sc:")
    }
}

extension Outputs: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        let dict = elements.reduce(into: [:]) { $0[$1.0] = $1.1 }
        self.init(dict)
    }
}
