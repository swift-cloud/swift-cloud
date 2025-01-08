import ArgumentParser
import Foundation

extension Command {
    struct OutputsCommand: RunCommand {
        static let configuration = CommandConfiguration(
            commandName: "outputs",
            abstract: "Show project outputs"
        )

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = UI.spinner(label: "Exporting outputs")
            do {
                let prepared = try await prepare(with: context)
                let outputs = try await prepared.client.stackOutputs()
                spinner.stop()
                UI.writeOutputs(outputs)
            } catch {
                spinner.stop()
                UI.error("➜  No deployments found for this stage")
            }
        }
    }
}
