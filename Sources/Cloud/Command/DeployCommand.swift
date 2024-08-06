import ArgumentParser
import Foundation

extension Command {
    struct Deploy: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Deploy your application")

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let prepared = try await prepare(with: context, buildTargets: true)
            let output = try await prepared.client.invoke(command: "up", arguments: ["--skip-preview", "--yes"])
            print(output)
        }
    }
}
