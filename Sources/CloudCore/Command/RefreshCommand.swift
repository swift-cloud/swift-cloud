import ArgumentParser
import Foundation

extension Command {
    struct RefreshCommand: RunCommand {
        static let configuration = CommandConfiguration(
            commandName: "refresh",
            abstract: "Refresh your application"
        )

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = UI.spinner(label: "Refreshing application state")
            do {
                let prepared = try await prepare(with: context)
                let output = try await prepared.client.invoke(
                    command: "refresh",
                    arguments: ["--clear-pending-creates", "--skip-preview", "--yes"],
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
