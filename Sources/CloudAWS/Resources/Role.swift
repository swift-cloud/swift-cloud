import Foundation

extension AWS {
    public struct Role: AWSResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            service: String,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = Resource(
                name: name,
                type: "aws:iam:Role",
                properties: [
                    "assumeRolePolicy": Resource.JSON([
                        "Version": "2012-10-17",
                        "Statement": [
                            [
                                "Effect": "Allow",
                                "Principal": ["Service": service],
                                "Action": "sts:AssumeRole",
                            ]
                        ],
                    ])
                ],
                options: options,
                context: context
            )
        }
    }
}
