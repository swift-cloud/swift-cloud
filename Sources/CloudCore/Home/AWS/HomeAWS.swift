import Foundation
import SotoCore

extension Home {
    public final class AWS: HomeProvider {
        public enum Error: Swift.Error {
            case invalidAccount
        }

        public let region: Region

        private let client: AWSClient

        private let sts: STS

        private let s3: S3

        public init(region regionValue: String = "us-east-1") {
            region = .init(rawValue: regionValue)
            client = AWSClient()
            sts = STS(client: client, region: region)
            s3 = S3(client: client, region: region)
        }

        deinit {
            try? client.syncShutdown()
        }

        public func bootstrap(with context: Context) async throws {
            let bucketName = try await s3BucketName()
            let request = S3.CreateBucketRequest(bucket: bucketName)
            _ = try? await s3.createBucket(request)
        }

        public func putItem<T: HomeProviderItem>(_ item: T, fileName: String, with context: Context) async throws {
            let data = try JSONEncoder().encode(item)
            let bytes = ByteBuffer(data: data)
            let bucketName = try await s3BucketName()
            let key = contextualFileName(fileName, with: context)
            let request = S3.PutObjectRequest(body: .init(buffer: bytes), bucket: bucketName, key: key)
            _ = try await s3.putObject(request)
        }

        public func getItem<T: HomeProviderItem>(fileName: String, with context: Context) async throws -> T {
            let bucketName = try await s3BucketName()
            let key = contextualFileName(fileName, with: context)
            let request = S3.GetObjectRequest(bucket: bucketName, key: key)
            let response = try await s3.getObject(request)
            let data = try await response.body.collect(upTo: 1024 * 1024)
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}

extension Home.AWS {
    private func s3BucketName() async throws -> String {
        let account = try await awsAccountId()
        return "swift-cloud-assets-\(account)"
    }
}

extension Home.AWS {
    private func awsAccountId() async throws -> String {
        let request = STS.GetCallerIdentityRequest()
        let response = try await sts.getCallerIdentity(request)
        guard let account = response.account else {
            throw Error.invalidAccount
        }
        return account
    }
}
