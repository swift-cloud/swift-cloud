import Testing
import Foundation
@testable import Cloud

@Suite("Output Tests")
struct OutputTests {
    @Test("Root output formatting")
    func root() throws {
        let out = Output<Any>(prefix: "", root: "root", path: [])
        #expect(out.description == "${root}")
    }

    @Test("Output with path components")
    func rootWithPath() throws {
        let out = Output<Any>(
            prefix: "",
            root: "root",
            path: [
                .property("foo"),
                .arrayIndex(4),
                .dictionaryKey("bar"),
            ]
        )
        #expect(out.description == "${root.foo[4][\"bar\"]}")
    }

    @Test("Output with prefix")
    func rootWithPrefix() throws {
        let out = Output<Any>(
            prefix: "https://",
            root: "root",
            path: []
        )
        #expect(out.description == "https://${root}")
    }

    @Test("Dynamic member lookup")
    func dynamicMemberLookup() throws {
        typealias T = (a: Int, b: Int, c: Int)
        let out = Output<T>(prefix: "", root: "root", path: []).a
        #expect(out.description == "${root.a}")
    }

    @Test("Dynamic member array lookup")
    func dynamicMemberArrayLookup() throws {
        typealias T = (a: [Int], b: [Int], c: Int)
        let out = Output<T>(prefix: "", root: "root", path: []).a[5]
        #expect(out.description == "${root.a[5]}")
    }

    @Test("String literal initialization")
    func stringLiteral() throws {
        let out: Output<String> = "hello-world"
        #expect(out.description == "hello-world")
    }

    @Test("String interpolation")
    func stringInterpolation() throws {
        let root = Output<Any>(prefix: "", root: "root", path: [])
        let out: Output<String> = "foo-bar\(root)hello-world"
        #expect(out.description == "foo-bar${root}hello-world")
    }

    @Test("Encodable conformance")
    func encodable() throws {
        typealias T = (a: [Int], b: [Int], c: Int)
        let out = Output<T>(prefix: "", root: "root", path: []).a[5]
        let data = try JSONEncoder().encode(out)
        #expect(String(data: data, encoding: .utf8) == "\"${root.a[5]}\"")
    }
}
