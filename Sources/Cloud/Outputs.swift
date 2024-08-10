public struct Outputs: Sendable {

    internal let pulumiProjectOutputs: Pulumi.Project.Outputs

    public init(_ outputs: [String: String] = [:]) {
        self.pulumiProjectOutputs = outputs
    }
}

extension Outputs {

    public static let noOutputs = Self()
}

extension Outputs: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        let dict = elements.reduce(into: [:]) { $0[$1.0] = $1.1 }
        self.init(dict)
    }
}
