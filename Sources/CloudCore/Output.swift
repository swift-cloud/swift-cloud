public enum OutputPathComponent: Sendable, Input {
    public typealias ValueType = String

    case property(String)
    case arrayIndex(Int)
    case dictionaryKey(String)

    public var description: String {
        switch self {
        case .property(let property):
            return ".\(property)"
        case .arrayIndex(let index):
            return "[\(index)]"
        case .dictionaryKey(let key):
            return "[\"\(key)\"]"
        }
    }
}

@dynamicMemberLookup
public struct Output<T>: Sendable {

    public let prefix: String

    public let root: String

    public let path: [OutputPathComponent]

    public init(prefix: String, root: String, path: [OutputPathComponent]) {
        self.prefix = prefix
        self.root = root
        self.path = path
    }

    public subscript<U>(dynamicMember member: KeyPath<T, U>) -> Output<U> {
        let memberString = "\(member)".split(separator: ".").last!
        return Output<U>(prefix: prefix, root: root, path: path + [.property(.init(memberString))])
    }

    public subscript<U>(index: Int) -> Output<U> where T == [U] {
        return Output<U>(prefix: prefix, root: root, path: path + [.arrayIndex(index)])
    }

    public subscript<U>(key: String) -> Output<U> where T == [String: U] {
        return Output<U>(prefix: prefix, root: root, path: path + [.dictionaryKey(key)])
    }

    public func keyPath<U>(_ properties: String...) -> Output<U> {
        Output<U>(prefix: prefix, root: root, path: path + properties.map { .property($0) })
    }

    public func keyPath(_ properties: String...) -> Output<Any> {
        Output<Any>(prefix: prefix, root: root, path: path + properties.map { .property($0) })
    }
}

extension Output: CustomStringConvertible {
    public var description: String {
        if root.isEmpty {
            return prefix
        }
        var ref = root
        for item in path {
            ref += item.description
        }
        return "\(prefix)${\(ref)}"
    }
}

extension Output: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension Output<String>:
    ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral
{
    public init(stringLiteral value: String) {
        self.init(prefix: value, root: "", path: [])
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(prefix: value, root: "", path: [])
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(prefix: value, root: "", path: [])
    }
}

extension Output<String>: ExpressibleByStringInterpolation {
    public init(stringInterpolation: StringInterpolation) {
        self.init(prefix: stringInterpolation.description, root: "", path: [])
    }
}
