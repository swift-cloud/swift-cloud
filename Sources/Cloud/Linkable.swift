public protocol Linkable {
    var name: Output<String> { get }

    var effect: String { get }

    var actions: [String] { get }

    var resources: [Output<String>] { get }

    var condition: [String: AnyEncodable]? { get }

    var environmentVariables: [String: CustomStringConvertible] { get }
}

extension Linkable {
    public var effect: String {
        "Allow"
    }

    public var condition: [String: AnyEncodable]? {
        nil
    }
}

extension Linkable {
    public var policy: AnyEncodable {
        var statement: [String: Encodable] = [
            "Effect": effect,
            "Action": actions,
            "Resource": resources,
        ]
        if let condition, !condition.isEmpty {
            statement["Condition"] = condition
        }
        return Resource.JSON([
            "Version": "2012-10-17",
            "Statement": statement,
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
