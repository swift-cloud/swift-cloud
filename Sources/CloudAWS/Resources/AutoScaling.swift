extension AWS {
    public struct AutoScaling: AWSResourceProvider {
        public let resource: Resource
        private let policies: [Resource]

        public init(
            _ webServer: AWS.WebServer,
            minimumConcurrency: Int,
            maximumConcurrency: Int,
            metrics: [Metric]
        ) {
            let resource = Resource(
                name: "\(webServer.chosenName)-ast",
                type: "aws:appautoscaling:Target",
                properties: [
                    "resourceId": "service/\(webServer.clusterName)/\(webServer.serviceName)",
                    "minCapacity": minimumConcurrency,
                    "maxCapacity": maximumConcurrency,
                    "scalableDimension": "ecs:service:DesiredCount",
                    "serviceNamespace": "ecs",
                ],
                options: webServer.service.options,
                context: webServer.service.context
            )

            let policies = metrics.map { metric in
                Resource(
                    name: "\(webServer.chosenName)-asr-\(metric)",
                    type: "aws:appautoscaling:Policy",
                    properties: [
                        "policyType": "TargetTrackingScaling",
                        "resourceId": resource.output.keyPath("resourceId"),
                        "scalableDimension": resource.output.keyPath("scalableDimension"),
                        "serviceNamespace": resource.output.keyPath("serviceNamespace"),
                        "targetTrackingScalingPolicyConfiguration": [
                            "predefinedMetricSpecification": [
                                "predefinedMetricType": metric.predefinedMetricType
                            ],
                            "targetValue": metric.targetValue,
                        ],
                    ],
                    options: webServer.service.options,
                    context: webServer.service.context
                )
            }

            self.resource = resource
            self.policies = policies
        }
    }
}

extension AWS.AutoScaling {
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
