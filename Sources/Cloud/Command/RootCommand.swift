import ArgumentParser
import Foundation

struct Command: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility to deploy Swift applications to the cloud.",
        subcommands: [Deploy.self, Preview.self, Cancel.self, Remove.self]
    )
}

extension Command {
    struct Options: ParsableArguments {
        @Option var stage: String
    }
}

extension Command {
    protocol RunCommand: ParsableCommand {
        var options: Options { get }

        func invoke(with project: any Project) async throws
    }
}

extension Command {
    struct Prepared {
        let context: Context
        let project: Project
        let client: Pulumi.Client
        let outputs: Outputs
    }
}

extension Command.RunCommand {
    func prepare(with project: Project, withBuilds: Bool = false) async throws -> Command.Prepared {
        let context = Context(stage: options.stage, project: project)

        // Bootstrap the home
        try await project.home.bootstrap(with: context)

        // Create pulumi client with passphrase
        let client = Pulumi.Client(
            passphrase: try await project.home.passphrase(with: context)
        )

        // Create shared state
        let builder = Builder()
        let store = Store()

        // Generate the project resources and collect outputs
        let outputs: Outputs = try await Store.$current.withValue(store) {
            return try await Context.$current.withValue(context) {
                return try await project.build()
            }
        }

        // Build the pulumi project
        let pulumiProject = Pulumi.Project(
            name: slugify(project.name),
            runtime: .yaml,
            backend: client.localProjectBackend(),
            resources: store.resources.reduce(into: [:]) {
                $0.merge($1.pulumiProjectResources()) { $1 }
            },
            variables: store.variables.reduce(into: [:]) {
                $0.merge($1.pulumiProjectVariables()) { $1 }
            },
            outputs: outputs.pulumiProjectOutputs
        )

        // Write pulumi configuration files
        try client.writePulumiProject(pulumiProject)

        // Execute any operations
        for operation in store.operations {
            try await operation()
        }

        // Execute any builds
        if withBuilds {
            for build in store.builds {
                try await build(builder)
            }
        }

        // Upsert our stack
        try await client.upsertStack(stage: context.stage)

        // Update gitignore
        try? updateGitignore()

        return Command.Prepared(
            context: context,
            project: project,
            client: client,
            outputs: outputs
        )
    }
}
