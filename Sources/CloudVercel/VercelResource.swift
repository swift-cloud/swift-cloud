import CloudCore

public protocol VercelResourceProvider: ResourceProvider {}

extension Resource: VercelResourceProvider {}
