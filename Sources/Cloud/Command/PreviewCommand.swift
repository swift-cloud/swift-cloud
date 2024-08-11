import ArgumentParser
import Foundation

extension Command {
    struct Preview: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Preview changes to your application")

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = UI.spinner(label: "Generating preview")
            do {
                let prepared = try await prepare(with: context)
                let output = try await prepared.client.invoke(command: "preview")
                spinner.stop()
                UI.writeBlock(output)
            } catch {
                spinner.stop()
                throw error
            }
        }
    }
}
