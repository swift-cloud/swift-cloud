extension AWS {
    public struct WebServer: Component, EnvironmentProvider {
        public let cluster: AWS.Cluster
        public let dockerImage: DockerImage
        public let role: Role
        public let loadBalancerSecurityGroup: AWS.SecurityGroup
        public let instanceSecurityGroup: AWS.SecurityGroup
        public let tlsCertificate: AWS.TLSCertificate?
        public let tlsCertificateValidation: AWS.TLSCertificate.Validation?
        public let applicationLoadBalancer: Resource
        public let service: Resource
        public let concurrency: Int
        public let environment: Environment

        public var name: String {
            serviceName
        }

        public var chosenName: String {
            service.chosenName
        }

        public var serviceName: String {
            service.keyPath("service", "name")
        }

        public var clusterName: String {
            cluster.name
        }

        public var hostname: String {
            applicationLoadBalancer.keyPath("loadBalancer", "dnsName")
        }

        public var url: String {
            if tlsCertificate == nil {
                return "http://\(hostname)"
            } else {
                return "https://\(hostname)"
            }
        }

        public init(
            _ name: String,
            targetName: String,
            domainName: String? = nil,
            concurrency: Int = 1,
            cpu: Int = 1024,
            memory: Int = 2048,
            autoScaling: AutoScalingConfiguration? = nil,
            instancePort: Int = 8080,
            vpc: AWS.VPC = .default,
            environment: [String: String] = [:],
            options: Resource.Options? = nil
        ) {
            self.concurrency = concurrency

            let dockerFilePath = Docker.Dockerfile.filePath(name)

            self.environment = Environment(environment, shape: .keyValuePairs)
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

            tlsCertificate = domainName.map {
                AWS.TLSCertificate(domainName: $0, options: options)
            }

            tlsCertificateValidation = tlsCertificate.map {
                AWS.TLSCertificate.Validation(certificate: $0)
            }

            applicationLoadBalancer = Resource(
                name: "\(name)-alb",
                type: "awsx:lb:ApplicationLoadBalancer",
                properties: [
                    "listeners": [
                        tlsCertificate
                            .map { ["port": 443, "protocol": "HTTPS", "certificateArn": $0.arn] }
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
                options: options
            )

            service = Resource(
                name: "\(name)-service",
                type: "awsx:ecs:FargateService",
                properties: [
                    "cluster": cluster.arn,
                    "desiredCount": concurrency,
                    "continueBeforeSteadyState": true,
                    "networkConfiguration": [
                        "assignPublicIp": true,
                        "securityGroups": [instanceSecurityGroup.id],
                        "subnets": vpc.publicSubnetIds,
                    ],
                    "taskDefinitionArgs": [
                        "runtimePlatform": [
                            "cpuArchitecture": Architecture.current.ecsArchitecture
                        ],
                        "container": [
                            "name": tokenize("\(name)-container"),
                            "image": dockerImage.uri,
                            "cpu": cpu,
                            "memory": memory,
                            "essential": true,
                            "portMappings": [
                                [
                                    "containerPort": instancePort,
                                    "hostPort": instancePort,
                                    "targetGroup": applicationLoadBalancer.keyPath("defaultTargetGroup"),
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
                options: options
            )

            if let autoScaling {
                enableAutoScaling(
                    minimumConcurrency: autoScaling.minimumConcurrency,
                    maximumConcurrency: autoScaling.maximumConcurrency,
                    metrics: autoScaling.metrics
                )
            }

            Context.current.store.invoke { _ in
                let dockerFile = Docker.Dockerfile.amazonLinux(targetName: targetName, port: instancePort)
                try Docker.Dockerfile.write(dockerFile, to: dockerFilePath)
            }

            Context.current.store.build {
                try await $0.builder.buildAmazonLinux(targetName: targetName)
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
            metrics: metrics,
            options: self.service.options
        )
    }
}
