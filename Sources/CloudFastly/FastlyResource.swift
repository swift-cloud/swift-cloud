import CloudCore

public protocol FastlyResourceProvider: ResourceProvider {}

extension Resource: FastlyResourceProvider {}

extension FastlyResourceProvider {
    public var id: Output<String> {
        output.keyPath("id")
    }
}
