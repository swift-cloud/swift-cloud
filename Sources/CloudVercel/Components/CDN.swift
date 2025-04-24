import CloudCore
import Foundation

extension Vercel {
    public struct CDN: VercelComponent {
        public let name: Output<String>

        public let project: Project

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

            let vercelProjectPath = "\(Context.cloudDirectory)/.vercel"

            self.deployment = Resource(
                name: "\(name)-deployment",
                type: "vercel:Deployment",
                properties: [
                    "projectId": self.project.id,
                    "teamId": teamId,
                    "files": getProjectDirectory(path: vercelProjectPath).files,
                    "pathPrefix": getProjectDirectory(path: vercelProjectPath).keyPath("path")
                ],
                options: options,
                context: context
            )

            context.store.build { _ in
                let rewrites = origins.map { origin in
                    [
                        "source": "\(origin.path)/:match*".replacing("//:match*", with: "/:match*"),
                        "destination": "\(origin.url)/:match*".replacing("//:match*", with: "/:match*")
                    ]
                }
                let json = [
                    "$schema": "https://openapi.vercel.sh/vercel.json",
                    "cleanUrls": true,
                    "rewrites": rewrites
                ]
                let contents = try JSONSerialization.data(withJSONObject: json, options: [
                    .prettyPrinted,
                    .sortedKeys,
                    .withoutEscapingSlashes,
                ])
                try Files.createFile(atPath: "\(vercelProjectPath)/vercel.json", contents: contents)
                try Files.createFile(atPath: "\(vercelProjectPath)/public/file.txt", contents: "Hello, World.")
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
