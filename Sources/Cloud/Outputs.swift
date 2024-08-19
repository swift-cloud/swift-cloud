public struct Outputs: Sendable, ExpressibleByDictionaryLiteral {

    private(set) var outputs: [String: Output<String>]

    public init(_ outputs: [String: Output<String>] = [:]) {
        self.outputs = outputs
    }

    public init(dictionaryLiteral elements: (String, Output<String>)...) {
        let dict = elements.reduce(into: [:]) { $0[$1.0] = $1.1 }
        self.init(dict)
    }

    mutating func merge(_ outputs: [String: Output<String>]) {
        self.outputs.merge(outputs) { $1 }
    }

    func pulumiProjectOutputs() -> Pulumi.Project.Outputs {
        return outputs
    }
}

extension Outputs {
    public static let noOutputs = Self()
}

extension Outputs {
    static func isInternalKey(_ key: String) -> Bool {
        key.hasPrefix("_sc:")
    }
}

@dynamicMemberLookup
public struct Output<T>: Encodable, Sendable, CustomStringConvertible {

    public let prefix: String

    public let root: String

    public let path: [OutputPathComponent]

    public init(_ root: String, path: [OutputPathComponent] = [], prefix: String = "") {
        self.prefix = prefix
        self.root = root
        self.path = path
    }

    public var description: String {
        if root.isEmpty {
            return prefix
        }
        var result = root
        for item in path {
            result += item.description
        }
        return "\(prefix)${\(result)}"
    }

    subscript<U>(dynamicMember member: KeyPath<T, U>) -> Output<U> {
        Output<U>(root, path: path + [.property("\(member)")])
    }

    subscript<U>(index: Int) -> Output<U> where T: Collection {
        Output<U>(root, path: path + [.arrayIndex(index)])
    }

    subscript<U>(key: String) -> Output<U> where T == [String: U] {
        Output<U>(root, path: path + [.dictionaryKey(key)])
    }

    public func keyPath<U>(_ properties: String...) -> Output<U> {
        Output<U>(root, path: path + properties.map { .property($0) })
    }

    public func keyPath(_ properties: String...) -> Output<Any> {
        Output<Any>(root, path: path + properties.map { .property($0) })
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

public enum OutputPathComponent: Sendable, CustomStringConvertible {
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

extension Output<String>: ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral,
    ExpressibleByUnicodeScalarLiteral
{
    public init(stringLiteral value: String) {
        self.init("", path: [], prefix: value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension Output<String>: ExpressibleByStringInterpolation {
    public init(stringInterpolation: StringInterpolation) {
        self.init("", path: [], prefix: stringInterpolation.description)
    }
}
