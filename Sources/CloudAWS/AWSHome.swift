import CloudCore
import Foundation
import SotoCore

extension AWS {
    public final class Home: HomeProvider {
        private let client: AWSClient
        private let sts: STS
        private let s3: S3

        public init(region: String = "us-east-1") {
            self.client = .init(credentialProvider: Self.credentialProvider())
            self.s3 = .init(client: client, region: .init(rawValue: region))
            self.sts = .init(client: client)
        }

        deinit {
            try? client.syncShutdown()
        }

        public func bootstrap(with context: Context) async throws {
            let bucketName = try await s3BucketName()
            _ = try await ensureBucketExists(bucketName)
        }

        public func putItem<T: HomeProviderItem>(_ item: T, fileName: String, with context: Context) async throws {
            let data = try JSONEncoder().encode(item)
            let bytes = ByteBuffer(data: data)
            let bucketName = try await s3BucketName()
            let key = contextualFileName(fileName, with: context)
            _ = try await s3.putObject(.init(body: .init(buffer: bytes), bucket: bucketName, key: key))
        }

        public func getItem<T: HomeProviderItem>(fileName: String, with context: Context) async throws -> T {
            let bucketName = try await s3BucketName()
            let key = contextualFileName(fileName, with: context)
            let response = try await s3.getObject(.init(bucket: bucketName, key: key))
            let data = try await response.body.collect(upTo: 1024 * 1024)
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
}

extension AWS.Home {
    private func s3BucketName() async throws -> String {
        let account = try await awsAccountId()
        return "swift-cloud-assets-\(account)"
    }

    private func ensureBucketExists(_ bucketName: String) async throws {
        do {
            _ = try await s3.createBucket(.init(bucket: bucketName))
        } catch let error as S3ErrorType {
            switch error {
            case .bucketAlreadyOwnedByYou:
                // Bucket already exists and is owned by us - this is expected behavior
                return
            case .bucketAlreadyExists:
                // Bucket exists but owned by someone else - this is a real error
                throw error
            default:
                // Any other S3 error should be propagated
                throw error
            }
        }
    }
}

extension AWS.Home {
    public enum Error: Swift.Error {
        case invalidAccount
    }

    private func awsAccountId() async throws -> String {
        let response = try await sts.getCallerIdentity()
        guard let account = response.account else {
            throw Error.invalidAccount
        }
        return account
    }

    private static func credentialProvider() -> CredentialProviderFactory {
        let env = Context.environment
        if let accessKey = env["AWS_ACCESS_KEY_ID"], let secret = env["AWS_SECRET_ACCESS_KEY"] {
            let sessionToken = env["AWS_SESSION_TOKEN"]
            return .static(accessKeyId: accessKey, secretAccessKey: secret, sessionToken: sessionToken)
        }
        return .default
    }
}

extension HomeProvider where Self == AWS.Home {
    public static func aws(region: String = "us-east-1") -> Self {
        .init(region: region)
    }
}
