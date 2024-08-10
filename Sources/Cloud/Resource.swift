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

    internal var internalName: String {
        tokenize(Context.current.stage, Context.current.qualifiedName, chosenName)
    }

    public init(
        name: String,
        type: String,
        properties: AnyEncodable? = nil,
        dependsOn: [any ResourceProvider]? = nil,
        options: Options? = nil
    ) {
        self.chosenName = name
        self.type = type
        self.properties = properties
        self.dependsOn = dependsOn
        self.options = options
        Context.current.store.track(self)
    }

    func pulumiProjectResources() -> Pulumi.Project.Resources {
        return [
            internalName: .init(
                type: type,
                properties: properties,
                options: .init(
                    dependsOn: (dependsOn ?? options?.dependsOn)?.map { $0.ref },
                    protect: options?.protect,
                    provider: options?.provider?.ref
                )
            )
        ]
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
    public func keyPath(_ paths: String...) -> String {
        let parts = [resource.internalName] + paths
        return "${\(parts.joined(separator: "."))}"
    }

    public var ref: String {
        keyPath()
    }

    public var id: String {
        keyPath("id")
    }

    public var arn: String {
        keyPath("arn")
    }

    public var name: String {
        keyPath("name")
    }
}

extension Resource {
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
