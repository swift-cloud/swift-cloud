import Cloud

public protocol DigitalOceanResourceProvider: ResourceProvider {}

extension Resource: DigitalOceanResourceProvider {}

extension DigitalOceanResourceProvider {}
