public protocol Component: Sendable {
    var name: Output<String> { get }
}
