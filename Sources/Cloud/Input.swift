public protocol _Input {
    associatedtype Value

    var value: Value { get }

    init(_ value: Value)
}

public struct Input<T>: Sendable where T: Sendable {
    public let value: T

    public init(_ value: T) {
        self.value = value
    }
}

extension Input<String> {
    public init(_ output: Output<T>) {
        self.init(output.description)
    }
}

extension Input: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

extension Input<String>: CustomStringConvertible {
    public var description: String {
        value
    }
}

extension Input<String>: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral,
    ExpressibleByUnicodeScalarLiteral
{
    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}

extension Input<String>: ExpressibleByStringInterpolation {
    public init(stringInterpolation: StringInterpolation) {
        self.init(stringInterpolation.description)
    }
}
