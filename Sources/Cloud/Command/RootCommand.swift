import ArgumentParser
import Foundation
import Yams

struct Command: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A utility to deploy Swift applications to the cloud.",
        subcommands: [Deploy.self, Preview.self, Cancel.self, Remove.self]
    )

    static func commandLineArguments() -> [String] {
        return [] + CommandLine.arguments.dropFirst()
    }
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
    class Store {
        fileprivate var resources: [Resource] = []

        fileprivate var variables: [Variable] = []

        fileprivate var operations: [() async throws -> Void] = []

        fileprivate var builds: [(Build) async throws -> Void] = []

        @TaskLocal static var current: Store!

        static func track(_ resource: Resource) {
            Store.current.resources.append(resource)
        }

        static func track(_ variable: Variable) {
            Store.current.variables.append(variable)
        }

        static func invoke(_ operation: @escaping () async throws -> Void) {
            Store.current.operations.append(operation)
        }

        static func build(_ operation: @escaping (Build) async throws -> Void) {
            Store.current.builds.append(operation)
        }
    }
}

extension Command {
    struct Prepared {
        let context: Context
        let project: Project
        let client: PulumiClient
        let outputs: Outputs
    }
}

extension Command.RunCommand {
    func prepare(with project: Project, withBuilds: Bool = false) async throws -> Command.Prepared {
        let context = Context(stage: options.stage)
        let store = Command.Store()
        let client = PulumiClient()

        // Generate the project resources and collect outputs
        let outputs: Outputs = try await Command.Store.$current.withValue(store) {
            return try await Context.$current.withValue(context) {
                return try await project.build()
            }
        }

        // Build the pulumi project
        let pulumiProject = Pulumi.Project(
            name: slugify(project.name),
            runtime: .yaml,
            backend: .init(url: .local(path: client.statePath)),
            resources: store.resources.reduce(into: [:]) {
                $0.merge($1.pulumiProjectResources()) { $1 }
            },
            variables: store.variables.reduce(into: [:]) {
                $0.merge($1.pulumiProjectVariables()) { $1 }
            },
            outputs: outputs.pulumiProjectOutputs
        )

        // Write pulumi configuration files
        let encoder = YAMLEncoder()
        encoder.options.indent = 2
        encoder.options.mappingStyle = .block
        encoder.options.sequenceStyle = .block
        encoder.options.sortKeys = true
        let yaml = try encoder.encode(pulumiProject)
        try createFile(atPath: client.configFilePath, contents: yaml)

        // Execute any operations
        for operation in store.operations {
            try await operation()
        }

        // Execute any builds
        if withBuilds {
            let builder = Build()
            for build in store.builds {
                try await build(builder)
            }
        }

        // Upsert our stack
        do {
            try FileManager.default.createDirectory(atPath: client.statePath, withIntermediateDirectories: true)
            try await client.invoke(command: "stack", arguments: ["select", context.stage])
        } catch {
            try await client.invoke(command: "stack", arguments: ["init", "--stack", context.stage])
        }

        return Command.Prepared(
            context: context,
            project: project,
            client: client,
            outputs: outputs
        )
    }
}
