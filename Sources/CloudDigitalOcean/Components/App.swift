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
            region: Region = .nyc3,
            instancePort: Int = 8080,
            environment: [String: CustomStringConvertible]? = nil,
            options: Resource.Options? = nil
        ) {
            self.environment = Environment(environment, shape: .keyValueList)

            let dockerFilePath = Docker.Dockerfile.filePath(name)

            app = Resource(
                name: name,
                type: "digitalocean:App",
                properties: [
                    "projectId": project.id,
                    "spec": [
                        "name": tokenize(Context.current.stage, name, "spec"),
                        "region": region.rawValue,
                        "envs": self.environment,
                        "services": [
                            [
                                "name": tokenize(Context.current.stage, name, "service-0"),
                                "dockerfilePath": dockerFilePath,
                                "image": [
                                    "registryType": "DOCR"
                                        // "repository": tokenize(Context.current.stage, name, "repo"),
                                        // "registryCredentials": ContainerRegistry.shared().credentials.dockerCredentials,
                                ],
                                "httpPort": instancePort,
                            ]
                        ],
                    ],
                ],
                options: options
            )

            Context.current.store.build {
                let dockerFile = Docker.Dockerfile.amazonLinux(targetName: targetName, port: instancePort)
                try Docker.Dockerfile.write(dockerFile, to: dockerFilePath)
                try await $0.builder.buildAmazonLinux(targetName: targetName)
            }
        }
    }
}
