import ArgumentParser
import ConsoleKitTerminal
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

        func invoke(with context: Context) async throws

        func complete(with context: Context) async throws
    }
}

extension Command {
    struct Prepared {
        let context: Context
        let client: Pulumi.Client
        let outputs: Outputs
    }
}

extension Command.RunCommand {
    func prepare(with context: Context, buildTargets: Bool = false) async throws -> Command.Prepared {
        // Bootstrap the home
        try await context.home.bootstrap(with: context)

        // Restore external state if available
        try? await context.home.pullState(context: context)

        // Create pulumi client with passphrase
        let client = Pulumi.Client(
            passphrase: try await context.home.passphrase(with: context)
        )

        // Generate the project resources and collect outputs
        let outputs = try await context.project.build()

        // Build the pulumi project
        let pulumiProject = Pulumi.Project(
            name: context.packageName,
            runtime: .yaml,
            backend: client.localProjectBackend(),
            resources: context.store.resources.reduce(into: [:]) {
                $0.merge($1.pulumiProjectResources()) { $1 }
            },
            variables: context.store.variables.reduce(into: [:]) {
                $0.merge($1.pulumiProjectVariables()) { $1 }
            },
            outputs: outputs.pulumiProjectOutputs
        )

        // Write pulumi configuration files
        try client.writePulumiProject(pulumiProject)

        // Execute any operations
        for operation in context.store.operations {
            try await operation(context)
        }

        // Execute any builds
        if buildTargets {
            for build in context.store.builds {
                try await build(context)
            }
        }

        // Upsert our stack
        try await client.upsertStack(stage: context.stage)

        // Configure all providers
        for provider in context.project.providers {
            try await client.installPlugins([provider.plugin] + provider.dependencies)
            try await client.configure(provider)
        }

        // Update gitignore
        try? updateGitignore()

        return Command.Prepared(
            context: context,
            client: client,
            outputs: outputs
        )
    }
}

extension Command.RunCommand {
    func complete(with context: Context) async throws {
        do {
            try await context.home.pushState(context: context)
        } catch {
            ui.error(error)
        }
    }
}
