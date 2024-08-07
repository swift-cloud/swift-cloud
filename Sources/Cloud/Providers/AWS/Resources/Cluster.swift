extension aws {
    public struct Cluster: ResourceProvider {
        public let resource: Resource
        private let capacityProviders: Resource

        public init(_ name: String, options: Resource.Options? = nil) {
            resource = Resource(
                name: name,
                type: "aws:ecs:Cluster",
                options: options
            )

            capacityProviders = Resource(
                name: "\(name)-cluster-capacity-provider",
                type: "aws:ecs:ClusterCapacityProviders",
                properties: [
                    "clusterName": resource.name,
                    "capacityProviders": ["FARGATE", "FARGATE_SPOT"],
                    "defaultCapacityProviderStrategies": [
                        [
                            "capacityProvider": "FARGATE",
                            "weight": 1,
                            "base": 1,
                        ],
                        [
                            "capacityProvider": "FARGATE_SPOT",
                            "weight": 1,
                        ],
                    ],
                ],
                options: options
            )
        }
    }
}
