import ArgumentParser
import Foundation
import Yams

extension Command {
    struct Cancel: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Cancel changes to your application")

        @OptionGroup var options: Options

        func invoke(with project: any Project) async throws {
            let prepared = try await prepare(with: project)
            let output = try await prepared.client.invoke(command: "cancel")
            print(output)
        }
    }
}
