import ArgumentParser
import Foundation

extension Command {
    struct Deploy: RunCommand {
        static let configuration = CommandConfiguration(abstract: "Deploy your application")

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = ui.spinner(label: "Deploying changes...")
            do {
                let prepared = try await prepare(with: context, buildTargets: true)
                let output = try await prepared.client.invoke(command: "up", arguments: ["--skip-preview", "--yes"])
                spinner.succeed()
                ui.writeBlock(output)
            } catch {
                spinner.fail()
                throw error
            }
        }
    }
}
