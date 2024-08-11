import ArgumentParser
import ConsoleKitTerminal

public protocol Project: Sendable {
    associatedtype ProjectHomeProvider: HomeProvider

    init()

    var home: ProjectHomeProvider { get }

    var providers: [Provider] { get }

    func build() async throws -> Outputs
}

extension Project {
    public var home: Home.AWS {
        Home.AWS()
    }
}

extension Project {
    public var providers: [Provider] {
        [.aws(region: "us-east-1")]
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
