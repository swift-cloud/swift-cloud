@preconcurrency import AWSS3
@preconcurrency import AWSSDKIdentity
@preconcurrency import AWSSTS
import CloudCore
import Foundation
import SmithyIdentity

extension AWS {
    public struct Home: HomeProvider {
        public let region: String

        private let sts: STSClient

        private let s3: S3Client

        public init(region: String = "us-east-1") {
            self.region = region
            self.s3 = try! .init(
                config: .init(
                    awsCredentialIdentityResolver: Self.credentialIdentityResolver(),
                    region: region
                )
            )
            self.sts = try! .init(
                config: .init(
                    awsCredentialIdentityResolver: Self.credentialIdentityResolver(),
                    region: region
                )
            )
        }

        public func bootstrap(with context: Context) async throws {
            let bucketName = try await s3BucketName()
            _ = try await s3.createBucket(input: .init(bucket: bucketName))
        }

        public func putItem<T: HomeProviderItem>(_ item: T, fileName: String, with context: Context) async throws {
            let data = try JSONEncoder().encode(item)
            let bucketName = try await s3BucketName()
            let key = contextualFileName(fileName, with: context)
            _ = try await s3.putObject(input: .init(body: .data(data), bucket: bucketName, key: key))
        }

        public func getItem<T: HomeProviderItem>(fileName: String, with context: Context) async throws -> T {
            let bucketName = try await s3BucketName()
            let key = contextualFileName(fileName, with: context)
            let response = try await s3.getObject(input: .init(bucket: bucketName, key: key))
            let data = try await response.body?.readData()
            return try JSONDecoder().decode(T.self, from: data ?? .init())
        }
    }
}

extension AWS.Home {
    private func s3BucketName() async throws -> String {
        let account = try await awsAccountId()
        return "swift-cloud-assets-\(account)"
    }
}

extension AWS.Home {
    public enum Error: Swift.Error {
        case invalidAccount
    }

    private func awsAccountId() async throws -> String {
        let response = try await sts.getCallerIdentity(input: .init())
        guard let account = response.account else {
            throw Error.invalidAccount
        }
        return account
    }

    private static func credentialIdentityResolver() throws -> (any SmithyIdentity.AWSCredentialIdentityResolver)? {
        let env = Context.environment
        if let accessKey = env["AWS_ACCESS_KEY_ID"], let secret = env["AWS_SECRET_ACCESS_KEY"] {
            let sessionToken = env["AWS_SESSION_TOKEN"]
            return try StaticAWSCredentialIdentityResolver(
                .init(accessKey: accessKey, secret: secret, sessionToken: sessionToken)
            )
        }
        return nil
    }
}

extension HomeProvider where Self == AWS.Home {
    public static func aws(region: String = "us-east-1") -> Self {
        .init(region: region)
    }
}
