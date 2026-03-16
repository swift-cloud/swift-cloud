import Testing

@testable import CloudAWS

@Suite("AWS Bucket CORS Rule Tests")
struct BucketCORSRuleTests {
    @Test("Accepts wildcard and origin URLs without path query or fragment")
    func acceptsValidOrigins() {
        #expect(AWS.Bucket.CORSRule.isValidOrigin("*"))
        #expect(AWS.Bucket.CORSRule.isValidOrigin("https://example.com"))
        #expect(AWS.Bucket.CORSRule.isValidOrigin("http://localhost"))
        #expect(AWS.Bucket.CORSRule.isValidOrigin("https://example.com:8443"))
    }

    @Test("Rejects invalid CORS origins")
    func rejectsInvalidOrigins() {
        #expect(!AWS.Bucket.CORSRule.isValidOrigin("example.com"))
        #expect(!AWS.Bucket.CORSRule.isValidOrigin("ftp://example.com"))
        #expect(!AWS.Bucket.CORSRule.isValidOrigin("https://example.com/path"))
        #expect(!AWS.Bucket.CORSRule.isValidOrigin("https://example.com?foo=bar"))
        #expect(!AWS.Bucket.CORSRule.isValidOrigin("https://example.com#fragment"))
    }
}
