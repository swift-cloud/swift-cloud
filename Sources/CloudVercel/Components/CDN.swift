import CloudCore
import Foundation

extension Vercel {
    public struct CDN: VercelComponent {
        public let name: Output<String>

        public let project: Project

        public let prebuiltProject: Output<GetPrebuiltProject>

        public var url: Output<String> {
            deployment.output.keyPath("url")
        }

        private let deployment: Resource

        public init(
            _ name: String,
            origins: [Vercel.CDN.Origin],
            project: Project? = nil,
            teamId: String? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.name = "\(name)"

            self.project = project ?? Project(name, options: options, context: context)

            self.prebuiltProject = getPrebuiltProject(path: Context.cloudDirectory)

            let vercelJsonPath = "\(Context.cloudDirectory)/.vercel/output/config.json"

            self.deployment = Resource(
                name: "\(name)-deployment",
                type: "vercel:Deployment",
                properties: [
                    "projectId": self.project.id,
                    "teamId": teamId,
                    "files": self.prebuiltProject.output,
                    "production": true
                ],
                options: options,
                context: context
            )

            context.store.build { _ in
                let routes = origins.map { origin in
                    [
                        "src": "\(origin.path)/(.*)".replacing("//(", with: "/("),
                        "dest": "\(origin.url)/$1".replacing("//$", with: "/$")
                    ]
                }
                let json = [
                    "version": 3,
                    "routes": routes
                ]
                let contents = try JSONSerialization.data(withJSONObject: json, options: [
                    .prettyPrinted,
                    .sortedKeys,
                    .withoutEscapingSlashes,
                ])
                try Files.createFile(atPath: vercelJsonPath, contents: contents)
            }
        }
    }
}

extension Vercel.CDN {
    public struct Origin {
        public let url: String
        public let path: String

        public init(
            url: any Input<String>,
            path: any Input<String>
        ) {
            self.url = url.description
            self.path = path.description
        }
    }
}

extension Vercel.CDN.Origin {
    public static func url(
        _ url: any Input<String>, path: any Input<String>
    ) -> Self {
        .init(url: url, path: path)
    }
}
