/// A type-erased `Codable` value.
///
/// The `AnyCodable` type forwards encoding and decoding responsibilities
/// to an underlying value, hiding its specific underlying type.
///
/// You can encode or decode mixed-type values in dictionaries
/// and other collections that require `Encodable` or `Decodable` conformance
/// by declaring their contained type to be `AnyCodable`.
///
/// - SeeAlso: `AnyEncodable`
/// - SeeAlso: `AnyDecodable`
@frozen public struct AnyCodable: Codable {
    public let value: Any

    public init(_ value: Any?) {
        self.value = value ?? ()
    }
}

extension AnyCodable: _AnyEncodable, _AnyDecodable {}

extension AnyCodable: CustomStringConvertible {
    public var description: String {
        switch value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: value)
        }
    }
}

extension AnyCodable: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch value {
        case let value as CustomDebugStringConvertible:
            return "AnyCodable(\(value.debugDescription))"
        default:
            return "AnyCodable(\(description))"
        }
    }
}

extension AnyCodable: ExpressibleByNilLiteral {}
extension AnyCodable: ExpressibleByBooleanLiteral {}
extension AnyCodable: ExpressibleByIntegerLiteral {}
extension AnyCodable: ExpressibleByFloatLiteral {}
extension AnyCodable: ExpressibleByStringLiteral {}
extension AnyCodable: ExpressibleByStringInterpolation {}
extension AnyCodable: ExpressibleByArrayLiteral {}
extension AnyCodable: ExpressibleByDictionaryLiteral {}

extension AnyCodable: @unchecked Sendable {}
extension AnyEncodable: @unchecked Sendable {}
extension AnyDecodable: @unchecked Sendable {}
