import CloudCore

public protocol CloudflareResourceProvider: ResourceProvider {}

extension Resource: CloudflareResourceProvider {}
