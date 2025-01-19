import Testing

@testable import CloudCore

@Suite("Project Tests")
struct ProjectTests {
    struct TestProject: Project {
        func build() async throws -> CloudCore.Outputs {
            return [:]
        }
    }

    @Test("Build context")
    func buildContext() async throws {
        let context = Context(
            stage: "testing",
            project: TestProject(),
            package: .init(name: "test"),
            store: .init(),
            builder: .init()
        )
        #expect(context.stage == "testing")
    }
}
