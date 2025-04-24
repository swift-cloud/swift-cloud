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

            let vercelProjectPath = "\(Context.cloudDirectory)/.vercel/\(context.project.name)"

            let prebuiltProject = getPrebuiltProject(path: vercelProjectPath)

            self.deployment = Resource(
                name: "\(name)-deployment",
                type: "vercel:Deployment",
                properties: [
                    "projectId": self.project.id,
                    "teamId": teamId,
                    "files": prebuiltProject.keyPath("output"),
                    "pathPrefix": prebuiltProject.keyPath("path"),
                    "production": true,
                    "environment": [
                        "SWIFT_ORIGIN_URL": origins[0].url
                    ]
                ],
                options: options,
                context: context
            )

            context.store.build { _ in
                let config = [
                    "version": 3,
                    "routes": origins.map { origin in
                        [
                            "src": "\(origin.path)/(.*)".replacing("//(.*)", with: "/(.*)"),
                            "middlewarePath": "\(vercelProjectPath)/.vercel/output/functions/edge.func"
                        ]
                    }
                ]
                try Files.createFile(
                    atPath: "\(vercelProjectPath)/.vercel/output/config.json",
                    contents: JSONSerialization.data(withJSONObject: config, options: [
                        .prettyPrinted,
                        .sortedKeys,
                        .withoutEscapingSlashes,
                    ])
                )

                let fnConfig = [
                    "runtime": "edge",
                    "entrypoint": "index.js",
                    "envVarsInUse": ["SWIFT_ORIGIN_URL"]
                ]
                try Files.createFile(
                    atPath: "\(vercelProjectPath)/.vercel/output/functions/edge.func/.vc-config.json",
                    contents: JSONSerialization.data(withJSONObject: fnConfig, options: [
                        .prettyPrinted,
                        .sortedKeys,
                        .withoutEscapingSlashes,
                    ])
                )

                try Files.createFile(
                    atPath: "\(vercelProjectPath)/.vercel/output/functions/edge.func/index.js",
                    contents: """
                    export default async function handler(request) {
                        return new Response("", {
                            headers: {
                                "x-middleware-rewrite": process.env.SWIFT_ORIGIN_URL
                            }
                        });
                    }
                    """
                )
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
