import Testing

@testable import CloudCore

@Suite("Pulumi Tests")
struct PulumiTests {
    @Test func setupPulumi() async throws {
        let client = Pulumi.Client(context: "testing")
        try await client.setup()
        #expect(client.isSetup)
    }
}
