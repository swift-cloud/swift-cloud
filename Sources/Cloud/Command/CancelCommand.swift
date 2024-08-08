import ArgumentParser
import Foundation

extension Command {
    struct Cancel: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Cancel changes to your application")

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = ui.spinner(label: "Cancelling changes")
            do {
                let prepared = try await prepare(with: context)
                let output = try await prepared.client.invoke(command: "cancel")
                spinner.stop()
                ui.writeBlock(output)
            } catch {
                spinner.stop()
                throw error
            }
        }
    }
}
