import ArgumentParser
import Foundation

extension Command {
    struct DeployCommand: RunCommand {
        static let configuration = CommandConfiguration(
            commandName: "deploy",
            abstract: "Deploy your application"
        )

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = UI.spinner(label: "Deploying changes")
            do {
                let prepared = try await prepare(with: context, buildTargets: true)
                try await prepared.client.invoke(command: "up", arguments: ["--skip-preview", "--yes"])
                let outputs = try await prepared.client.stackOutputs()
                spinner.stop()
                UI.writeOutputs(outputs)
            } catch {
                spinner.stop()
                throw error
            }
        }
    }
}
