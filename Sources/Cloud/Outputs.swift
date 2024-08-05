public struct Outputs: Sendable {

    internal let pulumiProjectOutputs: Pulumi.Project.Outputs

    public init(_ outputs: [String: String] = [:]) {
        self.pulumiProjectOutputs = outputs
    }
}

extension Outputs {

    public static let noOutputs = Self()
}
