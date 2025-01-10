import CloudCore
import Foundation

extension DigitalOcean {
    public struct App: DigitalOceanComponent, EnvironmentProvider {
        public let app: Resource
        public let environment: Environment

        public var name: Output<String> {
            app.name
        }

        public init(
            _ name: String,
            project: Project,
            targetName: String,
            registry: ContainerRegistry,
            region: Region = .nyc3,
            instancePort: Int = 8080,
            environment: [String: CustomStringConvertible]? = nil,
            options: Resource.Options? = nil
        ) {
            self.environment = Environment(environment, shape: .keyValueList)

            let dockerFilePath = Docker.Dockerfile.filePath(name)

            let architecture = Architecture.x86

            let repository = tokenize(Context.current.stage, name)

            let digitalOceanToken = Context.current.project.digitalOceanToken()

            let image = Resource(
                name: tokenize(Context.current.stage, name, "repo"),
                type: "docker-build:Image",
                properties: [
                    "push": true,
                    "dockerfile": ["location": dockerFilePath],
                    "context": ["location": Context.projectDirectory],
                    "platforms": ["linux/\(architecture.dockerPlatform)"],
                    "tags": ["\(registry.endpoint)/\(repository):latest"],
                    "registries": [
                        [
                            "address": registry.hostname,
                            "username": digitalOceanToken,
                            "password": digitalOceanToken,
                        ]
                    ],
                ],
                options: options
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
                            ]
                        ],
                    ],
                ],
                options: options
            )

            Context.current.store.build {
                let dockerFile = Docker.Dockerfile.ubuntu(
                    targetName: targetName,
                    architecture: architecture,
                    port: instancePort
                )
                try Docker.Dockerfile.write(dockerFile, to: dockerFilePath)
                try await $0.builder.buildUbuntu(targetName: targetName, architecture: architecture)
            }
        }
    }
}
