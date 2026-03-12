extension AWS {
    public struct ImageRepository: AWSResourceProvider {
        public let resource: Resource

        public var url: Output<String> {
            output.keyPath("repositoryUrl")
        }

        public init(
            _ name: String,
            forceDelete: Bool = true,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = Resource(
                name: name,
                type: "aws:ecr:Repository",
                properties: [
                    "forceDelete": forceDelete
                ],
                options: options,
                context: context
            )

            _ = Resource(
                name: "\(name)-lifecycle-policy",
                type: "aws:ecr:LifecyclePolicy",
                properties: [
                    "repository": resource.output.keyPath("name"),
                    "policy": """
                    {
                        "rules": [{
                            "rulePriority": 1,
                            "description": "Expire untagged images older than 1 day",
                            "selection": {
                                "tagStatus": "untagged",
                                "countType": "sinceImagePushed",
                                "countUnit": "days",
                                "countNumber": 1
                            },
                            "action": {
                                "type": "expire"
                            }
                        }]
                    }
                    """,
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.ImageRepository {
    public static func shared(options: Resource.Options? = nil) -> Self {
        let suffix = options?.provider.map { $0.resource.chosenName } ?? ""
        return AWS.ImageRepository(
            "shared-image-repository-\(suffix)",
            options: .provider(options?.provider)
        )
    }
}
