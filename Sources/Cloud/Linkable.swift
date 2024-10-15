public protocol Linkable {
    var name: Output<String> { get }

    var effect: String { get }

    var actions: [String] { get }

    var resources: [Output<String>] { get }

    var environmentVariables: [String: Input<String>] { get }
}

extension Linkable {
    public var effect: String {
        "Allow"
    }
}

extension Linkable {
    public var policy: AnyEncodable {
        Resource.JSON([
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

        return self
    }

    @discardableResult
    public func link(_ linkables: [Linkable]) -> Self {
        for linkable in linkables {
            link(linkable)
        }
        return self
    }
}
