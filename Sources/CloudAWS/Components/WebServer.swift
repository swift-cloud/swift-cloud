import CloudCore
import Foundation

extension AWS {
    public struct WebServer: AWSComponent, EnvironmentProvider {
        public let cluster: AWS.Cluster
        public let dockerImage: DockerImage
        public let role: Role
        public let loadBalancerSecurityGroup: AWS.SecurityGroup
        public let instanceSecurityGroup: AWS.SecurityGroup
        public let secureDomainName: AWS.SecureDomainName?
        public let applicationLoadBalancer: Resource
        public let service: Resource
        public let concurrency: Int
        public let environment: Environment

        public var name: Output<String> {
            serviceName
        }

        public var chosenName: String {
            service.chosenName
        }

        public var region: Output<String> {
            getARN(cluster).region
        }

        public var serviceName: Output<String> {
            service.output.keyPath("service", "name")
        }

        public var clusterName: Output<String> {
            cluster.name
        }

        public var internalHostname: Output<String> {
            applicationLoadBalancer.output.keyPath("loadBalancer", "dnsName")
        }

        public var zoneId: Output<String> {
            applicationLoadBalancer.output.keyPath("loadBalancer", "zoneId")
        }

        public var hostname: Output<String> {
            if let secureDomainName {
                return secureDomainName.hostname
            } else {
                return internalHostname
            }
        }

        public var url: Output<String> {
            if let secureDomainName {
                return "https://\(secureDomainName.hostname)"
            } else {
                return "http://\(hostname)"
            }
        }

        public init(
            _ name: String,
            targetName: String,
            domainName: DomainName? = nil,
            concurrency: Int = 1,
            cpu: Int = 256,
            memory: Int = 512,
            architecture: Architecture = .current,
            autoScaling: AutoScalingConfiguration? = nil,
            instancePort: Int = 8080,
            vpc: AWS.VPC? = nil,
            environment: [String: String] = [:],
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.concurrency = concurrency

            let dockerFilePath = Docker.Dockerfile.filePath(name)

            self.environment = Environment(environment, shape: .nameValueList)
            self.environment["PORT"] = "\(instancePort)"

            cluster = AWS.Cluster(
                "\(name)-cluster",
                options: options
            )

            dockerImage = DockerImage(
                "\(name)-image",
                imageRepository: .shared(options: options),
                dockerFilePath: dockerFilePath,
                options: options
            )

            role = AWS.Role(
                "\(name)-role",
                service: "ecs-tasks.amazonaws.com",
                options: options
            )

            loadBalancerSecurityGroup = AWS.SecurityGroup(
                "\(name)-lbsg",
                ingress: .all,
                egress: .all,
                options: options
            )

            instanceSecurityGroup = AWS.SecurityGroup(
                "\(name)-tsg",
                ingress: [.securityGroup(loadBalancerSecurityGroup)],
                egress: .all,
                options: options
            )

            secureDomainName = domainName.map {
                AWS.SecureDomainName(domainName: $0)
            }

            applicationLoadBalancer = Resource(
                name: "\(name)-alb",
                type: "awsx:lb:ApplicationLoadBalancer",
                properties: [
                    "listeners": [
                        secureDomainName
                            .map { ["port": 443, "protocol": "HTTPS", "certificateArn": $0.certificate.arn] }
                            ?? ["port": 80, "protocol": "HTTP"]
                    ],
                    "defaultTargetGroup": [
                        "port": instancePort,
                        "protocol": "HTTP",
                    ],
                    "defaultSecurityGroup": [
                        "securityGroupId": loadBalancerSecurityGroup.id
                    ],
                ],
                options: options,
                context: context,
                dependsOn: secureDomainName.map { [$0.validation] },
                maxNameLength: 24
            )

            let vpc = vpc ?? AWS.VPC.default(options: options)

            service = Resource(
                name: "\(name)-service",
                type: "awsx:ecs:FargateService",
                properties: [
                    "cluster": cluster.arn,
                    "desiredCount": concurrency,
                    "continueBeforeSteadyState": true,
                    "forceNewDeployment": true,
                    "networkConfiguration": [
                        "assignPublicIp": true,
                        "securityGroups": [instanceSecurityGroup.id],
                        "subnets": vpc.publicSubnetIds,
                    ],
                    "triggers": [
                        "date": Date().formatted(.iso8601)
                    ],
                    "taskDefinitionArgs": [
                        "runtimePlatform": [
                            "cpuArchitecture": architecture.ecsArchitecture
                        ],
                        "container": [
                            "name": "\(name)-container",
                            "image": dockerImage.uri,
                            "cpu": cpu,
                            "memory": memory,
                            "essential": true,
                            "portMappings": [
                                [
                                    "containerPort": instancePort,
                                    "hostPort": instancePort,
                                    "targetGroup": applicationLoadBalancer.output.keyPath("defaultTargetGroup"),
                                ]
                            ],
                            "environment": self.environment,
                        ],
                        "taskRole": [
                            "roleArn": role.arn
                        ],
                        "trackLatest": true,
                    ],
                ],
                options: options,
                context: context
            )

            if let autoScaling {
                enableAutoScaling(
                    minimumConcurrency: autoScaling.minimumConcurrency,
                    maximumConcurrency: autoScaling.maximumConcurrency,
                    metrics: autoScaling.metrics
                )
            }

            domainName?.aliasTo(internalHostname)

            context.store.build {
                let dockerFile = Docker.Dockerfile.ubuntu(targetName: targetName, port: instancePort)
                try Docker.Dockerfile.write(dockerFile, to: dockerFilePath)
                try await $0.builder.buildUbuntu(targetName: targetName)
            }
        }
    }
}

extension AWS.WebServer: RoleProvider {}

extension AWS.WebServer {
    public struct AutoScalingConfiguration: Sendable {
        public let minimumConcurrency: Int?
        public let maximumConcurrency: Int
        public let metrics: [AWS.AutoScaling.Metric]

        public init(
            minimumConcurrency: Int? = nil,
            maximumConcurrency: Int,
            metrics: [AWS.AutoScaling.Metric]
        ) {
            self.minimumConcurrency = minimumConcurrency
            self.maximumConcurrency = maximumConcurrency
            self.metrics = metrics
        }
    }

    @discardableResult
    public func enableAutoScaling(
        minimumConcurrency: Int? = nil,
        maximumConcurrency: Int,
        metrics: [AWS.AutoScaling.Metric]
    ) -> AWS.AutoScaling {
        .init(
            self,
            minimumConcurrency: minimumConcurrency ?? self.concurrency,
            maximumConcurrency: maximumConcurrency,
            metrics: metrics
        )
    }
}
