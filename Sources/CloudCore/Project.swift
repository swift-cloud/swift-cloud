import ArgumentParser
import Command
import ConsoleKitTerminal

public protocol Project: Sendable {
    init()

    var home: any HomeProvider { get }

    var providers: [Provider] { get }

    func build() async throws -> Outputs
}

extension Project {
    var providers: [Provider] {
        []
    }

    var home: Home.Local {
        .init()
    }
}

extension Project {
    public static func main() async throws {
        let command = try? Command.parseAsRoot()
        switch command {
        case let command as Command.RunCommand:
            let project = Self()
            let builder = Builder()
            let store = Store()
            let context = try await Context(
                stage: command.options.stage,
                project: project,
                package: .current(),
                store: store,
                builder: builder
            )
            await Context.$current.withValue(context) {
                UI.writeHeader()
                do {
                    try await command.invoke(with: context)
                    try await command.complete(with: context)
                } catch let ShellError.terminated(errorCode, stderr) {
                    UI.error("Command terminated with error \(errorCode): \(stderr)")
                } catch {
                    UI.error(error)
                }
                UI.writeFooter()
            }
        default:
            UI.newLine()
            UI.error("➜  Invalid command:   ensure you pass a stage, ie: --stage prod")
            UI.newLine()
        }
    }
}
