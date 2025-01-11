import CloudCore

public protocol DigitalOceanResourceProvider: ResourceProvider {}

extension Resource: DigitalOceanResourceProvider {}
