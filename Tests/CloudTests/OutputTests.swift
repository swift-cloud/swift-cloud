import XCTest

@testable import Cloud

final class OutputTests: XCTestCase {
    func testRoot() throws {
        let out = Output<Any>(prefix: "", root: "root", path: [])
        XCTAssertEqual("${root}", out.description)
    }

    func testRootWithPath() throws {
        let out = Output<Any>(
            prefix: "",
            root: "root",
            path: [
                .property("foo"),
                .arrayIndex(4),
                .dictionaryKey("bar"),
            ]
        )
        XCTAssertEqual("${root.foo[4][\"bar\"]}", out.description)
    }

    func testRootWithPrefix() throws {
        let out = Output<Any>(
            prefix: "https://",
            root: "root",
            path: []
        )
        XCTAssertEqual("https://${root}", out.description)
    }

    func testDynamicMemberLookup() throws {
        typealias T = (a: Int, b: Int, c: Int)
        let out = Output<T>(prefix: "", root: "root", path: []).a
        XCTAssertEqual("${root.a}", out.description)
    }

    func testDynamicMemberArrayLookup() throws {
        typealias T = (a: [Int], b: [Int], c: [Int])
        let out = Output<T>(prefix: "", root: "root", path: []).a[5]
        XCTAssertEqual("${root.a[5]}", out.description)
    }

    func testStringLiteral() throws {
        let out: Output<String> = "hello-world"
        XCTAssertEqual("hello-world", out.description)
    }

    func testStringInterpolation() throws {
        let root = Output<Any>(prefix: "", root: "root", path: [])
        let out: Output<String> = "foo-bar\(root)hello-world"
        XCTAssertEqual("foo-bar${root}hello-world", out.description)
    }

    func testEncodable() throws {
        typealias T = (a: [Int], b: [Int], c: [Int])
        let out = Output<T>(prefix: "", root: "root", path: []).a[5]
        let data = try JSONEncoder().encode(out)
        XCTAssertEqual("\"${root.a[5]}\"", String(data: data, encoding: .utf8))
    }
}
