import ArgumentParser
import Foundation

extension Command {
    struct Cancel: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Cancel changes to your application")

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let prepared = try await prepare(with: context)
            let output = try await prepared.client.invoke(command: "cancel")
            print(output)
        }
    }
}
