import Foundation

public protocol ResourceProvider: Sendable {
    var resource: Resource { get }
}

public struct Resource: Sendable {
    public let name: String

    public let type: String

    public let properties: [String: AnyEncodable]?

    public let dependsOn: [Resource]?

    public init(
        _ name: String,
        type: String,
        properties: [String: AnyEncodable]? = nil,
        dependsOn: [Resource]? = nil
    ) {
        self.name = name
        self.type = type
        self.properties = properties
        self.dependsOn = dependsOn
        Store.current.track(self)
    }

    func pulumiProjectResources() -> Pulumi.Project.Resources {
        return [
            slugify(name): .init(
                type: type,
                properties: properties,
                options: dependsOn.map {
                    .init(dependsOn: $0.map { $0.ref })
                }
            )
        ]
    }
}

extension Resource: ResourceProvider {
    public var resource: Resource { self }
}

extension ResourceProvider {
    public func keyPath(_ paths: String...) -> String {
        let root = slugify(resource.name)
        let parts = [root] + paths
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
        case let value as Bool:
            return ["fn::toJSON": value]
        case let value as String:
            return ["fn::toJSON": value]
        case let value as Int:
            return ["fn::toJSON": value]
        case let value as Float:
            return ["fn::toJSON": value]
        case let value as Double:
            return ["fn::toJSON": value]
        case let value as [String: Sendable]:
            return ["fn::toJSON": value]
        case let value as [Sendable]:
            return ["fn::toJSON": value]
        default:
            fatalError("Invalid JSON string: \(input)")
        }
    }

    public static func JSON(_ input: [String: AnyEncodable]) -> AnyEncodable {
        return ["fn::toJSON": input]
    }

    public static func JSON(_ input: [AnyEncodable]) -> AnyEncodable {
        return ["fn::toJSON": input]
    }
}
