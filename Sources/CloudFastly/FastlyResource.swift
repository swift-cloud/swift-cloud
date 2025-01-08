import CloudCore

public protocol FastlyResourceProvider: ResourceProvider {}

extension Resource: FastlyResourceProvider {}
