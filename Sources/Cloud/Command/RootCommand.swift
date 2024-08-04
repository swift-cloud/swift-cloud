//
//  RootCommand.swift
//
//
//  Created by Andrew Barba on 8/4/24.
//

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
        @TaskLocal static var current: Store!

        var resources: [Resource] = []

        var variables: [Variable] = []
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
    func prepare(with project: Project) async throws -> Command.Prepared {
        let context = Context(stage: options.stage)
        let store = Command.Store()
        let client = PulumiClient()

        // Generate the project resources and collect outputs
        let outputs = try await Command.Store.$current.withValue(store) {
            return try await project.run(context: context)
        }

        // Build the pulumi project
        let pulumiProject = Pulumi.Project(
            name: slugify(project.name, context.stage),
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
        let yaml = try encoder.encode(pulumiProject)
        FileManager.default.createFile(atPath: client.configFilePath, contents: yaml.data(using: .utf8))

        // Upsert our stack
        do {
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
