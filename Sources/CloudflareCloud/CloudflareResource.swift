import Cloud

public protocol CloudflareResourceProvider: ResourceProvider {}

extension Resource: CloudflareResourceProvider {}

extension CloudflareResourceProvider {
    public var id: Output<String> {
        output.keyPath("id")
    }
}
