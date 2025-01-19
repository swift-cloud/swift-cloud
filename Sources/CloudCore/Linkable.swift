public protocol Linkable {
    associatedtype NameType: Input<String>
    var name: NameType { get }

    var effect: String { get }

    var actions: [String] { get }

    associatedtype ResourceType: Input<String>
    var resources: [ResourceType] { get }

    var properties: LinkProperties? { get }
}

public struct LinkProperties: Sendable {
    public let type: any Input<String>

    public let name: any Input<String>

    public let properties: [String: any Input<String>]

    public init(type: any Input<String>, name: any Input<String>, properties: [String: any Input<String>]) {
        self.type = type
        self.name = name
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

    public var environmentVariables: [String: any Input<String>] {
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
    public func link(_ linkable: any Linkable) -> Self {
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

        role.resource.context.store.track(linkable)

        return self
    }

    @discardableResult
    public func link(_ linkables: [any Linkable]) -> Self {
        for linkable in linkables {
            link(linkable)
        }
        return self
    }

    @discardableResult
    public func link(_ linkables: any Linkable...) -> Self {
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
    public func linked(context: Context = .current) -> Self {
        context.store.track(self)
        return self
    }
}
