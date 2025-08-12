import CloudCore
import Foundation

extension DigitalOcean {
    public struct App: DigitalOceanComponent, EnvironmentProvider {
        public let app: Resource
        public let environment: Environment

        public var name: Output<String> {
            app.name
        }

        public var hostname: Output<String> {
            app.output.keyPath("liveDomain")
        }

        public var url: Output<String> {
            app.output.keyPath("liveUrl")
        }

        public init(
            _ name: String,
            project: Project,
            targetName: String,
            registryName: String,
            region: Region = .nyc3,
            instanceSize: InstanceSize = .shared_1vCPU_512mb,
            instancePort: Int = 8080,
            environment: [String: any Input<String>]? = nil,
            arguments: [String]? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.environment = Environment(environment, shape: .keyValueList)

            let dockerFilePath = Docker.Dockerfile.filePath(name)

            let architecture = Architecture.x86

            let repository = tokenize(context.stage, name)

            let digitalOceanToken = context.project.digitalOceanToken()

            let image = Resource(
                name: tokenize(context.stage, name, "repo"),
                type: "docker-build:Image",
                properties: [
                    "push": true,
                    "dockerfile": ["location": dockerFilePath],
                    "context": ["location": Context.projectDirectory],
                    "platforms": ["linux/\(architecture.dockerPlatform)"],
                    "tags": ["registry.digitalocean.com/\(registryName)/\(repository):latest"],
                    "registries": [
                        [
                            "address": "registry.digitalocean.com",
                            "username": digitalOceanToken,
                            "password": digitalOceanToken,
                        ]
                    ],
                ],
                options: options,
                context: context
            )

            app = Resource(
                name: name,
                type: "digitalocean:App",
                properties: [
                    "projectId": project.id,
                    "spec": [
                        "name": repository,
                        "region": region.rawValue,
                        "envs": self.environment,
                        "services": [
                            [
                                "name": tokenize(repository, "service-0"),
                                "dockerfilePath": dockerFilePath,
                                "image": [
                                    "registryType": "DOCR",
                                    "repository": repository,
                                    "digest": image.output.keyPath("digest"),
                                ],
                                "httpPort": instancePort,
                                "instanceSizeSlug": instanceSize.slug,
                                "autoscaling": instanceSize.autoScalingConfiguration.map {
                                    [
                                        "minInstanceCount": $0.minimumConcurrency,
                                        "maxInstanceCount": $0.maximumConcurrency,
                                        "metrics": [
                                            "cpu": ["percent": $0.cpuTarget.value]
                                        ],
                                    ]
                                } as Any?,
                            ]
                        ],
                    ],
                ],
                options: options,
                context: context
            )

            context.store.build {
                let dockerFile: String
                if let arguments = arguments {
                    dockerFile = Docker.Dockerfile.ubuntu(
                        targetName: targetName,
                        architecture: architecture,
                        port: instancePort,
                        arguments: arguments
                    )
                } else {
                    dockerFile = Docker.Dockerfile.ubuntu(
                        targetName: targetName,
                        architecture: architecture,
                        port: instancePort
                    )
                }
                try Docker.Dockerfile.write(dockerFile, to: dockerFilePath)
                try await $0.builder.buildUbuntu(targetName: targetName, architecture: architecture)
            }
        }
    }
}

extension DigitalOcean.App {
    public enum InstanceSize: Sendable {
        case shared(vCPU: Int, memory: Double)
        case dedicated(vCPU: Int, memory: Double, autoScaling: AutoScalingConfiguration?)

        public var slug: String {
            switch self {
            case .shared(let vCPU, let memory):
                return "apps-s-\(vCPU)vcpu-\(memory.formatted())gb"
            case .dedicated(let vCPU, let memory, _):
                return "apps-d-\(vCPU)vcpu-\(memory.formatted())gb"
            }
        }

        public var autoScalingConfiguration: AutoScalingConfiguration? {
            switch self {
            case .dedicated(_, _, let autoScaling):
                return autoScaling
            default:
                return nil
            }
        }
    }
}

extension DigitalOcean.App.InstanceSize {
    public static let shared_1vCPU_512mb = Self.shared(vCPU: 1, memory: 0.5)
    public static let shared_1vCPU_1gb = Self.shared(vCPU: 1, memory: 1)
    public static let shared_1vCPU_2gb = Self.shared(vCPU: 1, memory: 2)
    public static let shared_2vCPU_4gb = Self.shared(vCPU: 2, memory: 4)
}

extension DigitalOcean.App {
    public struct AutoScalingConfiguration: Sendable {
        public enum CPUTarget: Sendable {
            case percent(Int)

            public var value: Int {
                switch self {
                case .percent(let value):
                    return value
                }
            }
        }

        public let minimumConcurrency: Int
        public let maximumConcurrency: Int
        public let cpuTarget: CPUTarget

        public init(
            minimumConcurrency: Int = 1,
            maximumConcurrency: Int,
            cpuTarget: CPUTarget
        ) {
            self.minimumConcurrency = minimumConcurrency
            self.maximumConcurrency = maximumConcurrency
            self.cpuTarget = cpuTarget
        }
    }
}
