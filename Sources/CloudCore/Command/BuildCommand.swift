import ArgumentParser
import Foundation

extension Command {
    struct BuildCommand: RunCommand {
        static let configuration = CommandConfiguration(
            commandName: "build",
            abstract: "Build your project"
        )

        @OptionGroup var options: Options

        func invoke(with context: Context) async throws {
            let spinner = UI.spinner(label: "Building")
            do {
                _ = try await context.project.build()
                try writeSDKResources(.init(context.store.links.values))
                for build in context.store.builds {
                    try await build(context)
                }
                spinner.stop()
            } catch {
                spinner.stop()
                throw error
            }
        }
    }
}
