import ArgumentParser
import Foundation
import ShellOut
import Yams

extension Command {
    struct Deploy: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Deploy your application")

        @OptionGroup var options: Options

        func invoke(with project: any Project) async throws {
            let prepared = try await prepare(with: project)

            print("Building...")
            try await Build().build()
            print("Build complete")

            let output = try await prepared.client.invoke(command: "up", arguments: ["--skip-preview", "--yes"])
            print(output)
        }
    }
}
