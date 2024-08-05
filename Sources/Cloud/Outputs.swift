public struct Outputs {

    internal var pulumiProjectOutputs: Pulumi.Project.Outputs

    public init(_ outputs: [String: String] = [:]) {
        self.pulumiProjectOutputs = outputs
    }
}

extension Outputs {

    public static let noOutputs = Self()
}
