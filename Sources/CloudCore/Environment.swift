import Foundation

public protocol EnvironmentProvider {
    var environment: Environment { get }
}

public final class Environment: Encodable, @unchecked Sendable {
    public enum EncodingShape: String, Codable {
        case keyValue
        case nameValueList
        case keyValueList
    }

    private struct NameValuePair: Codable {
        let name: String
        let value: String
    }

    private struct KeyValuePair: Codable {
        let key: String
        let value: String
    }

    private let queue = DispatchQueue(label: "com.swift.cloud.environment")

    private let shape: EncodingShape

    private var _store: [String: CustomStringConvertible]
    private var store: [String: CustomStringConvertible] {
        get { queue.sync { _store } }
        set { queue.sync { _store = newValue } }
    }

    public init(_ initial: [String: CustomStringConvertible]? = nil, shape: EncodingShape) {
        self._store = [:]
        self.shape = shape
        Context.current.store.track(self)
        if let initial {
            self.merge(initial)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch shape {
        case .keyValue:
            try container.encode(store.reduce(into: [:]) { $0[$1.key] = "\($1.value)" })
        case .keyValueList:
            let pairs = store.map { KeyValuePair(key: $0.key, value: "\($0)") }
            try container.encode(pairs)
        case .nameValueList:
            let pairs = store.map { NameValuePair(name: $0.key, value: "\($0)") }
            try container.encode(pairs)
        }
    }

    public subscript(key: String) -> CustomStringConvertible? {
        get { store[Self.toKey(key)] }
        set { store[Self.toKey(key)] = newValue }
    }

    public func merge(_ other: [String: CustomStringConvertible]) {
        for (key, value) in other {
            store[Self.toKey(key)] = value
        }
    }
}

extension Environment {
    static func toKey(_ key: String) -> String {
        tokenize(key, separator: "_").uppercased()
    }
}
