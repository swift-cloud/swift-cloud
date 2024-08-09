import Foundation

public protocol EnvironmentProvider {
    var environment: Environment { get }
}

public final class Environment: Encodable, @unchecked Sendable {
    public enum EncodingShape: String, Codable {
        case dictionary
        case keyValueArray
    }

    private struct KeyValuePair: Codable {
        let name: String
        let value: String
    }

    private let queue = DispatchQueue(label: "com.swift.cloud.environment")

    private let shape: EncodingShape

    private var _store: [String: String]
    private var store: [String: String] {
        get { queue.sync { _store } }
        set { queue.sync { _store = newValue } }
    }

    public init(_ initial: [String: String]? = nil, shape: EncodingShape = .dictionary) {
        self._store = initial ?? [:]
        self.shape = shape
        Context.current.store.track(self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch shape {
        case .dictionary:
            try container.encode(store)
        case .keyValueArray:
            let keyValuePairs = store.map { KeyValuePair(name: $0.key, value: $0.value) }
            try container.encode(keyValuePairs)
        }
    }

    public subscript(key: String) -> String? {
        get { store[key] }
        set { store[key] = newValue }
    }

    public func merge(_ other: [String: String]) {
        for (key, value) in other {
            store[key] = value
        }
    }
}

extension Environment: ExpressibleByDictionaryLiteral {
    convenience public init(dictionaryLiteral elements: (String, String)...) {
        self.init(elements.reduce(into: [:]) { $0[$1.0] = $1.1 })
    }
}
