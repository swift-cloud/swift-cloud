extension aws {
    public struct AutoScaling: ResourceProvider {
        public let resource: Resource
        private let policies: [Resource]

        public init(
            _ webServer: aws.WebServer,
            minimumConcurrency: Int,
            maximumConcurrency: Int,
            metrics: [Metric],
            options: Resource.Options? = nil
        ) {
            let resource = Resource(
                name: "\(webServer.service.chosenName)-auto-scaling-target",
                type: "aws:appautoscaling:Target",
                properties: [
                    "resourceId": "service/\(webServer.cluster.name)/\(webServer.service.name)",
                    "minCapacity": minimumConcurrency,
                    "maxCapacity": maximumConcurrency,
                    "scalableDimension": "ecs:service:DesiredCount",
                    "serviceNamespace": "ecs",
                ],
                options: options
            )

            let policies = metrics.map { metric in
                Resource(
                    name: "\(webServer.service.chosenName)-auto-scaling-rule-\(metric)",
                    type: "aws:appautoscaling:Policy",
                    properties: [
                        "policyType": "TargetTrackingScaling",
                        "resourceId": resource.keyPath("resourceId"),
                        "scalableDimension": resource.keyPath("scalableDimension"),
                        "serviceNamespace": resource.keyPath("serviceNamespace"),
                        "targetTrackingScalingPolicyConfiguration": [
                            "predefinedMetricSpecification": [
                                "predefinedMetricType": metric.predefinedMetricType
                            ],
                            "targetValue": metric.targetValue,
                        ],
                    ],
                    options: options
                )
            }

            self.resource = resource
            self.policies = policies
        }
    }
}

extension aws.AutoScaling {
    public enum Metric: Sendable {
        case cpu(Int)
        case memory(Int)

        fileprivate var predefinedMetricType: String {
            switch self {
            case .cpu:
                return "ECSServiceAverageCPUUtilization"
            case .memory:
                return "ECSServiceAverageMemoryUtilization"
            }
        }

        fileprivate var targetValue: Int {
            switch self {
            case .cpu(let targetValue):
                return targetValue
            case .memory(let targetValue):
                return targetValue
            }
        }
    }
}
