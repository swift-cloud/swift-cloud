public protocol Input<ValueType>: Sendable, Encodable, CustomStringConvertible {
    associatedtype ValueType
}

extension String: Input {
    public typealias ValueType = Self
}

extension Int: Input {
    public typealias ValueType = Self
}

extension Double: Input {
    public typealias ValueType = Self
}

extension Output: Input {
    public typealias ValueType = T
}
