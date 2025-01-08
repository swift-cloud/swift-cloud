import ArgumentParser
import Foundation

extension Command {
    struct BuildCommand: RunCommand {
        static let configuration = CommandConfiguration(
            commandName: "build",
            abstract: "Build your application"
        )

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = UI.spinner(label: "Building")
            do {
                _ = try await prepare(with: context, buildTargets: true)
                spinner.stop()
            } catch {
                spinner.stop()
                throw error
            }
        }
    }
}
