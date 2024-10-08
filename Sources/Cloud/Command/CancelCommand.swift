import ArgumentParser
import Foundation

extension Command {
    struct CancelCommand: RunCommand {
        static let configuration = CommandConfiguration(
            commandName: "cancel",
            abstract: "Cancel changes to your application"
        )

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = UI.spinner(label: "Cancelling changes")
            do {
                let prepared = try await prepare(with: context)
                let output = try await prepared.client.invoke(command: "cancel")
                spinner.stop()
                UI.writeBlock(output)
            } catch {
                spinner.stop()
                throw error
            }
        }
    }
}
