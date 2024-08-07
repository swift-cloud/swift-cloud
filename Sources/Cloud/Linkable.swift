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
        let statement: [String: Sendable] = [
            "Effect": effect,
            "Action": actions,
            "Resource": resources,
        ]
        return Resource.JSON([
            "Version": "2012-10-17",
            "Statement": .init(statement),
        ])
    }
}

public protocol RoleProvider {
    var name: String { get }

    var role: Resource { get }
}

extension RoleProvider {
    @discardableResult
    public func link(_ linkable: Linkable) -> Self {
        let _ = Resource(
            name: "\(name)-\(linkable.name)-role-policy",
            type: "aws:iam:RolePolicy",
            properties: [
                "role": .init(role.id),
                "policy": linkable.policy,
            ],
            options: role.options
        )

        return self
    }
}
