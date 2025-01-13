import Crypto
import Foundation

public protocol ResourceProvider: Sendable {
    var resource: Resource { get }
}

public struct Resource: Sendable {
    public let chosenName: String
    public let type: String
    public let properties: AnyEncodable?
    public let dependsOn: [any ResourceProvider]?
    public let options: Options?
    public let existingId: String?
    public let maxNameLength: Int

    fileprivate var internalName: String {
        return tokenize(Context.current.stage, chosenName, maxLength: maxNameLength)
    }

    public init(
        name: String,
        type: String,
        properties: AnyEncodable? = nil,
        dependsOn: [any ResourceProvider]? = nil,
        options: Options? = nil,
        existingId: String? = nil,
        maxNameLength: Int = 55
    ) {
        self.chosenName = name
        self.type = type
        self.properties = properties
        self.dependsOn = dependsOn
        self.options = options
        self.existingId = existingId
        self.maxNameLength = maxNameLength
        Context.current.store.track(self)
    }

    func pulumiProjectResources() -> Pulumi.Project.Resources {
        return [
            internalName: .init(
                type: type,
                properties: properties,
                options: dependsOn == nil && options == nil
                    ? nil
                    : .init(
                        dependsOn: (dependsOn ?? options?.dependsOn)?.map { $0.output },
                        protect: options?.protect,
                        provider: options?.provider?.output),
                get: existingId.map { .init(id: $0) }
            )
        ]
    }
}

extension Resource {
    public static func lookup(type: String, id: String) -> Resource {
        .init(
            name: "\(type):\(id)",
            type: type,
            existingId: id
        )
    }
}

extension Resource {
    public struct Options: Sendable {
        public var dependsOn: [any ResourceProvider]?
        public var protect: Bool?
        public var provider: (any ResourceProvider)?

        public init(
            dependsOn: [any ResourceProvider]? = nil,
            protect: Bool? = nil,
            provider: (any ResourceProvider)? = nil
        ) {
            self.dependsOn = dependsOn
            self.protect = protect
            self.provider = provider
        }
    }
}

extension Resource.Options {
    public static func protect(_ value: Bool? = true) -> Resource.Options {
        .init(protect: value)
    }

    public static func provider(_ provider: (any ResourceProvider)?) -> Resource.Options {
        .init(provider: provider)
    }

    public static func dependsOn(_ resources: [any ResourceProvider]?) -> Resource.Options {
        .init(dependsOn: resources)
    }

    public func protect(_ value: Bool? = true) -> Resource.Options {
        var copy = self
        copy.protect = value
        return copy
    }

    public func provider(_ provider: (any ResourceProvider)?) -> Resource.Options {
        var copy = self
        copy.provider = provider
        return copy
    }

    public func dependsOn(_ resources: [any ResourceProvider]?) -> Resource.Options {
        var copy = self
        copy.dependsOn = resources
        return copy
    }
}

extension Resource: ResourceProvider {
    public var resource: Resource { self }
}

extension ResourceProvider {
    public var output: Output<Any> {
        .init(prefix: "", root: resource.internalName, path: [])
    }

    public var id: Output<String> {
        output.keyPath("id")
    }

    public var name: Output<String> {
        output.keyPath("name")
    }
}

extension ResourceProvider {
    public static func JSON(_ input: String) -> AnyEncodable {
        guard let data = try? JSONSerialization.jsonObject(with: .init(input.utf8)) else {
            fatalError("Invalid JSON string: \(input)")
        }
        switch data {
        case let value as Sendable:
            return ["fn::toJSON": value]
        default:
            fatalError("Invalid JSON string: \(input)")
        }
    }

    public static func JSON(_ input: AnyEncodable) -> AnyEncodable {
        return ["fn::toJSON": input]
    }

    public static func JSON(_ input: [AnyEncodable]) -> AnyEncodable {
        return ["fn::toJSON": input]
    }
}
