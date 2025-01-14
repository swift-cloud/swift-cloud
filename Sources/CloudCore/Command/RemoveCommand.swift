import ArgumentParser
import Foundation

extension Command {
    struct RemoveCommand: RunCommand {
        static let configuration = CommandConfiguration(
            commandName: "remove",
            abstract: "Remove your application"
        )

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = UI.spinner(label: "Removing application")
            do {
                let prepared = try await prepare(with: context)
                let output = try await prepared.client.invoke(
                    command: "destroy",
                    arguments: ["--continue-on-error", "--skip-preview", "--yes"],
                    onEvent: { spinner.push($0.string()) }
                )
                spinner.stop()
                UI.writeBlock(output)
            } catch {
                spinner.stop()
                throw error
            }
        }
    }
}
