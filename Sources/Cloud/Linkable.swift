public protocol Linkable {
    var name: String { get }

    var effect: String { get }

    var actions: [String] { get }

    var resources: [String] { get }
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

    var name: String { get }

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

        return self
    }
}
