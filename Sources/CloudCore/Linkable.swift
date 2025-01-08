public protocol Linkable {
    var name: Output<String> { get }

    var effect: String { get }

    var actions: [String] { get }

    var resources: [Output<String>] { get }

    var properties: LinkProperties? { get }
}

public struct LinkProperties: Sendable {
    public let type: String

    public let name: String

    public let properties: [String: Output<String>]

    public init(type: String, name: CustomStringConvertible, properties: [String: Output<String>]) {
        self.type = type
        self.name = name.description
        self.properties = properties
    }

    func environmentKey(_ key: String) -> String {
        return Environment.toKey("\(type) \(name) \(key)")
    }
}

extension Linkable {
    public var effect: String {
        "Allow"
    }

    public var actions: [String] {
        ["*"]
    }

    public var properties: LinkProperties? {
        nil
    }

    public var environmentVariables: [String: CustomStringConvertible] {
        guard let properties else {
            return [:]
        }

        return properties.properties.reduce(into: [:]) {
            $0[properties.environmentKey($1.key)] = $1.value
        }
    }
}

extension Linkable {
    public var policy: AnyEncodable {
        return Resource.JSON([
            "Version": "2012-10-17",
            "Statement": [
                "Effect": effect,
                "Action": actions,
                "Resource": resources,
            ],
        ])
    }
}

public protocol RoleProvider {
    associatedtype RoleType: ResourceProvider

    var name: Output<String> { get }

    var role: RoleType { get }
}

extension RoleProvider {
    @discardableResult
    public func link(_ linkable: Linkable) -> Self {
        let _ = Resource(
            name: "\(name)-\(linkable.name)-role-policy",
            type: "aws:iam:RolePolicy",
            properties: [
                "role": role.id,
                "policy": linkable.policy,
            ],
            options: role.resource.options
        )

        if let self = self as? EnvironmentProvider {
            self.environment.merge(linkable.environmentVariables)
        }

        Context.current.store.track(linkable)

        return self
    }

    @discardableResult
    public func link(_ linkables: [Linkable]) -> Self {
        for linkable in linkables {
            link(linkable)
        }
        return self
    }

    @discardableResult
    public func link(_ linkables: Linkable...) -> Self {
        return link(linkables)
    }
}

extension Linkable {
    @discardableResult
    public func linkTo(_ provider: any RoleProvider) -> Self {
        provider.link(self)
        return self
    }

    @discardableResult
    public func linkTo(_ providers: [any RoleProvider]) -> Self {
        for provider in providers {
            linkTo(provider)
        }
        return self
    }

    @discardableResult
    public func linkTo(_ providers: any RoleProvider...) -> Self {
        return linkTo(providers)
    }

    /// Links the current resource to the current context,
    /// ensuring it is written to the CloudSDK resources.
    @discardableResult
    public func linked() -> Self {
        Context.current.store.track(self)
        return self
    }
}
