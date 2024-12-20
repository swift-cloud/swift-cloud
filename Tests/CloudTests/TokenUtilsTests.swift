import Testing
@testable import Cloud

@Suite("Token Utils Tests")
struct TokenUtilsTests {
    @Test("Simple tokenization")
    func tokenizeSimple() throws {
        let value = tokenize("Hello World")
        #expect(value == "hello-world")
    }

    @Test("Camel case tokenization")
    func tokenizeCamelCase() throws {
        let value = tokenize("  --- camelCase ----")
        #expect(value == "camel-case")
    }
}
