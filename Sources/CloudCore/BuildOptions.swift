/// Options that control how Swift targets are built for deployment.
public struct BuildOptions: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Strip symbol information from the binary to reduce its size.
    /// This can dramatically reduce Lambda zip package sizes (often 50-70%)
    /// but crash stack traces will show raw memory addresses instead of function names.
    public static let stripSymbols = BuildOptions(rawValue: 1 << 0)
}
