import XCTest

@testable import Cloud

final class TokenUtilsTests: XCTestCase {
    func testTokenizeSimple() throws {
        let value = tokenize("Hello World")
        XCTAssertEqual(value, "hello-world")
    }

    func testTokenizeCamelCase() throws {
        let value = tokenize("  --- camelCase ----")
        XCTAssertEqual(value, "camel-case")
    }
}
