extension String {
    public func codable() -> AnyCodable {
        AnyCodable(self)
    }

    public func encodable() -> AnyEncodable {
        AnyEncodable(self)
    }
}
