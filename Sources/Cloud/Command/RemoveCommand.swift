import ArgumentParser
import Foundation

extension Command {
    struct Remove: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Remove your application")

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let prepared = try await prepare(with: context)
            let output = try await prepared.client.invoke(
                command: "destroy", arguments: ["--continue-on-error", "--skip-preview", "--yes"])
            print(output)
        }
    }
}
