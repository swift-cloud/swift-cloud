extension aws {
    public struct WebServer: Component {
        public let cluster: aws.Cluster
        public let dockerImage: DockerImage
        public let role: Role
        public let loadBalancerSecurityGroup: aws.SecurityGroup
        public let instanceSecurityGroup: aws.SecurityGroup
        public let applicationLoadBalancer: Resource
        public let service: Resource

        public var name: String {
            service.name
        }

        public var url: String {
            applicationLoadBalancer.keyPath("loadBalancer", "dnsName")
        }

        public init(
            _ name: String,
            targetName: String,
            concurrency: Int = 1,
            cpu: Int = 1024,
            memory: Int = 2048,
            instancePort: Int = 8080,
            vpc: aws.VPC = .default,
            environment: [String: String] = [:],
            options: Resource.Options? = nil
        ) {
            let dockerFilePath = Docker.Dockerfile.filePath(name)

            cluster = aws.Cluster(
                "\(name)-cluster",
                options: options
            )

            dockerImage = DockerImage(
                "\(name)-image",
                imageRepository: .shared(options: options),
                dockerFilePath: dockerFilePath,
                options: options
            )

            role = aws.Role(
                "\(name)-role",
                service: "ecs-tasks.amazonaws.com",
                options: options
            )

            loadBalancerSecurityGroup = aws.SecurityGroup(
                "\(name)-load-balancer-security-group",
                ingress: .all,
                egress: .all,
                options: options
            )

            instanceSecurityGroup = aws.SecurityGroup(
                "\(name)-task-security-group",
                ingress: [.securityGroup(loadBalancerSecurityGroup)],
                egress: .all,
                options: options
            )

            applicationLoadBalancer = Resource(
                name: "\(name)-alb",
                type: "awsx:lb:ApplicationLoadBalancer",
                properties: [
                    "listeners": [
                        ["port": 80, "protocol": "HTTP"],
                        ["port": 443, "protocol": "HTTPS"],
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
                            "environment": environment.map { key, value in
                                ["name": key, "value": value]
                            },
                        ],
                        "taskRole": [
                            "roleArn": role.arn
                        ],
                    ],
                ],
                options: options
            )

            Context.current.store.invoke { _ in
                let dockerFile = Docker.Dockerfile.awsECS(targetName: targetName)
                try createFile(atPath: dockerFilePath, contents: dockerFile)
            }

            Context.current.store.build {
                try await $0.builder.buildAmazonLinux(targetName: targetName)
            }
        }
    }
}

extension aws.WebServer: RoleProvider {}
