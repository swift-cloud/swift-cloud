//===----------------------------------------------------------------------===//
//
// This source file is part of the Soto for AWS open source project
//
// Copyright (c) 2017-2024 the Soto project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Soto project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

@_spi(SotoInternal) import SotoCore

#if os(Linux) && compiler(<5.10)
    // swift-corelibs-foundation hasn't been updated with Sendable conformances
    @preconcurrency import Foundation
#else
    import Foundation
#endif

extension S3 {
    // MARK: Enums

    internal enum AnalyticsS3ExportFileFormat: String, CustomStringConvertible, Codable, Sendable,
        CodingKeyRepresentable
    {
        case csv = "CSV"
        internal var description: String { return self.rawValue }
    }

    internal enum ArchiveStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case archiveAccess = "ARCHIVE_ACCESS"
        case deepArchiveAccess = "DEEP_ARCHIVE_ACCESS"
        internal var description: String { return self.rawValue }
    }

    internal enum BucketAccelerateStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case enabled = "Enabled"
        case suspended = "Suspended"
        internal var description: String { return self.rawValue }
    }

    internal enum BucketCannedACL: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case `private` = "private"
        case authenticatedRead = "authenticated-read"
        case publicRead = "public-read"
        case publicReadWrite = "public-read-write"
        internal var description: String { return self.rawValue }
    }

    internal struct BucketLocationConstraint: RawRepresentable, Equatable, Codable, Sendable, CodingKeyRepresentable {
        internal var rawValue: String

        internal init(rawValue: String) {
            self.rawValue = rawValue
        }

        internal static var afSouth1: Self { .init(rawValue: "af-south-1") }
        internal static var apEast1: Self { .init(rawValue: "ap-east-1") }
        internal static var apNortheast1: Self { .init(rawValue: "ap-northeast-1") }
        internal static var apNortheast2: Self { .init(rawValue: "ap-northeast-2") }
        internal static var apNortheast3: Self { .init(rawValue: "ap-northeast-3") }
        internal static var apSouth1: Self { .init(rawValue: "ap-south-1") }
        internal static var apSouth2: Self { .init(rawValue: "ap-south-2") }
        internal static var apSoutheast1: Self { .init(rawValue: "ap-southeast-1") }
        internal static var apSoutheast2: Self { .init(rawValue: "ap-southeast-2") }
        internal static var apSoutheast3: Self { .init(rawValue: "ap-southeast-3") }
        internal static var caCentral1: Self { .init(rawValue: "ca-central-1") }
        internal static var cnNorth1: Self { .init(rawValue: "cn-north-1") }
        internal static var cnNorthwest1: Self { .init(rawValue: "cn-northwest-1") }
        internal static var eu: Self { .init(rawValue: "EU") }
        internal static var euCentral1: Self { .init(rawValue: "eu-central-1") }
        internal static var euNorth1: Self { .init(rawValue: "eu-north-1") }
        internal static var euSouth1: Self { .init(rawValue: "eu-south-1") }
        internal static var euSouth2: Self { .init(rawValue: "eu-south-2") }
        internal static var euWest1: Self { .init(rawValue: "eu-west-1") }
        internal static var euWest2: Self { .init(rawValue: "eu-west-2") }
        internal static var euWest3: Self { .init(rawValue: "eu-west-3") }
        internal static var meSouth1: Self { .init(rawValue: "me-south-1") }
        internal static var saEast1: Self { .init(rawValue: "sa-east-1") }
        internal static var usEast1: Self { .init(rawValue: "us-east-1") }
        internal static var usEast2: Self { .init(rawValue: "us-east-2") }
        internal static var usGovEast1: Self { .init(rawValue: "us-gov-east-1") }
        internal static var usGovWest1: Self { .init(rawValue: "us-gov-west-1") }
        internal static var usWest1: Self { .init(rawValue: "us-west-1") }
        internal static var usWest2: Self { .init(rawValue: "us-west-2") }
    }

    internal enum BucketLogsPermission: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case fullControl = "FULL_CONTROL"
        case read = "READ"
        case write = "WRITE"
        internal var description: String { return self.rawValue }
    }

    internal enum BucketType: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case directory = "Directory"
        internal var description: String { return self.rawValue }
    }

    internal enum BucketVersioningStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case enabled = "Enabled"
        case suspended = "Suspended"
        internal var description: String { return self.rawValue }
    }

    internal enum ChecksumAlgorithm: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case crc32 = "CRC32"
        case crc32c = "CRC32C"
        case crc64nvme = "CRC64NVME"
        case sha1 = "SHA1"
        case sha256 = "SHA256"
        internal var description: String { return self.rawValue }
    }

    internal enum ChecksumMode: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case enabled = "ENABLED"
        internal var description: String { return self.rawValue }
    }

    internal enum CompressionType: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case bzip2 = "BZIP2"
        case gzip = "GZIP"
        case none = "NONE"
        internal var description: String { return self.rawValue }
    }

    internal enum DataRedundancy: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case singleAvailabilityZone = "SingleAvailabilityZone"
        case singleLocalZone = "SingleLocalZone"
        internal var description: String { return self.rawValue }
    }

    internal enum DeleteMarkerReplicationStatus: String, CustomStringConvertible, Codable, Sendable,
        CodingKeyRepresentable
    {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum EncodingType: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case url = "url"
        internal var description: String { return self.rawValue }
    }

    internal enum Event: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case s3Intelligenttiering = "s3:IntelligentTiering"
        case s3Lifecycleexpiration = "s3:LifecycleExpiration:*"
        case s3LifecycleexpirationDelete = "s3:LifecycleExpiration:Delete"
        case s3LifecycleexpirationDeletemarkercreated = "s3:LifecycleExpiration:DeleteMarkerCreated"
        case s3Lifecycletransition = "s3:LifecycleTransition"
        case s3ObjectaclPut = "s3:ObjectAcl:Put"
        case s3Objectcreated = "s3:ObjectCreated:*"
        case s3ObjectcreatedCompletemultipartupload = "s3:ObjectCreated:CompleteMultipartUpload"
        case s3ObjectcreatedCopy = "s3:ObjectCreated:Copy"
        case s3ObjectcreatedPost = "s3:ObjectCreated:Post"
        case s3ObjectcreatedPut = "s3:ObjectCreated:Put"
        case s3Objectremoved = "s3:ObjectRemoved:*"
        case s3ObjectremovedDelete = "s3:ObjectRemoved:Delete"
        case s3ObjectremovedDeletemarkercreated = "s3:ObjectRemoved:DeleteMarkerCreated"
        case s3Objectrestore = "s3:ObjectRestore:*"
        case s3ObjectrestoreCompleted = "s3:ObjectRestore:Completed"
        case s3ObjectrestoreDelete = "s3:ObjectRestore:Delete"
        case s3ObjectrestorePost = "s3:ObjectRestore:Post"
        case s3Objecttagging = "s3:ObjectTagging:*"
        case s3ObjecttaggingDelete = "s3:ObjectTagging:Delete"
        case s3ObjecttaggingPut = "s3:ObjectTagging:Put"
        case s3Reducedredundancylostobject = "s3:ReducedRedundancyLostObject"
        case s3Replication = "s3:Replication:*"
        case s3ReplicationOperationfailedreplication = "s3:Replication:OperationFailedReplication"
        case s3ReplicationOperationmissedthreshold = "s3:Replication:OperationMissedThreshold"
        case s3ReplicationOperationnottracked = "s3:Replication:OperationNotTracked"
        case s3ReplicationOperationreplicatedafterthreshold = "s3:Replication:OperationReplicatedAfterThreshold"
        internal var description: String { return self.rawValue }
    }

    internal enum ExistingObjectReplicationStatus: String, CustomStringConvertible, Codable, Sendable,
        CodingKeyRepresentable
    {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum ExpirationStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum ExpressionType: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case sql = "SQL"
        internal var description: String { return self.rawValue }
    }

    internal enum FileHeaderInfo: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case ignore = "IGNORE"
        case none = "NONE"
        case use = "USE"
        internal var description: String { return self.rawValue }
    }

    internal enum FilterRuleName: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case prefix = "prefix"
        case suffix = "suffix"
        internal var description: String { return self.rawValue }
    }

    internal enum IntelligentTieringAccessTier: String, CustomStringConvertible, Codable, Sendable,
        CodingKeyRepresentable
    {
        case archiveAccess = "ARCHIVE_ACCESS"
        case deepArchiveAccess = "DEEP_ARCHIVE_ACCESS"
        internal var description: String { return self.rawValue }
    }

    internal enum IntelligentTieringStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum InventoryFormat: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case csv = "CSV"
        case orc = "ORC"
        case parquet = "Parquet"
        internal var description: String { return self.rawValue }
    }

    internal enum InventoryFrequency: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case daily = "Daily"
        case weekly = "Weekly"
        internal var description: String { return self.rawValue }
    }

    internal enum InventoryIncludedObjectVersions: String, CustomStringConvertible, Codable, Sendable,
        CodingKeyRepresentable
    {
        case all = "All"
        case current = "Current"
        internal var description: String { return self.rawValue }
    }

    internal enum InventoryOptionalField: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case bucketKeyStatus = "BucketKeyStatus"
        case checksumAlgorithm = "ChecksumAlgorithm"
        case eTag = "ETag"
        case encryptionStatus = "EncryptionStatus"
        case intelligentTieringAccessTier = "IntelligentTieringAccessTier"
        case isMultipartUploaded = "IsMultipartUploaded"
        case lastModifiedDate = "LastModifiedDate"
        case objectAccessControlList = "ObjectAccessControlList"
        case objectLockLegalHoldStatus = "ObjectLockLegalHoldStatus"
        case objectLockMode = "ObjectLockMode"
        case objectLockRetainUntilDate = "ObjectLockRetainUntilDate"
        case objectOwner = "ObjectOwner"
        case replicationStatus = "ReplicationStatus"
        case size = "Size"
        case storageClass = "StorageClass"
        internal var description: String { return self.rawValue }
    }

    internal enum JSONType: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case document = "DOCUMENT"
        case lines = "LINES"
        internal var description: String { return self.rawValue }
    }

    internal enum LocationType: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case availabilityZone = "AvailabilityZone"
        case localZone = "LocalZone"
        internal var description: String { return self.rawValue }
    }

    internal enum MFADelete: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum MFADeleteStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum MetadataDirective: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case copy = "COPY"
        case replace = "REPLACE"
        internal var description: String { return self.rawValue }
    }

    internal enum MetricsStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectAttributes: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case checksum = "Checksum"
        case etag = "ETag"
        case objectParts = "ObjectParts"
        case objectSize = "ObjectSize"
        case storageClass = "StorageClass"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectCannedACL: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case `private` = "private"
        case authenticatedRead = "authenticated-read"
        case awsExecRead = "aws-exec-read"
        case bucketOwnerFullControl = "bucket-owner-full-control"
        case bucketOwnerRead = "bucket-owner-read"
        case publicRead = "public-read"
        case publicReadWrite = "public-read-write"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectLockEnabled: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectLockLegalHoldStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable
    {
        case off = "OFF"
        case on = "ON"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectLockMode: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case compliance = "COMPLIANCE"
        case governance = "GOVERNANCE"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectLockRetentionMode: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case compliance = "COMPLIANCE"
        case governance = "GOVERNANCE"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectOwnership: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case bucketOwnerEnforced = "BucketOwnerEnforced"
        case bucketOwnerPreferred = "BucketOwnerPreferred"
        case objectWriter = "ObjectWriter"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectStorageClass: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case deepArchive = "DEEP_ARCHIVE"
        case expressOnezone = "EXPRESS_ONEZONE"
        case glacier = "GLACIER"
        case glacierIr = "GLACIER_IR"
        case intelligentTiering = "INTELLIGENT_TIERING"
        case onezoneIa = "ONEZONE_IA"
        case outposts = "OUTPOSTS"
        case reducedRedundancy = "REDUCED_REDUNDANCY"
        case snow = "SNOW"
        case standard = "STANDARD"
        case standardIa = "STANDARD_IA"
        internal var description: String { return self.rawValue }
    }

    internal enum ObjectVersionStorageClass: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable
    {
        case standard = "STANDARD"
        internal var description: String { return self.rawValue }
    }

    internal enum OptionalObjectAttributes: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case restoreStatus = "RestoreStatus"
        internal var description: String { return self.rawValue }
    }

    internal enum OwnerOverride: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case destination = "Destination"
        internal var description: String { return self.rawValue }
    }

    internal enum PartitionDateSource: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case deliveryTime = "DeliveryTime"
        case eventTime = "EventTime"
        internal var description: String { return self.rawValue }
    }

    internal enum Payer: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case bucketOwner = "BucketOwner"
        case requester = "Requester"
        internal var description: String { return self.rawValue }
    }

    internal enum Permission: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case fullControl = "FULL_CONTROL"
        case read = "READ"
        case readAcp = "READ_ACP"
        case write = "WRITE"
        case writeAcp = "WRITE_ACP"
        internal var description: String { return self.rawValue }
    }

    internal enum QuoteFields: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case always = "ALWAYS"
        case asneeded = "ASNEEDED"
        internal var description: String { return self.rawValue }
    }

    internal enum ReplicaModificationsStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable
    {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum ReplicationRuleStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum ReplicationStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case complete = "COMPLETE"
        case completed = "COMPLETED"
        case failed = "FAILED"
        case pending = "PENDING"
        case replica = "REPLICA"
        internal var description: String { return self.rawValue }
    }

    internal enum ReplicationTimeStatus: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum RequestCharged: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case requester = "requester"
        internal var description: String { return self.rawValue }
    }

    internal enum RequestPayer: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case requester = "requester"
        internal var description: String { return self.rawValue }
    }

    internal enum RestoreRequestType: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case select = "SELECT"
        internal var description: String { return self.rawValue }
    }

    internal enum ServerSideEncryption: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case aes256 = "AES256"
        case awsKms = "aws:kms"
        case awsKmsDsse = "aws:kms:dsse"
        internal var description: String { return self.rawValue }
    }

    internal enum SessionMode: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case readOnly = "ReadOnly"
        case readWrite = "ReadWrite"
        internal var description: String { return self.rawValue }
    }

    internal enum SseKmsEncryptedObjectsStatus: String, CustomStringConvertible, Codable, Sendable,
        CodingKeyRepresentable
    {
        case disabled = "Disabled"
        case enabled = "Enabled"
        internal var description: String { return self.rawValue }
    }

    internal enum StorageClass: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case deepArchive = "DEEP_ARCHIVE"
        case expressOnezone = "EXPRESS_ONEZONE"
        case glacier = "GLACIER"
        case glacierIr = "GLACIER_IR"
        case intelligentTiering = "INTELLIGENT_TIERING"
        case none = "NONE"
        case onezoneIa = "ONEZONE_IA"
        case outposts = "OUTPOSTS"
        case reducedRedundancy = "REDUCED_REDUNDANCY"
        case snow = "SNOW"
        case standard = "STANDARD"
        case standardIa = "STANDARD_IA"
        internal var description: String { return self.rawValue }
    }

    internal enum StorageClassAnalysisSchemaVersion: String, CustomStringConvertible, Codable, Sendable,
        CodingKeyRepresentable
    {
        case v1 = "V_1"
        internal var description: String { return self.rawValue }
    }

    internal enum TaggingDirective: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case copy = "COPY"
        case replace = "REPLACE"
        internal var description: String { return self.rawValue }
    }

    internal enum Tier: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case bulk = "Bulk"
        case expedited = "Expedited"
        case standard = "Standard"
        internal var description: String { return self.rawValue }
    }

    internal enum TransitionDefaultMinimumObjectSize: String, CustomStringConvertible, Codable, Sendable,
        CodingKeyRepresentable
    {
        case allStorageClasses128K = "all_storage_classes_128K"
        case variesByStorageClass = "varies_by_storage_class"
        internal var description: String { return self.rawValue }
    }

    internal enum TransitionStorageClass: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case deepArchive = "DEEP_ARCHIVE"
        case glacier = "GLACIER"
        case glacierIr = "GLACIER_IR"
        case intelligentTiering = "INTELLIGENT_TIERING"
        case onezoneIa = "ONEZONE_IA"
        case standardIa = "STANDARD_IA"
        internal var description: String { return self.rawValue }
    }

    internal enum `Protocol`: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case http = "http"
        case https = "https"
        internal var description: String { return self.rawValue }
    }

    internal enum `Type`: String, CustomStringConvertible, Codable, Sendable, CodingKeyRepresentable {
        case amazonCustomerByEmail = "AmazonCustomerByEmail"
        case canonicalUser = "CanonicalUser"
        case group = "Group"
        internal var description: String { return self.rawValue }
    }

    internal enum AnalyticsFilter: AWSEncodableShape & AWSDecodableShape, Sendable {
        /// A conjunction (logical AND) of predicates, which is used in evaluating an analytics filter. The operator must have at least two predicates.
        case and(AnalyticsAndOperator)
        /// The prefix to use when evaluating an analytics filter.
        case prefix(String)
        /// The tag to use when evaluating an analytics filter.
        case tag(Tag)

        internal init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard container.allKeys.count == 1, let key = container.allKeys.first else {
                let context = DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Expected exactly one key, but got \(container.allKeys.count)"
                )
                throw DecodingError.dataCorrupted(context)
            }
            switch key {
            case .and:
                let value = try container.decode(AnalyticsAndOperator.self, forKey: .and)
                self = .and(value)
            case .prefix:
                let value = try container.decode(String.self, forKey: .prefix)
                self = .prefix(value)
            case .tag:
                let value = try container.decode(Tag.self, forKey: .tag)
                self = .tag(value)
            }
        }

        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .and(let value):
                try container.encode(value, forKey: .and)
            case .prefix(let value):
                try container.encode(value, forKey: .prefix)
            case .tag(let value):
                try container.encode(value, forKey: .tag)
            }
        }

        internal func validate(name: String) throws {
            switch self {
            case .and(let value):
                try value.validate(name: "\(name).and")
            case .tag(let value):
                try value.validate(name: "\(name).tag")
            default:
                break
            }
        }

        private enum CodingKeys: String, CodingKey {
            case and = "And"
            case prefix = "Prefix"
            case tag = "Tag"
        }
    }

    internal enum MetricsFilter: AWSEncodableShape & AWSDecodableShape, Sendable {
        /// The access point ARN used when evaluating a metrics filter.
        case accessPointArn(String)
        /// A conjunction (logical AND) of predicates, which is used in evaluating a metrics filter. The operator must have at least two predicates, and an object must match all of the predicates in order for the filter to apply.
        case and(MetricsAndOperator)
        /// The prefix used when evaluating a metrics filter.
        case prefix(String)
        /// The tag used when evaluating a metrics filter.
        case tag(Tag)

        internal init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard container.allKeys.count == 1, let key = container.allKeys.first else {
                let context = DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Expected exactly one key, but got \(container.allKeys.count)"
                )
                throw DecodingError.dataCorrupted(context)
            }
            switch key {
            case .accessPointArn:
                let value = try container.decode(String.self, forKey: .accessPointArn)
                self = .accessPointArn(value)
            case .and:
                let value = try container.decode(MetricsAndOperator.self, forKey: .and)
                self = .and(value)
            case .prefix:
                let value = try container.decode(String.self, forKey: .prefix)
                self = .prefix(value)
            case .tag:
                let value = try container.decode(Tag.self, forKey: .tag)
                self = .tag(value)
            }
        }

        internal func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .accessPointArn(let value):
                try container.encode(value, forKey: .accessPointArn)
            case .and(let value):
                try container.encode(value, forKey: .and)
            case .prefix(let value):
                try container.encode(value, forKey: .prefix)
            case .tag(let value):
                try container.encode(value, forKey: .tag)
            }
        }

        internal func validate(name: String) throws {
            switch self {
            case .and(let value):
                try value.validate(name: "\(name).and")
            case .tag(let value):
                try value.validate(name: "\(name).tag")
            default:
                break
            }
        }

        private enum CodingKeys: String, CodingKey {
            case accessPointArn = "AccessPointArn"
            case and = "And"
            case prefix = "Prefix"
            case tag = "Tag"
        }
    }

    internal enum SelectObjectContentEventStream: AWSDecodableShape, Sendable {
        /// The Continuation Event.
        case cont(ContinuationEvent)
        /// The End Event.
        case end(EndEvent)
        /// The Progress Event.
        case progress(ProgressEvent)
        /// The Records Event.
        case records(RecordsEvent)
        /// The Stats Event.
        case stats(StatsEvent)

        internal init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            guard container.allKeys.count == 1, let key = container.allKeys.first else {
                let context = DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Expected exactly one key, but got \(container.allKeys.count)"
                )
                throw DecodingError.dataCorrupted(context)
            }
            switch key {
            case .cont:
                let value = try container.decode(ContinuationEvent.self, forKey: .cont)
                self = .cont(value)
            case .end:
                let value = try container.decode(EndEvent.self, forKey: .end)
                self = .end(value)
            case .progress:
                let value = try container.decode(ProgressEvent.self, forKey: .progress)
                self = .progress(value)
            case .records:
                let value = try container.decode(RecordsEvent.self, forKey: .records)
                self = .records(value)
            case .stats:
                let value = try container.decode(StatsEvent.self, forKey: .stats)
                self = .stats(value)
            }
        }

        private enum CodingKeys: String, CodingKey {
            case cont = "Cont"
            case end = "End"
            case progress = "Progress"
            case records = "Records"
            case stats = "Stats"
        }
    }

    // MARK: Shapes

    internal struct AbortIncompleteMultipartUpload: AWSEncodableShape & AWSDecodableShape {
        /// Specifies the number of days after which Amazon S3 aborts an incomplete multipart upload.
        internal let daysAfterInitiation: Int?

        @inlinable
        internal init(daysAfterInitiation: Int? = nil) {
            self.daysAfterInitiation = daysAfterInitiation
        }

        private enum CodingKeys: String, CodingKey {
            case daysAfterInitiation = "DaysAfterInitiation"
        }
    }

    internal struct AbortMultipartUploadOutput: AWSDecodableShape {
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(requestCharged: RequestCharged? = nil) {
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct AbortMultipartUploadRequest: AWSEncodableShape {
        /// The bucket name to which the upload was taking place.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// If present, this header aborts an in progress multipart upload only if it was initiated on the provided timestamp. If the initiated timestamp of the multipart upload does not match the provided value, the operation returns a 412 Precondition Failed error.  If the initiated timestamp matches or if the multipart upload doesn’t exist, the operation returns a 204 Success (No Content) response.    This functionality is only supported for directory buckets.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var ifMatchInitiatedTime: Date?
        /// Key of the object for which the multipart upload was initiated.
        internal let key: String
        internal let requestPayer: RequestPayer?
        /// Upload ID that identifies the multipart upload.
        internal let uploadId: String

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, ifMatchInitiatedTime: Date? = nil, key: String,
            requestPayer: RequestPayer? = nil, uploadId: String
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.ifMatchInitiatedTime = ifMatchInitiatedTime
            self.key = key
            self.requestPayer = requestPayer
            self.uploadId = uploadId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self._ifMatchInitiatedTime, key: "x-amz-if-match-initiated-time")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.uploadId, key: "uploadId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct AccelerateConfiguration: AWSEncodableShape {
        /// Specifies the transfer acceleration status of the bucket.
        internal let status: BucketAccelerateStatus?

        @inlinable
        internal init(status: BucketAccelerateStatus? = nil) {
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case status = "Status"
        }
    }

    internal struct AccessControlPolicy: AWSEncodableShape {
        internal struct _GrantsEncoding: ArrayCoderProperties { internal static let member = "Grant" }

        /// A list of grants.
        @OptionalCustomCoding<ArrayCoder<_GrantsEncoding, Grant>>
        internal var grants: [Grant]?
        /// Container for the bucket owner's display name and ID.
        internal let owner: Owner?

        @inlinable
        internal init(grants: [Grant]? = nil, owner: Owner? = nil) {
            self.grants = grants
            self.owner = owner
        }

        private enum CodingKeys: String, CodingKey {
            case grants = "AccessControlList"
            case owner = "Owner"
        }
    }

    internal struct AccessControlTranslation: AWSEncodableShape & AWSDecodableShape {
        /// Specifies the replica ownership. For default and valid values, see PUT bucket replication in the Amazon S3 API Reference.
        internal let owner: OwnerOverride

        @inlinable
        internal init(owner: OwnerOverride) {
            self.owner = owner
        }

        private enum CodingKeys: String, CodingKey {
            case owner = "Owner"
        }
    }

    internal struct AnalyticsAndOperator: AWSEncodableShape & AWSDecodableShape {
        /// The prefix to use when evaluating an AND predicate: The prefix that an object must have to be included in the metrics results.
        internal let prefix: String?
        /// The list of tags to use when evaluating an AND predicate.
        internal let tags: [Tag]?

        @inlinable
        internal init(prefix: String? = nil, tags: [Tag]? = nil) {
            self.prefix = prefix
            self.tags = tags
        }

        internal func validate(name: String) throws {
            try self.tags?.forEach {
                try $0.validate(name: "\(name).tags[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case prefix = "Prefix"
            case tags = "Tag"
        }
    }

    internal struct AnalyticsConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// The filter used to describe a set of objects for analyses. A filter must have exactly one prefix, one tag, or one conjunction (AnalyticsAndOperator). If no filter is provided, all objects will be considered in any analysis.
        internal let filter: AnalyticsFilter?
        /// The ID that identifies the analytics configuration.
        internal let id: String
        ///  Contains data related to access patterns to be collected and made available to analyze the tradeoffs between different storage classes.
        internal let storageClassAnalysis: StorageClassAnalysis

        @inlinable
        internal init(filter: AnalyticsFilter? = nil, id: String, storageClassAnalysis: StorageClassAnalysis) {
            self.filter = filter
            self.id = id
            self.storageClassAnalysis = storageClassAnalysis
        }

        internal func validate(name: String) throws {
            try self.filter?.validate(name: "\(name).filter")
        }

        private enum CodingKeys: String, CodingKey {
            case filter = "Filter"
            case id = "Id"
            case storageClassAnalysis = "StorageClassAnalysis"
        }
    }

    internal struct AnalyticsExportDestination: AWSEncodableShape & AWSDecodableShape {
        /// A destination signifying output to an S3 bucket.
        internal let s3BucketDestination: AnalyticsS3BucketDestination

        @inlinable
        internal init(s3BucketDestination: AnalyticsS3BucketDestination) {
            self.s3BucketDestination = s3BucketDestination
        }

        private enum CodingKeys: String, CodingKey {
            case s3BucketDestination = "S3BucketDestination"
        }
    }

    internal struct AnalyticsS3BucketDestination: AWSEncodableShape & AWSDecodableShape {
        /// The Amazon Resource Name (ARN) of the bucket to which data is exported.
        internal let bucket: String
        /// The account ID that owns the destination S3 bucket. If no account ID is provided, the owner is not validated before exporting data.  Although this value is optional, we strongly recommend that you set it to help prevent problems if the destination bucket ownership changes.
        internal let bucketAccountId: String?
        /// Specifies the file format used when exporting data to Amazon S3.
        internal let format: AnalyticsS3ExportFileFormat
        /// The prefix to use when exporting data. The prefix is prepended to all results.
        internal let prefix: String?

        @inlinable
        internal init(
            bucket: String, bucketAccountId: String? = nil, format: AnalyticsS3ExportFileFormat, prefix: String? = nil
        ) {
            self.bucket = bucket
            self.bucketAccountId = bucketAccountId
            self.format = format
            self.prefix = prefix
        }

        private enum CodingKeys: String, CodingKey {
            case bucket = "Bucket"
            case bucketAccountId = "BucketAccountId"
            case format = "Format"
            case prefix = "Prefix"
        }
    }

    internal struct Bucket: AWSDecodableShape {
        ///  BucketRegion indicates the Amazon Web Services region where the bucket is located. If the request contains at least one valid parameter, it is included in the response.
        internal let bucketRegion: String?
        /// Date the bucket was created. This date can change when making changes to your bucket, such as editing its bucket policy.
        internal let creationDate: Date?
        /// The name of the bucket.
        internal let name: String?

        @inlinable
        internal init(bucketRegion: String? = nil, creationDate: Date? = nil, name: String? = nil) {
            self.bucketRegion = bucketRegion
            self.creationDate = creationDate
            self.name = name
        }

        private enum CodingKeys: String, CodingKey {
            case bucketRegion = "BucketRegion"
            case creationDate = "CreationDate"
            case name = "Name"
        }
    }

    internal struct BucketInfo: AWSEncodableShape {
        /// The number of Zone (Availability Zone or Local Zone) that's used for redundancy for the bucket.
        internal let dataRedundancy: DataRedundancy?
        /// The type of bucket.
        internal let type: BucketType?

        @inlinable
        internal init(dataRedundancy: DataRedundancy? = nil, type: BucketType? = nil) {
            self.dataRedundancy = dataRedundancy
            self.type = type
        }

        private enum CodingKeys: String, CodingKey {
            case dataRedundancy = "DataRedundancy"
            case type = "Type"
        }
    }

    internal struct BucketLifecycleConfiguration: AWSEncodableShape {
        /// A lifecycle rule for individual objects in an Amazon S3 bucket.
        internal let rules: [LifecycleRule]

        @inlinable
        internal init(rules: [LifecycleRule]) {
            self.rules = rules
        }

        internal func validate(name: String) throws {
            try self.rules.forEach {
                try $0.validate(name: "\(name).rules[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case rules = "Rule"
        }
    }

    internal struct BucketLoggingStatus: AWSEncodableShape {
        internal let loggingEnabled: LoggingEnabled?

        @inlinable
        internal init(loggingEnabled: LoggingEnabled? = nil) {
            self.loggingEnabled = loggingEnabled
        }

        private enum CodingKeys: String, CodingKey {
            case loggingEnabled = "LoggingEnabled"
        }
    }

    internal struct CORSConfiguration: AWSEncodableShape {
        /// A set of origins and methods (cross-origin access that you want to allow). You can add up to 100 rules to the configuration.
        internal let corsRules: [CORSRule]

        @inlinable
        internal init(corsRules: [CORSRule]) {
            self.corsRules = corsRules
        }

        private enum CodingKeys: String, CodingKey {
            case corsRules = "CORSRule"
        }
    }

    internal struct CORSRule: AWSEncodableShape & AWSDecodableShape {
        /// Headers that are specified in the Access-Control-Request-Headers header. These headers are allowed in a preflight OPTIONS request. In response to any preflight OPTIONS request, Amazon S3 returns any requested headers that are allowed.
        internal let allowedHeaders: [String]?
        /// An HTTP method that you allow the origin to execute. Valid values are GET, PUT, HEAD, POST, and DELETE.
        internal let allowedMethods: [String]
        /// One or more origins you want customers to be able to access the bucket from.
        internal let allowedOrigins: [String]
        /// One or more headers in the response that you want customers to be able to access from their applications (for example, from a JavaScript XMLHttpRequest object).
        internal let exposeHeaders: [String]?
        /// Unique identifier for the rule. The value cannot be longer than 255 characters.
        internal let id: String?
        /// The time in seconds that your browser is to cache the preflight response for the specified resource.
        internal let maxAgeSeconds: Int?

        @inlinable
        internal init(
            allowedHeaders: [String]? = nil, allowedMethods: [String], allowedOrigins: [String],
            exposeHeaders: [String]? = nil, id: String? = nil, maxAgeSeconds: Int? = nil
        ) {
            self.allowedHeaders = allowedHeaders
            self.allowedMethods = allowedMethods
            self.allowedOrigins = allowedOrigins
            self.exposeHeaders = exposeHeaders
            self.id = id
            self.maxAgeSeconds = maxAgeSeconds
        }

        private enum CodingKeys: String, CodingKey {
            case allowedHeaders = "AllowedHeader"
            case allowedMethods = "AllowedMethod"
            case allowedOrigins = "AllowedOrigin"
            case exposeHeaders = "ExposeHeader"
            case id = "ID"
            case maxAgeSeconds = "MaxAgeSeconds"
        }
    }

    internal struct CSVInput: AWSEncodableShape {
        /// Specifies that CSV field values may contain quoted record delimiters and such records should be allowed. Default value is FALSE. Setting this value to TRUE may lower performance.
        internal let allowQuotedRecordDelimiter: Bool?
        /// A single character used to indicate that a row should be ignored when the character is present at the start of that row. You can specify any character to indicate a comment line. The default character is #. Default: #
        internal let comments: String?
        /// A single character used to separate individual fields in a record. You can specify an arbitrary delimiter.
        internal let fieldDelimiter: String?
        /// Describes the first line of input. Valid values are:    NONE: First line is not a header.    IGNORE: First line is a header, but you can't use the header values to indicate the column in an expression. You can use column position (such as _1, _2, …) to indicate the column (SELECT s._1 FROM OBJECT s).    Use: First line is a header, and you can use the header value to identify a column in an expression (SELECT "name" FROM OBJECT).
        internal let fileHeaderInfo: FileHeaderInfo?
        /// A single character used for escaping when the field delimiter is part of the value. For example, if the value is a, b, Amazon S3 wraps this field value in quotation marks, as follows: " a , b ". Type: String Default: "  Ancestors: CSV
        internal let quoteCharacter: String?
        /// A single character used for escaping the quotation mark character inside an already escaped value. For example, the value """ a , b """ is parsed as " a , b ".
        internal let quoteEscapeCharacter: String?
        /// A single character used to separate individual records in the input. Instead of the default value, you can specify an arbitrary delimiter.
        internal let recordDelimiter: String?

        @inlinable
        internal init(
            allowQuotedRecordDelimiter: Bool? = nil, comments: String? = nil, fieldDelimiter: String? = nil,
            fileHeaderInfo: FileHeaderInfo? = nil, quoteCharacter: String? = nil, quoteEscapeCharacter: String? = nil,
            recordDelimiter: String? = nil
        ) {
            self.allowQuotedRecordDelimiter = allowQuotedRecordDelimiter
            self.comments = comments
            self.fieldDelimiter = fieldDelimiter
            self.fileHeaderInfo = fileHeaderInfo
            self.quoteCharacter = quoteCharacter
            self.quoteEscapeCharacter = quoteEscapeCharacter
            self.recordDelimiter = recordDelimiter
        }

        private enum CodingKeys: String, CodingKey {
            case allowQuotedRecordDelimiter = "AllowQuotedRecordDelimiter"
            case comments = "Comments"
            case fieldDelimiter = "FieldDelimiter"
            case fileHeaderInfo = "FileHeaderInfo"
            case quoteCharacter = "QuoteCharacter"
            case quoteEscapeCharacter = "QuoteEscapeCharacter"
            case recordDelimiter = "RecordDelimiter"
        }
    }

    internal struct CSVOutput: AWSEncodableShape {
        /// The value used to separate individual fields in a record. You can specify an arbitrary delimiter.
        internal let fieldDelimiter: String?
        /// A single character used for escaping when the field delimiter is part of the value. For example, if the value is a, b, Amazon S3 wraps this field value in quotation marks, as follows: " a , b ".
        internal let quoteCharacter: String?
        /// The single character used for escaping the quote character inside an already escaped value.
        internal let quoteEscapeCharacter: String?
        /// Indicates whether to use quotation marks around output fields.     ALWAYS: Always use quotation marks for output fields.    ASNEEDED: Use quotation marks for output fields when needed.
        internal let quoteFields: QuoteFields?
        /// A single character used to separate individual records in the output. Instead of the default value, you can specify an arbitrary delimiter.
        internal let recordDelimiter: String?

        @inlinable
        internal init(
            fieldDelimiter: String? = nil, quoteCharacter: String? = nil, quoteEscapeCharacter: String? = nil,
            quoteFields: QuoteFields? = nil, recordDelimiter: String? = nil
        ) {
            self.fieldDelimiter = fieldDelimiter
            self.quoteCharacter = quoteCharacter
            self.quoteEscapeCharacter = quoteEscapeCharacter
            self.quoteFields = quoteFields
            self.recordDelimiter = recordDelimiter
        }

        private enum CodingKeys: String, CodingKey {
            case fieldDelimiter = "FieldDelimiter"
            case quoteCharacter = "QuoteCharacter"
            case quoteEscapeCharacter = "QuoteEscapeCharacter"
            case quoteFields = "QuoteFields"
            case recordDelimiter = "RecordDelimiter"
        }
    }

    internal struct Checksum: AWSDecodableShape {
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?

        @inlinable
        internal init(
            checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil
        ) {
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
        }

        private enum CodingKeys: String, CodingKey {
            case checksumCRC32 = "ChecksumCRC32"
            case checksumCRC32C = "ChecksumCRC32C"
            case checksumSHA1 = "ChecksumSHA1"
            case checksumSHA256 = "ChecksumSHA256"
        }
    }

    internal struct CommonPrefix: AWSDecodableShape {
        /// Container for the specified common prefix.
        internal let prefix: String?

        @inlinable
        internal init(prefix: String? = nil) {
            self.prefix = prefix
        }

        private enum CodingKeys: String, CodingKey {
            case prefix = "Prefix"
        }
    }

    internal struct CompleteMultipartUploadOutput: AWSDecodableShape {
        /// The name of the bucket that contains the newly created object. Does not return the access point ARN or access point alias if used.  Access points are not supported by directory buckets.
        internal let bucket: String?
        /// Indicates whether the multipart upload uses an S3 Bucket Key for server-side encryption with Key Management Service (KMS) keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Entity tag that identifies the newly created object's data. Objects with different object data will have different entity tags. The entity tag is an opaque string. The entity tag may or may not be an MD5 digest of the object data. If the entity tag is not an MD5 digest of the object data, it will contain one or more nonhexadecimal characters and/or will consist of less than 32 or more than 32 hexadecimal digits. For more information about how the entity tag is calculated, see Checking object integrity in the Amazon S3 User Guide.
        internal let eTag: String?
        /// If the object expiration is configured, this will contain the expiration date (expiry-date) and rule ID (rule-id). The value of rule-id is URL-encoded.  This functionality is not supported for directory buckets.
        internal let expiration: String?
        /// The object key of the newly created object.
        internal let key: String?
        /// The URI that identifies the newly created object.
        internal let location: String?
        internal let requestCharged: RequestCharged?
        /// The server-side encryption algorithm used when storing this object in Amazon S3 (for example, AES256, aws:kms).
        internal let serverSideEncryption: ServerSideEncryption?
        /// If present, indicates the ID of the KMS key that was used for object encryption.
        internal let ssekmsKeyId: String?
        /// Version ID of the newly created object, in case the bucket has versioning turned on.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String? = nil, bucketKeyEnabled: Bool? = nil, checksumCRC32: String? = nil,
            checksumCRC32C: String? = nil, checksumSHA1: String? = nil, checksumSHA256: String? = nil,
            eTag: String? = nil, expiration: String? = nil, key: String? = nil, location: String? = nil,
            requestCharged: RequestCharged? = nil, serverSideEncryption: ServerSideEncryption? = nil,
            ssekmsKeyId: String? = nil, versionId: String? = nil
        ) {
            self.bucket = bucket
            self.bucketKeyEnabled = bucketKeyEnabled
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.eTag = eTag
            self.expiration = expiration
            self.key = key
            self.location = location
            self.requestCharged = requestCharged
            self.serverSideEncryption = serverSideEncryption
            self.ssekmsKeyId = ssekmsKeyId
            self.versionId = versionId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.bucket = try container.decodeIfPresent(String.self, forKey: .bucket)
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.checksumCRC32 = try container.decodeIfPresent(String.self, forKey: .checksumCRC32)
            self.checksumCRC32C = try container.decodeIfPresent(String.self, forKey: .checksumCRC32C)
            self.checksumSHA1 = try container.decodeIfPresent(String.self, forKey: .checksumSHA1)
            self.checksumSHA256 = try container.decodeIfPresent(String.self, forKey: .checksumSHA256)
            self.eTag = try container.decodeIfPresent(String.self, forKey: .eTag)
            self.expiration = try response.decodeHeaderIfPresent(String.self, key: "x-amz-expiration")
            self.key = try container.decodeIfPresent(String.self, forKey: .key)
            self.location = try container.decodeIfPresent(String.self, forKey: .location)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
        }

        private enum CodingKeys: String, CodingKey {
            case bucket = "Bucket"
            case checksumCRC32 = "ChecksumCRC32"
            case checksumCRC32C = "ChecksumCRC32C"
            case checksumSHA1 = "ChecksumSHA1"
            case checksumSHA256 = "ChecksumSHA256"
            case eTag = "ETag"
            case key = "Key"
            case location = "Location"
        }
    }

    internal struct CompleteMultipartUploadRequest: AWSEncodableShape {
        internal static let _xmlRootNodeName: String? = "CompleteMultipartUpload"
        /// Name of the bucket to which the multipart upload was initiated.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32 checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32C checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 160-bit SHA-1 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 256-bit SHA-256 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Uploads the object only if the ETag (entity tag) value provided during the WRITE operation matches the ETag of the object in S3. If the ETag values do not match, the operation returns a 412 Precondition Failed error. If a conflicting operation occurs during the upload S3 returns a 409 ConditionalRequestConflict response. On a 409 failure you should fetch the object's ETag, re-initiate the multipart upload with CreateMultipartUpload, and re-upload each part. Expects the ETag value as a string. For more information about conditional requests, see RFC 7232, or Conditional requests in the Amazon S3 User Guide.
        internal let ifMatch: String?
        /// Uploads the object only if the object key name does not already exist in the bucket specified. Otherwise, Amazon S3 returns a 412 Precondition Failed error. If a conflicting operation occurs during the upload S3 returns a 409 ConditionalRequestConflict response. On a 409 failure you should re-initiate the multipart upload with CreateMultipartUpload and re-upload each part. Expects the '*' (asterisk) character. For more information about conditional requests, see RFC 7232, or Conditional requests in the Amazon S3 User Guide.
        internal let ifNoneMatch: String?
        /// Object key for which the multipart upload was initiated.
        internal let key: String
        /// The container for the multipart upload request information.
        internal let multipartUpload: CompletedMultipartUpload?
        internal let requestPayer: RequestPayer?
        /// The server-side encryption (SSE) algorithm used to encrypt the object. This parameter is required only when the object was created using a checksum algorithm or if your bucket policy requires the use of SSE-C. For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// The server-side encryption (SSE) customer managed key. This parameter is needed only when the object was created using a checksum algorithm.  For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerKey: String?
        /// The MD5 server-side encryption (SSE) customer managed key. This parameter is needed only when the object was created using a checksum  algorithm. For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// ID for the initiated multipart upload.
        internal let uploadId: String

        @inlinable
        internal init(
            bucket: String, checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil, expectedBucketOwner: String? = nil, ifMatch: String? = nil,
            ifNoneMatch: String? = nil, key: String, multipartUpload: CompletedMultipartUpload? = nil,
            requestPayer: RequestPayer? = nil, sseCustomerAlgorithm: String? = nil, sseCustomerKey: String? = nil,
            sseCustomerKeyMD5: String? = nil, uploadId: String
        ) {
            self.bucket = bucket
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.expectedBucketOwner = expectedBucketOwner
            self.ifMatch = ifMatch
            self.ifNoneMatch = ifNoneMatch
            self.key = key
            self.multipartUpload = multipartUpload
            self.requestPayer = requestPayer
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.uploadId = uploadId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumCRC32, key: "x-amz-checksum-crc32")
            request.encodeHeader(self.checksumCRC32C, key: "x-amz-checksum-crc32c")
            request.encodeHeader(self.checksumSHA1, key: "x-amz-checksum-sha1")
            request.encodeHeader(self.checksumSHA256, key: "x-amz-checksum-sha256")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.ifMatch, key: "If-Match")
            request.encodeHeader(self.ifNoneMatch, key: "If-None-Match")
            request.encodePath(self.key, key: "Key")
            try container.encode(self.multipartUpload)
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeQuery(self.uploadId, key: "uploadId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct CompletedMultipartUpload: AWSEncodableShape {
        /// Array of CompletedPart data types. If you do not supply a valid Part with your request, the service sends back an HTTP 400 response.
        internal let parts: [CompletedPart]?

        @inlinable
        internal init(parts: [CompletedPart]? = nil) {
            self.parts = parts
        }

        private enum CodingKeys: String, CodingKey {
            case parts = "Part"
        }
    }

    internal struct CompletedPart: AWSEncodableShape {
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Entity tag returned when the part was uploaded.
        internal let eTag: String?
        /// Part number that identifies the part. This is a positive integer between 1 and 10,000.     General purpose buckets - In CompleteMultipartUpload, when a additional checksum (including x-amz-checksum-crc32, x-amz-checksum-crc32c, x-amz-checksum-sha1, or x-amz-checksum-sha256) is applied to each part, the PartNumber must start at 1 and the part numbers must be consecutive. Otherwise, Amazon S3 generates an HTTP 400 Bad Request status code and an InvalidPartOrder error code.    Directory buckets - In CompleteMultipartUpload, the PartNumber must start at 1 and the part numbers must be consecutive.
        internal let partNumber: Int?

        @inlinable
        internal init(
            checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil, eTag: String? = nil, partNumber: Int? = nil
        ) {
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.eTag = eTag
            self.partNumber = partNumber
        }

        private enum CodingKeys: String, CodingKey {
            case checksumCRC32 = "ChecksumCRC32"
            case checksumCRC32C = "ChecksumCRC32C"
            case checksumSHA1 = "ChecksumSHA1"
            case checksumSHA256 = "ChecksumSHA256"
            case eTag = "ETag"
            case partNumber = "PartNumber"
        }
    }

    internal struct Condition: AWSEncodableShape & AWSDecodableShape {
        /// The HTTP error code when the redirect is applied. In the event of an error, if the error code equals this value, then the specified redirect is applied. Required when parent element Condition is specified and sibling KeyPrefixEquals is not specified. If both are specified, then both must be true for the redirect to be applied.
        internal let httpErrorCodeReturnedEquals: String?
        /// The object key name prefix when the redirect is applied. For example, to redirect requests for ExamplePage.html, the key prefix will be ExamplePage.html. To redirect request for all pages with the prefix docs/, the key prefix will be /docs, which identifies all objects in the docs/ folder. Required when the parent element Condition is specified and sibling HttpErrorCodeReturnedEquals is not specified. If both conditions are specified, both must be true for the redirect to be applied.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let keyPrefixEquals: String?

        @inlinable
        internal init(httpErrorCodeReturnedEquals: String? = nil, keyPrefixEquals: String? = nil) {
            self.httpErrorCodeReturnedEquals = httpErrorCodeReturnedEquals
            self.keyPrefixEquals = keyPrefixEquals
        }

        private enum CodingKeys: String, CodingKey {
            case httpErrorCodeReturnedEquals = "HttpErrorCodeReturnedEquals"
            case keyPrefixEquals = "KeyPrefixEquals"
        }
    }

    internal struct ContinuationEvent: AWSDecodableShape {
        internal init() {}
    }

    internal struct CopyObjectOutput: AWSDecodableShape {
        /// Indicates whether the copied object uses an S3 Bucket Key for server-side encryption with Key Management Service (KMS) keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// Container for all response elements.
        internal let copyObjectResult: CopyObjectResult
        /// Version ID of the source object that was copied.  This functionality is not supported when the source object is in a directory bucket.
        internal let copySourceVersionId: String?
        /// If the object expiration is configured, the response includes this header.  Object expiration information is not returned in directory buckets and this header returns the value "NotImplemented" in all responses for directory buckets.
        internal let expiration: String?
        internal let requestCharged: RequestCharged?
        /// The server-side encryption algorithm used when you store this object in Amazon S3 (for example, AES256, aws:kms, aws:kms:dsse).
        internal let serverSideEncryption: ServerSideEncryption?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to confirm the encryption algorithm that's used.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide the round-trip message integrity verification of the customer-provided encryption key.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// If present, indicates the Amazon Web Services KMS Encryption Context to use for object encryption. The value of this header is a base64-encoded UTF-8 string holding JSON with the encryption context key-value pairs.
        internal let ssekmsEncryptionContext: String?
        /// If present, indicates the ID of the KMS key that was used for object encryption.
        internal let ssekmsKeyId: String?
        /// Version ID of the newly created copy.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(
            bucketKeyEnabled: Bool? = nil, copyObjectResult: CopyObjectResult, copySourceVersionId: String? = nil,
            expiration: String? = nil, requestCharged: RequestCharged? = nil,
            serverSideEncryption: ServerSideEncryption? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKeyMD5: String? = nil, ssekmsEncryptionContext: String? = nil, ssekmsKeyId: String? = nil,
            versionId: String? = nil
        ) {
            self.bucketKeyEnabled = bucketKeyEnabled
            self.copyObjectResult = copyObjectResult
            self.copySourceVersionId = copySourceVersionId
            self.expiration = expiration
            self.requestCharged = requestCharged
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsEncryptionContext = ssekmsEncryptionContext
            self.ssekmsKeyId = ssekmsKeyId
            self.versionId = versionId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.singleValueContainer()
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.copyObjectResult = try container.decode(CopyObjectResult.self)
            self.copySourceVersionId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-copy-source-version-id")
            self.expiration = try response.decodeHeaderIfPresent(String.self, key: "x-amz-expiration")
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.sseCustomerAlgorithm = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-algorithm")
            self.sseCustomerKeyMD5 = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-key-MD5")
            self.ssekmsEncryptionContext = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-context")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct CopyObjectRequest: AWSEncodableShape {
        /// The canned access control list (ACL) to apply to the object. When you copy an object, the ACL metadata is not preserved and is set to private by default. Only the owner has full access control. To override the default ACL setting, specify a new ACL when you generate a copy request. For more information, see Using ACLs.  If the destination bucket that you're copying objects to uses the bucket owner enforced setting for S3 Object Ownership, ACLs are disabled and no longer affect permissions. Buckets that use this setting only accept PUT requests that don't specify an ACL or PUT requests that specify bucket owner full control ACLs, such as the bucket-owner-full-control canned ACL or an equivalent form of this ACL expressed in the XML format. For more information, see Controlling ownership of objects and disabling ACLs in the Amazon S3 User Guide.    If your destination bucket uses the bucket owner enforced setting for Object Ownership, all objects written to the bucket by any account will be owned by the bucket owner.   This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let acl: ObjectCannedACL?
        /// The name of the destination bucket.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Copying objects across different Amazon Web Services Regions isn't supported when the source or destination bucket is in Amazon Web Services Local Zones. The source and destination buckets must have the same parent Amazon Web Services Region. Otherwise,  you get an HTTP 400 Bad Request error with the error code InvalidRequest.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Specifies whether Amazon S3 should use an S3 Bucket Key for object encryption with server-side encryption using Key Management Service (KMS) keys (SSE-KMS). If a target object uses SSE-KMS, you can enable an S3 Bucket Key for the object. Setting this header to true causes Amazon S3 to use an S3 Bucket Key for object encryption with SSE-KMS. Specifying this header with a COPY action doesn’t affect bucket-level settings for S3 Bucket Key. For more information, see Amazon S3 Bucket Keys in the Amazon S3 User Guide.   Directory buckets - S3 Bucket Keys aren't supported, when you copy SSE-KMS encrypted objects from general purpose buckets
        /// to directory buckets, from directory buckets to general purpose buckets, or between directory buckets, through CopyObject. In this case, Amazon S3 makes a call to KMS every time a copy request is made for a KMS-encrypted object.
        internal let bucketKeyEnabled: Bool?
        /// Specifies the caching behavior along the request/reply chain.
        internal let cacheControl: String?
        /// Indicates the algorithm that you want Amazon S3 to use to create the checksum for the object. For more information, see Checking object integrity in the Amazon S3 User Guide. When you copy an object, if the source object has a checksum, that checksum value will be copied to the new object by default. If the CopyObject request does not include this x-amz-checksum-algorithm header, the checksum algorithm will be copied from the source object to the destination object (if it's present on the source object). You can optionally specify a different checksum algorithm to use with the x-amz-checksum-algorithm header. Unrecognized or unsupported values will respond with the HTTP status code 400 Bad Request.  For directory buckets, when you use Amazon Web Services SDKs, CRC32 is the default checksum algorithm that's used for performance.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// Specifies presentational information for the object. Indicates whether an object should be displayed in a web browser or downloaded as a file. It allows specifying the desired filename for the downloaded file.
        internal let contentDisposition: String?
        /// Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.  For directory buckets, only the aws-chunked value is supported in this header field.
        internal let contentEncoding: String?
        /// The language the content is in.
        internal let contentLanguage: String?
        /// A standard MIME type that describes the format of the object data.
        internal let contentType: String?
        /// Specifies the source object for the copy operation. The source object can be up to 5 GB. If the source object is an object that was uploaded by using a multipart upload, the object copy will be a single part object after the source object is copied to the destination bucket. You specify the value of the copy source in one of two formats, depending on whether you want to access the source object through an access point:   For objects not accessed through an access point, specify the name of the source bucket and the key of the source object, separated by a slash (/). For example, to copy the object reports/january.pdf from the general purpose bucket awsexamplebucket, use awsexamplebucket/reports/january.pdf. The value must be URL-encoded. To copy the object reports/january.pdf from the directory bucket awsexamplebucket--use1-az5--x-s3, use awsexamplebucket--use1-az5--x-s3/reports/january.pdf. The value must be URL-encoded.   For objects accessed through access points, specify the Amazon Resource Name (ARN) of the object as accessed through the access point, in the format arn:aws:s3:::accesspoint//object/. For example, to copy the object reports/january.pdf through access point my-access-point owned by account 123456789012 in Region us-west-2, use the URL encoding of arn:aws:s3:us-west-2:123456789012:accesspoint/my-access-point/object/reports/january.pdf. The value must be URL encoded.    Amazon S3 supports copy operations using Access points only when the source and destination buckets are in the same Amazon Web Services Region.   Access points are not supported by directory buckets.    Alternatively, for objects accessed through Amazon S3 on Outposts, specify the ARN of the object as accessed in the format arn:aws:s3-outposts:::outpost//object/. For example, to copy the object reports/january.pdf through outpost my-outpost owned by account 123456789012 in Region us-west-2, use the URL encoding of arn:aws:s3-outposts:us-west-2:123456789012:outpost/my-outpost/object/reports/january.pdf. The value must be URL-encoded.     If your source bucket versioning is enabled, the x-amz-copy-source header by default identifies the current version of an object to copy. If the current version is a delete marker, Amazon S3 behaves as if the object was deleted. To copy a different version, use the versionId query parameter. Specifically, append ?versionId= to the value (for example, awsexamplebucket/reports/january.pdf?versionId=QUpfdndhfd8438MNFDN93jdnJFkdmqnh893). If you don't specify a version ID, Amazon S3 copies the latest version of the source object. If you enable versioning on the destination bucket, Amazon S3 generates a unique version ID for the copied object. This version ID is different from the version ID of the source object. Amazon S3 returns the version ID of the copied object in the x-amz-version-id response header in the response. If you do not enable versioning or suspend it on the destination bucket, the version ID that Amazon S3 generates in the x-amz-version-id response header is always null.   Directory buckets - S3 Versioning isn't enabled and supported for directory buckets.
        internal let copySource: String
        /// Copies the object if its entity tag (ETag) matches the specified tag. If both the x-amz-copy-source-if-match and x-amz-copy-source-if-unmodified-since headers are present in the request and evaluate as follows, Amazon S3 returns 200 OK and copies the data:    x-amz-copy-source-if-match condition evaluates to true    x-amz-copy-source-if-unmodified-since condition evaluates to false
        internal let copySourceIfMatch: String?
        /// Copies the object if it has been modified since the specified time. If both the x-amz-copy-source-if-none-match and x-amz-copy-source-if-modified-since headers are present in the request and evaluate as follows, Amazon S3 returns the 412 Precondition Failed response code:    x-amz-copy-source-if-none-match condition evaluates to false    x-amz-copy-source-if-modified-since condition evaluates to true
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var copySourceIfModifiedSince: Date?
        /// Copies the object if its entity tag (ETag) is different than the specified ETag. If both the x-amz-copy-source-if-none-match and x-amz-copy-source-if-modified-since headers are present in the request and evaluate as follows, Amazon S3 returns the 412 Precondition Failed response code:    x-amz-copy-source-if-none-match condition evaluates to false    x-amz-copy-source-if-modified-since condition evaluates to true
        internal let copySourceIfNoneMatch: String?
        /// Copies the object if it hasn't been modified since the specified time. If both the x-amz-copy-source-if-match and x-amz-copy-source-if-unmodified-since headers are present in the request and evaluate as follows, Amazon S3 returns 200 OK and copies the data:    x-amz-copy-source-if-match condition evaluates to true    x-amz-copy-source-if-unmodified-since condition evaluates to false
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var copySourceIfUnmodifiedSince: Date?
        /// Specifies the algorithm to use when decrypting the source object (for example, AES256). If the source object for the copy is stored in Amazon S3 using SSE-C, you must provide the necessary encryption information in your request so that Amazon S3 can decrypt the object for copying.  This functionality is not supported when the source object is in a directory bucket.
        internal let copySourceSSECustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use to decrypt the source object. The encryption key provided in this header must be the same one that was used when the source object was created. If the source object for the copy is stored in Amazon S3 using SSE-C, you must provide the necessary encryption information in your request so that Amazon S3 can decrypt the object for copying.  This functionality is not supported when the source object is in a directory bucket.
        internal let copySourceSSECustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error. If the source object for the copy is stored in Amazon S3 using SSE-C, you must provide the necessary encryption information in your request so that Amazon S3 can decrypt the object for copying.  This functionality is not supported when the source object is in a directory bucket.
        internal let copySourceSSECustomerKeyMD5: String?
        /// The account ID of the expected destination bucket owner. If the account ID that you provide does not match the actual owner of the destination bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The account ID of the expected source bucket owner. If the account ID that you provide does not match the actual owner of the source bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedSourceBucketOwner: String?
        /// The date and time at which the object is no longer cacheable.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var expires: Date?
        /// Gives the grantee READ, READ_ACP, and WRITE_ACP permissions on the object.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantFullControl: String?
        /// Allows grantee to read the object data and its metadata.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantRead: String?
        /// Allows grantee to read the object ACL.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantReadACP: String?
        /// Allows grantee to write the ACL for the applicable object.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantWriteACP: String?
        /// The key of the destination object.
        internal let key: String
        /// A map of metadata to store with the object in S3.
        internal let metadata: [String: String]?
        /// Specifies whether the metadata is copied from the source object or replaced with metadata that's provided in the request. When copying an object, you can preserve all metadata (the default) or specify new metadata. If this header isn’t specified, COPY is the default behavior.   General purpose bucket - For general purpose buckets, when you grant permissions, you can use the s3:x-amz-metadata-directive condition key to enforce certain metadata behavior when objects are uploaded. For more information, see Amazon S3 condition key examples in the Amazon S3 User Guide.   x-amz-website-redirect-location is unique to each object and is not copied when using the x-amz-metadata-directive header. To copy the value, you must specify x-amz-website-redirect-location in the request header.
        internal let metadataDirective: MetadataDirective?
        /// Specifies whether you want to apply a legal hold to the object copy.  This functionality is not supported for directory buckets.
        internal let objectLockLegalHoldStatus: ObjectLockLegalHoldStatus?
        /// The Object Lock mode that you want to apply to the object copy.  This functionality is not supported for directory buckets.
        internal let objectLockMode: ObjectLockMode?
        /// The date and time when you want the Object Lock of the object copy to expire.  This functionality is not supported for directory buckets.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var objectLockRetainUntilDate: Date?
        internal let requestPayer: RequestPayer?
        /// The server-side encryption algorithm used when storing this object in Amazon S3. Unrecognized or unsupported values won’t write a destination object and will receive a 400 Bad Request response.  Amazon S3 automatically encrypts all new objects that are copied to an S3 bucket. When copying an object, if you don't specify encryption information in your copy request, the encryption setting of the target object is set to the default encryption configuration of the destination bucket. By default, all buckets have a base level of encryption configuration that uses server-side encryption with Amazon S3 managed keys (SSE-S3). If the destination bucket has a different default encryption configuration, Amazon S3 uses the corresponding encryption key to encrypt the target object copy. With server-side encryption, Amazon S3 encrypts your data as it writes your data to disks in its data centers and decrypts the data when you access it. For more information about server-side encryption, see Using Server-Side Encryption in the Amazon S3 User Guide.  General purpose buckets     For general purpose buckets, there are the following supported options for server-side encryption: server-side encryption with Key Management Service (KMS) keys (SSE-KMS), dual-layer server-side encryption with Amazon Web Services KMS keys (DSSE-KMS), and server-side encryption with customer-provided encryption keys (SSE-C). Amazon S3 uses the corresponding KMS key, or a customer-provided key to encrypt the target object copy.   When you perform a CopyObject operation, if you want to use a different type of encryption setting for the target object, you can specify appropriate encryption-related headers to encrypt the target object with an Amazon S3 managed key, a KMS key, or a customer-provided key. If the encryption setting in your request is different from the default encryption configuration of the destination bucket, the encryption setting in your request takes precedence.     Directory buckets     For directory buckets, there are only two supported options for server-side encryption: server-side encryption with Amazon S3 managed keys (SSE-S3) (AES256) and server-side encryption with KMS keys (SSE-KMS) (aws:kms). We recommend that the bucket's default encryption uses the desired encryption configuration and you don't override the bucket default encryption in your  CreateSession requests or PUT object requests. Then, new objects  are automatically encrypted with the desired encryption settings. For more information, see Protecting data with server-side encryption in the Amazon S3 User Guide. For more information about the encryption overriding behaviors in directory buckets, see Specifying server-side encryption with KMS for new object uploads.   To encrypt new object copies to a directory bucket with SSE-KMS, we recommend you specify SSE-KMS as the directory bucket's default encryption configuration with a KMS key (specifically, a customer managed key). The Amazon Web Services managed key (aws/s3) isn't supported. Your SSE-KMS configuration can only support 1 customer managed key per directory bucket for the lifetime of the bucket. After you specify a customer managed key for SSE-KMS, you can't override the customer managed key for the bucket's SSE-KMS configuration. Then, when you perform a CopyObject operation and want to specify server-side encryption settings for new object copies with SSE-KMS in the encryption-related request headers, you must ensure the encryption key is the same customer managed key that you specified for the directory bucket's default encryption configuration.
        internal let serverSideEncryption: ServerSideEncryption?
        /// Specifies the algorithm to use when encrypting the object (for example, AES256). When you perform a CopyObject operation, if you want to use a different type of encryption setting for the target object, you can specify appropriate encryption-related headers to encrypt the target object with an Amazon S3 managed key, a KMS key, or a customer-provided key. If the encryption setting in your request is different from the default encryption configuration of the destination bucket, the encryption setting in your request takes precedence.   This functionality is not supported when the destination bucket is a directory bucket.
        internal let sseCustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded. Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header.  This functionality is not supported when the destination bucket is a directory bucket.
        internal let sseCustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported when the destination bucket is a directory bucket.
        internal let sseCustomerKeyMD5: String?
        /// Specifies the Amazon Web Services KMS Encryption Context as an additional encryption context to use for the destination object encryption. The value of this header is a base64-encoded UTF-8 string holding JSON with the encryption context key-value pairs.  General purpose buckets - This value must be explicitly added to specify encryption context for CopyObject requests if you want an additional encryption context for your destination object. The additional encryption context of the source object won't be copied to the destination object. For more information, see Encryption context in the Amazon S3 User Guide.  Directory buckets - You can optionally provide an explicit encryption context value. The value must match the default encryption context - the bucket Amazon Resource Name (ARN). An additional encryption context value is not supported.
        internal let ssekmsEncryptionContext: String?
        /// Specifies the KMS key ID (Key ID, Key ARN, or Key Alias) to use for object encryption. All GET and PUT requests for an object protected by KMS will fail if they're not made via SSL or using SigV4. For information about configuring any of the officially supported Amazon Web Services SDKs and Amazon Web Services CLI, see Specifying the Signature Version in Request Authentication in the Amazon S3 User Guide.  Directory buckets - If you specify x-amz-server-side-encryption with aws:kms, the  x-amz-server-side-encryption-aws-kms-key-id header is implicitly assigned the ID of the KMS  symmetric encryption customer managed key that's configured for your directory bucket's default encryption setting.  If you want to specify the  x-amz-server-side-encryption-aws-kms-key-id header explicitly, you can only specify it with the ID (Key ID or Key ARN) of the KMS  customer managed key that's configured for your directory bucket's default encryption setting. Otherwise, you get an HTTP 400 Bad Request error. Only use the key ID or key ARN. The key alias format of the KMS key isn't supported. Your SSE-KMS configuration can only support 1 customer managed key per directory bucket for the lifetime of the bucket.
        /// The Amazon Web Services managed key (aws/s3) isn't supported.
        internal let ssekmsKeyId: String?
        /// If the x-amz-storage-class header is not used, the copied object will be stored in the STANDARD Storage Class by default. The STANDARD storage class provides high durability and high availability. Depending on performance needs, you can specify a different Storage Class.      Directory buckets  - For directory buckets, only the S3 Express One Zone storage class is supported to store newly created objects.
        /// Unsupported storage class values won't write a destination object and will respond with the HTTP status code 400 Bad Request.    Amazon S3 on Outposts  - S3 on Outposts only uses the OUTPOSTS Storage Class.    You can use the CopyObject action to change the storage class of an object that is already stored in Amazon S3 by using the x-amz-storage-class header. For more information, see Storage Classes in the Amazon S3 User Guide. Before using an object as a source object for the copy operation, you must restore a copy of it if it meets any of the following conditions:   The storage class of the source object is GLACIER or DEEP_ARCHIVE.   The storage class of the source object is INTELLIGENT_TIERING and it's S3 Intelligent-Tiering access tier is Archive Access or Deep Archive Access.   For more information, see RestoreObject and Copying Objects in the Amazon S3 User Guide.
        internal let storageClass: StorageClass?
        /// The tag-set for the object copy in the destination bucket. This value must be used in conjunction with the x-amz-tagging-directive if you choose REPLACE for the x-amz-tagging-directive. If you choose COPY for the x-amz-tagging-directive, you don't need to set the x-amz-tagging header, because the tag-set will be copied from the source object directly. The tag-set must be encoded as URL Query parameters. The default value is the empty value.   Directory buckets - For directory buckets in a CopyObject operation, only the empty tag-set is supported. Any requests that attempt to write non-empty tags into directory buckets will receive a 501 Not Implemented status code.
        /// When the destination bucket is a directory bucket, you will receive a 501 Not Implemented response in any of the following situations:   When you attempt to COPY the tag-set from an S3 source object that has non-empty tags.   When you attempt to REPLACE the tag-set of a source object and set a non-empty value to x-amz-tagging.   When you don't set the x-amz-tagging-directive header and the source object has non-empty tags. This is because the default value of x-amz-tagging-directive is COPY.   Because only the empty tag-set is supported for directory buckets in a CopyObject operation, the following situations are allowed:   When you attempt to COPY the tag-set from a directory bucket source object that has no tags to a general purpose bucket. It copies an empty tag-set to the destination object.   When you attempt to REPLACE the tag-set of a directory bucket source object and set the x-amz-tagging value of the directory bucket destination object to empty.   When you attempt to REPLACE the tag-set of a general purpose bucket source object that has non-empty tags and set the x-amz-tagging value of the directory bucket destination object to empty.   When you attempt to REPLACE the tag-set of a directory bucket source object and don't set the x-amz-tagging value of the directory bucket destination object. This is because the default value of x-amz-tagging is the empty value.
        internal let tagging: String?
        /// Specifies whether the object tag-set is copied from the source object or replaced with the tag-set that's provided in the request. The default value is COPY.   Directory buckets - For directory buckets in a CopyObject operation, only the empty tag-set is supported. Any requests that attempt to write non-empty tags into directory buckets will receive a 501 Not Implemented status code.
        /// When the destination bucket is a directory bucket, you will receive a 501 Not Implemented response in any of the following situations:   When you attempt to COPY the tag-set from an S3 source object that has non-empty tags.   When you attempt to REPLACE the tag-set of a source object and set a non-empty value to x-amz-tagging.   When you don't set the x-amz-tagging-directive header and the source object has non-empty tags. This is because the default value of x-amz-tagging-directive is COPY.   Because only the empty tag-set is supported for directory buckets in a CopyObject operation, the following situations are allowed:   When you attempt to COPY the tag-set from a directory bucket source object that has no tags to a general purpose bucket. It copies an empty tag-set to the destination object.   When you attempt to REPLACE the tag-set of a directory bucket source object and set the x-amz-tagging value of the directory bucket destination object to empty.   When you attempt to REPLACE the tag-set of a general purpose bucket source object that has non-empty tags and set the x-amz-tagging value of the directory bucket destination object to empty.   When you attempt to REPLACE the tag-set of a directory bucket source object and don't set the x-amz-tagging value of the directory bucket destination object. This is because the default value of x-amz-tagging is the empty value.
        internal let taggingDirective: TaggingDirective?
        /// If the destination bucket is configured as a website, redirects requests for this object copy to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata. This value is unique to each object and is not copied when using the x-amz-metadata-directive header. Instead, you may opt to provide this header in combination with the x-amz-metadata-directive header.  This functionality is not supported for directory buckets.
        internal let websiteRedirectLocation: String?

        @inlinable
        internal init(
            acl: ObjectCannedACL? = nil, bucket: String, bucketKeyEnabled: Bool? = nil, cacheControl: String? = nil,
            checksumAlgorithm: ChecksumAlgorithm? = nil, contentDisposition: String? = nil,
            contentEncoding: String? = nil, contentLanguage: String? = nil, contentType: String? = nil,
            copySource: String, copySourceIfMatch: String? = nil, copySourceIfModifiedSince: Date? = nil,
            copySourceIfNoneMatch: String? = nil, copySourceIfUnmodifiedSince: Date? = nil,
            copySourceSSECustomerAlgorithm: String? = nil, copySourceSSECustomerKey: String? = nil,
            copySourceSSECustomerKeyMD5: String? = nil, expectedBucketOwner: String? = nil,
            expectedSourceBucketOwner: String? = nil, expires: Date? = nil, grantFullControl: String? = nil,
            grantRead: String? = nil, grantReadACP: String? = nil, grantWriteACP: String? = nil, key: String,
            metadata: [String: String]? = nil, metadataDirective: MetadataDirective? = nil,
            objectLockLegalHoldStatus: ObjectLockLegalHoldStatus? = nil, objectLockMode: ObjectLockMode? = nil,
            objectLockRetainUntilDate: Date? = nil, requestPayer: RequestPayer? = nil,
            serverSideEncryption: ServerSideEncryption? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil, ssekmsEncryptionContext: String? = nil,
            ssekmsKeyId: String? = nil, storageClass: StorageClass? = nil, tagging: String? = nil,
            taggingDirective: TaggingDirective? = nil, websiteRedirectLocation: String? = nil
        ) {
            self.acl = acl
            self.bucket = bucket
            self.bucketKeyEnabled = bucketKeyEnabled
            self.cacheControl = cacheControl
            self.checksumAlgorithm = checksumAlgorithm
            self.contentDisposition = contentDisposition
            self.contentEncoding = contentEncoding
            self.contentLanguage = contentLanguage
            self.contentType = contentType
            self.copySource = copySource
            self.copySourceIfMatch = copySourceIfMatch
            self.copySourceIfModifiedSince = copySourceIfModifiedSince
            self.copySourceIfNoneMatch = copySourceIfNoneMatch
            self.copySourceIfUnmodifiedSince = copySourceIfUnmodifiedSince
            self.copySourceSSECustomerAlgorithm = copySourceSSECustomerAlgorithm
            self.copySourceSSECustomerKey = copySourceSSECustomerKey
            self.copySourceSSECustomerKeyMD5 = copySourceSSECustomerKeyMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.expectedSourceBucketOwner = expectedSourceBucketOwner
            self.expires = expires
            self.grantFullControl = grantFullControl
            self.grantRead = grantRead
            self.grantReadACP = grantReadACP
            self.grantWriteACP = grantWriteACP
            self.key = key
            self.metadata = metadata
            self.metadataDirective = metadataDirective
            self.objectLockLegalHoldStatus = objectLockLegalHoldStatus
            self.objectLockMode = objectLockMode
            self.objectLockRetainUntilDate = objectLockRetainUntilDate
            self.requestPayer = requestPayer
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsEncryptionContext = ssekmsEncryptionContext
            self.ssekmsKeyId = ssekmsKeyId
            self.storageClass = storageClass
            self.tagging = tagging
            self.taggingDirective = taggingDirective
            self.websiteRedirectLocation = websiteRedirectLocation
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodeHeader(self.acl, key: "x-amz-acl")
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.bucketKeyEnabled, key: "x-amz-server-side-encryption-bucket-key-enabled")
            request.encodeHeader(self.cacheControl, key: "Cache-Control")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-checksum-algorithm")
            request.encodeHeader(self.contentDisposition, key: "Content-Disposition")
            request.encodeHeader(self.contentEncoding, key: "Content-Encoding")
            request.encodeHeader(self.contentLanguage, key: "Content-Language")
            request.encodeHeader(self.contentType, key: "Content-Type")
            request.encodeHeader(self.copySource, key: "x-amz-copy-source")
            request.encodeHeader(self.copySourceIfMatch, key: "x-amz-copy-source-if-match")
            request.encodeHeader(self._copySourceIfModifiedSince, key: "x-amz-copy-source-if-modified-since")
            request.encodeHeader(self.copySourceIfNoneMatch, key: "x-amz-copy-source-if-none-match")
            request.encodeHeader(self._copySourceIfUnmodifiedSince, key: "x-amz-copy-source-if-unmodified-since")
            request.encodeHeader(
                self.copySourceSSECustomerAlgorithm, key: "x-amz-copy-source-server-side-encryption-customer-algorithm")
            request.encodeHeader(
                self.copySourceSSECustomerKey, key: "x-amz-copy-source-server-side-encryption-customer-key")
            request.encodeHeader(
                self.copySourceSSECustomerKeyMD5, key: "x-amz-copy-source-server-side-encryption-customer-key-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.expectedSourceBucketOwner, key: "x-amz-source-expected-bucket-owner")
            request.encodeHeader(self._expires, key: "Expires")
            request.encodeHeader(self.grantFullControl, key: "x-amz-grant-full-control")
            request.encodeHeader(self.grantRead, key: "x-amz-grant-read")
            request.encodeHeader(self.grantReadACP, key: "x-amz-grant-read-acp")
            request.encodeHeader(self.grantWriteACP, key: "x-amz-grant-write-acp")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.metadata, key: "x-amz-meta-")
            request.encodeHeader(self.metadataDirective, key: "x-amz-metadata-directive")
            request.encodeHeader(self.objectLockLegalHoldStatus, key: "x-amz-object-lock-legal-hold")
            request.encodeHeader(self.objectLockMode, key: "x-amz-object-lock-mode")
            request.encodeHeader(self._objectLockRetainUntilDate, key: "x-amz-object-lock-retain-until-date")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.serverSideEncryption, key: "x-amz-server-side-encryption")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeHeader(self.ssekmsEncryptionContext, key: "x-amz-server-side-encryption-context")
            request.encodeHeader(self.ssekmsKeyId, key: "x-amz-server-side-encryption-aws-kms-key-id")
            request.encodeHeader(self.storageClass, key: "x-amz-storage-class")
            request.encodeHeader(self.tagging, key: "x-amz-tagging")
            request.encodeHeader(self.taggingDirective, key: "x-amz-tagging-directive")
            request.encodeHeader(self.websiteRedirectLocation, key: "x-amz-website-redirect-location")
        }

        internal func validate(name: String) throws {
            try self.validate(self.copySource, name: "copySource", parent: name, pattern: ".+\\/.+")
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct CopyObjectResult: AWSDecodableShape {
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. For more information, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. For more information, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. For more information, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. For more information, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Returns the ETag of the new object. The ETag reflects only changes to the contents of an object, not its metadata.
        internal let eTag: String?
        /// Creation date of the object.
        internal let lastModified: Date?

        @inlinable
        internal init(
            checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil, eTag: String? = nil, lastModified: Date? = nil
        ) {
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.eTag = eTag
            self.lastModified = lastModified
        }

        private enum CodingKeys: String, CodingKey {
            case checksumCRC32 = "ChecksumCRC32"
            case checksumCRC32C = "ChecksumCRC32C"
            case checksumSHA1 = "ChecksumSHA1"
            case checksumSHA256 = "ChecksumSHA256"
            case eTag = "ETag"
            case lastModified = "LastModified"
        }
    }

    internal struct CopyPartResult: AWSDecodableShape {
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Entity tag of the object.
        internal let eTag: String?
        /// Date and time at which the object was uploaded.
        internal let lastModified: Date?

        @inlinable
        internal init(
            checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil, eTag: String? = nil, lastModified: Date? = nil
        ) {
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.eTag = eTag
            self.lastModified = lastModified
        }

        private enum CodingKeys: String, CodingKey {
            case checksumCRC32 = "ChecksumCRC32"
            case checksumCRC32C = "ChecksumCRC32C"
            case checksumSHA1 = "ChecksumSHA1"
            case checksumSHA256 = "ChecksumSHA256"
            case eTag = "ETag"
            case lastModified = "LastModified"
        }
    }

    internal struct CreateBucketConfiguration: AWSEncodableShape {
        /// Specifies the information about the bucket that will be created.  This functionality is only supported by directory buckets.
        internal let bucket: BucketInfo?
        /// Specifies the location where the bucket will be created.  Directory buckets  - The location type is Availability Zone or Local Zone.  When the location type is Local Zone, your Local Zone must be  in opt-in status. Otherwise, you get an HTTP 400 Bad Request error with the  error code Access denied. To learn more about opt-in Local Zones, see Opt-in Dedicated Local Zonesin the Amazon S3 User Guide.   This functionality is only supported by directory buckets.
        internal let location: LocationInfo?
        /// Specifies the Region where the bucket will be created. You might choose a Region to optimize latency, minimize costs, or address regulatory requirements. For example, if you reside in Europe, you will probably find it advantageous to create buckets in the Europe (Ireland) Region. For more information, see Accessing a bucket in the Amazon S3 User Guide. If you don't specify a Region, the bucket is created in the US East (N. Virginia) Region (us-east-1) by default.  This functionality is not supported for directory buckets.
        internal let locationConstraint: BucketLocationConstraint?

        @inlinable
        internal init(
            bucket: BucketInfo? = nil, location: LocationInfo? = nil,
            locationConstraint: BucketLocationConstraint? = nil
        ) {
            self.bucket = bucket
            self.location = location
            self.locationConstraint = locationConstraint
        }

        private enum CodingKeys: String, CodingKey {
            case bucket = "Bucket"
            case location = "Location"
            case locationConstraint = "LocationConstraint"
        }
    }

    internal struct CreateBucketMetadataTableConfigurationRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "MetadataTableConfiguration"
        ///  The general purpose bucket that you want to create the metadata table configuration in.
        internal let bucket: String
        ///  The checksum algorithm to use with your metadata table configuration.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        ///  The Content-MD5 header for the metadata table configuration.
        internal let contentMD5: String?
        ///  The expected owner of the general purpose bucket that contains your metadata table configuration.
        internal let expectedBucketOwner: String?
        ///  The contents of your metadata table configuration.
        internal let metadataTableConfiguration: MetadataTableConfiguration

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, metadataTableConfiguration: MetadataTableConfiguration
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.metadataTableConfiguration = metadataTableConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.metadataTableConfiguration)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct CreateBucketOutput: AWSDecodableShape {
        /// A forward slash followed by the name of the bucket.
        internal let location: String?

        @inlinable
        internal init(location: String? = nil) {
            self.location = location
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.location = try response.decodeHeaderIfPresent(String.self, key: "Location")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct CreateBucketRequest: AWSEncodableShape {
        internal static let _xmlRootNodeName: String? = "CreateBucketConfiguration"
        /// The canned ACL to apply to the bucket.  This functionality is not supported for directory buckets.
        internal let acl: BucketCannedACL?
        /// The name of the bucket to create.  General purpose buckets - For information about bucket naming restrictions, see Bucket naming rules in the Amazon S3 User Guide.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide
        internal let bucket: String
        /// The configuration information for the bucket.
        internal let createBucketConfiguration: CreateBucketConfiguration?
        /// Allows grantee the read, write, read ACP, and write ACP permissions on the bucket.  This functionality is not supported for directory buckets.
        internal let grantFullControl: String?
        /// Allows grantee to list the objects in the bucket.  This functionality is not supported for directory buckets.
        internal let grantRead: String?
        /// Allows grantee to read the bucket ACL.  This functionality is not supported for directory buckets.
        internal let grantReadACP: String?
        /// Allows grantee to create new objects in the bucket. For the bucket and object owners of existing objects, also allows deletions and overwrites of those objects.  This functionality is not supported for directory buckets.
        internal let grantWrite: String?
        /// Allows grantee to write the ACL for the applicable bucket.  This functionality is not supported for directory buckets.
        internal let grantWriteACP: String?
        /// Specifies whether you want S3 Object Lock to be enabled for the new bucket.  This functionality is not supported for directory buckets.
        internal let objectLockEnabledForBucket: Bool?
        internal let objectOwnership: ObjectOwnership?

        @inlinable
        internal init(
            acl: BucketCannedACL? = nil, bucket: String, createBucketConfiguration: CreateBucketConfiguration? = nil,
            grantFullControl: String? = nil, grantRead: String? = nil, grantReadACP: String? = nil,
            grantWrite: String? = nil, grantWriteACP: String? = nil, objectLockEnabledForBucket: Bool? = nil,
            objectOwnership: ObjectOwnership? = nil
        ) {
            self.acl = acl
            self.bucket = bucket
            self.createBucketConfiguration = createBucketConfiguration
            self.grantFullControl = grantFullControl
            self.grantRead = grantRead
            self.grantReadACP = grantReadACP
            self.grantWrite = grantWrite
            self.grantWriteACP = grantWriteACP
            self.objectLockEnabledForBucket = objectLockEnabledForBucket
            self.objectOwnership = objectOwnership
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodeHeader(self.acl, key: "x-amz-acl")
            request.encodePath(self.bucket, key: "Bucket")
            try container.encode(self.createBucketConfiguration)
            request.encodeHeader(self.grantFullControl, key: "x-amz-grant-full-control")
            request.encodeHeader(self.grantRead, key: "x-amz-grant-read")
            request.encodeHeader(self.grantReadACP, key: "x-amz-grant-read-acp")
            request.encodeHeader(self.grantWrite, key: "x-amz-grant-write")
            request.encodeHeader(self.grantWriteACP, key: "x-amz-grant-write-acp")
            request.encodeHeader(self.objectLockEnabledForBucket, key: "x-amz-bucket-object-lock-enabled")
            request.encodeHeader(self.objectOwnership, key: "x-amz-object-ownership")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct CreateMultipartUploadOutput: AWSDecodableShape {
        /// If the bucket has a lifecycle rule configured with an action to abort incomplete multipart uploads and the prefix in the lifecycle rule matches the object name in the request, the response includes this header. The header indicates when the initiated multipart upload becomes eligible for an abort operation. For more information, see  Aborting Incomplete Multipart Uploads Using a Bucket Lifecycle Configuration in the Amazon S3 User Guide. The response also includes the x-amz-abort-rule-id header that provides the ID of the lifecycle configuration rule that defines the abort action.  This functionality is not supported for directory buckets.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var abortDate: Date?
        /// This header is returned along with the x-amz-abort-date header. It identifies the applicable lifecycle configuration rule that defines the action to abort incomplete multipart uploads.  This functionality is not supported for directory buckets.
        internal let abortRuleId: String?
        /// The name of the bucket to which the multipart upload was initiated. Does not return the access point ARN or access point alias if used.  Access points are not supported by directory buckets.
        internal let bucket: String?
        /// Indicates whether the multipart upload uses an S3 Bucket Key for server-side encryption with Key Management Service (KMS) keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// The algorithm that was used to create a checksum of the object.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// Object key for which the multipart upload was initiated.
        internal let key: String?
        internal let requestCharged: RequestCharged?
        /// The server-side encryption algorithm used when you store this object in Amazon S3 (for example, AES256, aws:kms).
        internal let serverSideEncryption: ServerSideEncryption?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to confirm the encryption algorithm that's used.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide the round-trip message integrity verification of the customer-provided encryption key.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// If present, indicates the Amazon Web Services KMS Encryption Context to use for object encryption. The value of this header is a Base64-encoded string of a UTF-8 encoded JSON, which contains the encryption context as key-value pairs.
        internal let ssekmsEncryptionContext: String?
        /// If present, indicates the ID of the KMS key that was used for object encryption.
        internal let ssekmsKeyId: String?
        /// ID for the initiated multipart upload.
        internal let uploadId: String?

        @inlinable
        internal init(
            abortDate: Date? = nil, abortRuleId: String? = nil, bucket: String? = nil, bucketKeyEnabled: Bool? = nil,
            checksumAlgorithm: ChecksumAlgorithm? = nil, key: String? = nil, requestCharged: RequestCharged? = nil,
            serverSideEncryption: ServerSideEncryption? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKeyMD5: String? = nil, ssekmsEncryptionContext: String? = nil, ssekmsKeyId: String? = nil,
            uploadId: String? = nil
        ) {
            self.abortDate = abortDate
            self.abortRuleId = abortRuleId
            self.bucket = bucket
            self.bucketKeyEnabled = bucketKeyEnabled
            self.checksumAlgorithm = checksumAlgorithm
            self.key = key
            self.requestCharged = requestCharged
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsEncryptionContext = ssekmsEncryptionContext
            self.ssekmsKeyId = ssekmsKeyId
            self.uploadId = uploadId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.abortDate = try response.decodeHeaderIfPresent(Date.self, key: "x-amz-abort-date")
            self.abortRuleId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-abort-rule-id")
            self.bucket = try container.decodeIfPresent(String.self, forKey: .bucket)
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.checksumAlgorithm = try response.decodeHeaderIfPresent(
                ChecksumAlgorithm.self, key: "x-amz-checksum-algorithm")
            self.key = try container.decodeIfPresent(String.self, forKey: .key)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.sseCustomerAlgorithm = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-algorithm")
            self.sseCustomerKeyMD5 = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-key-MD5")
            self.ssekmsEncryptionContext = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-context")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
            self.uploadId = try container.decodeIfPresent(String.self, forKey: .uploadId)
        }

        private enum CodingKeys: String, CodingKey {
            case bucket = "Bucket"
            case key = "Key"
            case uploadId = "UploadId"
        }
    }

    internal struct CreateMultipartUploadRequest: AWSEncodableShape {
        /// The canned ACL to apply to the object. Amazon S3 supports a set of predefined ACLs, known as canned ACLs. Each canned ACL has a predefined set of grantees and permissions. For more information, see Canned ACL in the Amazon S3 User Guide. By default, all objects are private. Only the owner has full access control. When uploading an object, you can grant access permissions to individual Amazon Web Services accounts or to predefined groups defined by Amazon S3. These permissions are then added to the access control list (ACL) on the new object. For more information, see Using ACLs. One way to grant the permissions using the request headers is to specify a canned ACL with the x-amz-acl request header.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let acl: ObjectCannedACL?
        /// The name of the bucket where the multipart upload is initiated and where the object is uploaded.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Specifies whether Amazon S3 should use an S3 Bucket Key for object encryption with server-side encryption using Key Management Service (KMS) keys (SSE-KMS).  General purpose buckets - Setting this header to true causes Amazon S3 to use an S3 Bucket Key for object encryption with SSE-KMS. Also, specifying this header with a PUT action doesn't affect bucket-level settings for S3 Bucket Key.  Directory buckets - S3 Bucket Keys are always enabled for GET and PUT operations in a directory bucket and can’t be disabled. S3 Bucket Keys aren't supported, when you copy SSE-KMS encrypted objects from general purpose buckets
        /// to directory buckets, from directory buckets to general purpose buckets, or between directory buckets, through CopyObject, UploadPartCopy, the Copy operation in Batch Operations, or  the import jobs. In this case, Amazon S3 makes a call to KMS every time a copy request is made for a KMS-encrypted object.
        internal let bucketKeyEnabled: Bool?
        /// Specifies caching behavior along the request/reply chain.
        internal let cacheControl: String?
        /// Indicates the algorithm that you want Amazon S3 to use to create the checksum for the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// Specifies presentational information for the object.
        internal let contentDisposition: String?
        /// Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.  For directory buckets, only the aws-chunked value is supported in this header field.
        internal let contentEncoding: String?
        /// The language that the content is in.
        internal let contentLanguage: String?
        /// A standard MIME type describing the format of the object data.
        internal let contentType: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The date and time at which the object is no longer cacheable.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var expires: Date?
        /// Specify access permissions explicitly to give the grantee READ, READ_ACP, and WRITE_ACP permissions on the object. By default, all objects are private. Only the owner has full access control. When uploading an object, you can use this header to explicitly grant access permissions to specific Amazon Web Services accounts or groups. This header maps to specific permissions that Amazon S3 supports in an ACL. For more information, see Access Control List (ACL) Overview in the Amazon S3 User Guide. You specify each grantee as a type=value pair, where the type is one of the following:    id – if the value specified is the canonical user ID of an Amazon Web Services account    uri – if you are granting permissions to a predefined group    emailAddress – if the value specified is the email address of an Amazon Web Services account  Using email addresses to specify a grantee is only supported in the following Amazon Web Services Regions:    US East (N. Virginia)   US West (N. California)   US West (Oregon)   Asia Pacific (Singapore)   Asia Pacific (Sydney)   Asia Pacific (Tokyo)   Europe (Ireland)   South America (São Paulo)   For a list of all the Amazon S3 supported Regions and endpoints, see Regions and Endpoints in the Amazon Web Services General Reference.    For example, the following x-amz-grant-read header grants the Amazon Web Services accounts identified by account IDs permissions to read object data and its metadata:  x-amz-grant-read: id="11112222333", id="444455556666"      This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantFullControl: String?
        /// Specify access permissions explicitly to allow grantee to read the object data and its metadata. By default, all objects are private. Only the owner has full access control. When uploading an object, you can use this header to explicitly grant access permissions to specific Amazon Web Services accounts or groups. This header maps to specific permissions that Amazon S3 supports in an ACL. For more information, see Access Control List (ACL) Overview in the Amazon S3 User Guide. You specify each grantee as a type=value pair, where the type is one of the following:    id – if the value specified is the canonical user ID of an Amazon Web Services account    uri – if you are granting permissions to a predefined group    emailAddress – if the value specified is the email address of an Amazon Web Services account  Using email addresses to specify a grantee is only supported in the following Amazon Web Services Regions:    US East (N. Virginia)   US West (N. California)   US West (Oregon)   Asia Pacific (Singapore)   Asia Pacific (Sydney)   Asia Pacific (Tokyo)   Europe (Ireland)   South America (São Paulo)   For a list of all the Amazon S3 supported Regions and endpoints, see Regions and Endpoints in the Amazon Web Services General Reference.    For example, the following x-amz-grant-read header grants the Amazon Web Services accounts identified by account IDs permissions to read object data and its metadata:  x-amz-grant-read: id="11112222333", id="444455556666"      This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantRead: String?
        /// Specify access permissions explicitly to allows grantee to read the object ACL. By default, all objects are private. Only the owner has full access control. When uploading an object, you can use this header to explicitly grant access permissions to specific Amazon Web Services accounts or groups. This header maps to specific permissions that Amazon S3 supports in an ACL. For more information, see Access Control List (ACL) Overview in the Amazon S3 User Guide. You specify each grantee as a type=value pair, where the type is one of the following:    id – if the value specified is the canonical user ID of an Amazon Web Services account    uri – if you are granting permissions to a predefined group    emailAddress – if the value specified is the email address of an Amazon Web Services account  Using email addresses to specify a grantee is only supported in the following Amazon Web Services Regions:    US East (N. Virginia)   US West (N. California)   US West (Oregon)   Asia Pacific (Singapore)   Asia Pacific (Sydney)   Asia Pacific (Tokyo)   Europe (Ireland)   South America (São Paulo)   For a list of all the Amazon S3 supported Regions and endpoints, see Regions and Endpoints in the Amazon Web Services General Reference.    For example, the following x-amz-grant-read header grants the Amazon Web Services accounts identified by account IDs permissions to read object data and its metadata:  x-amz-grant-read: id="11112222333", id="444455556666"      This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantReadACP: String?
        /// Specify access permissions explicitly to allows grantee to allow grantee to write the ACL for the applicable object. By default, all objects are private. Only the owner has full access control. When uploading an object, you can use this header to explicitly grant access permissions to specific Amazon Web Services accounts or groups. This header maps to specific permissions that Amazon S3 supports in an ACL. For more information, see Access Control List (ACL) Overview in the Amazon S3 User Guide. You specify each grantee as a type=value pair, where the type is one of the following:    id – if the value specified is the canonical user ID of an Amazon Web Services account    uri – if you are granting permissions to a predefined group    emailAddress – if the value specified is the email address of an Amazon Web Services account  Using email addresses to specify a grantee is only supported in the following Amazon Web Services Regions:    US East (N. Virginia)   US West (N. California)   US West (Oregon)   Asia Pacific (Singapore)   Asia Pacific (Sydney)   Asia Pacific (Tokyo)   Europe (Ireland)   South America (São Paulo)   For a list of all the Amazon S3 supported Regions and endpoints, see Regions and Endpoints in the Amazon Web Services General Reference.    For example, the following x-amz-grant-read header grants the Amazon Web Services accounts identified by account IDs permissions to read object data and its metadata:  x-amz-grant-read: id="11112222333", id="444455556666"      This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantWriteACP: String?
        /// Object key for which the multipart upload is to be initiated.
        internal let key: String
        /// A map of metadata to store with the object in S3.
        internal let metadata: [String: String]?
        /// Specifies whether you want to apply a legal hold to the uploaded object.  This functionality is not supported for directory buckets.
        internal let objectLockLegalHoldStatus: ObjectLockLegalHoldStatus?
        /// Specifies the Object Lock mode that you want to apply to the uploaded object.  This functionality is not supported for directory buckets.
        internal let objectLockMode: ObjectLockMode?
        /// Specifies the date and time when you want the Object Lock to expire.  This functionality is not supported for directory buckets.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var objectLockRetainUntilDate: Date?
        internal let requestPayer: RequestPayer?
        /// The server-side encryption algorithm used when you store this object in Amazon S3 (for example, AES256, aws:kms).    Directory buckets  - For directory buckets, there are only two supported options for server-side encryption: server-side encryption with Amazon S3 managed keys (SSE-S3) (AES256) and server-side encryption with KMS keys (SSE-KMS) (aws:kms). We recommend that the bucket's default encryption uses the desired encryption configuration and you don't override the bucket default encryption in your  CreateSession requests or PUT object requests. Then, new objects  are automatically encrypted with the desired encryption settings. For more information, see Protecting data with server-side encryption in the Amazon S3 User Guide. For more information about the encryption overriding behaviors in directory buckets, see Specifying server-side encryption with KMS for new object uploads.  In the Zonal endpoint API calls (except CopyObject and UploadPartCopy) using the REST API, the encryption request headers must match the encryption settings that are specified in the CreateSession request.  You can't override the values of the encryption settings (x-amz-server-side-encryption, x-amz-server-side-encryption-aws-kms-key-id, x-amz-server-side-encryption-context, and x-amz-server-side-encryption-bucket-key-enabled) that are specified in the CreateSession request.  You don't need to explicitly specify these encryption settings values in Zonal endpoint API calls, and    Amazon S3 will use the encryption settings values from the CreateSession request to protect new objects in the directory bucket.    When you use the CLI or the Amazon Web Services SDKs, for CreateSession, the session token refreshes automatically to avoid service interruptions when a session expires. The CLI or the Amazon Web Services SDKs use the bucket's default encryption configuration for the  CreateSession request. It's not supported to override the encryption settings values in the CreateSession request.  So in the Zonal endpoint API calls (except CopyObject and UploadPartCopy),  the encryption request headers must match the default encryption configuration of the directory bucket.
        ///
        internal let serverSideEncryption: ServerSideEncryption?
        /// Specifies the algorithm to use when encrypting the object (for example, AES256).  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header.  This functionality is not supported for directory buckets.
        internal let sseCustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the customer-provided encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// Specifies the Amazon Web Services KMS Encryption Context to use for object encryption. The value of this header is a Base64-encoded string of a UTF-8 encoded JSON, which contains the encryption context as key-value pairs.  Directory buckets - You can optionally provide an explicit encryption context value. The value must match the default encryption context - the bucket Amazon Resource Name (ARN). An additional encryption context value is not supported.
        internal let ssekmsEncryptionContext: String?
        /// Specifies the KMS key ID (Key ID, Key ARN, or Key Alias) to use for object encryption. If the KMS key doesn't exist in the same account that's issuing the command, you must use the full Key ARN not the Key ID.  General purpose buckets - If you specify x-amz-server-side-encryption with aws:kms or aws:kms:dsse, this header specifies the ID (Key ID, Key ARN, or Key Alias) of the KMS  key to use. If you specify x-amz-server-side-encryption:aws:kms or x-amz-server-side-encryption:aws:kms:dsse, but do not provide x-amz-server-side-encryption-aws-kms-key-id, Amazon S3 uses the Amazon Web Services managed key (aws/s3) to protect the data.  Directory buckets - If you specify x-amz-server-side-encryption with aws:kms, the  x-amz-server-side-encryption-aws-kms-key-id header is implicitly assigned the ID of the KMS  symmetric encryption customer managed key that's configured for your directory bucket's default encryption setting.  If you want to specify the  x-amz-server-side-encryption-aws-kms-key-id header explicitly, you can only specify it with the ID (Key ID or Key ARN) of the KMS  customer managed key that's configured for your directory bucket's default encryption setting. Otherwise, you get an HTTP 400 Bad Request error. Only use the key ID or key ARN. The key alias format of the KMS key isn't supported. Your SSE-KMS configuration can only support 1 customer managed key per directory bucket for the lifetime of the bucket.
        /// The Amazon Web Services managed key (aws/s3) isn't supported.
        internal let ssekmsKeyId: String?
        /// By default, Amazon S3 uses the STANDARD Storage Class to store newly created objects. The STANDARD storage class provides high durability and high availability. Depending on performance needs, you can specify a different Storage Class. For more information, see Storage Classes in the Amazon S3 User Guide.    For directory buckets, only the S3 Express One Zone storage class is supported to store newly created objects.   Amazon S3 on Outposts only uses the OUTPOSTS Storage Class.
        internal let storageClass: StorageClass?
        /// The tag-set for the object. The tag-set must be encoded as URL Query parameters.  This functionality is not supported for directory buckets.
        internal let tagging: String?
        /// If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata.  This functionality is not supported for directory buckets.
        internal let websiteRedirectLocation: String?

        @inlinable
        internal init(
            acl: ObjectCannedACL? = nil, bucket: String, bucketKeyEnabled: Bool? = nil, cacheControl: String? = nil,
            checksumAlgorithm: ChecksumAlgorithm? = nil, contentDisposition: String? = nil,
            contentEncoding: String? = nil, contentLanguage: String? = nil, contentType: String? = nil,
            expectedBucketOwner: String? = nil, expires: Date? = nil, grantFullControl: String? = nil,
            grantRead: String? = nil, grantReadACP: String? = nil, grantWriteACP: String? = nil, key: String,
            metadata: [String: String]? = nil, objectLockLegalHoldStatus: ObjectLockLegalHoldStatus? = nil,
            objectLockMode: ObjectLockMode? = nil, objectLockRetainUntilDate: Date? = nil,
            requestPayer: RequestPayer? = nil, serverSideEncryption: ServerSideEncryption? = nil,
            sseCustomerAlgorithm: String? = nil, sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil,
            ssekmsEncryptionContext: String? = nil, ssekmsKeyId: String? = nil, storageClass: StorageClass? = nil,
            tagging: String? = nil, websiteRedirectLocation: String? = nil
        ) {
            self.acl = acl
            self.bucket = bucket
            self.bucketKeyEnabled = bucketKeyEnabled
            self.cacheControl = cacheControl
            self.checksumAlgorithm = checksumAlgorithm
            self.contentDisposition = contentDisposition
            self.contentEncoding = contentEncoding
            self.contentLanguage = contentLanguage
            self.contentType = contentType
            self.expectedBucketOwner = expectedBucketOwner
            self.expires = expires
            self.grantFullControl = grantFullControl
            self.grantRead = grantRead
            self.grantReadACP = grantReadACP
            self.grantWriteACP = grantWriteACP
            self.key = key
            self.metadata = metadata
            self.objectLockLegalHoldStatus = objectLockLegalHoldStatus
            self.objectLockMode = objectLockMode
            self.objectLockRetainUntilDate = objectLockRetainUntilDate
            self.requestPayer = requestPayer
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsEncryptionContext = ssekmsEncryptionContext
            self.ssekmsKeyId = ssekmsKeyId
            self.storageClass = storageClass
            self.tagging = tagging
            self.websiteRedirectLocation = websiteRedirectLocation
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodeHeader(self.acl, key: "x-amz-acl")
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.bucketKeyEnabled, key: "x-amz-server-side-encryption-bucket-key-enabled")
            request.encodeHeader(self.cacheControl, key: "Cache-Control")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-checksum-algorithm")
            request.encodeHeader(self.contentDisposition, key: "Content-Disposition")
            request.encodeHeader(self.contentEncoding, key: "Content-Encoding")
            request.encodeHeader(self.contentLanguage, key: "Content-Language")
            request.encodeHeader(self.contentType, key: "Content-Type")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self._expires, key: "Expires")
            request.encodeHeader(self.grantFullControl, key: "x-amz-grant-full-control")
            request.encodeHeader(self.grantRead, key: "x-amz-grant-read")
            request.encodeHeader(self.grantReadACP, key: "x-amz-grant-read-acp")
            request.encodeHeader(self.grantWriteACP, key: "x-amz-grant-write-acp")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.metadata, key: "x-amz-meta-")
            request.encodeHeader(self.objectLockLegalHoldStatus, key: "x-amz-object-lock-legal-hold")
            request.encodeHeader(self.objectLockMode, key: "x-amz-object-lock-mode")
            request.encodeHeader(self._objectLockRetainUntilDate, key: "x-amz-object-lock-retain-until-date")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.serverSideEncryption, key: "x-amz-server-side-encryption")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeHeader(self.ssekmsEncryptionContext, key: "x-amz-server-side-encryption-context")
            request.encodeHeader(self.ssekmsKeyId, key: "x-amz-server-side-encryption-aws-kms-key-id")
            request.encodeHeader(self.storageClass, key: "x-amz-storage-class")
            request.encodeHeader(self.tagging, key: "x-amz-tagging")
            request.encodeHeader(self.websiteRedirectLocation, key: "x-amz-website-redirect-location")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct CreateSessionOutput: AWSDecodableShape {
        /// Indicates whether to use an S3 Bucket Key for server-side encryption with KMS keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// The established temporary security credentials for the created session.
        internal let credentials: SessionCredentials
        /// The server-side encryption algorithm used when you store objects in the directory bucket.
        internal let serverSideEncryption: ServerSideEncryption?
        /// If present, indicates the Amazon Web Services KMS Encryption Context to use for object encryption. The value of this header is a Base64-encoded string of a UTF-8 encoded JSON, which contains the encryption context as key-value pairs.  This value is stored as object metadata and automatically gets passed on to Amazon Web Services KMS for future GetObject  operations on this object.
        internal let ssekmsEncryptionContext: String?
        /// If you specify x-amz-server-side-encryption with aws:kms, this header indicates the ID of the KMS  symmetric encryption customer managed key that was used for object encryption.
        internal let ssekmsKeyId: String?

        @inlinable
        internal init(
            bucketKeyEnabled: Bool? = nil, credentials: SessionCredentials,
            serverSideEncryption: ServerSideEncryption? = nil, ssekmsEncryptionContext: String? = nil,
            ssekmsKeyId: String? = nil
        ) {
            self.bucketKeyEnabled = bucketKeyEnabled
            self.credentials = credentials
            self.serverSideEncryption = serverSideEncryption
            self.ssekmsEncryptionContext = ssekmsEncryptionContext
            self.ssekmsKeyId = ssekmsKeyId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.credentials = try container.decode(SessionCredentials.self, forKey: .credentials)
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.ssekmsEncryptionContext = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-context")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
        }

        private enum CodingKeys: String, CodingKey {
            case credentials = "Credentials"
        }
    }

    internal struct CreateSessionRequest: AWSEncodableShape {
        /// The name of the bucket that you create a session for.
        internal let bucket: String
        /// Specifies whether Amazon S3 should use an S3 Bucket Key for object encryption with server-side encryption using KMS keys (SSE-KMS). S3 Bucket Keys are always enabled for GET and PUT operations in a directory bucket and can’t be disabled. S3 Bucket Keys aren't supported, when you copy SSE-KMS encrypted objects from general purpose buckets
        /// to directory buckets, from directory buckets to general purpose buckets, or between directory buckets, through CopyObject, UploadPartCopy, the Copy operation in Batch Operations, or  the import jobs. In this case, Amazon S3 makes a call to KMS every time a copy request is made for a KMS-encrypted object.
        internal let bucketKeyEnabled: Bool?
        /// The server-side encryption algorithm to use when you store objects in the directory bucket. For directory buckets, there are only two supported options for server-side encryption: server-side encryption with Amazon S3 managed keys (SSE-S3) (AES256) and server-side encryption with KMS keys (SSE-KMS) (aws:kms). By default, Amazon S3 encrypts data with SSE-S3.  For more information, see Protecting data with server-side encryption in the Amazon S3 User Guide.
        internal let serverSideEncryption: ServerSideEncryption?
        /// Specifies the mode of the session that will be created, either ReadWrite or ReadOnly. By default, a ReadWrite session is created. A ReadWrite session is capable of executing all the Zonal endpoint API operations on a directory bucket. A ReadOnly session is constrained to execute the following Zonal endpoint API operations: GetObject, HeadObject, ListObjectsV2, GetObjectAttributes, ListParts, and ListMultipartUploads.
        internal let sessionMode: SessionMode?
        /// Specifies the Amazon Web Services KMS Encryption Context as an additional encryption context to use for object encryption. The value of this header is a Base64-encoded string of a UTF-8 encoded JSON, which contains the encryption context as key-value pairs.  This value is stored as object metadata and automatically gets passed on to Amazon Web Services KMS for future GetObject operations on this object.  General purpose buckets - This value must be explicitly added during CopyObject operations if you want an additional encryption context for your object. For more information, see Encryption context in the Amazon S3 User Guide.  Directory buckets - You can optionally provide an explicit encryption context value. The value must match the default encryption context - the bucket Amazon Resource Name (ARN). An additional encryption context value is not supported.
        internal let ssekmsEncryptionContext: String?
        /// If you specify x-amz-server-side-encryption with aws:kms, you must specify the  x-amz-server-side-encryption-aws-kms-key-id header with the ID (Key ID or Key ARN) of the KMS  symmetric encryption customer managed key to use. Otherwise, you get an HTTP 400 Bad Request error. Only use the key ID or key ARN. The key alias format of the KMS key isn't supported. Also, if the KMS key doesn't exist in the same account that't issuing the command, you must use the full Key ARN not the Key ID.  Your SSE-KMS configuration can only support 1 customer managed key per directory bucket for the lifetime of the bucket.
        /// The Amazon Web Services managed key (aws/s3) isn't supported.
        internal let ssekmsKeyId: String?

        @inlinable
        internal init(
            bucket: String, bucketKeyEnabled: Bool? = nil, serverSideEncryption: ServerSideEncryption? = nil,
            sessionMode: SessionMode? = nil, ssekmsEncryptionContext: String? = nil, ssekmsKeyId: String? = nil
        ) {
            self.bucket = bucket
            self.bucketKeyEnabled = bucketKeyEnabled
            self.serverSideEncryption = serverSideEncryption
            self.sessionMode = sessionMode
            self.ssekmsEncryptionContext = ssekmsEncryptionContext
            self.ssekmsKeyId = ssekmsKeyId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.bucketKeyEnabled, key: "x-amz-server-side-encryption-bucket-key-enabled")
            request.encodeHeader(self.serverSideEncryption, key: "x-amz-server-side-encryption")
            request.encodeHeader(self.sessionMode, key: "x-amz-create-session-mode")
            request.encodeHeader(self.ssekmsEncryptionContext, key: "x-amz-server-side-encryption-context")
            request.encodeHeader(self.ssekmsKeyId, key: "x-amz-server-side-encryption-aws-kms-key-id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DefaultRetention: AWSEncodableShape & AWSDecodableShape {
        /// The number of days that you want to specify for the default retention period. Must be used with Mode.
        internal let days: Int?
        /// The default Object Lock retention mode you want to apply to new objects placed in the specified bucket. Must be used with either Days or Years.
        internal let mode: ObjectLockRetentionMode?
        /// The number of years that you want to specify for the default retention period. Must be used with Mode.
        internal let years: Int?

        @inlinable
        internal init(days: Int? = nil, mode: ObjectLockRetentionMode? = nil, years: Int? = nil) {
            self.days = days
            self.mode = mode
            self.years = years
        }

        private enum CodingKeys: String, CodingKey {
            case days = "Days"
            case mode = "Mode"
            case years = "Years"
        }
    }

    internal struct Delete: AWSEncodableShape {
        /// The object to delete.   Directory buckets - For directory buckets, an object that's composed entirely of whitespace characters is not supported by the DeleteObjects API operation. The request will receive a 400 Bad Request error and none of the objects in the request will be deleted.
        internal let objects: [ObjectIdentifier]
        /// Element to enable quiet mode for the request. When you add this element, you must set its value to true.
        internal let quiet: Bool?

        @inlinable
        internal init(objects: [ObjectIdentifier], quiet: Bool? = nil) {
            self.objects = objects
            self.quiet = quiet
        }

        internal func validate(name: String) throws {
            try self.objects.forEach {
                try $0.validate(name: "\(name).objects[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case objects = "Object"
            case quiet = "Quiet"
        }
    }

    internal struct DeleteBucketAnalyticsConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket from which an analytics configuration is deleted.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID that identifies the analytics configuration.
        internal let id: String

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil, id: String) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketCorsRequest: AWSEncodableShape {
        /// Specifies the bucket whose cors configuration is being deleted.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketEncryptionRequest: AWSEncodableShape {
        /// The name of the bucket containing the server-side encryption configuration to delete.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  For directory buckets, this header is not supported in this API operation. If you specify this header, the request fails with the HTTP status code
        /// 501 Not Implemented.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketIntelligentTieringConfigurationRequest: AWSEncodableShape {
        /// The name of the Amazon S3 bucket whose configuration you want to modify or retrieve.
        internal let bucket: String
        /// The ID used to identify the S3 Intelligent-Tiering configuration.
        internal let id: String

        @inlinable
        internal init(bucket: String, id: String) {
            self.bucket = bucket
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.id, key: "id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketInventoryConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket containing the inventory configuration to delete.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID used to identify the inventory configuration.
        internal let id: String

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil, id: String) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketLifecycleRequest: AWSEncodableShape {
        /// The bucket name of the lifecycle to delete.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketMetadataTableConfigurationRequest: AWSEncodableShape {
        ///  The general purpose bucket that you want to remove the metadata table configuration from.
        internal let bucket: String
        ///  The expected bucket owner of the general purpose bucket that you want to remove the  metadata table configuration from.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketMetricsConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket containing the metrics configuration to delete.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID used to identify the metrics configuration. The ID has a 64 character limit and can only contain letters, numbers, periods, dashes, and underscores.
        internal let id: String

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil, id: String) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketOwnershipControlsRequest: AWSEncodableShape {
        /// The Amazon S3 bucket whose OwnershipControls you want to delete.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketPolicyRequest: AWSEncodableShape {
        /// The bucket name.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  For directory buckets, this header is not supported in this API operation. If you specify this header, the request fails with the HTTP status code
        /// 501 Not Implemented.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketReplicationRequest: AWSEncodableShape {
        ///  The bucket name.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketRequest: AWSEncodableShape {
        /// Specifies the bucket being deleted.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  For directory buckets, this header is not supported in this API operation. If you specify this header, the request fails with the HTTP status code
        /// 501 Not Implemented.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketTaggingRequest: AWSEncodableShape {
        /// The bucket that has the tag set to be removed.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteBucketWebsiteRequest: AWSEncodableShape {
        /// The bucket name for which you want to remove the website configuration.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteMarkerEntry: AWSDecodableShape {
        /// Specifies whether the object is (true) or is not (false) the latest version of an object.
        internal let isLatest: Bool?
        /// The object key.
        internal let key: String?
        /// Date and time when the object was last modified.
        internal let lastModified: Date?
        /// The account that created the delete marker.>
        internal let owner: Owner?
        /// Version ID of an object.
        internal let versionId: String?

        @inlinable
        internal init(
            isLatest: Bool? = nil, key: String? = nil, lastModified: Date? = nil, owner: Owner? = nil,
            versionId: String? = nil
        ) {
            self.isLatest = isLatest
            self.key = key
            self.lastModified = lastModified
            self.owner = owner
            self.versionId = versionId
        }

        private enum CodingKeys: String, CodingKey {
            case isLatest = "IsLatest"
            case key = "Key"
            case lastModified = "LastModified"
            case owner = "Owner"
            case versionId = "VersionId"
        }
    }

    internal struct DeleteMarkerReplication: AWSEncodableShape & AWSDecodableShape {
        /// Indicates whether to replicate delete markers.  Indicates whether to replicate delete markers.
        internal let status: DeleteMarkerReplicationStatus?

        @inlinable
        internal init(status: DeleteMarkerReplicationStatus? = nil) {
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case status = "Status"
        }
    }

    internal struct DeleteObjectOutput: AWSDecodableShape {
        /// Indicates whether the specified object version that was permanently deleted was (true) or was not (false) a delete marker before deletion. In a simple DELETE, this header indicates whether (true) or not (false) the current version of the object is a delete marker.  This functionality is not supported for directory buckets.
        internal let deleteMarker: Bool?
        internal let requestCharged: RequestCharged?
        /// Returns the version ID of the delete marker created as a result of the DELETE operation.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(deleteMarker: Bool? = nil, requestCharged: RequestCharged? = nil, versionId: String? = nil) {
            self.deleteMarker = deleteMarker
            self.requestCharged = requestCharged
            self.versionId = versionId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.deleteMarker = try response.decodeHeaderIfPresent(Bool.self, key: "x-amz-delete-marker")
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteObjectRequest: AWSEncodableShape {
        /// The bucket name of the bucket containing the object.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Indicates whether S3 Object Lock should bypass Governance-mode restrictions to process this operation. To use this header, you must have the s3:BypassGovernanceRetention permission.  This functionality is not supported for directory buckets.
        internal let bypassGovernanceRetention: Bool?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The If-Match header field makes the request method conditional on ETags. If the ETag value does not match, the operation returns a 412 Precondition Failed error. If the ETag matches or if the object doesn't exist, the operation will return a 204 Success (No  Content) response. For more information about conditional requests, see RFC 7232.  This functionality is only supported for directory buckets.
        internal let ifMatch: String?
        /// If present, the object is deleted only if its modification times matches the provided Timestamp. If the Timestamp values do not match, the operation returns a 412 Precondition Failed error. If the Timestamp matches or if the object doesn’t exist, the operation returns a 204 Success (No Content) response.  This functionality is only supported for directory buckets.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var ifMatchLastModifiedTime: Date?
        /// If present, the object is deleted only if its size matches the provided size in bytes. If the Size value does not match, the operation returns a 412 Precondition Failed error. If the Size matches or if the object doesn’t exist,  the operation returns a 204 Success (No Content) response.  This functionality is only supported for directory buckets.   You can use the If-Match, x-amz-if-match-last-modified-time and x-amz-if-match-size  conditional headers in conjunction with each-other or individually.
        internal let ifMatchSize: Int64?
        /// Key name of the object to delete.
        internal let key: String
        /// The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. Required to permanently delete a versioned object if versioning is configured with MFA delete enabled.  This functionality is not supported for directory buckets.
        internal let mfa: String?
        internal let requestPayer: RequestPayer?
        /// Version ID used to reference a specific version of the object.  For directory buckets in this API operation, only the null value of the version ID is supported.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, bypassGovernanceRetention: Bool? = nil, expectedBucketOwner: String? = nil,
            ifMatch: String? = nil, ifMatchLastModifiedTime: Date? = nil, ifMatchSize: Int64? = nil, key: String,
            mfa: String? = nil, requestPayer: RequestPayer? = nil, versionId: String? = nil
        ) {
            self.bucket = bucket
            self.bypassGovernanceRetention = bypassGovernanceRetention
            self.expectedBucketOwner = expectedBucketOwner
            self.ifMatch = ifMatch
            self.ifMatchLastModifiedTime = ifMatchLastModifiedTime
            self.ifMatchSize = ifMatchSize
            self.key = key
            self.mfa = mfa
            self.requestPayer = requestPayer
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.bypassGovernanceRetention, key: "x-amz-bypass-governance-retention")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.ifMatch, key: "If-Match")
            request.encodeHeader(self._ifMatchLastModifiedTime, key: "x-amz-if-match-last-modified-time")
            request.encodeHeader(self.ifMatchSize, key: "x-amz-if-match-size")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.mfa, key: "x-amz-mfa")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteObjectTaggingOutput: AWSDecodableShape {
        /// The versionId of the object the tag-set was removed from.
        internal let versionId: String?

        @inlinable
        internal init(versionId: String? = nil) {
            self.versionId = versionId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteObjectTaggingRequest: AWSEncodableShape {
        /// The bucket name containing the objects from which to remove the tags.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The key that identifies the object in the bucket from which to remove all tags.
        internal let key: String
        /// The versionId of the object that the tag-set will be removed from.
        internal let versionId: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil, key: String, versionId: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeleteObjectsOutput: AWSDecodableShape {
        /// Container element for a successful delete. It identifies the object that was successfully deleted.
        internal let deleted: [DeletedObject]?
        /// Container for a failed delete action that describes the object that Amazon S3 attempted to delete and the error it encountered.
        internal let errors: [Error]?
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(deleted: [DeletedObject]? = nil, errors: [Error]? = nil, requestCharged: RequestCharged? = nil) {
            self.deleted = deleted
            self.errors = errors
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.deleted = try container.decodeIfPresent([DeletedObject].self, forKey: .deleted)
            self.errors = try container.decodeIfPresent([Error].self, forKey: .errors)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: String, CodingKey {
            case deleted = "Deleted"
            case errors = "Error"
        }
    }

    internal struct DeleteObjectsRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired]
        internal static let _xmlRootNodeName: String? = "Delete"
        /// The bucket name containing the objects to delete.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Specifies whether you want to delete this object even if it has a Governance-type Object Lock in place. To use this header, you must have the s3:BypassGovernanceRetention permission.  This functionality is not supported for directory buckets.
        internal let bypassGovernanceRetention: Bool?
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum-algorithm or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For the x-amz-checksum-algorithm header, replace  algorithm with the supported algorithm from the following list:     CRC32     CRC32C     SHA1     SHA256    For more information, see Checking object integrity in the Amazon S3 User Guide. If the individual checksum value you provide through x-amz-checksum-algorithm doesn't match the checksum algorithm you set through x-amz-sdk-checksum-algorithm,  Amazon S3 ignores any provided ChecksumAlgorithm parameter and uses the checksum algorithm that matches the provided value in x-amz-checksum-algorithm . If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// Container for the request.
        internal let delete: Delete
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. Required to permanently delete a versioned object if versioning is configured with MFA delete enabled. When performing the DeleteObjects operation on an MFA delete enabled bucket, which attempts to delete the specified versioned objects, you must include an MFA token. If you don't provide an MFA token, the entire request will fail, even if there are non-versioned objects that you are trying to delete. If you provide an invalid token, whether there are versioned object keys in the request or not, the entire Multi-Object Delete request will fail. For information about MFA Delete, see  MFA Delete in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let mfa: String?
        internal let requestPayer: RequestPayer?

        @inlinable
        internal init(
            bucket: String, bypassGovernanceRetention: Bool? = nil, checksumAlgorithm: ChecksumAlgorithm? = nil,
            delete: Delete, expectedBucketOwner: String? = nil, mfa: String? = nil, requestPayer: RequestPayer? = nil
        ) {
            self.bucket = bucket
            self.bypassGovernanceRetention = bypassGovernanceRetention
            self.checksumAlgorithm = checksumAlgorithm
            self.delete = delete
            self.expectedBucketOwner = expectedBucketOwner
            self.mfa = mfa
            self.requestPayer = requestPayer
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.bypassGovernanceRetention, key: "x-amz-bypass-governance-retention")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            try container.encode(self.delete)
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.mfa, key: "x-amz-mfa")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
        }

        internal func validate(name: String) throws {
            try self.delete.validate(name: "\(name).delete")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeletePublicAccessBlockRequest: AWSEncodableShape {
        /// The Amazon S3 bucket whose PublicAccessBlock configuration you want to delete.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct DeletedObject: AWSDecodableShape {
        /// Indicates whether the specified object version that was permanently deleted was (true) or was not (false) a delete marker before deletion. In a simple DELETE, this header indicates whether (true) or not (false) the current version of the object is a delete marker.  This functionality is not supported for directory buckets.
        internal let deleteMarker: Bool?
        /// The version ID of the delete marker created as a result of the DELETE operation. If you delete a specific object version, the value returned by this header is the version ID of the object version deleted.  This functionality is not supported for directory buckets.
        internal let deleteMarkerVersionId: String?
        /// The name of the deleted object.
        internal let key: String?
        /// The version ID of the deleted object.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(
            deleteMarker: Bool? = nil, deleteMarkerVersionId: String? = nil, key: String? = nil,
            versionId: String? = nil
        ) {
            self.deleteMarker = deleteMarker
            self.deleteMarkerVersionId = deleteMarkerVersionId
            self.key = key
            self.versionId = versionId
        }

        private enum CodingKeys: String, CodingKey {
            case deleteMarker = "DeleteMarker"
            case deleteMarkerVersionId = "DeleteMarkerVersionId"
            case key = "Key"
            case versionId = "VersionId"
        }
    }

    internal struct Destination: AWSEncodableShape & AWSDecodableShape {
        /// Specify this only in a cross-account scenario (where source and destination bucket owners are not the same), and you want to change replica ownership to the Amazon Web Services account that owns the destination bucket. If this is not specified in the replication configuration, the replicas are owned by same Amazon Web Services account that owns the source object.
        internal let accessControlTranslation: AccessControlTranslation?
        /// Destination bucket owner account ID. In a cross-account scenario, if you direct Amazon S3 to change replica ownership to the Amazon Web Services account that owns the destination bucket by specifying the AccessControlTranslation property, this is the account ID of the destination bucket owner. For more information, see Replication Additional Configuration: Changing the Replica Owner in the Amazon S3 User Guide.
        internal let account: String?
        ///  The Amazon Resource Name (ARN) of the bucket where you want Amazon S3 to store the results.
        internal let bucket: String
        /// A container that provides information about encryption. If SourceSelectionCriteria is specified, you must specify this element.
        internal let encryptionConfiguration: EncryptionConfiguration?
        ///  A container specifying replication metrics-related settings enabling replication metrics and events.
        internal let metrics: Metrics?
        ///  A container specifying S3 Replication Time Control (S3 RTC), including whether S3 RTC is enabled and the time when all objects and operations on objects must be replicated. Must be specified together with a Metrics block.
        internal let replicationTime: ReplicationTime?
        ///  The storage class to use when replicating objects, such as S3 Standard or reduced redundancy. By default, Amazon S3 uses the storage class of the source object to create the object replica.  For valid values, see the StorageClass element of the PUT Bucket replication action in the Amazon S3 API Reference.
        internal let storageClass: StorageClass?

        @inlinable
        internal init(
            accessControlTranslation: AccessControlTranslation? = nil, account: String? = nil, bucket: String,
            encryptionConfiguration: EncryptionConfiguration? = nil, metrics: Metrics? = nil,
            replicationTime: ReplicationTime? = nil, storageClass: StorageClass? = nil
        ) {
            self.accessControlTranslation = accessControlTranslation
            self.account = account
            self.bucket = bucket
            self.encryptionConfiguration = encryptionConfiguration
            self.metrics = metrics
            self.replicationTime = replicationTime
            self.storageClass = storageClass
        }

        private enum CodingKeys: String, CodingKey {
            case accessControlTranslation = "AccessControlTranslation"
            case account = "Account"
            case bucket = "Bucket"
            case encryptionConfiguration = "EncryptionConfiguration"
            case metrics = "Metrics"
            case replicationTime = "ReplicationTime"
            case storageClass = "StorageClass"
        }
    }

    internal struct Encryption: AWSEncodableShape {
        /// The server-side encryption algorithm used when storing job results in Amazon S3 (for example, AES256, aws:kms).
        internal let encryptionType: ServerSideEncryption
        /// If the encryption type is aws:kms, this optional value can be used to specify the encryption context for the restore results.
        internal let kmsContext: String?
        /// If the encryption type is aws:kms, this optional value specifies the ID of the symmetric encryption customer managed key to use for encryption of job results. Amazon S3 only supports symmetric encryption KMS keys. For more information, see Asymmetric keys in KMS in the Amazon Web Services Key Management Service Developer Guide.
        internal let kmsKeyId: String?

        @inlinable
        internal init(encryptionType: ServerSideEncryption, kmsContext: String? = nil, kmsKeyId: String? = nil) {
            self.encryptionType = encryptionType
            self.kmsContext = kmsContext
            self.kmsKeyId = kmsKeyId
        }

        private enum CodingKeys: String, CodingKey {
            case encryptionType = "EncryptionType"
            case kmsContext = "KMSContext"
            case kmsKeyId = "KMSKeyId"
        }
    }

    internal struct EncryptionConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// Specifies the ID (Key ARN or Alias ARN) of the customer managed Amazon Web Services KMS key stored in Amazon Web Services Key Management Service (KMS) for the destination bucket. Amazon S3 uses this key to encrypt replica objects. Amazon S3 only supports symmetric encryption KMS keys. For more information, see Asymmetric keys in Amazon Web Services KMS in the Amazon Web Services Key Management Service Developer Guide.
        internal let replicaKmsKeyID: String?

        @inlinable
        internal init(replicaKmsKeyID: String? = nil) {
            self.replicaKmsKeyID = replicaKmsKeyID
        }

        private enum CodingKeys: String, CodingKey {
            case replicaKmsKeyID = "ReplicaKmsKeyID"
        }
    }

    internal struct EndEvent: AWSDecodableShape {
        internal init() {}
    }

    internal struct Error: AWSDecodableShape {
        /// The error code is a string that uniquely identifies an error condition. It is meant to be read and understood by programs that detect and handle errors by type. The following is a list of Amazon S3 error codes. For more information, see Error responses.      Code: AccessDenied     Description: Access Denied    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: AccountProblem    Description: There is a problem with your Amazon Web Services account that prevents the action from completing successfully. Contact Amazon Web Services Support for further assistance.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: AllAccessDisabled    Description: All access to this Amazon S3 resource has been disabled. Contact Amazon Web Services Support for further assistance.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: AmbiguousGrantByEmailAddress    Description: The email address you provided is associated with more than one account.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: AuthorizationHeaderMalformed    Description: The authorization header you provided is invalid.    HTTP Status Code: 400 Bad Request    HTTP Status Code: N/A        Code: BadDigest    Description: The Content-MD5 you specified did not match what we received.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: BucketAlreadyExists    Description: The requested bucket name is not available. The bucket namespace is shared by all users of the system. Please select a different name and try again.    HTTP Status Code: 409 Conflict    SOAP Fault Code Prefix: Client        Code: BucketAlreadyOwnedByYou    Description: The bucket you tried to create already exists, and you own it. Amazon S3 returns this error in all Amazon Web Services Regions except in the North Virginia Region. For legacy compatibility, if you re-create an existing bucket that you already own in the North Virginia Region, Amazon S3 returns 200 OK and resets the bucket access control lists (ACLs).    Code: 409 Conflict (in all Regions except the North Virginia Region)     SOAP Fault Code Prefix: Client        Code: BucketNotEmpty    Description: The bucket you tried to delete is not empty.    HTTP Status Code: 409 Conflict    SOAP Fault Code Prefix: Client        Code: CredentialsNotSupported    Description: This request does not support credentials.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: CrossLocationLoggingProhibited    Description: Cross-location logging not allowed. Buckets in one geographic location cannot log information to a bucket in another location.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: EntityTooSmall    Description: Your proposed upload is smaller than the minimum allowed object size.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: EntityTooLarge    Description: Your proposed upload exceeds the maximum allowed object size.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: ExpiredToken    Description: The provided token has expired.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: IllegalVersioningConfigurationException     Description: Indicates that the versioning configuration specified in the request is invalid.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: IncompleteBody    Description: You did not provide the number of bytes specified by the Content-Length HTTP header    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: IncorrectNumberOfFilesInPostRequest    Description: POST requires exactly one file upload per request.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InlineDataTooLarge    Description: Inline data exceeds the maximum allowed size.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InternalError    Description: We encountered an internal error. Please try again.    HTTP Status Code: 500 Internal Server Error    SOAP Fault Code Prefix: Server        Code: InvalidAccessKeyId    Description: The Amazon Web Services access key ID you provided does not exist in our records.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: InvalidAddressingHeader    Description: You must specify the Anonymous role.    HTTP Status Code: N/A    SOAP Fault Code Prefix: Client        Code: InvalidArgument    Description: Invalid Argument    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidBucketName    Description: The specified bucket is not valid.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidBucketState    Description: The request is not valid with the current state of the bucket.    HTTP Status Code: 409 Conflict    SOAP Fault Code Prefix: Client        Code: InvalidDigest    Description: The Content-MD5 you specified is not valid.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidEncryptionAlgorithmError    Description: The encryption request you specified is not valid. The valid value is AES256.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidLocationConstraint    Description: The specified location constraint is not valid. For more information about Regions, see How to Select a Region for Your Buckets.     HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidObjectState    Description: The action is not valid for the current state of the object.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: InvalidPart    Description: One or more of the specified parts could not be found. The part might not have been uploaded, or the specified entity tag might not have matched the part's entity tag.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidPartOrder    Description: The list of parts was not in ascending order. Parts list must be specified in order by part number.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidPayer    Description: All access to this object has been disabled. Please contact Amazon Web Services Support for further assistance.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: InvalidPolicyDocument    Description: The content of the form does not meet the conditions specified in the policy document.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidRange    Description: The requested range cannot be satisfied.    HTTP Status Code: 416 Requested Range Not Satisfiable    SOAP Fault Code Prefix: Client        Code: InvalidRequest    Description: Please use AWS4-HMAC-SHA256.    HTTP Status Code: 400 Bad Request    Code: N/A        Code: InvalidRequest    Description: SOAP requests must be made over an HTTPS connection.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidRequest    Description: Amazon S3 Transfer Acceleration is not supported for buckets with non-DNS compliant names.    HTTP Status Code: 400 Bad Request    Code: N/A        Code: InvalidRequest    Description: Amazon S3 Transfer Acceleration is not supported for buckets with periods (.) in their names.    HTTP Status Code: 400 Bad Request    Code: N/A        Code: InvalidRequest    Description: Amazon S3 Transfer Accelerate endpoint only supports virtual style requests.    HTTP Status Code: 400 Bad Request    Code: N/A        Code: InvalidRequest    Description: Amazon S3 Transfer Accelerate is not configured on this bucket.    HTTP Status Code: 400 Bad Request    Code: N/A        Code: InvalidRequest    Description: Amazon S3 Transfer Accelerate is disabled on this bucket.    HTTP Status Code: 400 Bad Request    Code: N/A        Code: InvalidRequest    Description: Amazon S3 Transfer Acceleration is not supported on this bucket. Contact Amazon Web Services Support for more information.    HTTP Status Code: 400 Bad Request    Code: N/A        Code: InvalidRequest    Description: Amazon S3 Transfer Acceleration cannot be enabled on this bucket. Contact Amazon Web Services Support for more information.    HTTP Status Code: 400 Bad Request    Code: N/A        Code: InvalidSecurity    Description: The provided security credentials are not valid.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: InvalidSOAPRequest    Description: The SOAP request body is invalid.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidStorageClass    Description: The storage class you specified is not valid.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidTargetBucketForLogging    Description: The target bucket for logging does not exist, is not owned by you, or does not have the appropriate grants for the log-delivery group.     HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidToken    Description: The provided token is malformed or otherwise invalid.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: InvalidURI    Description: Couldn't parse the specified URI.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: KeyTooLongError    Description: Your key is too long.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MalformedACLError    Description: The XML you provided was not well-formed or did not validate against our published schema.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MalformedPOSTRequest     Description: The body of your POST request is not well-formed multipart/form-data.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MalformedXML    Description: This happens when the user sends malformed XML (XML that doesn't conform to the published XSD) for the configuration. The error message is, "The XML you provided was not well-formed or did not validate against our published schema."     HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MaxMessageLengthExceeded    Description: Your request was too big.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MaxPostPreDataLengthExceededError    Description: Your POST request fields preceding the upload file were too large.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MetadataTooLarge    Description: Your metadata headers exceed the maximum allowed metadata size.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MethodNotAllowed    Description: The specified method is not allowed against this resource.    HTTP Status Code: 405 Method Not Allowed    SOAP Fault Code Prefix: Client        Code: MissingAttachment    Description: A SOAP attachment was expected, but none were found.    HTTP Status Code: N/A    SOAP Fault Code Prefix: Client        Code: MissingContentLength    Description: You must provide the Content-Length HTTP header.    HTTP Status Code: 411 Length Required    SOAP Fault Code Prefix: Client        Code: MissingRequestBodyError    Description: This happens when the user sends an empty XML document as a request. The error message is, "Request body is empty."     HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MissingSecurityElement    Description: The SOAP 1.1 request is missing a security element.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: MissingSecurityHeader    Description: Your request is missing a required header.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: NoLoggingStatusForKey    Description: There is no such thing as a logging status subresource for a key.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: NoSuchBucket    Description: The specified bucket does not exist.    HTTP Status Code: 404 Not Found    SOAP Fault Code Prefix: Client        Code: NoSuchBucketPolicy    Description: The specified bucket does not have a bucket policy.    HTTP Status Code: 404 Not Found    SOAP Fault Code Prefix: Client        Code: NoSuchKey    Description: The specified key does not exist.    HTTP Status Code: 404 Not Found    SOAP Fault Code Prefix: Client        Code: NoSuchLifecycleConfiguration    Description: The lifecycle configuration does not exist.     HTTP Status Code: 404 Not Found    SOAP Fault Code Prefix: Client        Code: NoSuchUpload    Description: The specified multipart upload does not exist. The upload ID might be invalid, or the multipart upload might have been aborted or completed.    HTTP Status Code: 404 Not Found    SOAP Fault Code Prefix: Client        Code: NoSuchVersion     Description: Indicates that the version ID specified in the request does not match an existing version.    HTTP Status Code: 404 Not Found    SOAP Fault Code Prefix: Client        Code: NotImplemented    Description: A header you provided implies functionality that is not implemented.    HTTP Status Code: 501 Not Implemented    SOAP Fault Code Prefix: Server        Code: NotSignedUp    Description: Your account is not signed up for the Amazon S3 service. You must sign up before you can use Amazon S3. You can sign up at the following URL: Amazon S3     HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: OperationAborted    Description: A conflicting conditional action is currently in progress against this resource. Try again.    HTTP Status Code: 409 Conflict    SOAP Fault Code Prefix: Client        Code: PermanentRedirect    Description: The bucket you are attempting to access must be addressed using the specified endpoint. Send all future requests to this endpoint.    HTTP Status Code: 301 Moved Permanently    SOAP Fault Code Prefix: Client        Code: PreconditionFailed    Description: At least one of the preconditions you specified did not hold.    HTTP Status Code: 412 Precondition Failed    SOAP Fault Code Prefix: Client        Code: Redirect    Description: Temporary redirect.    HTTP Status Code: 307 Moved Temporarily    SOAP Fault Code Prefix: Client        Code: RestoreAlreadyInProgress    Description: Object restore is already in progress.    HTTP Status Code: 409 Conflict    SOAP Fault Code Prefix: Client        Code: RequestIsNotMultiPartContent    Description: Bucket POST must be of the enclosure-type multipart/form-data.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: RequestTimeout    Description: Your socket connection to the server was not read from or written to within the timeout period.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: RequestTimeTooSkewed    Description: The difference between the request time and the server's time is too large.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: RequestTorrentOfBucketError    Description: Requesting the torrent file of a bucket is not permitted.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: SignatureDoesNotMatch    Description: The request signature we calculated does not match the signature you provided. Check your Amazon Web Services secret access key and signing method. For more information, see REST Authentication and SOAP Authentication for details.    HTTP Status Code: 403 Forbidden    SOAP Fault Code Prefix: Client        Code: ServiceUnavailable    Description: Service is unable to handle request.    HTTP Status Code: 503 Service Unavailable    SOAP Fault Code Prefix: Server        Code: SlowDown    Description: Reduce your request rate.    HTTP Status Code: 503 Slow Down    SOAP Fault Code Prefix: Server        Code: TemporaryRedirect    Description: You are being redirected to the bucket while DNS updates.    HTTP Status Code: 307 Moved Temporarily    SOAP Fault Code Prefix: Client        Code: TokenRefreshRequired    Description: The provided token must be refreshed.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: TooManyBuckets    Description: You have attempted to create more buckets than allowed.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: UnexpectedContent    Description: This request does not support content.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: UnresolvableGrantByEmailAddress    Description: The email address you provided does not match any account on record.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client        Code: UserKeyMustBeSpecified    Description: The bucket POST must contain the specified field name. If it is specified, check the order of the fields.    HTTP Status Code: 400 Bad Request    SOAP Fault Code Prefix: Client
        internal let code: String?
        /// The error key.
        internal let key: String?
        /// The error message contains a generic description of the error condition in English. It is intended for a human audience. Simple programs display the message directly to the end user if they encounter an error condition they don't know how or don't care to handle. Sophisticated programs with more exhaustive error handling and proper internationalization are more likely to ignore the error message.
        internal let message: String?
        /// The version ID of the error.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(code: String? = nil, key: String? = nil, message: String? = nil, versionId: String? = nil) {
            self.code = code
            self.key = key
            self.message = message
            self.versionId = versionId
        }

        private enum CodingKeys: String, CodingKey {
            case code = "Code"
            case key = "Key"
            case message = "Message"
            case versionId = "VersionId"
        }
    }

    internal struct ErrorDetails: AWSDecodableShape {
        ///  If the CreateBucketMetadataTableConfiguration request succeeds, but S3 Metadata was  unable to create the table, this structure contains the error code. The possible error codes and  error messages are as follows:     AccessDeniedCreatingResources - You don't have sufficient permissions to  create the required resources. Make sure that you have s3tables:CreateNamespace,  s3tables:CreateTable, s3tables:GetTable and  s3tables:PutTablePolicy permissions, and then try again. To create a new metadata  table, you must delete the metadata configuration for this bucket, and then create a new  metadata configuration.     AccessDeniedWritingToTable - Unable to write to the metadata table because of  missing resource permissions. To fix the resource policy, Amazon S3 needs to create a new  metadata table. To create a new metadata table, you must delete the metadata configuration for  this bucket, and then create a new metadata configuration.    DestinationTableNotFound - The destination table doesn't exist. To create a  new metadata table, you must delete the metadata configuration for this bucket, and then  create a new metadata configuration.    ServerInternalError - An internal error has occurred. To create a new metadata  table, you must delete the metadata configuration for this bucket, and then create a new  metadata configuration.    TableAlreadyExists - The table that you specified already exists in the table  bucket's namespace. Specify a different table name. To create a new metadata table, you must  delete the metadata configuration for this bucket, and then create a new metadata  configuration.    TableBucketNotFound - The table bucket that you specified doesn't exist in  this Amazon Web Services Region and account. Create or choose a different table bucket. To create a new  metadata table, you must delete the metadata configuration for this bucket, and then create  a new metadata configuration.
        internal let errorCode: String?
        ///  If the CreateBucketMetadataTableConfiguration request succeeds, but S3 Metadata was  unable to create the table, this structure contains the error message. The possible error codes and  error messages are as follows:     AccessDeniedCreatingResources - You don't have sufficient permissions to  create the required resources. Make sure that you have s3tables:CreateNamespace,  s3tables:CreateTable, s3tables:GetTable and  s3tables:PutTablePolicy permissions, and then try again. To create a new metadata  table, you must delete the metadata configuration for this bucket, and then create a new  metadata configuration.     AccessDeniedWritingToTable - Unable to write to the metadata table because of  missing resource permissions. To fix the resource policy, Amazon S3 needs to create a new  metadata table. To create a new metadata table, you must delete the metadata configuration for  this bucket, and then create a new metadata configuration.    DestinationTableNotFound - The destination table doesn't exist. To create a  new metadata table, you must delete the metadata configuration for this bucket, and then  create a new metadata configuration.    ServerInternalError - An internal error has occurred. To create a new metadata  table, you must delete the metadata configuration for this bucket, and then create a new  metadata configuration.    TableAlreadyExists - The table that you specified already exists in the table  bucket's namespace. Specify a different table name. To create a new metadata table, you must  delete the metadata configuration for this bucket, and then create a new metadata  configuration.    TableBucketNotFound - The table bucket that you specified doesn't exist in  this Amazon Web Services Region and account. Create or choose a different table bucket. To create a new  metadata table, you must delete the metadata configuration for this bucket, and then create  a new metadata configuration.
        internal let errorMessage: String?

        @inlinable
        internal init(errorCode: String? = nil, errorMessage: String? = nil) {
            self.errorCode = errorCode
            self.errorMessage = errorMessage
        }

        private enum CodingKeys: String, CodingKey {
            case errorCode = "ErrorCode"
            case errorMessage = "ErrorMessage"
        }
    }

    internal struct ErrorDocument: AWSEncodableShape & AWSDecodableShape {
        /// The object key name to use when a 4XX class error occurs.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let key: String

        @inlinable
        internal init(key: String) {
            self.key = key
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: String, CodingKey {
            case key = "Key"
        }
    }

    internal struct EventBridgeConfiguration: AWSEncodableShape & AWSDecodableShape {
        internal init() {}
    }

    internal struct ExistingObjectReplication: AWSEncodableShape & AWSDecodableShape {
        /// Specifies whether Amazon S3 replicates existing source bucket objects.
        internal let status: ExistingObjectReplicationStatus

        @inlinable
        internal init(status: ExistingObjectReplicationStatus) {
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case status = "Status"
        }
    }

    internal struct FilterRule: AWSEncodableShape & AWSDecodableShape {
        /// The object key name prefix or suffix identifying one or more objects to which the filtering rule applies. The maximum length is 1,024 characters. Overlapping prefixes and suffixes are not supported. For more information, see Configuring Event Notifications in the Amazon S3 User Guide.
        internal let name: FilterRuleName?
        /// The value that the filter searches for in object key names.
        internal let value: String?

        @inlinable
        internal init(name: FilterRuleName? = nil, value: String? = nil) {
            self.name = name
            self.value = value
        }

        private enum CodingKeys: String, CodingKey {
            case name = "Name"
            case value = "Value"
        }
    }

    internal struct GetBucketAccelerateConfigurationOutput: AWSDecodableShape {
        internal let requestCharged: RequestCharged?
        /// The accelerate configuration of the bucket.
        internal let status: BucketAccelerateStatus?

        @inlinable
        internal init(requestCharged: RequestCharged? = nil, status: BucketAccelerateStatus? = nil) {
            self.requestCharged = requestCharged
            self.status = status
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.status = try container.decodeIfPresent(BucketAccelerateStatus.self, forKey: .status)
        }

        private enum CodingKeys: String, CodingKey {
            case status = "Status"
        }
    }

    internal struct GetBucketAccelerateConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket for which the accelerate configuration is retrieved.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        internal let requestPayer: RequestPayer?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil, requestPayer: RequestPayer? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.requestPayer = requestPayer
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketAclOutput: AWSDecodableShape {
        internal struct _GrantsEncoding: ArrayCoderProperties { internal static let member = "Grant" }

        /// A list of grants.
        @OptionalCustomCoding<ArrayCoder<_GrantsEncoding, Grant>>
        internal var grants: [Grant]?
        /// Container for the bucket owner's display name and ID.
        internal let owner: Owner?

        @inlinable
        internal init(grants: [Grant]? = nil, owner: Owner? = nil) {
            self.grants = grants
            self.owner = owner
        }

        private enum CodingKeys: String, CodingKey {
            case grants = "AccessControlList"
            case owner = "Owner"
        }
    }

    internal struct GetBucketAclRequest: AWSEncodableShape {
        /// Specifies the S3 bucket whose ACL is being requested. When you use this API operation with an access point, provide the alias of the access point in place of the bucket name. When you use this API operation with an Object Lambda access point, provide the alias of the Object Lambda access point in place of the bucket name.
        /// If the Object Lambda access point alias in a request is not valid, the error code InvalidAccessPointAliasError is returned.
        /// For more information about InvalidAccessPointAliasError, see List of Error Codes.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketAnalyticsConfigurationOutput: AWSDecodableShape {
        /// The configuration and any analyses for the analytics filter.
        internal let analyticsConfiguration: AnalyticsConfiguration

        @inlinable
        internal init(analyticsConfiguration: AnalyticsConfiguration) {
            self.analyticsConfiguration = analyticsConfiguration
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.analyticsConfiguration = try container.decode(AnalyticsConfiguration.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketAnalyticsConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket from which an analytics configuration is retrieved.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID that identifies the analytics configuration.
        internal let id: String

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil, id: String) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketCorsOutput: AWSDecodableShape {
        /// A set of origins and methods (cross-origin access that you want to allow). You can add up to 100 rules to the configuration.
        internal let corsRules: [CORSRule]?

        @inlinable
        internal init(corsRules: [CORSRule]? = nil) {
            self.corsRules = corsRules
        }

        private enum CodingKeys: String, CodingKey {
            case corsRules = "CORSRule"
        }
    }

    internal struct GetBucketCorsRequest: AWSEncodableShape {
        /// The bucket name for which to get the cors configuration. When you use this API operation with an access point, provide the alias of the access point in place of the bucket name. When you use this API operation with an Object Lambda access point, provide the alias of the Object Lambda access point in place of the bucket name.
        /// If the Object Lambda access point alias in a request is not valid, the error code InvalidAccessPointAliasError is returned.
        /// For more information about InvalidAccessPointAliasError, see List of Error Codes.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketEncryptionOutput: AWSDecodableShape {
        internal let serverSideEncryptionConfiguration: ServerSideEncryptionConfiguration

        @inlinable
        internal init(serverSideEncryptionConfiguration: ServerSideEncryptionConfiguration) {
            self.serverSideEncryptionConfiguration = serverSideEncryptionConfiguration
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.serverSideEncryptionConfiguration = try container.decode(ServerSideEncryptionConfiguration.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketEncryptionRequest: AWSEncodableShape {
        /// The name of the bucket from which the server-side encryption configuration is retrieved.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  For directory buckets, this header is not supported in this API operation. If you specify this header, the request fails with the HTTP status code
        /// 501 Not Implemented.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketIntelligentTieringConfigurationOutput: AWSDecodableShape {
        /// Container for S3 Intelligent-Tiering configuration.
        internal let intelligentTieringConfiguration: IntelligentTieringConfiguration

        @inlinable
        internal init(intelligentTieringConfiguration: IntelligentTieringConfiguration) {
            self.intelligentTieringConfiguration = intelligentTieringConfiguration
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.intelligentTieringConfiguration = try container.decode(IntelligentTieringConfiguration.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketIntelligentTieringConfigurationRequest: AWSEncodableShape {
        /// The name of the Amazon S3 bucket whose configuration you want to modify or retrieve.
        internal let bucket: String
        /// The ID used to identify the S3 Intelligent-Tiering configuration.
        internal let id: String

        @inlinable
        internal init(bucket: String, id: String) {
            self.bucket = bucket
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.id, key: "id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketInventoryConfigurationOutput: AWSDecodableShape {
        /// Specifies the inventory configuration.
        internal let inventoryConfiguration: InventoryConfiguration

        @inlinable
        internal init(inventoryConfiguration: InventoryConfiguration) {
            self.inventoryConfiguration = inventoryConfiguration
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.inventoryConfiguration = try container.decode(InventoryConfiguration.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketInventoryConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket containing the inventory configuration to retrieve.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID used to identify the inventory configuration.
        internal let id: String

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil, id: String) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketLifecycleConfigurationOutput: AWSDecodableShape {
        /// Container for a lifecycle rule.
        internal let rules: [LifecycleRule]?
        /// Indicates which default minimum object size behavior is applied to the lifecycle configuration.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.     all_storage_classes_128K - Objects smaller than 128 KB will not transition to any storage class by default.    varies_by_storage_class - Objects smaller than 128 KB will transition to Glacier Flexible Retrieval or Glacier Deep Archive storage classes. By default, all other storage classes will prevent transitions smaller than 128 KB.    To customize the minimum object size for any transition you can add a filter that specifies a custom ObjectSizeGreaterThan or ObjectSizeLessThan in the body of your transition rule. Custom filters always take precedence over the default transition behavior.
        internal let transitionDefaultMinimumObjectSize: TransitionDefaultMinimumObjectSize?

        @inlinable
        internal init(
            rules: [LifecycleRule]? = nil, transitionDefaultMinimumObjectSize: TransitionDefaultMinimumObjectSize? = nil
        ) {
            self.rules = rules
            self.transitionDefaultMinimumObjectSize = transitionDefaultMinimumObjectSize
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.rules = try container.decodeIfPresent([LifecycleRule].self, forKey: .rules)
            self.transitionDefaultMinimumObjectSize = try response.decodeHeaderIfPresent(
                TransitionDefaultMinimumObjectSize.self, key: "x-amz-transition-default-minimum-object-size")
        }

        private enum CodingKeys: String, CodingKey {
            case rules = "Rule"
        }
    }

    internal struct GetBucketLifecycleConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket for which to get the lifecycle information.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketLocationOutput: AWSDecodableShape {
        /// Specifies the Region where the bucket resides. For a list of all the Amazon S3 supported location constraints by Region, see Regions and Endpoints. Buckets in Region us-east-1 have a LocationConstraint of null.
        internal let locationConstraint: BucketLocationConstraint?

        @inlinable
        internal init(locationConstraint: BucketLocationConstraint? = nil) {
            self.locationConstraint = locationConstraint
        }

        private enum CodingKeys: String, CodingKey {
            case locationConstraint = "LocationConstraint"
        }
    }

    internal struct GetBucketLocationRequest: AWSEncodableShape {
        /// The name of the bucket for which to get the location. When you use this API operation with an access point, provide the alias of the access point in place of the bucket name. When you use this API operation with an Object Lambda access point, provide the alias of the Object Lambda access point in place of the bucket name.
        /// If the Object Lambda access point alias in a request is not valid, the error code InvalidAccessPointAliasError is returned.
        /// For more information about InvalidAccessPointAliasError, see List of Error Codes.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketLoggingOutput: AWSDecodableShape {
        internal let loggingEnabled: LoggingEnabled?

        @inlinable
        internal init(loggingEnabled: LoggingEnabled? = nil) {
            self.loggingEnabled = loggingEnabled
        }

        private enum CodingKeys: String, CodingKey {
            case loggingEnabled = "LoggingEnabled"
        }
    }

    internal struct GetBucketLoggingRequest: AWSEncodableShape {
        /// The bucket name for which to get the logging information.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketMetadataTableConfigurationOutput: AWSDecodableShape {
        ///  The metadata table configuration for the general purpose bucket.
        internal let getBucketMetadataTableConfigurationResult: GetBucketMetadataTableConfigurationResult

        @inlinable
        internal init(getBucketMetadataTableConfigurationResult: GetBucketMetadataTableConfigurationResult) {
            self.getBucketMetadataTableConfigurationResult = getBucketMetadataTableConfigurationResult
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.getBucketMetadataTableConfigurationResult = try container.decode(
                GetBucketMetadataTableConfigurationResult.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketMetadataTableConfigurationRequest: AWSEncodableShape {
        ///  The general purpose bucket that contains the metadata table configuration that you want to retrieve.
        internal let bucket: String
        ///  The expected owner of the general purpose bucket that you want to retrieve the metadata table configuration from.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketMetadataTableConfigurationResult: AWSDecodableShape {
        ///  If the CreateBucketMetadataTableConfiguration request succeeds, but S3 Metadata was  unable to create the table, this structure contains the error code and error message.
        internal let error: ErrorDetails?
        ///  The metadata table configuration for a general purpose bucket.
        internal let metadataTableConfigurationResult: MetadataTableConfigurationResult
        ///  The status of the metadata table. The status values are:     CREATING - The metadata table is in the process of being created in the  specified table bucket.    ACTIVE - The metadata table has been created successfully and records  are being delivered to the table.     FAILED - Amazon S3 is unable to create the metadata table, or Amazon S3 is unable to deliver  records. See ErrorDetails for details.
        internal let status: String

        @inlinable
        internal init(
            error: ErrorDetails? = nil, metadataTableConfigurationResult: MetadataTableConfigurationResult,
            status: String
        ) {
            self.error = error
            self.metadataTableConfigurationResult = metadataTableConfigurationResult
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case error = "Error"
            case metadataTableConfigurationResult = "MetadataTableConfigurationResult"
            case status = "Status"
        }
    }

    internal struct GetBucketMetricsConfigurationOutput: AWSDecodableShape {
        /// Specifies the metrics configuration.
        internal let metricsConfiguration: MetricsConfiguration

        @inlinable
        internal init(metricsConfiguration: MetricsConfiguration) {
            self.metricsConfiguration = metricsConfiguration
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.metricsConfiguration = try container.decode(MetricsConfiguration.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketMetricsConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket containing the metrics configuration to retrieve.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID used to identify the metrics configuration. The ID has a 64 character limit and can only contain letters, numbers, periods, dashes, and underscores.
        internal let id: String

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil, id: String) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketNotificationConfigurationRequest: AWSEncodableShape {
        /// The name of the bucket for which to get the notification configuration. When you use this API operation with an access point, provide the alias of the access point in place of the bucket name. When you use this API operation with an Object Lambda access point, provide the alias of the Object Lambda access point in place of the bucket name.
        /// If the Object Lambda access point alias in a request is not valid, the error code InvalidAccessPointAliasError is returned.
        /// For more information about InvalidAccessPointAliasError, see List of Error Codes.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketOwnershipControlsOutput: AWSDecodableShape {
        /// The OwnershipControls (BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter) currently in effect for this Amazon S3 bucket.
        internal let ownershipControls: OwnershipControls

        @inlinable
        internal init(ownershipControls: OwnershipControls) {
            self.ownershipControls = ownershipControls
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.ownershipControls = try container.decode(OwnershipControls.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketOwnershipControlsRequest: AWSEncodableShape {
        /// The name of the Amazon S3 bucket whose OwnershipControls you want to retrieve.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketPolicyOutput: AWSDecodableShape {
        /// The bucket policy as a JSON document.
        internal let policy: String

        @inlinable
        internal init(policy: String) {
            self.policy = policy
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.policy = try container.decode(String.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketPolicyRequest: AWSEncodableShape {
        /// The bucket name to get the bucket policy for.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide   Access points - When you use this API operation with an access point, provide the alias of the access point in place of the bucket name.  Object Lambda access points - When you use this API operation with an Object Lambda access point, provide the alias of the Object Lambda access point in place of the bucket name.
        /// If the Object Lambda access point alias in a request is not valid, the error code InvalidAccessPointAliasError is returned.
        /// For more information about InvalidAccessPointAliasError, see List of Error Codes.  Access points and Object Lambda access points are not supported by directory buckets.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  For directory buckets, this header is not supported in this API operation. If you specify this header, the request fails with the HTTP status code
        /// 501 Not Implemented.
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketPolicyStatusOutput: AWSDecodableShape {
        /// The policy status for the specified bucket.
        internal let policyStatus: PolicyStatus

        @inlinable
        internal init(policyStatus: PolicyStatus) {
            self.policyStatus = policyStatus
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.policyStatus = try container.decode(PolicyStatus.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketPolicyStatusRequest: AWSEncodableShape {
        /// The name of the Amazon S3 bucket whose policy status you want to retrieve.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketReplicationOutput: AWSDecodableShape {
        internal let replicationConfiguration: ReplicationConfiguration

        @inlinable
        internal init(replicationConfiguration: ReplicationConfiguration) {
            self.replicationConfiguration = replicationConfiguration
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.replicationConfiguration = try container.decode(ReplicationConfiguration.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketReplicationRequest: AWSEncodableShape {
        /// The bucket name for which to get the replication information.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketRequestPaymentOutput: AWSDecodableShape {
        /// Specifies who pays for the download and request fees.
        internal let payer: Payer?

        @inlinable
        internal init(payer: Payer? = nil) {
            self.payer = payer
        }

        private enum CodingKeys: String, CodingKey {
            case payer = "Payer"
        }
    }

    internal struct GetBucketRequestPaymentRequest: AWSEncodableShape {
        /// The name of the bucket for which to get the payment request configuration
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketTaggingOutput: AWSDecodableShape {
        internal struct _TagSetEncoding: ArrayCoderProperties { internal static let member = "Tag" }

        /// Contains the tag set.
        @CustomCoding<ArrayCoder<_TagSetEncoding, Tag>>
        internal var tagSet: [Tag]

        @inlinable
        internal init(tagSet: [Tag]) {
            self.tagSet = tagSet
        }

        private enum CodingKeys: String, CodingKey {
            case tagSet = "TagSet"
        }
    }

    internal struct GetBucketTaggingRequest: AWSEncodableShape {
        /// The name of the bucket for which to get the tagging information.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketVersioningOutput: AWSDecodableShape {
        /// Specifies whether MFA delete is enabled in the bucket versioning configuration. This element is only returned if the bucket has been configured with MFA delete. If the bucket has never been so configured, this element is not returned.
        internal let mfaDelete: MFADeleteStatus?
        /// The versioning state of the bucket.
        internal let status: BucketVersioningStatus?

        @inlinable
        internal init(mfaDelete: MFADeleteStatus? = nil, status: BucketVersioningStatus? = nil) {
            self.mfaDelete = mfaDelete
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case mfaDelete = "MfaDelete"
            case status = "Status"
        }
    }

    internal struct GetBucketVersioningRequest: AWSEncodableShape {
        /// The name of the bucket for which to get the versioning information.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetBucketWebsiteOutput: AWSDecodableShape {
        internal struct _RoutingRulesEncoding: ArrayCoderProperties { internal static let member = "RoutingRule" }

        /// The object key name of the website error document to use for 4XX class errors.
        internal let errorDocument: ErrorDocument?
        /// The name of the index document for the website (for example index.html).
        internal let indexDocument: IndexDocument?
        /// Specifies the redirect behavior of all requests to a website endpoint of an Amazon S3 bucket.
        internal let redirectAllRequestsTo: RedirectAllRequestsTo?
        /// Rules that define when a redirect is applied and the redirect behavior.
        @OptionalCustomCoding<ArrayCoder<_RoutingRulesEncoding, RoutingRule>>
        internal var routingRules: [RoutingRule]?

        @inlinable
        internal init(
            errorDocument: ErrorDocument? = nil, indexDocument: IndexDocument? = nil,
            redirectAllRequestsTo: RedirectAllRequestsTo? = nil, routingRules: [RoutingRule]? = nil
        ) {
            self.errorDocument = errorDocument
            self.indexDocument = indexDocument
            self.redirectAllRequestsTo = redirectAllRequestsTo
            self.routingRules = routingRules
        }

        private enum CodingKeys: String, CodingKey {
            case errorDocument = "ErrorDocument"
            case indexDocument = "IndexDocument"
            case redirectAllRequestsTo = "RedirectAllRequestsTo"
            case routingRules = "RoutingRules"
        }
    }

    internal struct GetBucketWebsiteRequest: AWSEncodableShape {
        /// The bucket name for which to get the website configuration.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectAclOutput: AWSDecodableShape {
        internal struct _GrantsEncoding: ArrayCoderProperties { internal static let member = "Grant" }

        /// A list of grants.
        @OptionalCustomCoding<ArrayCoder<_GrantsEncoding, Grant>>
        internal var grants: [Grant]?
        ///  Container for the bucket owner's display name and ID.
        internal let owner: Owner?
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(grants: [Grant]? = nil, owner: Owner? = nil, requestCharged: RequestCharged? = nil) {
            self.grants = grants
            self.owner = owner
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.grants = try container.decode(
                OptionalCustomCoding<ArrayCoder<_GrantsEncoding, Grant>>.self, forKey: .grants
            ).wrappedValue
            self.owner = try container.decodeIfPresent(Owner.self, forKey: .owner)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: String, CodingKey {
            case grants = "AccessControlList"
            case owner = "Owner"
        }
    }

    internal struct GetObjectAclRequest: AWSEncodableShape {
        /// The bucket name that contains the object for which to get the ACL information.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The key of the object for which to get the ACL information.
        internal let key: String
        internal let requestPayer: RequestPayer?
        /// Version ID used to reference a specific version of the object.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, key: String, requestPayer: RequestPayer? = nil,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.requestPayer = requestPayer
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectAttributesOutput: AWSDecodableShape {
        /// The checksum or digest of the object.
        internal let checksum: Checksum?
        /// Specifies whether the object retrieved was (true) or was not (false) a delete marker. If false, this response header does not appear in the response.  This functionality is not supported for directory buckets.
        internal let deleteMarker: Bool?
        /// An ETag is an opaque identifier assigned by a web server to a specific version of a resource found at a URL.
        internal let eTag: String?
        /// Date and time when the object was last modified.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var lastModified: Date?
        /// A collection of parts associated with a multipart upload.
        internal let objectParts: GetObjectAttributesParts?
        /// The size of the object in bytes.
        internal let objectSize: Int64?
        internal let requestCharged: RequestCharged?
        /// Provides the storage class information of the object. Amazon S3 returns this header for all objects except for S3 Standard storage class objects. For more information, see Storage Classes.   Directory buckets - Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let storageClass: StorageClass?
        /// The version ID of the object.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(
            checksum: Checksum? = nil, deleteMarker: Bool? = nil, eTag: String? = nil, lastModified: Date? = nil,
            objectParts: GetObjectAttributesParts? = nil, objectSize: Int64? = nil,
            requestCharged: RequestCharged? = nil, storageClass: StorageClass? = nil, versionId: String? = nil
        ) {
            self.checksum = checksum
            self.deleteMarker = deleteMarker
            self.eTag = eTag
            self.lastModified = lastModified
            self.objectParts = objectParts
            self.objectSize = objectSize
            self.requestCharged = requestCharged
            self.storageClass = storageClass
            self.versionId = versionId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.checksum = try container.decodeIfPresent(Checksum.self, forKey: .checksum)
            self.deleteMarker = try response.decodeHeaderIfPresent(Bool.self, key: "x-amz-delete-marker")
            self.eTag = try container.decodeIfPresent(String.self, forKey: .eTag)
            self.lastModified = try response.decodeHeaderIfPresent(Date.self, key: "Last-Modified")
            self.objectParts = try container.decodeIfPresent(GetObjectAttributesParts.self, forKey: .objectParts)
            self.objectSize = try container.decodeIfPresent(Int64.self, forKey: .objectSize)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.storageClass = try container.decodeIfPresent(StorageClass.self, forKey: .storageClass)
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
        }

        private enum CodingKeys: String, CodingKey {
            case checksum = "Checksum"
            case eTag = "ETag"
            case objectParts = "ObjectParts"
            case objectSize = "ObjectSize"
            case storageClass = "StorageClass"
        }
    }

    internal struct GetObjectAttributesParts: AWSDecodableShape {
        /// Indicates whether the returned list of parts is truncated. A value of true indicates that the list was truncated. A list can be truncated if the number of parts exceeds the limit returned in the MaxParts element.
        internal let isTruncated: Bool?
        /// The maximum number of parts allowed in the response.
        internal let maxParts: Int?
        /// When a list is truncated, this element specifies the last part in the list, as well as the value to use for the PartNumberMarker request parameter in a subsequent request.
        internal let nextPartNumberMarker: String?
        /// The marker for the current part.
        internal let partNumberMarker: String?
        /// A container for elements related to a particular part. A response can contain zero or more Parts elements.     General purpose buckets - For GetObjectAttributes, if a additional checksum (including x-amz-checksum-crc32, x-amz-checksum-crc32c, x-amz-checksum-sha1, or x-amz-checksum-sha256) isn't applied to the object specified in the request, the response doesn't return Part.    Directory buckets - For GetObjectAttributes, no matter whether a additional checksum is applied to the object specified in the request, the response returns Part.
        internal let parts: [ObjectPart]?
        /// The total number of parts.
        internal let totalPartsCount: Int?

        @inlinable
        internal init(
            isTruncated: Bool? = nil, maxParts: Int? = nil, nextPartNumberMarker: String? = nil,
            partNumberMarker: String? = nil, parts: [ObjectPart]? = nil, totalPartsCount: Int? = nil
        ) {
            self.isTruncated = isTruncated
            self.maxParts = maxParts
            self.nextPartNumberMarker = nextPartNumberMarker
            self.partNumberMarker = partNumberMarker
            self.parts = parts
            self.totalPartsCount = totalPartsCount
        }

        private enum CodingKeys: String, CodingKey {
            case isTruncated = "IsTruncated"
            case maxParts = "MaxParts"
            case nextPartNumberMarker = "NextPartNumberMarker"
            case partNumberMarker = "PartNumberMarker"
            case parts = "Part"
            case totalPartsCount = "PartsCount"
        }
    }

    internal struct GetObjectAttributesRequest: AWSEncodableShape {
        /// The name of the bucket that contains the object.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The object key.
        internal let key: String
        /// Sets the maximum number of parts to return.
        internal let maxParts: Int?
        /// Specifies the fields at the root level that you want returned in the response. Fields that you do not specify are not returned.
        internal let objectAttributes: [ObjectAttributes]
        /// Specifies the part after which listing should begin. Only parts with higher part numbers will be listed.
        internal let partNumberMarker: String?
        internal let requestPayer: RequestPayer?
        /// Specifies the algorithm to use when encrypting the object (for example, AES256).  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header.  This functionality is not supported for directory buckets.
        internal let sseCustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// The version ID used to reference a specific version of the object.  S3 Versioning isn't enabled and supported for directory buckets. For this API operation, only the null value of the version ID is supported by directory buckets. You can only specify null to the versionId query parameter in the request.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, key: String, maxParts: Int? = nil,
            objectAttributes: [ObjectAttributes], partNumberMarker: String? = nil, requestPayer: RequestPayer? = nil,
            sseCustomerAlgorithm: String? = nil, sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.maxParts = maxParts
            self.objectAttributes = objectAttributes
            self.partNumberMarker = partNumberMarker
            self.requestPayer = requestPayer
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.maxParts, key: "x-amz-max-parts")
            request.encodeHeader(self.objectAttributes, key: "x-amz-object-attributes")
            request.encodeHeader(self.partNumberMarker, key: "x-amz-part-number-marker")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectLegalHoldOutput: AWSDecodableShape {
        /// The current legal hold status for the specified object.
        internal let legalHold: ObjectLockLegalHold

        @inlinable
        internal init(legalHold: ObjectLockLegalHold) {
            self.legalHold = legalHold
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.legalHold = try container.decode(ObjectLockLegalHold.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectLegalHoldRequest: AWSEncodableShape {
        /// The bucket name containing the object whose legal hold status you want to retrieve.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The key name for the object whose legal hold status you want to retrieve.
        internal let key: String
        internal let requestPayer: RequestPayer?
        /// The version ID of the object whose legal hold status you want to retrieve.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, key: String, requestPayer: RequestPayer? = nil,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.requestPayer = requestPayer
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectLockConfigurationOutput: AWSDecodableShape {
        /// The specified bucket's Object Lock configuration.
        internal let objectLockConfiguration: ObjectLockConfiguration

        @inlinable
        internal init(objectLockConfiguration: ObjectLockConfiguration) {
            self.objectLockConfiguration = objectLockConfiguration
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.objectLockConfiguration = try container.decode(ObjectLockConfiguration.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectLockConfigurationRequest: AWSEncodableShape {
        /// The bucket whose Object Lock configuration you want to retrieve.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectOutput: AWSDecodableShape {
        internal static let _options: AWSShapeOptions = [.rawPayload]
        /// Indicates that a range of bytes was specified in the request.
        internal let acceptRanges: String?
        /// Object data.
        internal let body: AWSHTTPBody
        /// Indicates whether the object uses an S3 Bucket Key for server-side encryption with Key Management Service (KMS) keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// Specifies caching behavior along the request/reply chain.
        internal let cacheControl: String?
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. For more information, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. For more information, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. For more information, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. For more information, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Specifies presentational information for the object.
        internal let contentDisposition: String?
        /// Indicates what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.
        internal let contentEncoding: String?
        /// The language the content is in.
        internal let contentLanguage: String?
        /// Size of the body in bytes.
        internal let contentLength: Int64?
        /// The portion of the object returned in the response.
        internal let contentRange: String?
        /// A standard MIME type describing the format of the object data.
        internal let contentType: String?
        /// Indicates whether the object retrieved was (true) or was not (false) a Delete Marker. If false, this response header does not appear in the response.    If the current version of the object is a delete marker, Amazon S3 behaves as if the object was deleted and includes x-amz-delete-marker: true in the response.   If the specified version in the request is a delete marker, the response returns a 405 Method Not Allowed error and the Last-Modified: timestamp response header.
        internal let deleteMarker: Bool?
        /// An entity tag (ETag) is an opaque identifier assigned by a web server to a specific version of a resource found at a URL.
        internal let eTag: String?
        /// If the object expiration is configured (see  PutBucketLifecycleConfiguration ), the response includes this header. It includes the expiry-date and rule-id key-value pairs providing object expiration information. The value of the rule-id is URL-encoded.  Object expiration information is not returned in directory buckets and this header returns the value "NotImplemented" in all responses for directory buckets.
        internal let expiration: String?
        /// The date and time at which the object is no longer cacheable.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var expires: Date?
        /// Date and time when the object was last modified.  General purpose buckets  - When you specify a versionId of the object in your request, if the specified version in the request is a delete marker, the response returns a 405 Method Not Allowed error and the Last-Modified: timestamp response header.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var lastModified: Date?
        /// A map of metadata to store with the object in S3.
        internal let metadata: [String: String]?
        /// This is set to the number of metadata entries not returned in the headers that are prefixed with x-amz-meta-. This can happen if you create metadata using an API like SOAP that supports more flexible metadata than the REST API. For example, using SOAP, you can create metadata whose values are not legal HTTP headers.  This functionality is not supported for directory buckets.
        internal let missingMeta: Int?
        /// Indicates whether this object has an active legal hold. This field is only returned if you have permission to view an object's legal hold status.   This functionality is not supported for directory buckets.
        internal let objectLockLegalHoldStatus: ObjectLockLegalHoldStatus?
        /// The Object Lock mode that's currently in place for this object.  This functionality is not supported for directory buckets.
        internal let objectLockMode: ObjectLockMode?
        /// The date and time when this object's Object Lock will expire.  This functionality is not supported for directory buckets.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var objectLockRetainUntilDate: Date?
        /// The count of parts this object has. This value is only returned if you specify partNumber in your request and the object was uploaded as a multipart upload.
        internal let partsCount: Int?
        /// Amazon S3 can return this if your request involves a bucket that is either a source or destination in a replication rule.  This functionality is not supported for directory buckets.
        internal let replicationStatus: ReplicationStatus?
        internal let requestCharged: RequestCharged?
        /// Provides information about object restoration action and expiration time of the restored object copy.  This functionality is not supported for directory buckets. Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let restore: String?
        /// The server-side encryption algorithm used when you store this object in Amazon S3.
        internal let serverSideEncryption: ServerSideEncryption?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to confirm the encryption algorithm that's used.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide the round-trip message integrity verification of the customer-provided encryption key.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// If present, indicates the ID of the KMS key that was used for object encryption.
        internal let ssekmsKeyId: String?
        /// Provides storage class information of the object. Amazon S3 returns this header for all objects except for S3 Standard storage class objects.   Directory buckets  - Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let storageClass: StorageClass?
        /// The number of tags, if any, on the object, when you have the relevant permission to read object tags. You can use GetObjectTagging to retrieve the tag set associated with an object.  This functionality is not supported for directory buckets.
        internal let tagCount: Int?
        /// Version ID of the object.  This functionality is not supported for directory buckets.
        internal let versionId: String?
        /// If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata.  This functionality is not supported for directory buckets.
        internal let websiteRedirectLocation: String?

        @inlinable
        internal init(
            acceptRanges: String? = nil, body: AWSHTTPBody, bucketKeyEnabled: Bool? = nil, cacheControl: String? = nil,
            checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil, contentDisposition: String? = nil, contentEncoding: String? = nil,
            contentLanguage: String? = nil, contentLength: Int64? = nil, contentRange: String? = nil,
            contentType: String? = nil, deleteMarker: Bool? = nil, eTag: String? = nil, expiration: String? = nil,
            expires: Date? = nil, lastModified: Date? = nil, metadata: [String: String]? = nil, missingMeta: Int? = nil,
            objectLockLegalHoldStatus: ObjectLockLegalHoldStatus? = nil, objectLockMode: ObjectLockMode? = nil,
            objectLockRetainUntilDate: Date? = nil, partsCount: Int? = nil, replicationStatus: ReplicationStatus? = nil,
            requestCharged: RequestCharged? = nil, restore: String? = nil,
            serverSideEncryption: ServerSideEncryption? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKeyMD5: String? = nil, ssekmsKeyId: String? = nil, storageClass: StorageClass? = nil,
            tagCount: Int? = nil, versionId: String? = nil, websiteRedirectLocation: String? = nil
        ) {
            self.acceptRanges = acceptRanges
            self.body = body
            self.bucketKeyEnabled = bucketKeyEnabled
            self.cacheControl = cacheControl
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.contentDisposition = contentDisposition
            self.contentEncoding = contentEncoding
            self.contentLanguage = contentLanguage
            self.contentLength = contentLength
            self.contentRange = contentRange
            self.contentType = contentType
            self.deleteMarker = deleteMarker
            self.eTag = eTag
            self.expiration = expiration
            self.expires = expires
            self.lastModified = lastModified
            self.metadata = metadata
            self.missingMeta = missingMeta
            self.objectLockLegalHoldStatus = objectLockLegalHoldStatus
            self.objectLockMode = objectLockMode
            self.objectLockRetainUntilDate = objectLockRetainUntilDate
            self.partsCount = partsCount
            self.replicationStatus = replicationStatus
            self.requestCharged = requestCharged
            self.restore = restore
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsKeyId = ssekmsKeyId
            self.storageClass = storageClass
            self.tagCount = tagCount
            self.versionId = versionId
            self.websiteRedirectLocation = websiteRedirectLocation
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.singleValueContainer()
            self.acceptRanges = try response.decodeHeaderIfPresent(String.self, key: "accept-ranges")
            self.body = try container.decode(AWSHTTPBody.self)
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.cacheControl = try response.decodeHeaderIfPresent(String.self, key: "Cache-Control")
            self.checksumCRC32 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-crc32")
            self.checksumCRC32C = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-crc32c")
            self.checksumSHA1 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-sha1")
            self.checksumSHA256 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-sha256")
            self.contentDisposition = try response.decodeHeaderIfPresent(String.self, key: "Content-Disposition")
            self.contentEncoding = try response.decodeHeaderIfPresent(String.self, key: "Content-Encoding")
            self.contentLanguage = try response.decodeHeaderIfPresent(String.self, key: "Content-Language")
            self.contentLength = try response.decodeHeaderIfPresent(Int64.self, key: "Content-Length")
            self.contentRange = try response.decodeHeaderIfPresent(String.self, key: "Content-Range")
            self.contentType = try response.decodeHeaderIfPresent(String.self, key: "Content-Type")
            self.deleteMarker = try response.decodeHeaderIfPresent(Bool.self, key: "x-amz-delete-marker")
            self.eTag = try response.decodeHeaderIfPresent(String.self, key: "ETag")
            self.expiration = try response.decodeHeaderIfPresent(String.self, key: "x-amz-expiration")
            self.expires = try response.decodeHeaderIfPresent(Date.self, key: "Expires")
            self.lastModified = try response.decodeHeaderIfPresent(Date.self, key: "Last-Modified")
            self.metadata = try response.decodeHeaderIfPresent([String: String].self, key: "x-amz-meta-")
            self.missingMeta = try response.decodeHeaderIfPresent(Int.self, key: "x-amz-missing-meta")
            self.objectLockLegalHoldStatus = try response.decodeHeaderIfPresent(
                ObjectLockLegalHoldStatus.self, key: "x-amz-object-lock-legal-hold")
            self.objectLockMode = try response.decodeHeaderIfPresent(ObjectLockMode.self, key: "x-amz-object-lock-mode")
            self.objectLockRetainUntilDate = try response.decodeHeaderIfPresent(
                Date.self, key: "x-amz-object-lock-retain-until-date")
            self.partsCount = try response.decodeHeaderIfPresent(Int.self, key: "x-amz-mp-parts-count")
            self.replicationStatus = try response.decodeHeaderIfPresent(
                ReplicationStatus.self, key: "x-amz-replication-status")
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.restore = try response.decodeHeaderIfPresent(String.self, key: "x-amz-restore")
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.sseCustomerAlgorithm = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-algorithm")
            self.sseCustomerKeyMD5 = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-key-MD5")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
            self.storageClass = try response.decodeHeaderIfPresent(StorageClass.self, key: "x-amz-storage-class")
            self.tagCount = try response.decodeHeaderIfPresent(Int.self, key: "x-amz-tagging-count")
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
            self.websiteRedirectLocation = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-website-redirect-location")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader]
        /// The bucket name containing the object.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Object Lambda access points - When you use this action with an Object Lambda access point, you must direct requests to the Object Lambda access point hostname. The Object Lambda access point hostname takes the form AccessPointName-AccountId.s3-object-lambda.Region.amazonaws.com.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// To retrieve the checksum, this mode must be enabled.  General purpose buckets - In addition, if you enable checksum mode and the object is uploaded with a checksum and encrypted with an Key Management Service (KMS) key, you must have permission to use the kms:Decrypt action to retrieve the checksum.
        internal let checksumMode: ChecksumMode?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Return the object only if its entity tag (ETag) is the same as the one specified in this header; otherwise, return a 412 Precondition Failed error. If both of the If-Match and If-Unmodified-Since headers are present in the request as follows: If-Match condition evaluates to true, and; If-Unmodified-Since condition evaluates to false; then, S3 returns 200 OK and the data requested.  For more information about conditional requests, see RFC 7232.
        internal let ifMatch: String?
        /// Return the object only if it has been modified since the specified time; otherwise, return a 304 Not Modified error. If both of the If-None-Match and If-Modified-Since headers are present in the request as follows: If-None-Match condition evaluates to false, and; If-Modified-Since condition evaluates to true; then, S3 returns 304 Not Modified status code. For more information about conditional requests, see RFC 7232.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var ifModifiedSince: Date?
        /// Return the object only if its entity tag (ETag) is different from the one specified in this header; otherwise, return a 304 Not Modified error. If both of the If-None-Match and If-Modified-Since headers are present in the request as follows: If-None-Match condition evaluates to false, and; If-Modified-Since condition evaluates to true; then, S3 returns 304 Not Modified HTTP status code. For more information about conditional requests, see RFC 7232.
        internal let ifNoneMatch: String?
        /// Return the object only if it has not been modified since the specified time; otherwise, return a 412 Precondition Failed error. If both of the If-Match and If-Unmodified-Since headers are present in the request as follows: If-Match condition evaluates to true, and; If-Unmodified-Since condition evaluates to false; then, S3 returns 200 OK and the data requested.  For more information about conditional requests, see RFC 7232.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var ifUnmodifiedSince: Date?
        /// Key of the object to get.
        internal let key: String
        /// Part number of the object being read. This is a positive integer between 1 and 10,000. Effectively performs a 'ranged' GET request for the part specified. Useful for downloading just a part of an object.
        internal let partNumber: Int?
        /// Downloads the specified byte range of an object. For more information about the HTTP Range header, see https://www.rfc-editor.org/rfc/rfc9110.html#name-range.  Amazon S3 doesn't support retrieving multiple ranges of data per GET request.
        internal let range: String?
        internal let requestPayer: RequestPayer?
        /// Sets the Cache-Control header of the response.
        internal let responseCacheControl: String?
        /// Sets the Content-Disposition header of the response.
        internal let responseContentDisposition: String?
        /// Sets the Content-Encoding header of the response.
        internal let responseContentEncoding: String?
        /// Sets the Content-Language header of the response.
        internal let responseContentLanguage: String?
        /// Sets the Content-Type header of the response.
        internal let responseContentType: String?
        /// Sets the Expires header of the response.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var responseExpires: Date?
        /// Specifies the algorithm to use when decrypting the object (for example, AES256). If you encrypt an object by using server-side encryption with customer-provided encryption keys (SSE-C) when you store the object in Amazon S3, then when you GET the object, you must use the following headers:    x-amz-server-side-encryption-customer-algorithm     x-amz-server-side-encryption-customer-key     x-amz-server-side-encryption-customer-key-MD5    For more information about SSE-C, see Server-Side Encryption (Using Customer-Provided Encryption Keys) in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key that you originally provided for Amazon S3 to encrypt the data before storing it. This value is used to decrypt the object when recovering it and must match the one used when storing the data. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header. If you encrypt an object by using server-side encryption with customer-provided encryption keys (SSE-C) when you store the object in Amazon S3, then when you GET the object, you must use the following headers:    x-amz-server-side-encryption-customer-algorithm     x-amz-server-side-encryption-customer-key     x-amz-server-side-encryption-customer-key-MD5    For more information about SSE-C, see Server-Side Encryption (Using Customer-Provided Encryption Keys) in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the customer-provided encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error. If you encrypt an object by using server-side encryption with customer-provided encryption keys (SSE-C) when you store the object in Amazon S3, then when you GET the object, you must use the following headers:    x-amz-server-side-encryption-customer-algorithm     x-amz-server-side-encryption-customer-key     x-amz-server-side-encryption-customer-key-MD5    For more information about SSE-C, see Server-Side Encryption (Using Customer-Provided Encryption Keys) in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// Version ID used to reference a specific version of the object. By default, the GetObject operation returns the current version of an object. To return a different version, use the versionId subresource.    If you include a versionId in your request header, you must have the s3:GetObjectVersion permission to access a specific version of an object. The s3:GetObject permission is not required in this scenario.   If you request the current version of an object without a specific versionId in the request header, only the s3:GetObject permission is required. The s3:GetObjectVersion permission is not required in this scenario.    Directory buckets - S3 Versioning isn't enabled and supported for directory buckets. For this API operation, only the null value of the version ID is supported by directory buckets. You can only specify null to the versionId query parameter in the request.    For more information about versioning, see PutBucketVersioning.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, checksumMode: ChecksumMode? = nil, expectedBucketOwner: String? = nil,
            ifMatch: String? = nil, ifModifiedSince: Date? = nil, ifNoneMatch: String? = nil,
            ifUnmodifiedSince: Date? = nil, key: String, partNumber: Int? = nil, range: String? = nil,
            requestPayer: RequestPayer? = nil, responseCacheControl: String? = nil,
            responseContentDisposition: String? = nil, responseContentEncoding: String? = nil,
            responseContentLanguage: String? = nil, responseContentType: String? = nil, responseExpires: Date? = nil,
            sseCustomerAlgorithm: String? = nil, sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.checksumMode = checksumMode
            self.expectedBucketOwner = expectedBucketOwner
            self.ifMatch = ifMatch
            self.ifModifiedSince = ifModifiedSince
            self.ifNoneMatch = ifNoneMatch
            self.ifUnmodifiedSince = ifUnmodifiedSince
            self.key = key
            self.partNumber = partNumber
            self.range = range
            self.requestPayer = requestPayer
            self.responseCacheControl = responseCacheControl
            self.responseContentDisposition = responseContentDisposition
            self.responseContentEncoding = responseContentEncoding
            self.responseContentLanguage = responseContentLanguage
            self.responseContentType = responseContentType
            self.responseExpires = responseExpires
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumMode, key: "x-amz-checksum-mode")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.ifMatch, key: "If-Match")
            request.encodeHeader(self._ifModifiedSince, key: "If-Modified-Since")
            request.encodeHeader(self.ifNoneMatch, key: "If-None-Match")
            request.encodeHeader(self._ifUnmodifiedSince, key: "If-Unmodified-Since")
            request.encodePath(self.key, key: "Key")
            request.encodeQuery(self.partNumber, key: "partNumber")
            request.encodeHeader(self.range, key: "Range")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.responseCacheControl, key: "response-cache-control")
            request.encodeQuery(self.responseContentDisposition, key: "response-content-disposition")
            request.encodeQuery(self.responseContentEncoding, key: "response-content-encoding")
            request.encodeQuery(self.responseContentLanguage, key: "response-content-language")
            request.encodeQuery(self.responseContentType, key: "response-content-type")
            request.encodeQuery(self._responseExpires, key: "response-expires")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectRetentionOutput: AWSDecodableShape {
        /// The container element for an object's retention settings.
        internal let retention: ObjectLockRetention

        @inlinable
        internal init(retention: ObjectLockRetention) {
            self.retention = retention
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.retention = try container.decode(ObjectLockRetention.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectRetentionRequest: AWSEncodableShape {
        /// The bucket name containing the object whose retention settings you want to retrieve.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The key name for the object whose retention settings you want to retrieve.
        internal let key: String
        internal let requestPayer: RequestPayer?
        /// The version ID for the object whose retention settings you want to retrieve.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, key: String, requestPayer: RequestPayer? = nil,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.requestPayer = requestPayer
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectTaggingOutput: AWSDecodableShape {
        internal struct _TagSetEncoding: ArrayCoderProperties { internal static let member = "Tag" }

        /// Contains the tag set.
        @CustomCoding<ArrayCoder<_TagSetEncoding, Tag>>
        internal var tagSet: [Tag]
        /// The versionId of the object for which you got the tagging information.
        internal let versionId: String?

        @inlinable
        internal init(tagSet: [Tag], versionId: String? = nil) {
            self.tagSet = tagSet
            self.versionId = versionId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.tagSet = try container.decode(CustomCoding<ArrayCoder<_TagSetEncoding, Tag>>.self, forKey: .tagSet)
                .wrappedValue
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
        }

        private enum CodingKeys: String, CodingKey {
            case tagSet = "TagSet"
        }
    }

    internal struct GetObjectTaggingRequest: AWSEncodableShape {
        /// The bucket name containing the object for which to get the tagging information.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Object key for which to get the tagging information.
        internal let key: String
        internal let requestPayer: RequestPayer?
        /// The versionId of the object for which to get the tagging information.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, key: String, requestPayer: RequestPayer? = nil,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.requestPayer = requestPayer
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectTorrentOutput: AWSDecodableShape {
        internal static let _options: AWSShapeOptions = [.rawPayload]
        /// A Bencoded dictionary as defined by the BitTorrent specification
        internal let body: AWSHTTPBody
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(body: AWSHTTPBody, requestCharged: RequestCharged? = nil) {
            self.body = body
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.singleValueContainer()
            self.body = try container.decode(AWSHTTPBody.self)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetObjectTorrentRequest: AWSEncodableShape {
        /// The name of the bucket containing the object for which to get the torrent files.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The object key for which to get the information.
        internal let key: String
        internal let requestPayer: RequestPayer?

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, key: String, requestPayer: RequestPayer? = nil
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.requestPayer = requestPayer
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetPublicAccessBlockOutput: AWSDecodableShape {
        /// The PublicAccessBlock configuration currently in effect for this Amazon S3 bucket.
        internal let publicAccessBlockConfiguration: PublicAccessBlockConfiguration

        @inlinable
        internal init(publicAccessBlockConfiguration: PublicAccessBlockConfiguration) {
            self.publicAccessBlockConfiguration = publicAccessBlockConfiguration
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.publicAccessBlockConfiguration = try container.decode(PublicAccessBlockConfiguration.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GetPublicAccessBlockRequest: AWSEncodableShape {
        /// The name of the Amazon S3 bucket whose PublicAccessBlock configuration you want to retrieve.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct GlacierJobParameters: AWSEncodableShape {
        /// Retrieval tier at which the restore will be processed.
        internal let tier: Tier

        @inlinable
        internal init(tier: Tier) {
            self.tier = tier
        }

        private enum CodingKeys: String, CodingKey {
            case tier = "Tier"
        }
    }

    internal struct Grant: AWSEncodableShape & AWSDecodableShape {
        /// The person being granted permissions.
        internal let grantee: Grantee?
        /// Specifies the permission given to the grantee.
        internal let permission: Permission?

        @inlinable
        internal init(grantee: Grantee? = nil, permission: Permission? = nil) {
            self.grantee = grantee
            self.permission = permission
        }

        private enum CodingKeys: String, CodingKey {
            case grantee = "Grantee"
            case permission = "Permission"
        }
    }

    internal struct Grantee: AWSEncodableShape & AWSDecodableShape {
        /// Screen name of the grantee.
        internal let displayName: String?
        /// Email address of the grantee.  Using email addresses to specify a grantee is only supported in the following Amazon Web Services Regions:    US East (N. Virginia)   US West (N. California)   US West (Oregon)   Asia Pacific (Singapore)   Asia Pacific (Sydney)   Asia Pacific (Tokyo)   Europe (Ireland)   South America (São Paulo)   For a list of all the Amazon S3 supported Regions and endpoints, see Regions and Endpoints in the Amazon Web Services General Reference.
        internal let emailAddress: String?
        /// The canonical user ID of the grantee.
        internal let id: String?
        /// Type of grantee
        internal let type: `Type`
        /// URI of the grantee group.
        internal let uri: String?

        @inlinable
        internal init(
            displayName: String? = nil, emailAddress: String? = nil, id: String? = nil, type: `Type`, uri: String? = nil
        ) {
            self.displayName = displayName
            self.emailAddress = emailAddress
            self.id = id
            self.type = type
            self.uri = uri
        }

        private enum CodingKeys: String, CodingKey {
            case displayName = "DisplayName"
            case emailAddress = "EmailAddress"
            case id = "ID"
            case type = "xsi:type"
            case uri = "URI"
        }
    }

    internal struct HeadBucketOutput: AWSDecodableShape {
        /// Indicates whether the bucket name used in the request is an access point alias.  For directory buckets, the value of this field is false.
        internal let accessPointAlias: Bool?
        /// The name of the location where the bucket will be created. For directory buckets, the Zone ID of the Availability Zone or the Local Zone where the bucket is created. An example Zone ID value for an Availability Zone is usw2-az1.  This functionality is only supported by directory buckets.
        internal let bucketLocationName: String?
        /// The type of location where the bucket is created.  This functionality is only supported by directory buckets.
        internal let bucketLocationType: LocationType?
        /// The Region that the bucket is located.
        internal let bucketRegion: String?

        @inlinable
        internal init(
            accessPointAlias: Bool? = nil, bucketLocationName: String? = nil, bucketLocationType: LocationType? = nil,
            bucketRegion: String? = nil
        ) {
            self.accessPointAlias = accessPointAlias
            self.bucketLocationName = bucketLocationName
            self.bucketLocationType = bucketLocationType
            self.bucketRegion = bucketRegion
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.accessPointAlias = try response.decodeHeaderIfPresent(Bool.self, key: "x-amz-access-point-alias")
            self.bucketLocationName = try response.decodeHeaderIfPresent(String.self, key: "x-amz-bucket-location-name")
            self.bucketLocationType = try response.decodeHeaderIfPresent(
                LocationType.self, key: "x-amz-bucket-location-type")
            self.bucketRegion = try response.decodeHeaderIfPresent(String.self, key: "x-amz-bucket-region")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct HeadBucketRequest: AWSEncodableShape {
        /// The bucket name.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Object Lambda access points - When you use this API operation with an Object Lambda access point, provide the alias of the Object Lambda access point in place of the bucket name.
        /// If the Object Lambda access point alias in a request is not valid, the error code InvalidAccessPointAliasError is returned.
        /// For more information about InvalidAccessPointAliasError, see List of Error Codes.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct HeadObjectOutput: AWSDecodableShape {
        /// Indicates that a range of bytes was specified.
        internal let acceptRanges: String?
        /// The archive state of the head object.  This functionality is not supported for directory buckets.
        internal let archiveStatus: ArchiveStatus?
        /// Indicates whether the object uses an S3 Bucket Key for server-side encryption with Key Management Service (KMS) keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// Specifies caching behavior along the request/reply chain.
        internal let cacheControl: String?
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Specifies presentational information for the object.
        internal let contentDisposition: String?
        /// Indicates what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.
        internal let contentEncoding: String?
        /// The language the content is in.
        internal let contentLanguage: String?
        /// Size of the body in bytes.
        internal let contentLength: Int64?
        /// A standard MIME type describing the format of the object data.
        internal let contentType: String?
        /// Specifies whether the object retrieved was (true) or was not (false) a Delete Marker. If false, this response header does not appear in the response.  This functionality is not supported for directory buckets.
        internal let deleteMarker: Bool?
        /// An entity tag (ETag) is an opaque identifier assigned by a web server to a specific version of a resource found at a URL.
        internal let eTag: String?
        /// If the object expiration is configured (see  PutBucketLifecycleConfiguration ), the response includes this header. It includes the expiry-date and rule-id key-value pairs providing object expiration information. The value of the rule-id is URL-encoded.  Object expiration information is not returned in directory buckets and this header returns the value "NotImplemented" in all responses for directory buckets.
        internal let expiration: String?
        /// The date and time at which the object is no longer cacheable.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var expires: Date?
        /// Date and time when the object was last modified.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var lastModified: Date?
        /// A map of metadata to store with the object in S3.
        internal let metadata: [String: String]?
        /// This is set to the number of metadata entries not returned in x-amz-meta headers. This can happen if you create metadata using an API like SOAP that supports more flexible metadata than the REST API. For example, using SOAP, you can create metadata whose values are not legal HTTP headers.  This functionality is not supported for directory buckets.
        internal let missingMeta: Int?
        /// Specifies whether a legal hold is in effect for this object. This header is only returned if the requester has the s3:GetObjectLegalHold permission. This header is not returned if the specified version of this object has never had a legal hold applied. For more information about S3 Object Lock, see Object Lock.  This functionality is not supported for directory buckets.
        internal let objectLockLegalHoldStatus: ObjectLockLegalHoldStatus?
        /// The Object Lock mode, if any, that's in effect for this object. This header is only returned if the requester has the s3:GetObjectRetention permission. For more information about S3 Object Lock, see Object Lock.   This functionality is not supported for directory buckets.
        internal let objectLockMode: ObjectLockMode?
        /// The date and time when the Object Lock retention period expires. This header is only returned if the requester has the s3:GetObjectRetention permission.  This functionality is not supported for directory buckets.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var objectLockRetainUntilDate: Date?
        /// The count of parts this object has. This value is only returned if you specify partNumber in your request and the object was uploaded as a multipart upload.
        internal let partsCount: Int?
        /// Amazon S3 can return this header if your request involves a bucket that is either a source or a destination in a replication rule. In replication, you have a source bucket on which you configure replication and destination bucket or buckets where Amazon S3 stores object replicas. When you request an object (GetObject) or object metadata (HeadObject) from these buckets, Amazon S3 will return the x-amz-replication-status header in the response as follows:    If requesting an object from the source bucket, Amazon S3 will return the x-amz-replication-status header if the object in your request is eligible for replication. For example, suppose that in your replication configuration, you specify object prefix TaxDocs requesting Amazon S3 to replicate objects with key prefix TaxDocs. Any objects you upload with this key name prefix, for example TaxDocs/document1.pdf, are eligible for replication. For any object request with this key name prefix, Amazon S3 will return the x-amz-replication-status header with value PENDING, COMPLETED or FAILED indicating object replication status.    If requesting an object from a destination bucket, Amazon S3 will return the x-amz-replication-status header with value REPLICA if the object in your request is a replica that Amazon S3 created and there is no replica modification replication in progress.    When replicating objects to multiple destination buckets, the x-amz-replication-status header acts differently. The header of the source object will only return a value of COMPLETED when replication is successful to all destinations. The header will remain at value PENDING until replication has completed for all destinations. If one or more destinations fails replication the header will return FAILED.    For more information, see Replication.  This functionality is not supported for directory buckets.
        internal let replicationStatus: ReplicationStatus?
        internal let requestCharged: RequestCharged?
        /// If the object is an archived object (an object whose storage class is GLACIER), the response includes this header if either the archive restoration is in progress (see RestoreObject or an archive copy is already restored. If an archive copy is already restored, the header value indicates when Amazon S3 is scheduled to delete the object copy. For example:  x-amz-restore: ongoing-request="false", expiry-date="Fri, 21 Dec 2012 00:00:00 GMT"  If the object restoration is in progress, the header returns the value ongoing-request="true". For more information about archiving objects, see Transitioning Objects: General Considerations.  This functionality is not supported for directory buckets. Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let restore: String?
        /// The server-side encryption algorithm used when you store this object in Amazon S3 (for example, AES256, aws:kms, aws:kms:dsse).
        internal let serverSideEncryption: ServerSideEncryption?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to confirm the encryption algorithm that's used.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide the round-trip message integrity verification of the customer-provided encryption key.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// If present, indicates the ID of the KMS key that was used for object encryption.
        internal let ssekmsKeyId: String?
        /// Provides storage class information of the object. Amazon S3 returns this header for all objects except for S3 Standard storage class objects. For more information, see Storage Classes.   Directory buckets  - Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let storageClass: StorageClass?
        /// Version ID of the object.  This functionality is not supported for directory buckets.
        internal let versionId: String?
        /// If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata.  This functionality is not supported for directory buckets.
        internal let websiteRedirectLocation: String?

        @inlinable
        internal init(
            acceptRanges: String? = nil, archiveStatus: ArchiveStatus? = nil, bucketKeyEnabled: Bool? = nil,
            cacheControl: String? = nil, checksumCRC32: String? = nil, checksumCRC32C: String? = nil,
            checksumSHA1: String? = nil, checksumSHA256: String? = nil, contentDisposition: String? = nil,
            contentEncoding: String? = nil, contentLanguage: String? = nil, contentLength: Int64? = nil,
            contentType: String? = nil, deleteMarker: Bool? = nil, eTag: String? = nil, expiration: String? = nil,
            expires: Date? = nil, lastModified: Date? = nil, metadata: [String: String]? = nil, missingMeta: Int? = nil,
            objectLockLegalHoldStatus: ObjectLockLegalHoldStatus? = nil, objectLockMode: ObjectLockMode? = nil,
            objectLockRetainUntilDate: Date? = nil, partsCount: Int? = nil, replicationStatus: ReplicationStatus? = nil,
            requestCharged: RequestCharged? = nil, restore: String? = nil,
            serverSideEncryption: ServerSideEncryption? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKeyMD5: String? = nil, ssekmsKeyId: String? = nil, storageClass: StorageClass? = nil,
            versionId: String? = nil, websiteRedirectLocation: String? = nil
        ) {
            self.acceptRanges = acceptRanges
            self.archiveStatus = archiveStatus
            self.bucketKeyEnabled = bucketKeyEnabled
            self.cacheControl = cacheControl
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.contentDisposition = contentDisposition
            self.contentEncoding = contentEncoding
            self.contentLanguage = contentLanguage
            self.contentLength = contentLength
            self.contentType = contentType
            self.deleteMarker = deleteMarker
            self.eTag = eTag
            self.expiration = expiration
            self.expires = expires
            self.lastModified = lastModified
            self.metadata = metadata
            self.missingMeta = missingMeta
            self.objectLockLegalHoldStatus = objectLockLegalHoldStatus
            self.objectLockMode = objectLockMode
            self.objectLockRetainUntilDate = objectLockRetainUntilDate
            self.partsCount = partsCount
            self.replicationStatus = replicationStatus
            self.requestCharged = requestCharged
            self.restore = restore
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsKeyId = ssekmsKeyId
            self.storageClass = storageClass
            self.versionId = versionId
            self.websiteRedirectLocation = websiteRedirectLocation
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.acceptRanges = try response.decodeHeaderIfPresent(String.self, key: "accept-ranges")
            self.archiveStatus = try response.decodeHeaderIfPresent(ArchiveStatus.self, key: "x-amz-archive-status")
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.cacheControl = try response.decodeHeaderIfPresent(String.self, key: "Cache-Control")
            self.checksumCRC32 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-crc32")
            self.checksumCRC32C = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-crc32c")
            self.checksumSHA1 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-sha1")
            self.checksumSHA256 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-sha256")
            self.contentDisposition = try response.decodeHeaderIfPresent(String.self, key: "Content-Disposition")
            self.contentEncoding = try response.decodeHeaderIfPresent(String.self, key: "Content-Encoding")
            self.contentLanguage = try response.decodeHeaderIfPresent(String.self, key: "Content-Language")
            self.contentLength = try response.decodeHeaderIfPresent(Int64.self, key: "Content-Length")
            self.contentType = try response.decodeHeaderIfPresent(String.self, key: "Content-Type")
            self.deleteMarker = try response.decodeHeaderIfPresent(Bool.self, key: "x-amz-delete-marker")
            self.eTag = try response.decodeHeaderIfPresent(String.self, key: "ETag")
            self.expiration = try response.decodeHeaderIfPresent(String.self, key: "x-amz-expiration")
            self.expires = try response.decodeHeaderIfPresent(Date.self, key: "Expires")
            self.lastModified = try response.decodeHeaderIfPresent(Date.self, key: "Last-Modified")
            self.metadata = try response.decodeHeaderIfPresent([String: String].self, key: "x-amz-meta-")
            self.missingMeta = try response.decodeHeaderIfPresent(Int.self, key: "x-amz-missing-meta")
            self.objectLockLegalHoldStatus = try response.decodeHeaderIfPresent(
                ObjectLockLegalHoldStatus.self, key: "x-amz-object-lock-legal-hold")
            self.objectLockMode = try response.decodeHeaderIfPresent(ObjectLockMode.self, key: "x-amz-object-lock-mode")
            self.objectLockRetainUntilDate = try response.decodeHeaderIfPresent(
                Date.self, key: "x-amz-object-lock-retain-until-date")
            self.partsCount = try response.decodeHeaderIfPresent(Int.self, key: "x-amz-mp-parts-count")
            self.replicationStatus = try response.decodeHeaderIfPresent(
                ReplicationStatus.self, key: "x-amz-replication-status")
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.restore = try response.decodeHeaderIfPresent(String.self, key: "x-amz-restore")
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.sseCustomerAlgorithm = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-algorithm")
            self.sseCustomerKeyMD5 = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-key-MD5")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
            self.storageClass = try response.decodeHeaderIfPresent(StorageClass.self, key: "x-amz-storage-class")
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
            self.websiteRedirectLocation = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-website-redirect-location")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct HeadObjectRequest: AWSEncodableShape {
        /// The name of the bucket that contains the object.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// To retrieve the checksum, this parameter must be enabled.  General purpose buckets - If you enable checksum mode and the object is uploaded with a checksum and encrypted with an Key Management Service (KMS) key, you must have permission to use the kms:Decrypt action to retrieve the checksum.  Directory buckets - If you enable ChecksumMode and the object is encrypted with Amazon Web Services Key Management Service (Amazon Web Services KMS), you must also have the kms:GenerateDataKey and kms:Decrypt permissions in IAM identity-based policies and KMS key policies for the KMS key to retrieve the checksum of the object.
        internal let checksumMode: ChecksumMode?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Return the object only if its entity tag (ETag) is the same as the one specified; otherwise, return a 412 (precondition failed) error. If both of the If-Match and If-Unmodified-Since headers are present in the request as follows:    If-Match condition evaluates to true, and;    If-Unmodified-Since condition evaluates to false;   Then Amazon S3 returns 200 OK and the data requested. For more information about conditional requests, see RFC 7232.
        internal let ifMatch: String?
        /// Return the object only if it has been modified since the specified time; otherwise, return a 304 (not modified) error. If both of the If-None-Match and If-Modified-Since headers are present in the request as follows:    If-None-Match condition evaluates to false, and;    If-Modified-Since condition evaluates to true;   Then Amazon S3 returns the 304 Not Modified response code. For more information about conditional requests, see RFC 7232.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var ifModifiedSince: Date?
        /// Return the object only if its entity tag (ETag) is different from the one specified; otherwise, return a 304 (not modified) error. If both of the If-None-Match and If-Modified-Since headers are present in the request as follows:    If-None-Match condition evaluates to false, and;    If-Modified-Since condition evaluates to true;   Then Amazon S3 returns the 304 Not Modified response code. For more information about conditional requests, see RFC 7232.
        internal let ifNoneMatch: String?
        /// Return the object only if it has not been modified since the specified time; otherwise, return a 412 (precondition failed) error. If both of the If-Match and If-Unmodified-Since headers are present in the request as follows:    If-Match condition evaluates to true, and;    If-Unmodified-Since condition evaluates to false;   Then Amazon S3 returns 200 OK and the data requested. For more information about conditional requests, see RFC 7232.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var ifUnmodifiedSince: Date?
        /// The object key.
        internal let key: String
        /// Part number of the object being read. This is a positive integer between 1 and 10,000. Effectively performs a 'ranged' HEAD request for the part specified. Useful querying about the size of the part and the number of parts in this object.
        internal let partNumber: Int?
        /// HeadObject returns only the metadata for an object. If the Range is satisfiable, only the ContentLength is affected in the response. If the Range is not satisfiable, S3 returns a 416 - Requested Range Not Satisfiable error.
        internal let range: String?
        internal let requestPayer: RequestPayer?
        /// Sets the Cache-Control header of the response.
        internal let responseCacheControl: String?
        /// Sets the Content-Disposition header of the response.
        internal let responseContentDisposition: String?
        /// Sets the Content-Encoding header of the response.
        internal let responseContentEncoding: String?
        /// Sets the Content-Language header of the response.
        internal let responseContentLanguage: String?
        /// Sets the Content-Type header of the response.
        internal let responseContentType: String?
        /// Sets the Expires header of the response.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var responseExpires: Date?
        /// Specifies the algorithm to use when encrypting the object (for example, AES256).  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header.  This functionality is not supported for directory buckets.
        internal let sseCustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// Version ID used to reference a specific version of the object.  For directory buckets in this API operation, only the null value of the version ID is supported.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, checksumMode: ChecksumMode? = nil, expectedBucketOwner: String? = nil,
            ifMatch: String? = nil, ifModifiedSince: Date? = nil, ifNoneMatch: String? = nil,
            ifUnmodifiedSince: Date? = nil, key: String, partNumber: Int? = nil, range: String? = nil,
            requestPayer: RequestPayer? = nil, responseCacheControl: String? = nil,
            responseContentDisposition: String? = nil, responseContentEncoding: String? = nil,
            responseContentLanguage: String? = nil, responseContentType: String? = nil, responseExpires: Date? = nil,
            sseCustomerAlgorithm: String? = nil, sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.checksumMode = checksumMode
            self.expectedBucketOwner = expectedBucketOwner
            self.ifMatch = ifMatch
            self.ifModifiedSince = ifModifiedSince
            self.ifNoneMatch = ifNoneMatch
            self.ifUnmodifiedSince = ifUnmodifiedSince
            self.key = key
            self.partNumber = partNumber
            self.range = range
            self.requestPayer = requestPayer
            self.responseCacheControl = responseCacheControl
            self.responseContentDisposition = responseContentDisposition
            self.responseContentEncoding = responseContentEncoding
            self.responseContentLanguage = responseContentLanguage
            self.responseContentType = responseContentType
            self.responseExpires = responseExpires
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumMode, key: "x-amz-checksum-mode")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.ifMatch, key: "If-Match")
            request.encodeHeader(self._ifModifiedSince, key: "If-Modified-Since")
            request.encodeHeader(self.ifNoneMatch, key: "If-None-Match")
            request.encodeHeader(self._ifUnmodifiedSince, key: "If-Unmodified-Since")
            request.encodePath(self.key, key: "Key")
            request.encodeQuery(self.partNumber, key: "partNumber")
            request.encodeHeader(self.range, key: "Range")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.responseCacheControl, key: "response-cache-control")
            request.encodeQuery(self.responseContentDisposition, key: "response-content-disposition")
            request.encodeQuery(self.responseContentEncoding, key: "response-content-encoding")
            request.encodeQuery(self.responseContentLanguage, key: "response-content-language")
            request.encodeQuery(self.responseContentType, key: "response-content-type")
            request.encodeQuery(self._responseExpires, key: "response-expires")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct IndexDocument: AWSEncodableShape & AWSDecodableShape {
        /// A suffix that is appended to a request that is for a directory on the website endpoint. (For example, if the suffix is index.html and you make a request to samplebucket/images/, the data that is returned will be for the object with the key name images/index.html.) The suffix must not be empty and must not include a slash character.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let suffix: String

        @inlinable
        internal init(suffix: String) {
            self.suffix = suffix
        }

        private enum CodingKeys: String, CodingKey {
            case suffix = "Suffix"
        }
    }

    internal struct Initiator: AWSDecodableShape {
        /// Name of the Principal.  This functionality is not supported for directory buckets.
        internal let displayName: String?
        /// If the principal is an Amazon Web Services account, it provides the Canonical User ID. If the principal is an IAM User, it provides a user ARN value.   Directory buckets - If the principal is an Amazon Web Services account, it provides the Amazon Web Services account ID. If the principal is an IAM User, it provides a user ARN value.
        internal let id: String?

        @inlinable
        internal init(displayName: String? = nil, id: String? = nil) {
            self.displayName = displayName
            self.id = id
        }

        private enum CodingKeys: String, CodingKey {
            case displayName = "DisplayName"
            case id = "ID"
        }
    }

    internal struct InputSerialization: AWSEncodableShape {
        /// Specifies object's compression format. Valid values: NONE, GZIP, BZIP2. Default Value: NONE.
        internal let compressionType: CompressionType?
        /// Describes the serialization of a CSV-encoded object.
        internal let csv: CSVInput?
        /// Specifies JSON as object's input serialization format.
        internal let json: JSONInput?
        /// Specifies Parquet as object's input serialization format.
        internal let parquet: ParquetInput?

        @inlinable
        internal init(
            compressionType: CompressionType? = nil, csv: CSVInput? = nil, json: JSONInput? = nil,
            parquet: ParquetInput? = nil
        ) {
            self.compressionType = compressionType
            self.csv = csv
            self.json = json
            self.parquet = parquet
        }

        private enum CodingKeys: String, CodingKey {
            case compressionType = "CompressionType"
            case csv = "CSV"
            case json = "JSON"
            case parquet = "Parquet"
        }
    }

    internal struct IntelligentTieringAndOperator: AWSEncodableShape & AWSDecodableShape {
        /// An object key name prefix that identifies the subset of objects to which the configuration applies.
        internal let prefix: String?
        /// All of these tags must exist in the object's tag set in order for the configuration to apply.
        internal let tags: [Tag]?

        @inlinable
        internal init(prefix: String? = nil, tags: [Tag]? = nil) {
            self.prefix = prefix
            self.tags = tags
        }

        internal func validate(name: String) throws {
            try self.tags?.forEach {
                try $0.validate(name: "\(name).tags[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case prefix = "Prefix"
            case tags = "Tag"
        }
    }

    internal struct IntelligentTieringConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// Specifies a bucket filter. The configuration only includes objects that meet the filter's criteria.
        internal let filter: IntelligentTieringFilter?
        /// The ID used to identify the S3 Intelligent-Tiering configuration.
        internal let id: String
        /// Specifies the status of the configuration.
        internal let status: IntelligentTieringStatus
        /// Specifies the S3 Intelligent-Tiering storage class tier of the configuration.
        internal let tierings: [Tiering]

        @inlinable
        internal init(
            filter: IntelligentTieringFilter? = nil, id: String, status: IntelligentTieringStatus, tierings: [Tiering]
        ) {
            self.filter = filter
            self.id = id
            self.status = status
            self.tierings = tierings
        }

        internal func validate(name: String) throws {
            try self.filter?.validate(name: "\(name).filter")
        }

        private enum CodingKeys: String, CodingKey {
            case filter = "Filter"
            case id = "Id"
            case status = "Status"
            case tierings = "Tiering"
        }
    }

    internal struct IntelligentTieringFilter: AWSEncodableShape & AWSDecodableShape {
        /// A conjunction (logical AND) of predicates, which is used in evaluating a metrics filter. The operator must have at least two predicates, and an object must match all of the predicates in order for the filter to apply.
        internal let and: IntelligentTieringAndOperator?
        /// An object key name prefix that identifies the subset of objects to which the rule applies.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let prefix: String?
        internal let tag: Tag?

        @inlinable
        internal init(and: IntelligentTieringAndOperator? = nil, prefix: String? = nil, tag: Tag? = nil) {
            self.and = and
            self.prefix = prefix
            self.tag = tag
        }

        internal func validate(name: String) throws {
            try self.and?.validate(name: "\(name).and")
            try self.tag?.validate(name: "\(name).tag")
        }

        private enum CodingKeys: String, CodingKey {
            case and = "And"
            case prefix = "Prefix"
            case tag = "Tag"
        }
    }

    internal struct InventoryConfiguration: AWSEncodableShape & AWSDecodableShape {
        internal struct _OptionalFieldsEncoding: ArrayCoderProperties { internal static let member = "Field" }

        /// Contains information about where to publish the inventory results.
        internal let destination: InventoryDestination
        /// Specifies an inventory filter. The inventory only includes objects that meet the filter's criteria.
        internal let filter: InventoryFilter?
        /// The ID used to identify the inventory configuration.
        internal let id: String
        /// Object versions to include in the inventory list. If set to All, the list includes all the object versions, which adds the version-related fields VersionId, IsLatest, and DeleteMarker to the list. If set to Current, the list does not contain these version-related fields.
        internal let includedObjectVersions: InventoryIncludedObjectVersions
        /// Specifies whether the inventory is enabled or disabled. If set to True, an inventory list is generated. If set to False, no inventory list is generated.
        internal let isEnabled: Bool
        /// Contains the optional fields that are included in the inventory results.
        @OptionalCustomCoding<ArrayCoder<_OptionalFieldsEncoding, InventoryOptionalField>>
        internal var optionalFields: [InventoryOptionalField]?
        /// Specifies the schedule for generating inventory results.
        internal let schedule: InventorySchedule

        @inlinable
        internal init(
            destination: InventoryDestination, filter: InventoryFilter? = nil, id: String,
            includedObjectVersions: InventoryIncludedObjectVersions, isEnabled: Bool,
            optionalFields: [InventoryOptionalField]? = nil, schedule: InventorySchedule
        ) {
            self.destination = destination
            self.filter = filter
            self.id = id
            self.includedObjectVersions = includedObjectVersions
            self.isEnabled = isEnabled
            self.optionalFields = optionalFields
            self.schedule = schedule
        }

        private enum CodingKeys: String, CodingKey {
            case destination = "Destination"
            case filter = "Filter"
            case id = "Id"
            case includedObjectVersions = "IncludedObjectVersions"
            case isEnabled = "IsEnabled"
            case optionalFields = "OptionalFields"
            case schedule = "Schedule"
        }
    }

    internal struct InventoryDestination: AWSEncodableShape & AWSDecodableShape {
        /// Contains the bucket name, file format, bucket owner (optional), and prefix (optional) where inventory results are published.
        internal let s3BucketDestination: InventoryS3BucketDestination

        @inlinable
        internal init(s3BucketDestination: InventoryS3BucketDestination) {
            self.s3BucketDestination = s3BucketDestination
        }

        private enum CodingKeys: String, CodingKey {
            case s3BucketDestination = "S3BucketDestination"
        }
    }

    internal struct InventoryEncryption: AWSEncodableShape & AWSDecodableShape {
        /// Specifies the use of SSE-KMS to encrypt delivered inventory reports.
        internal let ssekms: SSEKMS?
        /// Specifies the use of SSE-S3 to encrypt delivered inventory reports.
        internal let sses3: SSES3?

        @inlinable
        internal init(ssekms: SSEKMS? = nil, sses3: SSES3? = nil) {
            self.ssekms = ssekms
            self.sses3 = sses3
        }

        private enum CodingKeys: String, CodingKey {
            case ssekms = "SSE-KMS"
            case sses3 = "SSE-S3"
        }
    }

    internal struct InventoryFilter: AWSEncodableShape & AWSDecodableShape {
        /// The prefix that an object must have to be included in the inventory results.
        internal let prefix: String

        @inlinable
        internal init(prefix: String) {
            self.prefix = prefix
        }

        private enum CodingKeys: String, CodingKey {
            case prefix = "Prefix"
        }
    }

    internal struct InventoryS3BucketDestination: AWSEncodableShape & AWSDecodableShape {
        /// The account ID that owns the destination S3 bucket. If no account ID is provided, the owner is not validated before exporting data.   Although this value is optional, we strongly recommend that you set it to help prevent problems if the destination bucket ownership changes.
        internal let accountId: String?
        /// The Amazon Resource Name (ARN) of the bucket where inventory results will be published.
        internal let bucket: String
        /// Contains the type of server-side encryption used to encrypt the inventory results.
        internal let encryption: InventoryEncryption?
        /// Specifies the output format of the inventory results.
        internal let format: InventoryFormat
        /// The prefix that is prepended to all inventory results.
        internal let prefix: String?

        @inlinable
        internal init(
            accountId: String? = nil, bucket: String, encryption: InventoryEncryption? = nil, format: InventoryFormat,
            prefix: String? = nil
        ) {
            self.accountId = accountId
            self.bucket = bucket
            self.encryption = encryption
            self.format = format
            self.prefix = prefix
        }

        private enum CodingKeys: String, CodingKey {
            case accountId = "AccountId"
            case bucket = "Bucket"
            case encryption = "Encryption"
            case format = "Format"
            case prefix = "Prefix"
        }
    }

    internal struct InventorySchedule: AWSEncodableShape & AWSDecodableShape {
        /// Specifies how frequently inventory results are produced.
        internal let frequency: InventoryFrequency

        @inlinable
        internal init(frequency: InventoryFrequency) {
            self.frequency = frequency
        }

        private enum CodingKeys: String, CodingKey {
            case frequency = "Frequency"
        }
    }

    internal struct JSONInput: AWSEncodableShape {
        /// The type of JSON. Valid values: Document, Lines.
        internal let type: JSONType?

        @inlinable
        internal init(type: JSONType? = nil) {
            self.type = type
        }

        private enum CodingKeys: String, CodingKey {
            case type = "Type"
        }
    }

    internal struct JSONOutput: AWSEncodableShape {
        /// The value used to separate individual records in the output. If no value is specified, Amazon S3 uses a newline character ('\n').
        internal let recordDelimiter: String?

        @inlinable
        internal init(recordDelimiter: String? = nil) {
            self.recordDelimiter = recordDelimiter
        }

        private enum CodingKeys: String, CodingKey {
            case recordDelimiter = "RecordDelimiter"
        }
    }

    internal struct LambdaFunctionConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// The Amazon S3 bucket event for which to invoke the Lambda function. For more information, see Supported Event Types in the Amazon S3 User Guide.
        internal let events: [Event]
        internal let filter: NotificationConfigurationFilter?
        internal let id: String?
        /// The Amazon Resource Name (ARN) of the Lambda function that Amazon S3 invokes when the specified event type occurs.
        internal let lambdaFunctionArn: String

        @inlinable
        internal init(
            events: [Event], filter: NotificationConfigurationFilter? = nil, id: String? = nil,
            lambdaFunctionArn: String
        ) {
            self.events = events
            self.filter = filter
            self.id = id
            self.lambdaFunctionArn = lambdaFunctionArn
        }

        private enum CodingKeys: String, CodingKey {
            case events = "Event"
            case filter = "Filter"
            case id = "Id"
            case lambdaFunctionArn = "CloudFunction"
        }
    }

    internal struct LifecycleExpiration: AWSEncodableShape & AWSDecodableShape {
        /// Indicates at what date the object is to be moved or deleted. The date value must conform to the ISO 8601 format. The time is always midnight UTC.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var date: Date?
        /// Indicates the lifetime, in days, of the objects that are subject to the rule. The value must be a non-zero positive integer.
        internal let days: Int?
        /// Indicates whether Amazon S3 will remove a delete marker with no noncurrent versions. If set to true, the delete marker will be expired; if set to false the policy takes no action. This cannot be specified with Days or Date in a Lifecycle Expiration Policy.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let expiredObjectDeleteMarker: Bool?

        @inlinable
        internal init(date: Date? = nil, days: Int? = nil, expiredObjectDeleteMarker: Bool? = nil) {
            self.date = date
            self.days = days
            self.expiredObjectDeleteMarker = expiredObjectDeleteMarker
        }

        private enum CodingKeys: String, CodingKey {
            case date = "Date"
            case days = "Days"
            case expiredObjectDeleteMarker = "ExpiredObjectDeleteMarker"
        }
    }

    internal struct LifecycleRule: AWSEncodableShape & AWSDecodableShape {
        internal let abortIncompleteMultipartUpload: AbortIncompleteMultipartUpload?
        /// Specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker.
        internal let expiration: LifecycleExpiration?
        /// The Filter is used to identify objects that a Lifecycle Rule applies to. A Filter must have exactly one of Prefix, Tag, or And specified. Filter is required if the LifecycleRule does not contain a Prefix element.   Tag filters are not supported for directory buckets.
        internal let filter: LifecycleRuleFilter
        /// Unique identifier for the rule. The value cannot be longer than 255 characters.
        internal let id: String?
        internal let noncurrentVersionExpiration: NoncurrentVersionExpiration?
        /// Specifies the transition rule for the lifecycle rule that describes when noncurrent objects transition to a specific storage class. If your bucket is versioning-enabled (or versioning is suspended), you can set this action to request that Amazon S3 transition noncurrent object versions to a specific storage class at a set period in the object's lifetime.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let noncurrentVersionTransitions: [NoncurrentVersionTransition]?
        /// Prefix identifying one or more objects to which the rule applies. This is no longer used; use Filter instead.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let prefix: String?
        /// If 'Enabled', the rule is currently being applied. If 'Disabled', the rule is not currently being applied.
        internal let status: ExpirationStatus
        /// Specifies when an Amazon S3 object transitions to a specified storage class.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let transitions: [Transition]?

        @inlinable
        internal init(
            abortIncompleteMultipartUpload: AbortIncompleteMultipartUpload? = nil,
            expiration: LifecycleExpiration? = nil, filter: LifecycleRuleFilter, id: String? = nil,
            noncurrentVersionExpiration: NoncurrentVersionExpiration? = nil,
            noncurrentVersionTransitions: [NoncurrentVersionTransition]? = nil, status: ExpirationStatus,
            transitions: [Transition]? = nil
        ) {
            self.abortIncompleteMultipartUpload = abortIncompleteMultipartUpload
            self.expiration = expiration
            self.filter = filter
            self.id = id
            self.noncurrentVersionExpiration = noncurrentVersionExpiration
            self.noncurrentVersionTransitions = noncurrentVersionTransitions
            self.prefix = nil
            self.status = status
            self.transitions = transitions
        }

        @available(*, deprecated, message: "Members prefix have been deprecated")
        @inlinable
        internal init(
            abortIncompleteMultipartUpload: AbortIncompleteMultipartUpload? = nil,
            expiration: LifecycleExpiration? = nil, filter: LifecycleRuleFilter, id: String? = nil,
            noncurrentVersionExpiration: NoncurrentVersionExpiration? = nil,
            noncurrentVersionTransitions: [NoncurrentVersionTransition]? = nil, prefix: String? = nil,
            status: ExpirationStatus, transitions: [Transition]? = nil
        ) {
            self.abortIncompleteMultipartUpload = abortIncompleteMultipartUpload
            self.expiration = expiration
            self.filter = filter
            self.id = id
            self.noncurrentVersionExpiration = noncurrentVersionExpiration
            self.noncurrentVersionTransitions = noncurrentVersionTransitions
            self.prefix = prefix
            self.status = status
            self.transitions = transitions
        }

        internal func validate(name: String) throws {
            try self.filter.validate(name: "\(name).filter")
        }

        private enum CodingKeys: String, CodingKey {
            case abortIncompleteMultipartUpload = "AbortIncompleteMultipartUpload"
            case expiration = "Expiration"
            case filter = "Filter"
            case id = "ID"
            case noncurrentVersionExpiration = "NoncurrentVersionExpiration"
            case noncurrentVersionTransitions = "NoncurrentVersionTransition"
            case prefix = "Prefix"
            case status = "Status"
            case transitions = "Transition"
        }
    }

    internal struct LifecycleRuleAndOperator: AWSEncodableShape & AWSDecodableShape {
        /// Minimum object size to which the rule applies.
        internal let objectSizeGreaterThan: Int64?
        /// Maximum object size to which the rule applies.
        internal let objectSizeLessThan: Int64?
        /// Prefix identifying one or more objects to which the rule applies.
        internal let prefix: String?
        /// All of these tags must exist in the object's tag set in order for the rule to apply.
        internal let tags: [Tag]?

        @inlinable
        internal init(
            objectSizeGreaterThan: Int64? = nil, objectSizeLessThan: Int64? = nil, prefix: String? = nil,
            tags: [Tag]? = nil
        ) {
            self.objectSizeGreaterThan = objectSizeGreaterThan
            self.objectSizeLessThan = objectSizeLessThan
            self.prefix = prefix
            self.tags = tags
        }

        internal func validate(name: String) throws {
            try self.tags?.forEach {
                try $0.validate(name: "\(name).tags[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case objectSizeGreaterThan = "ObjectSizeGreaterThan"
            case objectSizeLessThan = "ObjectSizeLessThan"
            case prefix = "Prefix"
            case tags = "Tag"
        }
    }

    internal struct LifecycleRuleFilter: AWSEncodableShape & AWSDecodableShape {
        internal let and: LifecycleRuleAndOperator?
        /// Minimum object size to which the rule applies.
        internal let objectSizeGreaterThan: Int64?
        /// Maximum object size to which the rule applies.
        internal let objectSizeLessThan: Int64?
        /// Prefix identifying one or more objects to which the rule applies.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let prefix: String?
        /// This tag must exist in the object's tag set in order for the rule to apply.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let tag: Tag?

        @inlinable
        internal init(
            and: LifecycleRuleAndOperator? = nil, objectSizeGreaterThan: Int64? = nil, objectSizeLessThan: Int64? = nil,
            prefix: String? = nil, tag: Tag? = nil
        ) {
            self.and = and
            self.objectSizeGreaterThan = objectSizeGreaterThan
            self.objectSizeLessThan = objectSizeLessThan
            self.prefix = prefix
            self.tag = tag
        }

        internal func validate(name: String) throws {
            try self.and?.validate(name: "\(name).and")
            try self.tag?.validate(name: "\(name).tag")
        }

        private enum CodingKeys: String, CodingKey {
            case and = "And"
            case objectSizeGreaterThan = "ObjectSizeGreaterThan"
            case objectSizeLessThan = "ObjectSizeLessThan"
            case prefix = "Prefix"
            case tag = "Tag"
        }
    }

    internal struct ListBucketAnalyticsConfigurationsOutput: AWSDecodableShape {
        /// The list of analytics configurations for a bucket.
        internal let analyticsConfigurationList: [AnalyticsConfiguration]?
        /// The marker that is used as a starting point for this analytics configuration list response. This value is present if it was sent in the request.
        internal let continuationToken: String?
        /// Indicates whether the returned list of analytics configurations is complete. A value of true indicates that the list is not complete and the NextContinuationToken will be provided for a subsequent request.
        internal let isTruncated: Bool?
        ///  NextContinuationToken is sent when isTruncated is true, which indicates that there are more analytics configurations to list. The next request must include this NextContinuationToken. The token is obfuscated and is not a usable value.
        internal let nextContinuationToken: String?

        @inlinable
        internal init(
            analyticsConfigurationList: [AnalyticsConfiguration]? = nil, continuationToken: String? = nil,
            isTruncated: Bool? = nil, nextContinuationToken: String? = nil
        ) {
            self.analyticsConfigurationList = analyticsConfigurationList
            self.continuationToken = continuationToken
            self.isTruncated = isTruncated
            self.nextContinuationToken = nextContinuationToken
        }

        private enum CodingKeys: String, CodingKey {
            case analyticsConfigurationList = "AnalyticsConfiguration"
            case continuationToken = "ContinuationToken"
            case isTruncated = "IsTruncated"
            case nextContinuationToken = "NextContinuationToken"
        }
    }

    internal struct ListBucketAnalyticsConfigurationsRequest: AWSEncodableShape {
        /// The name of the bucket from which analytics configurations are retrieved.
        internal let bucket: String
        /// The ContinuationToken that represents a placeholder from where this request should begin.
        internal let continuationToken: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, continuationToken: String? = nil, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.continuationToken = continuationToken
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.continuationToken, key: "continuation-token")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListBucketIntelligentTieringConfigurationsOutput: AWSDecodableShape {
        /// The ContinuationToken that represents a placeholder from where this request should begin.
        internal let continuationToken: String?
        /// The list of S3 Intelligent-Tiering configurations for a bucket.
        internal let intelligentTieringConfigurationList: [IntelligentTieringConfiguration]?
        /// Indicates whether the returned list of analytics configurations is complete. A value of true indicates that the list is not complete and the NextContinuationToken will be provided for a subsequent request.
        internal let isTruncated: Bool?
        /// The marker used to continue this inventory configuration listing. Use the NextContinuationToken from this response to continue the listing in a subsequent request. The continuation token is an opaque value that Amazon S3 understands.
        internal let nextContinuationToken: String?

        @inlinable
        internal init(
            continuationToken: String? = nil,
            intelligentTieringConfigurationList: [IntelligentTieringConfiguration]? = nil, isTruncated: Bool? = nil,
            nextContinuationToken: String? = nil
        ) {
            self.continuationToken = continuationToken
            self.intelligentTieringConfigurationList = intelligentTieringConfigurationList
            self.isTruncated = isTruncated
            self.nextContinuationToken = nextContinuationToken
        }

        private enum CodingKeys: String, CodingKey {
            case continuationToken = "ContinuationToken"
            case intelligentTieringConfigurationList = "IntelligentTieringConfiguration"
            case isTruncated = "IsTruncated"
            case nextContinuationToken = "NextContinuationToken"
        }
    }

    internal struct ListBucketIntelligentTieringConfigurationsRequest: AWSEncodableShape {
        /// The name of the Amazon S3 bucket whose configuration you want to modify or retrieve.
        internal let bucket: String
        /// The ContinuationToken that represents a placeholder from where this request should begin.
        internal let continuationToken: String?

        @inlinable
        internal init(bucket: String, continuationToken: String? = nil) {
            self.bucket = bucket
            self.continuationToken = continuationToken
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.continuationToken, key: "continuation-token")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListBucketInventoryConfigurationsOutput: AWSDecodableShape {
        /// If sent in the request, the marker that is used as a starting point for this inventory configuration list response.
        internal let continuationToken: String?
        /// The list of inventory configurations for a bucket.
        internal let inventoryConfigurationList: [InventoryConfiguration]?
        /// Tells whether the returned list of inventory configurations is complete. A value of true indicates that the list is not complete and the NextContinuationToken is provided for a subsequent request.
        internal let isTruncated: Bool?
        /// The marker used to continue this inventory configuration listing. Use the NextContinuationToken from this response to continue the listing in a subsequent request. The continuation token is an opaque value that Amazon S3 understands.
        internal let nextContinuationToken: String?

        @inlinable
        internal init(
            continuationToken: String? = nil, inventoryConfigurationList: [InventoryConfiguration]? = nil,
            isTruncated: Bool? = nil, nextContinuationToken: String? = nil
        ) {
            self.continuationToken = continuationToken
            self.inventoryConfigurationList = inventoryConfigurationList
            self.isTruncated = isTruncated
            self.nextContinuationToken = nextContinuationToken
        }

        private enum CodingKeys: String, CodingKey {
            case continuationToken = "ContinuationToken"
            case inventoryConfigurationList = "InventoryConfiguration"
            case isTruncated = "IsTruncated"
            case nextContinuationToken = "NextContinuationToken"
        }
    }

    internal struct ListBucketInventoryConfigurationsRequest: AWSEncodableShape {
        /// The name of the bucket containing the inventory configurations to retrieve.
        internal let bucket: String
        /// The marker used to continue an inventory configuration listing that has been truncated. Use the NextContinuationToken from a previously truncated list response to continue the listing. The continuation token is an opaque value that Amazon S3 understands.
        internal let continuationToken: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, continuationToken: String? = nil, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.continuationToken = continuationToken
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.continuationToken, key: "continuation-token")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListBucketMetricsConfigurationsOutput: AWSDecodableShape {
        /// The marker that is used as a starting point for this metrics configuration list response. This value is present if it was sent in the request.
        internal let continuationToken: String?
        /// Indicates whether the returned list of metrics configurations is complete. A value of true indicates that the list is not complete and the NextContinuationToken will be provided for a subsequent request.
        internal let isTruncated: Bool?
        /// The list of metrics configurations for a bucket.
        internal let metricsConfigurationList: [MetricsConfiguration]?
        /// The marker used to continue a metrics configuration listing that has been truncated. Use the NextContinuationToken from a previously truncated list response to continue the listing. The continuation token is an opaque value that Amazon S3 understands.
        internal let nextContinuationToken: String?

        @inlinable
        internal init(
            continuationToken: String? = nil, isTruncated: Bool? = nil,
            metricsConfigurationList: [MetricsConfiguration]? = nil, nextContinuationToken: String? = nil
        ) {
            self.continuationToken = continuationToken
            self.isTruncated = isTruncated
            self.metricsConfigurationList = metricsConfigurationList
            self.nextContinuationToken = nextContinuationToken
        }

        private enum CodingKeys: String, CodingKey {
            case continuationToken = "ContinuationToken"
            case isTruncated = "IsTruncated"
            case metricsConfigurationList = "MetricsConfiguration"
            case nextContinuationToken = "NextContinuationToken"
        }
    }

    internal struct ListBucketMetricsConfigurationsRequest: AWSEncodableShape {
        /// The name of the bucket containing the metrics configurations to retrieve.
        internal let bucket: String
        /// The marker that is used to continue a metrics configuration listing that has been truncated. Use the NextContinuationToken from a previously truncated list response to continue the listing. The continuation token is an opaque value that Amazon S3 understands.
        internal let continuationToken: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(bucket: String, continuationToken: String? = nil, expectedBucketOwner: String? = nil) {
            self.bucket = bucket
            self.continuationToken = continuationToken
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.continuationToken, key: "continuation-token")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListBucketsOutput: AWSDecodableShape {
        internal struct _BucketsEncoding: ArrayCoderProperties { internal static let member = "Bucket" }

        /// The list of buckets owned by the requester.
        @OptionalCustomCoding<ArrayCoder<_BucketsEncoding, Bucket>>
        internal var buckets: [Bucket]?
        ///  ContinuationToken is included in the response when there are more buckets that can be listed with pagination. The next ListBuckets request to Amazon S3 can be continued with this ContinuationToken. ContinuationToken is obfuscated and is not a real bucket.
        internal let continuationToken: String?
        /// The owner of the buckets listed.
        internal let owner: Owner?
        /// If Prefix was sent with the request, it is included in the response. All bucket names in the response begin with the specified bucket name prefix.
        internal let prefix: String?

        @inlinable
        internal init(
            buckets: [Bucket]? = nil, continuationToken: String? = nil, owner: Owner? = nil, prefix: String? = nil
        ) {
            self.buckets = buckets
            self.continuationToken = continuationToken
            self.owner = owner
            self.prefix = prefix
        }

        private enum CodingKeys: String, CodingKey {
            case buckets = "Buckets"
            case continuationToken = "ContinuationToken"
            case owner = "Owner"
            case prefix = "Prefix"
        }
    }

    internal struct ListBucketsRequest: AWSEncodableShape {
        /// Limits the response to buckets that are located in the specified Amazon Web Services Region. The Amazon Web Services Region must be expressed according to the Amazon Web Services Region code, such as us-west-2 for the US West (Oregon) Region. For a list of the valid values for all of the Amazon Web Services Regions, see Regions and Endpoints.  Requests made to a Regional endpoint that is different from the bucket-region parameter are not supported. For example, if you want to limit the response to your buckets in Region us-west-2, the request must be made to an endpoint in Region us-west-2.
        internal let bucketRegion: String?
        ///  ContinuationToken indicates to Amazon S3 that the list is being continued on this bucket with a token. ContinuationToken is obfuscated and is not a real key. You can use this ContinuationToken for pagination of the list results.  Length Constraints: Minimum length of 0. Maximum length of 1024. Required: No.  If you specify the bucket-region, prefix, or continuation-token  query parameters without using max-buckets to set the maximum number of buckets returned in the response,  Amazon S3 applies a default page size of 10,000 and provides a continuation token if there are more buckets.
        internal let continuationToken: String?
        /// Maximum number of buckets to be returned in response. When the number is more than the count of buckets that are owned by an Amazon Web Services account, return all the buckets in response.
        internal let maxBuckets: Int?
        /// Limits the response to bucket names that begin with the specified bucket name prefix.
        internal let prefix: String?

        @inlinable
        internal init(
            bucketRegion: String? = nil, continuationToken: String? = nil, maxBuckets: Int? = nil, prefix: String? = nil
        ) {
            self.bucketRegion = bucketRegion
            self.continuationToken = continuationToken
            self.maxBuckets = maxBuckets
            self.prefix = prefix
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodeQuery(self.bucketRegion, key: "bucket-region")
            request.encodeQuery(self.continuationToken, key: "continuation-token")
            request.encodeQuery(self.maxBuckets, key: "max-buckets")
            request.encodeQuery(self.prefix, key: "prefix")
        }

        internal func validate(name: String) throws {
            try self.validate(self.maxBuckets, name: "maxBuckets", parent: name, max: 10000)
            try self.validate(self.maxBuckets, name: "maxBuckets", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListDirectoryBucketsOutput: AWSDecodableShape {
        internal struct _BucketsEncoding: ArrayCoderProperties { internal static let member = "Bucket" }

        /// The list of buckets owned by the requester.
        @OptionalCustomCoding<ArrayCoder<_BucketsEncoding, Bucket>>
        internal var buckets: [Bucket]?
        /// If ContinuationToken was sent with the request, it is included in the response. You can use the returned ContinuationToken for pagination of the list response.
        internal let continuationToken: String?

        @inlinable
        internal init(buckets: [Bucket]? = nil, continuationToken: String? = nil) {
            self.buckets = buckets
            self.continuationToken = continuationToken
        }

        private enum CodingKeys: String, CodingKey {
            case buckets = "Buckets"
            case continuationToken = "ContinuationToken"
        }
    }

    internal struct ListDirectoryBucketsRequest: AWSEncodableShape {
        ///  ContinuationToken indicates to Amazon S3 that the list is being continued on buckets in this account with a token. ContinuationToken is obfuscated and is not a real bucket name. You can use this ContinuationToken for the pagination of the list results.
        internal let continuationToken: String?
        /// Maximum number of buckets to be returned in response. When the number is more than the count of buckets that are owned by an Amazon Web Services account, return all the buckets in response.
        internal let maxDirectoryBuckets: Int?

        @inlinable
        internal init(continuationToken: String? = nil, maxDirectoryBuckets: Int? = nil) {
            self.continuationToken = continuationToken
            self.maxDirectoryBuckets = maxDirectoryBuckets
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodeQuery(self.continuationToken, key: "continuation-token")
            request.encodeQuery(self.maxDirectoryBuckets, key: "max-directory-buckets")
        }

        internal func validate(name: String) throws {
            try self.validate(self.continuationToken, name: "continuationToken", parent: name, max: 1024)
            try self.validate(self.maxDirectoryBuckets, name: "maxDirectoryBuckets", parent: name, max: 1000)
            try self.validate(self.maxDirectoryBuckets, name: "maxDirectoryBuckets", parent: name, min: 0)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListMultipartUploadsOutput: AWSDecodableShape {
        /// The name of the bucket to which the multipart upload was initiated. Does not return the access point ARN or access point alias if used.
        internal let bucket: String?
        /// If you specify a delimiter in the request, then the result returns each distinct key prefix containing the delimiter in a CommonPrefixes element. The distinct key prefixes are returned in the Prefix child element.   Directory buckets - For directory buckets, only prefixes that end in a delimiter (/) are supported.
        internal let commonPrefixes: [CommonPrefix]?
        /// Contains the delimiter you specified in the request. If you don't specify a delimiter in your request, this element is absent from the response.   Directory buckets - For directory buckets, / is the only supported delimiter.
        internal let delimiter: String?
        /// Encoding type used by Amazon S3 to encode object keys in the response. If you specify the encoding-type request parameter, Amazon S3 includes this element in the response, and returns encoded key name values in the following response elements:  Delimiter, KeyMarker, Prefix, NextKeyMarker, Key.
        internal let encodingType: EncodingType?
        /// Indicates whether the returned list of multipart uploads is truncated. A value of true indicates that the list was truncated. The list can be truncated if the number of multipart uploads exceeds the limit allowed or specified by max uploads.
        internal let isTruncated: Bool?
        /// The key at or after which the listing began.
        internal let keyMarker: String?
        /// Maximum number of multipart uploads that could have been included in the response.
        internal let maxUploads: Int?
        /// When a list is truncated, this element specifies the value that should be used for the key-marker request parameter in a subsequent request.
        internal let nextKeyMarker: String?
        /// When a list is truncated, this element specifies the value that should be used for the upload-id-marker request parameter in a subsequent request.  This functionality is not supported for directory buckets.
        internal let nextUploadIdMarker: String?
        /// When a prefix is provided in the request, this field contains the specified prefix. The result contains only keys starting with the specified prefix.   Directory buckets - For directory buckets, only prefixes that end in a delimiter (/) are supported.
        internal let prefix: String?
        internal let requestCharged: RequestCharged?
        /// Together with key-marker, specifies the multipart upload after which listing should begin. If key-marker is not specified, the upload-id-marker parameter is ignored. Otherwise, any multipart uploads for a key equal to the key-marker might be included in the list only if they have an upload ID lexicographically greater than the specified upload-id-marker.  This functionality is not supported for directory buckets.
        internal let uploadIdMarker: String?
        /// Container for elements related to a particular multipart upload. A response can contain zero or more Upload elements.
        internal let uploads: [MultipartUpload]?

        @inlinable
        internal init(
            bucket: String? = nil, commonPrefixes: [CommonPrefix]? = nil, delimiter: String? = nil,
            encodingType: EncodingType? = nil, isTruncated: Bool? = nil, keyMarker: String? = nil,
            maxUploads: Int? = nil, nextKeyMarker: String? = nil, nextUploadIdMarker: String? = nil,
            prefix: String? = nil, requestCharged: RequestCharged? = nil, uploadIdMarker: String? = nil,
            uploads: [MultipartUpload]? = nil
        ) {
            self.bucket = bucket
            self.commonPrefixes = commonPrefixes
            self.delimiter = delimiter
            self.encodingType = encodingType
            self.isTruncated = isTruncated
            self.keyMarker = keyMarker
            self.maxUploads = maxUploads
            self.nextKeyMarker = nextKeyMarker
            self.nextUploadIdMarker = nextUploadIdMarker
            self.prefix = prefix
            self.requestCharged = requestCharged
            self.uploadIdMarker = uploadIdMarker
            self.uploads = uploads
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.bucket = try container.decodeIfPresent(String.self, forKey: .bucket)
            self.commonPrefixes = try container.decodeIfPresent([CommonPrefix].self, forKey: .commonPrefixes)
            self.delimiter = try container.decodeIfPresent(String.self, forKey: .delimiter)
            self.encodingType = try container.decodeIfPresent(EncodingType.self, forKey: .encodingType)
            self.isTruncated = try container.decodeIfPresent(Bool.self, forKey: .isTruncated)
            self.keyMarker = try container.decodeIfPresent(String.self, forKey: .keyMarker)
            self.maxUploads = try container.decodeIfPresent(Int.self, forKey: .maxUploads)
            self.nextKeyMarker = try container.decodeIfPresent(String.self, forKey: .nextKeyMarker)
            self.nextUploadIdMarker = try container.decodeIfPresent(String.self, forKey: .nextUploadIdMarker)
            self.prefix = try container.decodeIfPresent(String.self, forKey: .prefix)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.uploadIdMarker = try container.decodeIfPresent(String.self, forKey: .uploadIdMarker)
            self.uploads = try container.decodeIfPresent([MultipartUpload].self, forKey: .uploads)
        }

        private enum CodingKeys: String, CodingKey {
            case bucket = "Bucket"
            case commonPrefixes = "CommonPrefixes"
            case delimiter = "Delimiter"
            case encodingType = "EncodingType"
            case isTruncated = "IsTruncated"
            case keyMarker = "KeyMarker"
            case maxUploads = "MaxUploads"
            case nextKeyMarker = "NextKeyMarker"
            case nextUploadIdMarker = "NextUploadIdMarker"
            case prefix = "Prefix"
            case uploadIdMarker = "UploadIdMarker"
            case uploads = "Upload"
        }
    }

    internal struct ListMultipartUploadsRequest: AWSEncodableShape {
        /// The name of the bucket to which the multipart upload was initiated.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Character you use to group keys. All keys that contain the same string between the prefix, if specified, and the first occurrence of the delimiter after the prefix are grouped under a single result element, CommonPrefixes. If you don't specify the prefix parameter, then the substring starts at the beginning of the key. The keys that are grouped under CommonPrefixes result element are not returned elsewhere in the response.   Directory buckets - For directory buckets, / is the only supported delimiter.
        internal let delimiter: String?
        internal let encodingType: EncodingType?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Specifies the multipart upload after which listing should begin.     General purpose buckets - For general purpose buckets, key-marker is an object key. Together with upload-id-marker, this parameter specifies the multipart upload after which listing should begin. If upload-id-marker is not specified, only the keys lexicographically greater than the specified key-marker will be included in the list. If upload-id-marker is specified, any multipart uploads for a key equal to the key-marker might also be included, provided those multipart uploads have upload IDs lexicographically greater than the specified upload-id-marker.    Directory buckets - For directory buckets, key-marker is obfuscated and isn't a real object key. The upload-id-marker parameter isn't supported by directory buckets. To list the additional multipart uploads, you only need to set the value of key-marker to the NextKeyMarker value from the previous response.  In the ListMultipartUploads response, the multipart uploads aren't sorted lexicographically based on the object keys.
        internal let keyMarker: String?
        /// Sets the maximum number of multipart uploads, from 1 to 1,000, to return in the response body. 1,000 is the maximum number of uploads that can be returned in a response.
        internal let maxUploads: Int?
        /// Lists in-progress uploads only for those keys that begin with the specified prefix. You can use prefixes to separate a bucket into different grouping of keys. (You can think of using prefix to make groups in the same way that you'd use a folder in a file system.)   Directory buckets - For directory buckets, only prefixes that end in a delimiter (/) are supported.
        internal let prefix: String?
        internal let requestPayer: RequestPayer?
        /// Together with key-marker, specifies the multipart upload after which listing should begin. If key-marker is not specified, the upload-id-marker parameter is ignored. Otherwise, any multipart uploads for a key equal to the key-marker might be included in the list only if they have an upload ID lexicographically greater than the specified upload-id-marker.  This functionality is not supported for directory buckets.
        internal let uploadIdMarker: String?

        @inlinable
        internal init(
            bucket: String, delimiter: String? = nil, encodingType: EncodingType? = nil,
            expectedBucketOwner: String? = nil, keyMarker: String? = nil, maxUploads: Int? = nil, prefix: String? = nil,
            requestPayer: RequestPayer? = nil, uploadIdMarker: String? = nil
        ) {
            self.bucket = bucket
            self.delimiter = delimiter
            self.encodingType = encodingType
            self.expectedBucketOwner = expectedBucketOwner
            self.keyMarker = keyMarker
            self.maxUploads = maxUploads
            self.prefix = prefix
            self.requestPayer = requestPayer
            self.uploadIdMarker = uploadIdMarker
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.delimiter, key: "delimiter")
            request.encodeQuery(self.encodingType, key: "encoding-type")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.keyMarker, key: "key-marker")
            request.encodeQuery(self.maxUploads, key: "max-uploads")
            request.encodeQuery(self.prefix, key: "prefix")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.uploadIdMarker, key: "upload-id-marker")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListObjectVersionsOutput: AWSDecodableShape {
        /// All of the keys rolled up into a common prefix count as a single return when calculating the number of returns.
        internal let commonPrefixes: [CommonPrefix]?
        /// Container for an object that is a delete marker.
        internal let deleteMarkers: [DeleteMarkerEntry]?
        /// The delimiter grouping the included keys. A delimiter is a character that you specify to group keys. All keys that contain the same string between the prefix and the first occurrence of the delimiter are grouped under a single result element in CommonPrefixes. These groups are counted as one result against the max-keys limitation. These keys are not returned elsewhere in the response.
        internal let delimiter: String?
        ///  Encoding type used by Amazon S3 to encode object key names in the XML response. If you specify the encoding-type request parameter, Amazon S3 includes this element in the response, and returns encoded key name values in the following response elements:  KeyMarker, NextKeyMarker, Prefix, Key, and Delimiter.
        internal let encodingType: EncodingType?
        /// A flag that indicates whether Amazon S3 returned all of the results that satisfied the search criteria. If your results were truncated, you can make a follow-up paginated request by using the NextKeyMarker and NextVersionIdMarker response parameters as a starting place in another request to return the rest of the results.
        internal let isTruncated: Bool?
        /// Marks the last key returned in a truncated response.
        internal let keyMarker: String?
        /// Specifies the maximum number of objects to return.
        internal let maxKeys: Int?
        /// The bucket name.
        internal let name: String?
        /// When the number of responses exceeds the value of MaxKeys, NextKeyMarker specifies the first key not returned that satisfies the search criteria. Use this value for the key-marker request parameter in a subsequent request.
        internal let nextKeyMarker: String?
        /// When the number of responses exceeds the value of MaxKeys, NextVersionIdMarker specifies the first object version not returned that satisfies the search criteria. Use this value for the version-id-marker request parameter in a subsequent request.
        internal let nextVersionIdMarker: String?
        /// Selects objects that start with the value supplied by this parameter.
        internal let prefix: String?
        internal let requestCharged: RequestCharged?
        /// Marks the last version of the key returned in a truncated response.
        internal let versionIdMarker: String?
        /// Container for version information.
        internal let versions: [ObjectVersion]?

        @inlinable
        internal init(
            commonPrefixes: [CommonPrefix]? = nil, deleteMarkers: [DeleteMarkerEntry]? = nil, delimiter: String? = nil,
            encodingType: EncodingType? = nil, isTruncated: Bool? = nil, keyMarker: String? = nil, maxKeys: Int? = nil,
            name: String? = nil, nextKeyMarker: String? = nil, nextVersionIdMarker: String? = nil,
            prefix: String? = nil, requestCharged: RequestCharged? = nil, versionIdMarker: String? = nil,
            versions: [ObjectVersion]? = nil
        ) {
            self.commonPrefixes = commonPrefixes
            self.deleteMarkers = deleteMarkers
            self.delimiter = delimiter
            self.encodingType = encodingType
            self.isTruncated = isTruncated
            self.keyMarker = keyMarker
            self.maxKeys = maxKeys
            self.name = name
            self.nextKeyMarker = nextKeyMarker
            self.nextVersionIdMarker = nextVersionIdMarker
            self.prefix = prefix
            self.requestCharged = requestCharged
            self.versionIdMarker = versionIdMarker
            self.versions = versions
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.commonPrefixes = try container.decodeIfPresent([CommonPrefix].self, forKey: .commonPrefixes)
            self.deleteMarkers = try container.decodeIfPresent([DeleteMarkerEntry].self, forKey: .deleteMarkers)
            self.delimiter = try container.decodeIfPresent(String.self, forKey: .delimiter)
            self.encodingType = try container.decodeIfPresent(EncodingType.self, forKey: .encodingType)
            self.isTruncated = try container.decodeIfPresent(Bool.self, forKey: .isTruncated)
            self.keyMarker = try container.decodeIfPresent(String.self, forKey: .keyMarker)
            self.maxKeys = try container.decodeIfPresent(Int.self, forKey: .maxKeys)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.nextKeyMarker = try container.decodeIfPresent(String.self, forKey: .nextKeyMarker)
            self.nextVersionIdMarker = try container.decodeIfPresent(String.self, forKey: .nextVersionIdMarker)
            self.prefix = try container.decodeIfPresent(String.self, forKey: .prefix)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.versionIdMarker = try container.decodeIfPresent(String.self, forKey: .versionIdMarker)
            self.versions = try container.decodeIfPresent([ObjectVersion].self, forKey: .versions)
        }

        private enum CodingKeys: String, CodingKey {
            case commonPrefixes = "CommonPrefixes"
            case deleteMarkers = "DeleteMarker"
            case delimiter = "Delimiter"
            case encodingType = "EncodingType"
            case isTruncated = "IsTruncated"
            case keyMarker = "KeyMarker"
            case maxKeys = "MaxKeys"
            case name = "Name"
            case nextKeyMarker = "NextKeyMarker"
            case nextVersionIdMarker = "NextVersionIdMarker"
            case prefix = "Prefix"
            case versionIdMarker = "VersionIdMarker"
            case versions = "Version"
        }
    }

    internal struct ListObjectVersionsRequest: AWSEncodableShape {
        /// The bucket name that contains the objects.
        internal let bucket: String
        /// A delimiter is a character that you specify to group keys. All keys that contain the same string between the prefix and the first occurrence of the delimiter are grouped under a single result element in CommonPrefixes. These groups are counted as one result against the max-keys limitation. These keys are not returned elsewhere in the response.
        internal let delimiter: String?
        internal let encodingType: EncodingType?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Specifies the key to start with when listing objects in a bucket.
        internal let keyMarker: String?
        /// Sets the maximum number of keys returned in the response. By default, the action returns up to 1,000 key names. The response might contain fewer keys but will never contain more. If additional keys satisfy the search criteria, but were not returned because max-keys was exceeded, the response contains true. To return the additional keys, see key-marker and version-id-marker.
        internal let maxKeys: Int?
        /// Specifies the optional fields that you want returned in the response. Fields that you do not specify are not returned.
        internal let optionalObjectAttributes: [OptionalObjectAttributes]?
        /// Use this parameter to select only those keys that begin with the specified prefix. You can use prefixes to separate a bucket into different groupings of keys. (You can think of using prefix to make groups in the same way that you'd use a folder in a file system.) You can use prefix with delimiter to roll up numerous objects into a single result under CommonPrefixes.
        internal let prefix: String?
        internal let requestPayer: RequestPayer?
        /// Specifies the object version you want to start listing from.
        internal let versionIdMarker: String?

        @inlinable
        internal init(
            bucket: String, delimiter: String? = nil, encodingType: EncodingType? = nil,
            expectedBucketOwner: String? = nil, keyMarker: String? = nil, maxKeys: Int? = nil,
            optionalObjectAttributes: [OptionalObjectAttributes]? = nil, prefix: String? = nil,
            requestPayer: RequestPayer? = nil, versionIdMarker: String? = nil
        ) {
            self.bucket = bucket
            self.delimiter = delimiter
            self.encodingType = encodingType
            self.expectedBucketOwner = expectedBucketOwner
            self.keyMarker = keyMarker
            self.maxKeys = maxKeys
            self.optionalObjectAttributes = optionalObjectAttributes
            self.prefix = prefix
            self.requestPayer = requestPayer
            self.versionIdMarker = versionIdMarker
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.delimiter, key: "delimiter")
            request.encodeQuery(self.encodingType, key: "encoding-type")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.keyMarker, key: "key-marker")
            request.encodeQuery(self.maxKeys, key: "max-keys")
            request.encodeHeader(self.optionalObjectAttributes, key: "x-amz-optional-object-attributes")
            request.encodeQuery(self.prefix, key: "prefix")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.versionIdMarker, key: "version-id-marker")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListObjectsOutput: AWSDecodableShape {
        /// All of the keys (up to 1,000) rolled up in a common prefix count as a single return when calculating the number of returns.  A response can contain CommonPrefixes only if you specify a delimiter.  CommonPrefixes contains all (if there are any) keys between Prefix and the next occurrence of the string specified by the delimiter.  CommonPrefixes lists keys that act like subdirectories in the directory specified by Prefix. For example, if the prefix is notes/ and the delimiter is a slash (/), as in notes/summer/july, the common prefix is notes/summer/. All of the keys that roll up into a common prefix count as a single return when calculating the number of returns.
        internal let commonPrefixes: [CommonPrefix]?
        /// Metadata about each object returned.
        internal let contents: [Object]?
        /// Causes keys that contain the same string between the prefix and the first occurrence of the delimiter to be rolled up into a single result element in the CommonPrefixes collection. These rolled-up keys are not returned elsewhere in the response. Each rolled-up result counts as only one return against the MaxKeys value.
        internal let delimiter: String?
        /// Encoding type used by Amazon S3 to encode the object keys in the response. Responses are encoded only in UTF-8. An object key can contain any Unicode character. However, the XML 1.0 parser can't parse certain characters, such as characters with an ASCII value from 0 to 10. For characters that aren't supported in XML 1.0, you can add this parameter to request that Amazon S3 encode the keys in the response. For more information about characters to avoid in object key names, see Object key naming guidelines.  When using the URL encoding type, non-ASCII characters that are used in an object's key name will be percent-encoded according to UTF-8 code values. For example, the object test_file(3).png will appear as test_file%283%29.png.
        internal let encodingType: EncodingType?
        /// A flag that indicates whether Amazon S3 returned all of the results that satisfied the search criteria.
        internal let isTruncated: Bool?
        /// Indicates where in the bucket listing begins. Marker is included in the response if it was sent with the request.
        internal let marker: String?
        /// The maximum number of keys returned in the response body.
        internal let maxKeys: Int?
        /// The bucket name.
        internal let name: String?
        /// When the response is truncated (the IsTruncated element value in the response is true), you can use the key name in this field as the marker parameter in the subsequent request to get the next set of objects. Amazon S3 lists objects in alphabetical order.   This element is returned only if you have the delimiter request parameter specified. If the response does not include the NextMarker element and it is truncated, you can use the value of the last Key element in the response as the marker parameter in the subsequent request to get the next set of object keys.
        internal let nextMarker: String?
        /// Keys that begin with the indicated prefix.
        internal let prefix: String?
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(
            commonPrefixes: [CommonPrefix]? = nil, contents: [Object]? = nil, delimiter: String? = nil,
            encodingType: EncodingType? = nil, isTruncated: Bool? = nil, marker: String? = nil, maxKeys: Int? = nil,
            name: String? = nil, nextMarker: String? = nil, prefix: String? = nil, requestCharged: RequestCharged? = nil
        ) {
            self.commonPrefixes = commonPrefixes
            self.contents = contents
            self.delimiter = delimiter
            self.encodingType = encodingType
            self.isTruncated = isTruncated
            self.marker = marker
            self.maxKeys = maxKeys
            self.name = name
            self.nextMarker = nextMarker
            self.prefix = prefix
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.commonPrefixes = try container.decodeIfPresent([CommonPrefix].self, forKey: .commonPrefixes)
            self.contents = try container.decodeIfPresent([Object].self, forKey: .contents)
            self.delimiter = try container.decodeIfPresent(String.self, forKey: .delimiter)
            self.encodingType = try container.decodeIfPresent(EncodingType.self, forKey: .encodingType)
            self.isTruncated = try container.decodeIfPresent(Bool.self, forKey: .isTruncated)
            self.marker = try container.decodeIfPresent(String.self, forKey: .marker)
            self.maxKeys = try container.decodeIfPresent(Int.self, forKey: .maxKeys)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.nextMarker = try container.decodeIfPresent(String.self, forKey: .nextMarker)
            self.prefix = try container.decodeIfPresent(String.self, forKey: .prefix)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: String, CodingKey {
            case commonPrefixes = "CommonPrefixes"
            case contents = "Contents"
            case delimiter = "Delimiter"
            case encodingType = "EncodingType"
            case isTruncated = "IsTruncated"
            case marker = "Marker"
            case maxKeys = "MaxKeys"
            case name = "Name"
            case nextMarker = "NextMarker"
            case prefix = "Prefix"
        }
    }

    internal struct ListObjectsRequest: AWSEncodableShape {
        /// The name of the bucket containing the objects.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// A delimiter is a character that you use to group keys.
        internal let delimiter: String?
        internal let encodingType: EncodingType?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Marker is where you want Amazon S3 to start listing from. Amazon S3 starts listing after this specified key. Marker can be any key in the bucket.
        internal let marker: String?
        /// Sets the maximum number of keys returned in the response. By default, the action returns up to 1,000 key names. The response might contain fewer keys but will never contain more.
        internal let maxKeys: Int?
        /// Specifies the optional fields that you want returned in the response. Fields that you do not specify are not returned.
        internal let optionalObjectAttributes: [OptionalObjectAttributes]?
        /// Limits the response to keys that begin with the specified prefix.
        internal let prefix: String?
        /// Confirms that the requester knows that she or he will be charged for the list objects request. Bucket owners need not specify this parameter in their requests.
        internal let requestPayer: RequestPayer?

        @inlinable
        internal init(
            bucket: String, delimiter: String? = nil, encodingType: EncodingType? = nil,
            expectedBucketOwner: String? = nil, marker: String? = nil, maxKeys: Int? = nil,
            optionalObjectAttributes: [OptionalObjectAttributes]? = nil, prefix: String? = nil,
            requestPayer: RequestPayer? = nil
        ) {
            self.bucket = bucket
            self.delimiter = delimiter
            self.encodingType = encodingType
            self.expectedBucketOwner = expectedBucketOwner
            self.marker = marker
            self.maxKeys = maxKeys
            self.optionalObjectAttributes = optionalObjectAttributes
            self.prefix = prefix
            self.requestPayer = requestPayer
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.delimiter, key: "delimiter")
            request.encodeQuery(self.encodingType, key: "encoding-type")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.marker, key: "marker")
            request.encodeQuery(self.maxKeys, key: "max-keys")
            request.encodeHeader(self.optionalObjectAttributes, key: "x-amz-optional-object-attributes")
            request.encodeQuery(self.prefix, key: "prefix")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListObjectsV2Output: AWSDecodableShape {
        /// All of the keys (up to 1,000) that share the same prefix are grouped together. When counting the total numbers of returns by this API operation, this group of keys is considered as one item. A response can contain CommonPrefixes only if you specify a delimiter.  CommonPrefixes contains all (if there are any) keys between Prefix and the next occurrence of the string specified by a delimiter.  CommonPrefixes lists keys that act like subdirectories in the directory specified by Prefix. For example, if the prefix is notes/ and the delimiter is a slash (/) as in notes/summer/july, the common prefix is notes/summer/. All of the keys that roll up into a common prefix count as a single return when calculating the number of returns.      Directory buckets - For directory buckets, only prefixes that end in a delimiter (/) are supported.    Directory buckets  - When you query ListObjectsV2 with a delimiter during in-progress multipart uploads, the CommonPrefixes response parameter contains the prefixes that are associated with the in-progress multipart uploads. For more information about multipart uploads, see Multipart Upload Overview in the Amazon S3 User Guide.
        internal let commonPrefixes: [CommonPrefix]?
        /// Metadata about each object returned.
        internal let contents: [Object]?
        ///  If ContinuationToken was sent with the request, it is included in the response. You can use the returned ContinuationToken for pagination of the list response. You can use this ContinuationToken for pagination of the list results.
        internal let continuationToken: String?
        /// Causes keys that contain the same string between the prefix and the first occurrence of the delimiter to be rolled up into a single result element in the CommonPrefixes collection. These rolled-up keys are not returned elsewhere in the response. Each rolled-up result counts as only one return against the MaxKeys value.   Directory buckets - For directory buckets, / is the only supported delimiter.
        internal let delimiter: String?
        /// Encoding type used by Amazon S3 to encode object key names in the XML response. If you specify the encoding-type request parameter, Amazon S3 includes this element in the response, and returns encoded key name values in the following response elements:  Delimiter, Prefix, Key, and StartAfter.
        internal let encodingType: EncodingType?
        /// Set to false if all of the results were returned. Set to true if more keys are available to return. If the number of results exceeds that specified by MaxKeys, all of the results might not be returned.
        internal let isTruncated: Bool?
        ///  KeyCount is the number of keys returned with this request. KeyCount will always be less than or equal to the MaxKeys field. For example, if you ask for 50 keys, your result will include 50 keys or fewer.
        internal let keyCount: Int?
        /// Sets the maximum number of keys returned in the response. By default, the action returns up to 1,000 key names. The response might contain fewer keys but will never contain more.
        internal let maxKeys: Int?
        /// The bucket name.
        internal let name: String?
        ///  NextContinuationToken is sent when isTruncated is true, which means there are more keys in the bucket that can be listed. The next list requests to Amazon S3 can be continued with this NextContinuationToken. NextContinuationToken is obfuscated and is not a real key
        internal let nextContinuationToken: String?
        /// Keys that begin with the indicated prefix.   Directory buckets - For directory buckets, only prefixes that end in a delimiter (/) are supported.
        internal let prefix: String?
        internal let requestCharged: RequestCharged?
        /// If StartAfter was sent with the request, it is included in the response.  This functionality is not supported for directory buckets.
        internal let startAfter: String?

        @inlinable
        internal init(
            commonPrefixes: [CommonPrefix]? = nil, contents: [Object]? = nil, continuationToken: String? = nil,
            delimiter: String? = nil, encodingType: EncodingType? = nil, isTruncated: Bool? = nil, keyCount: Int? = nil,
            maxKeys: Int? = nil, name: String? = nil, nextContinuationToken: String? = nil, prefix: String? = nil,
            requestCharged: RequestCharged? = nil, startAfter: String? = nil
        ) {
            self.commonPrefixes = commonPrefixes
            self.contents = contents
            self.continuationToken = continuationToken
            self.delimiter = delimiter
            self.encodingType = encodingType
            self.isTruncated = isTruncated
            self.keyCount = keyCount
            self.maxKeys = maxKeys
            self.name = name
            self.nextContinuationToken = nextContinuationToken
            self.prefix = prefix
            self.requestCharged = requestCharged
            self.startAfter = startAfter
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.commonPrefixes = try container.decodeIfPresent([CommonPrefix].self, forKey: .commonPrefixes)
            self.contents = try container.decodeIfPresent([Object].self, forKey: .contents)
            self.continuationToken = try container.decodeIfPresent(String.self, forKey: .continuationToken)
            self.delimiter = try container.decodeIfPresent(String.self, forKey: .delimiter)
            self.encodingType = try container.decodeIfPresent(EncodingType.self, forKey: .encodingType)
            self.isTruncated = try container.decodeIfPresent(Bool.self, forKey: .isTruncated)
            self.keyCount = try container.decodeIfPresent(Int.self, forKey: .keyCount)
            self.maxKeys = try container.decodeIfPresent(Int.self, forKey: .maxKeys)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.nextContinuationToken = try container.decodeIfPresent(String.self, forKey: .nextContinuationToken)
            self.prefix = try container.decodeIfPresent(String.self, forKey: .prefix)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.startAfter = try container.decodeIfPresent(String.self, forKey: .startAfter)
        }

        private enum CodingKeys: String, CodingKey {
            case commonPrefixes = "CommonPrefixes"
            case contents = "Contents"
            case continuationToken = "ContinuationToken"
            case delimiter = "Delimiter"
            case encodingType = "EncodingType"
            case isTruncated = "IsTruncated"
            case keyCount = "KeyCount"
            case maxKeys = "MaxKeys"
            case name = "Name"
            case nextContinuationToken = "NextContinuationToken"
            case prefix = "Prefix"
            case startAfter = "StartAfter"
        }
    }

    internal struct ListObjectsV2Request: AWSEncodableShape {
        ///  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        ///  ContinuationToken indicates to Amazon S3 that the list is being continued on this bucket with a token. ContinuationToken is obfuscated and is not a real key. You can use this ContinuationToken for pagination of the list results.
        internal let continuationToken: String?
        /// A delimiter is a character that you use to group keys.     Directory buckets - For directory buckets, / is the only supported delimiter.    Directory buckets  - When you query ListObjectsV2 with a delimiter during in-progress multipart uploads, the CommonPrefixes response parameter contains the prefixes that are associated with the in-progress multipart uploads. For more information about multipart uploads, see Multipart Upload Overview in the Amazon S3 User Guide.
        internal let delimiter: String?
        /// Encoding type used by Amazon S3 to encode the object keys in the response. Responses are encoded only in UTF-8. An object key can contain any Unicode character. However, the XML 1.0 parser can't parse certain characters, such as characters with an ASCII value from 0 to 10. For characters that aren't supported in XML 1.0, you can add this parameter to request that Amazon S3 encode the keys in the response. For more information about characters to avoid in object key names, see Object key naming guidelines.  When using the URL encoding type, non-ASCII characters that are used in an object's key name will be percent-encoded according to UTF-8 code values. For example, the object test_file(3).png will appear as test_file%283%29.png.
        internal let encodingType: EncodingType?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The owner field is not present in ListObjectsV2 by default. If you want to return the owner field with each key in the result, then set the FetchOwner field to true.   Directory buckets - For directory buckets, the bucket owner is returned as the object owner for all objects.
        internal let fetchOwner: Bool?
        /// Sets the maximum number of keys returned in the response. By default, the action returns up to 1,000 key names. The response might contain fewer keys but will never contain more.
        internal let maxKeys: Int?
        /// Specifies the optional fields that you want returned in the response. Fields that you do not specify are not returned.  This functionality is not supported for directory buckets.
        internal let optionalObjectAttributes: [OptionalObjectAttributes]?
        /// Limits the response to keys that begin with the specified prefix.   Directory buckets - For directory buckets, only prefixes that end in a delimiter (/) are supported.
        internal let prefix: String?
        /// Confirms that the requester knows that she or he will be charged for the list objects request in V2 style. Bucket owners need not specify this parameter in their requests.  This functionality is not supported for directory buckets.
        internal let requestPayer: RequestPayer?
        /// StartAfter is where you want Amazon S3 to start listing from. Amazon S3 starts listing after this specified key. StartAfter can be any key in the bucket.  This functionality is not supported for directory buckets.
        internal let startAfter: String?

        @inlinable
        internal init(
            bucket: String, continuationToken: String? = nil, delimiter: String? = nil,
            encodingType: EncodingType? = nil, expectedBucketOwner: String? = nil, fetchOwner: Bool? = nil,
            maxKeys: Int? = nil, optionalObjectAttributes: [OptionalObjectAttributes]? = nil, prefix: String? = nil,
            requestPayer: RequestPayer? = nil, startAfter: String? = nil
        ) {
            self.bucket = bucket
            self.continuationToken = continuationToken
            self.delimiter = delimiter
            self.encodingType = encodingType
            self.expectedBucketOwner = expectedBucketOwner
            self.fetchOwner = fetchOwner
            self.maxKeys = maxKeys
            self.optionalObjectAttributes = optionalObjectAttributes
            self.prefix = prefix
            self.requestPayer = requestPayer
            self.startAfter = startAfter
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.continuationToken, key: "continuation-token")
            request.encodeQuery(self.delimiter, key: "delimiter")
            request.encodeQuery(self.encodingType, key: "encoding-type")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.fetchOwner, key: "fetch-owner")
            request.encodeQuery(self.maxKeys, key: "max-keys")
            request.encodeHeader(self.optionalObjectAttributes, key: "x-amz-optional-object-attributes")
            request.encodeQuery(self.prefix, key: "prefix")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.startAfter, key: "start-after")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct ListPartsOutput: AWSDecodableShape {
        /// If the bucket has a lifecycle rule configured with an action to abort incomplete multipart uploads and the prefix in the lifecycle rule matches the object name in the request, then the response includes this header indicating when the initiated multipart upload will become eligible for abort operation. For more information, see Aborting Incomplete Multipart Uploads Using a Bucket Lifecycle Configuration. The response will also include the x-amz-abort-rule-id header that will provide the ID of the lifecycle configuration rule that defines this action.  This functionality is not supported for directory buckets.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var abortDate: Date?
        /// This header is returned along with the x-amz-abort-date header. It identifies applicable lifecycle configuration rule that defines the action to abort incomplete multipart uploads.  This functionality is not supported for directory buckets.
        internal let abortRuleId: String?
        /// The name of the bucket to which the multipart upload was initiated. Does not return the access point ARN or access point alias if used.
        internal let bucket: String?
        /// The algorithm that was used to create a checksum of the object.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// Container element that identifies who initiated the multipart upload. If the initiator is an Amazon Web Services account, this element provides the same information as the Owner element. If the initiator is an IAM User, this element provides the user ARN and display name.
        internal let initiator: Initiator?
        ///  Indicates whether the returned list of parts is truncated. A true value indicates that the list was truncated. A list can be truncated if the number of parts exceeds the limit returned in the MaxParts element.
        internal let isTruncated: Bool?
        /// Object key for which the multipart upload was initiated.
        internal let key: String?
        /// Maximum number of parts that were allowed in the response.
        internal let maxParts: Int?
        /// When a list is truncated, this element specifies the last part in the list, as well as the value to use for the part-number-marker request parameter in a subsequent request.
        internal let nextPartNumberMarker: String?
        /// Container element that identifies the object owner, after the object is created. If multipart upload is initiated by an IAM user, this element provides the parent account ID and display name.   Directory buckets - The bucket owner is returned as the object owner for all the parts.
        internal let owner: Owner?
        /// Specifies the part after which listing should begin. Only parts with higher part numbers will be listed.
        internal let partNumberMarker: String?
        /// Container for elements related to a particular part. A response can contain zero or more Part elements.
        internal let parts: [Part]?
        internal let requestCharged: RequestCharged?
        /// The class of storage used to store the uploaded object.   Directory buckets - Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let storageClass: StorageClass?
        /// Upload ID identifying the multipart upload whose parts are being listed.
        internal let uploadId: String?

        @inlinable
        internal init(
            abortDate: Date? = nil, abortRuleId: String? = nil, bucket: String? = nil,
            checksumAlgorithm: ChecksumAlgorithm? = nil, initiator: Initiator? = nil, isTruncated: Bool? = nil,
            key: String? = nil, maxParts: Int? = nil, nextPartNumberMarker: String? = nil, owner: Owner? = nil,
            partNumberMarker: String? = nil, parts: [Part]? = nil, requestCharged: RequestCharged? = nil,
            storageClass: StorageClass? = nil, uploadId: String? = nil
        ) {
            self.abortDate = abortDate
            self.abortRuleId = abortRuleId
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.initiator = initiator
            self.isTruncated = isTruncated
            self.key = key
            self.maxParts = maxParts
            self.nextPartNumberMarker = nextPartNumberMarker
            self.owner = owner
            self.partNumberMarker = partNumberMarker
            self.parts = parts
            self.requestCharged = requestCharged
            self.storageClass = storageClass
            self.uploadId = uploadId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.abortDate = try response.decodeHeaderIfPresent(Date.self, key: "x-amz-abort-date")
            self.abortRuleId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-abort-rule-id")
            self.bucket = try container.decodeIfPresent(String.self, forKey: .bucket)
            self.checksumAlgorithm = try container.decodeIfPresent(ChecksumAlgorithm.self, forKey: .checksumAlgorithm)
            self.initiator = try container.decodeIfPresent(Initiator.self, forKey: .initiator)
            self.isTruncated = try container.decodeIfPresent(Bool.self, forKey: .isTruncated)
            self.key = try container.decodeIfPresent(String.self, forKey: .key)
            self.maxParts = try container.decodeIfPresent(Int.self, forKey: .maxParts)
            self.nextPartNumberMarker = try container.decodeIfPresent(String.self, forKey: .nextPartNumberMarker)
            self.owner = try container.decodeIfPresent(Owner.self, forKey: .owner)
            self.partNumberMarker = try container.decodeIfPresent(String.self, forKey: .partNumberMarker)
            self.parts = try container.decodeIfPresent([Part].self, forKey: .parts)
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.storageClass = try container.decodeIfPresent(StorageClass.self, forKey: .storageClass)
            self.uploadId = try container.decodeIfPresent(String.self, forKey: .uploadId)
        }

        private enum CodingKeys: String, CodingKey {
            case bucket = "Bucket"
            case checksumAlgorithm = "ChecksumAlgorithm"
            case initiator = "Initiator"
            case isTruncated = "IsTruncated"
            case key = "Key"
            case maxParts = "MaxParts"
            case nextPartNumberMarker = "NextPartNumberMarker"
            case owner = "Owner"
            case partNumberMarker = "PartNumberMarker"
            case parts = "Part"
            case storageClass = "StorageClass"
            case uploadId = "UploadId"
        }
    }

    internal struct ListPartsRequest: AWSEncodableShape {
        /// The name of the bucket to which the parts are being uploaded.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Object key for which the multipart upload was initiated.
        internal let key: String
        /// Sets the maximum number of parts to return.
        internal let maxParts: Int?
        /// Specifies the part after which listing should begin. Only parts with higher part numbers will be listed.
        internal let partNumberMarker: String?
        internal let requestPayer: RequestPayer?
        /// The server-side encryption (SSE) algorithm used to encrypt the object. This parameter is needed only when the object was created  using a checksum algorithm. For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// The server-side encryption (SSE) customer managed key. This parameter is needed only when the object was created using a checksum algorithm.  For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerKey: String?
        /// The MD5 server-side encryption (SSE) customer managed key. This parameter is needed only when the object was created using a checksum  algorithm. For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// Upload ID identifying the multipart upload whose parts are being listed.
        internal let uploadId: String

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, key: String, maxParts: Int? = nil,
            partNumberMarker: String? = nil, requestPayer: RequestPayer? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil, uploadId: String
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.maxParts = maxParts
            self.partNumberMarker = partNumberMarker
            self.requestPayer = requestPayer
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.uploadId = uploadId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeQuery(self.maxParts, key: "max-parts")
            request.encodeQuery(self.partNumberMarker, key: "part-number-marker")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeQuery(self.uploadId, key: "uploadId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct LocationInfo: AWSEncodableShape {
        /// The name of the location where the bucket will be created. For directory buckets, the name of the location is the Zone ID of the Availability Zone (AZ) or Local Zone (LZ) where the bucket will be created. An example AZ ID value is usw2-az1.
        internal let name: String?
        /// The type of location where the bucket will be created.
        internal let type: LocationType?

        @inlinable
        internal init(name: String? = nil, type: LocationType? = nil) {
            self.name = name
            self.type = type
        }

        private enum CodingKeys: String, CodingKey {
            case name = "Name"
            case type = "Type"
        }
    }

    internal struct LoggingEnabled: AWSEncodableShape & AWSDecodableShape {
        internal struct _TargetGrantsEncoding: ArrayCoderProperties { internal static let member = "Grant" }

        /// Specifies the bucket where you want Amazon S3 to store server access logs. You can have your logs delivered to any bucket that you own, including the same bucket that is being logged. You can also configure multiple buckets to deliver their logs to the same target bucket. In this case, you should choose a different TargetPrefix for each source bucket so that the delivered log files can be distinguished by key.
        internal let targetBucket: String
        /// Container for granting information. Buckets that use the bucket owner enforced setting for Object Ownership don't support target grants. For more information, see Permissions for server access log delivery in the Amazon S3 User Guide.
        @OptionalCustomCoding<ArrayCoder<_TargetGrantsEncoding, TargetGrant>>
        internal var targetGrants: [TargetGrant]?
        /// Amazon S3 key format for log objects.
        internal let targetObjectKeyFormat: TargetObjectKeyFormat?
        /// A prefix for all log object keys. If you store log files from multiple Amazon S3 buckets in a single bucket, you can use a prefix to distinguish which log files came from which bucket.
        internal let targetPrefix: String

        @inlinable
        internal init(
            targetBucket: String, targetGrants: [TargetGrant]? = nil,
            targetObjectKeyFormat: TargetObjectKeyFormat? = nil, targetPrefix: String
        ) {
            self.targetBucket = targetBucket
            self.targetGrants = targetGrants
            self.targetObjectKeyFormat = targetObjectKeyFormat
            self.targetPrefix = targetPrefix
        }

        private enum CodingKeys: String, CodingKey {
            case targetBucket = "TargetBucket"
            case targetGrants = "TargetGrants"
            case targetObjectKeyFormat = "TargetObjectKeyFormat"
            case targetPrefix = "TargetPrefix"
        }
    }

    internal struct MetadataEntry: AWSEncodableShape {
        /// Name of the object.
        internal let name: String?
        /// Value of the object.
        internal let value: String?

        @inlinable
        internal init(name: String? = nil, value: String? = nil) {
            self.name = name
            self.value = value
        }

        private enum CodingKeys: String, CodingKey {
            case name = "Name"
            case value = "Value"
        }
    }

    internal struct MetadataTableConfiguration: AWSEncodableShape {
        ///  The destination information for the metadata table configuration. The destination table bucket must be in the same Region and Amazon Web Services account as the general purpose bucket. The specified metadata table name must be unique within the aws_s3_metadata namespace in the destination  table bucket.
        internal let s3TablesDestination: S3TablesDestination

        @inlinable
        internal init(s3TablesDestination: S3TablesDestination) {
            self.s3TablesDestination = s3TablesDestination
        }

        private enum CodingKeys: String, CodingKey {
            case s3TablesDestination = "S3TablesDestination"
        }
    }

    internal struct MetadataTableConfigurationResult: AWSDecodableShape {
        ///  The destination information for the metadata table configuration. The destination table bucket must be in the same Region and Amazon Web Services account as the general purpose bucket. The specified metadata table name must be unique within the aws_s3_metadata namespace in the destination  table bucket.
        internal let s3TablesDestinationResult: S3TablesDestinationResult

        @inlinable
        internal init(s3TablesDestinationResult: S3TablesDestinationResult) {
            self.s3TablesDestinationResult = s3TablesDestinationResult
        }

        private enum CodingKeys: String, CodingKey {
            case s3TablesDestinationResult = "S3TablesDestinationResult"
        }
    }

    internal struct Metrics: AWSEncodableShape & AWSDecodableShape {
        ///  A container specifying the time threshold for emitting the s3:Replication:OperationMissedThreshold event.
        internal let eventThreshold: ReplicationTimeValue?
        ///  Specifies whether the replication metrics are enabled.
        internal let status: MetricsStatus

        @inlinable
        internal init(eventThreshold: ReplicationTimeValue? = nil, status: MetricsStatus) {
            self.eventThreshold = eventThreshold
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case eventThreshold = "EventThreshold"
            case status = "Status"
        }
    }

    internal struct MetricsAndOperator: AWSEncodableShape & AWSDecodableShape {
        /// The access point ARN used when evaluating an AND predicate.
        internal let accessPointArn: String?
        /// The prefix used when evaluating an AND predicate.
        internal let prefix: String?
        /// The list of tags used when evaluating an AND predicate.
        internal let tags: [Tag]?

        @inlinable
        internal init(accessPointArn: String? = nil, prefix: String? = nil, tags: [Tag]? = nil) {
            self.accessPointArn = accessPointArn
            self.prefix = prefix
            self.tags = tags
        }

        internal func validate(name: String) throws {
            try self.tags?.forEach {
                try $0.validate(name: "\(name).tags[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case accessPointArn = "AccessPointArn"
            case prefix = "Prefix"
            case tags = "Tag"
        }
    }

    internal struct MetricsConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// Specifies a metrics configuration filter. The metrics configuration will only include objects that meet the filter's criteria. A filter must be a prefix, an object tag, an access point ARN, or a conjunction (MetricsAndOperator).
        internal let filter: MetricsFilter?
        /// The ID used to identify the metrics configuration. The ID has a 64 character limit and can only contain letters, numbers, periods, dashes, and underscores.
        internal let id: String

        @inlinable
        internal init(filter: MetricsFilter? = nil, id: String) {
            self.filter = filter
            self.id = id
        }

        internal func validate(name: String) throws {
            try self.filter?.validate(name: "\(name).filter")
        }

        private enum CodingKeys: String, CodingKey {
            case filter = "Filter"
            case id = "Id"
        }
    }

    internal struct MultipartUpload: AWSDecodableShape {
        /// The algorithm that was used to create a checksum of the object.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// Date and time at which the multipart upload was initiated.
        internal let initiated: Date?
        /// Identifies who initiated the multipart upload.
        internal let initiator: Initiator?
        /// Key of the object for which the multipart upload was initiated.
        internal let key: String?
        /// Specifies the owner of the object that is part of the multipart upload.    Directory buckets - The bucket owner is returned as the object owner for all the objects.
        internal let owner: Owner?
        /// The class of storage used to store the object.   Directory buckets - Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let storageClass: StorageClass?
        /// Upload ID that identifies the multipart upload.
        internal let uploadId: String?

        @inlinable
        internal init(
            checksumAlgorithm: ChecksumAlgorithm? = nil, initiated: Date? = nil, initiator: Initiator? = nil,
            key: String? = nil, owner: Owner? = nil, storageClass: StorageClass? = nil, uploadId: String? = nil
        ) {
            self.checksumAlgorithm = checksumAlgorithm
            self.initiated = initiated
            self.initiator = initiator
            self.key = key
            self.owner = owner
            self.storageClass = storageClass
            self.uploadId = uploadId
        }

        private enum CodingKeys: String, CodingKey {
            case checksumAlgorithm = "ChecksumAlgorithm"
            case initiated = "Initiated"
            case initiator = "Initiator"
            case key = "Key"
            case owner = "Owner"
            case storageClass = "StorageClass"
            case uploadId = "UploadId"
        }
    }

    internal struct NoncurrentVersionExpiration: AWSEncodableShape & AWSDecodableShape {
        /// Specifies how many noncurrent versions Amazon S3 will retain. You can specify up to 100 noncurrent versions to retain. Amazon S3 will permanently delete any additional noncurrent versions beyond the specified number to retain. For more information about noncurrent versions, see Lifecycle configuration elements in the Amazon S3 User Guide.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let newerNoncurrentVersions: Int?
        /// Specifies the number of days an object is noncurrent before Amazon S3 can perform the associated action. The value must be a non-zero positive integer. For information about the noncurrent days calculations, see How Amazon S3 Calculates When an Object Became Noncurrent in the Amazon S3 User Guide.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let noncurrentDays: Int?

        @inlinable
        internal init(newerNoncurrentVersions: Int? = nil, noncurrentDays: Int? = nil) {
            self.newerNoncurrentVersions = newerNoncurrentVersions
            self.noncurrentDays = noncurrentDays
        }

        private enum CodingKeys: String, CodingKey {
            case newerNoncurrentVersions = "NewerNoncurrentVersions"
            case noncurrentDays = "NoncurrentDays"
        }
    }

    internal struct NoncurrentVersionTransition: AWSEncodableShape & AWSDecodableShape {
        /// Specifies how many noncurrent versions Amazon S3 will retain in the same storage class before transitioning objects. You can specify up to 100 noncurrent versions to retain. Amazon S3 will transition any additional noncurrent versions beyond the specified number to retain. For more information about noncurrent versions, see Lifecycle configuration elements in the Amazon S3 User Guide.
        internal let newerNoncurrentVersions: Int?
        /// Specifies the number of days an object is noncurrent before Amazon S3 can perform the associated action. For information about the noncurrent days calculations, see How Amazon S3 Calculates How Long an Object Has Been Noncurrent in the Amazon S3 User Guide.
        internal let noncurrentDays: Int?
        /// The class of storage used to store the object.
        internal let storageClass: TransitionStorageClass?

        @inlinable
        internal init(
            newerNoncurrentVersions: Int? = nil, noncurrentDays: Int? = nil, storageClass: TransitionStorageClass? = nil
        ) {
            self.newerNoncurrentVersions = newerNoncurrentVersions
            self.noncurrentDays = noncurrentDays
            self.storageClass = storageClass
        }

        private enum CodingKeys: String, CodingKey {
            case newerNoncurrentVersions = "NewerNoncurrentVersions"
            case noncurrentDays = "NoncurrentDays"
            case storageClass = "StorageClass"
        }
    }

    internal struct NotificationConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// Enables delivery of events to Amazon EventBridge.
        internal let eventBridgeConfiguration: EventBridgeConfiguration?
        /// Describes the Lambda functions to invoke and the events for which to invoke them.
        internal let lambdaFunctionConfigurations: [LambdaFunctionConfiguration]?
        /// The Amazon Simple Queue Service queues to publish messages to and the events for which to publish messages.
        internal let queueConfigurations: [QueueConfiguration]?
        /// The topic to which notifications are sent and the events for which notifications are generated.
        internal let topicConfigurations: [TopicConfiguration]?

        @inlinable
        internal init(
            eventBridgeConfiguration: EventBridgeConfiguration? = nil,
            lambdaFunctionConfigurations: [LambdaFunctionConfiguration]? = nil,
            queueConfigurations: [QueueConfiguration]? = nil, topicConfigurations: [TopicConfiguration]? = nil
        ) {
            self.eventBridgeConfiguration = eventBridgeConfiguration
            self.lambdaFunctionConfigurations = lambdaFunctionConfigurations
            self.queueConfigurations = queueConfigurations
            self.topicConfigurations = topicConfigurations
        }

        private enum CodingKeys: String, CodingKey {
            case eventBridgeConfiguration = "EventBridgeConfiguration"
            case lambdaFunctionConfigurations = "CloudFunctionConfiguration"
            case queueConfigurations = "QueueConfiguration"
            case topicConfigurations = "TopicConfiguration"
        }
    }

    internal struct NotificationConfigurationFilter: AWSEncodableShape & AWSDecodableShape {
        internal let key: S3KeyFilter?

        @inlinable
        internal init(key: S3KeyFilter? = nil) {
            self.key = key
        }

        private enum CodingKeys: String, CodingKey {
            case key = "S3Key"
        }
    }

    internal struct Object: AWSDecodableShape {
        /// The algorithm that was used to create a checksum of the object.
        internal let checksumAlgorithm: [ChecksumAlgorithm]?
        /// The entity tag is a hash of the object. The ETag reflects changes only to the contents of an object, not its metadata. The ETag may or may not be an MD5 digest of the object data. Whether or not it is depends on how the object was created and how it is encrypted as described below:   Objects created by the PUT Object, POST Object, or Copy operation, or through the Amazon Web Services Management Console, and are encrypted by SSE-S3 or plaintext, have ETags that are an MD5 digest of their object data.   Objects created by the PUT Object, POST Object, or Copy operation, or through the Amazon Web Services Management Console, and are encrypted by SSE-C or SSE-KMS, have ETags that are not an MD5 digest of their object data.   If an object is created by either the Multipart Upload or Part Copy operation, the ETag is not an MD5 digest, regardless of the method of encryption. If an object is larger than 16 MB, the Amazon Web Services Management Console will upload or copy that object as a Multipart Upload, and therefore the ETag will not be an MD5 digest.     Directory buckets - MD5 is not supported by directory buckets.
        internal let eTag: String?
        /// The name that you assign to an object. You use the object key to retrieve the object.
        internal let key: String?
        /// Creation date of the object.
        internal let lastModified: Date?
        /// The owner of the object   Directory buckets - The bucket owner is returned as the object owner.
        internal let owner: Owner?
        /// Specifies the restoration status of an object. Objects in certain storage classes must be restored before they can be retrieved. For more information about these storage classes and how to work with archived objects, see  Working with archived objects in the Amazon S3 User Guide.  This functionality is not supported for directory buckets. Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let restoreStatus: RestoreStatus?
        /// Size in bytes of the object
        internal let size: Int64?
        /// The class of storage used to store the object.   Directory buckets - Only the S3 Express One Zone storage class is supported by directory buckets to store objects.
        internal let storageClass: ObjectStorageClass?

        @inlinable
        internal init(
            checksumAlgorithm: [ChecksumAlgorithm]? = nil, eTag: String? = nil, key: String? = nil,
            lastModified: Date? = nil, owner: Owner? = nil, restoreStatus: RestoreStatus? = nil, size: Int64? = nil,
            storageClass: ObjectStorageClass? = nil
        ) {
            self.checksumAlgorithm = checksumAlgorithm
            self.eTag = eTag
            self.key = key
            self.lastModified = lastModified
            self.owner = owner
            self.restoreStatus = restoreStatus
            self.size = size
            self.storageClass = storageClass
        }

        private enum CodingKeys: String, CodingKey {
            case checksumAlgorithm = "ChecksumAlgorithm"
            case eTag = "ETag"
            case key = "Key"
            case lastModified = "LastModified"
            case owner = "Owner"
            case restoreStatus = "RestoreStatus"
            case size = "Size"
            case storageClass = "StorageClass"
        }
    }

    internal struct ObjectIdentifier: AWSEncodableShape {
        /// An entity tag (ETag) is an identifier assigned by a web server to a specific version of a resource found at a URL. This header field makes the request method conditional on ETags.   Entity tags (ETags) for S3 Express One Zone are random alphanumeric strings unique to the object.
        internal let eTag: String?
        /// Key name of the object.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let key: String
        /// If present, the objects are deleted only if its modification times matches the provided Timestamp.    This functionality is only supported for directory buckets.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var lastModifiedTime: Date?
        /// If present, the objects are deleted only if its size matches the provided size in bytes.   This functionality is only supported for directory buckets.
        internal let size: Int64?
        /// Version ID for the specific version of the object to delete.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(
            eTag: String? = nil, key: String, lastModifiedTime: Date? = nil, size: Int64? = nil,
            versionId: String? = nil
        ) {
            self.eTag = eTag
            self.key = key
            self.lastModifiedTime = lastModifiedTime
            self.size = size
            self.versionId = versionId
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: String, CodingKey {
            case eTag = "ETag"
            case key = "Key"
            case lastModifiedTime = "LastModifiedTime"
            case size = "Size"
            case versionId = "VersionId"
        }
    }

    internal struct ObjectLockConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// Indicates whether this bucket has an Object Lock configuration enabled. Enable ObjectLockEnabled when you apply ObjectLockConfiguration to a bucket.
        internal let objectLockEnabled: ObjectLockEnabled?
        /// Specifies the Object Lock rule for the specified object. Enable the this rule when you apply ObjectLockConfiguration to a bucket. Bucket settings require both a mode and a period. The period can be either Days or Years but you must select one. You cannot specify Days and Years at the same time.
        internal let rule: ObjectLockRule?

        @inlinable
        internal init(objectLockEnabled: ObjectLockEnabled? = nil, rule: ObjectLockRule? = nil) {
            self.objectLockEnabled = objectLockEnabled
            self.rule = rule
        }

        private enum CodingKeys: String, CodingKey {
            case objectLockEnabled = "ObjectLockEnabled"
            case rule = "Rule"
        }
    }

    internal struct ObjectLockLegalHold: AWSEncodableShape & AWSDecodableShape {
        /// Indicates whether the specified object has a legal hold in place.
        internal let status: ObjectLockLegalHoldStatus?

        @inlinable
        internal init(status: ObjectLockLegalHoldStatus? = nil) {
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case status = "Status"
        }
    }

    internal struct ObjectLockRetention: AWSEncodableShape & AWSDecodableShape {
        /// Indicates the Retention mode for the specified object.
        internal let mode: ObjectLockRetentionMode?
        /// The date on which this Object Lock Retention will expire.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var retainUntilDate: Date?

        @inlinable
        internal init(mode: ObjectLockRetentionMode? = nil, retainUntilDate: Date? = nil) {
            self.mode = mode
            self.retainUntilDate = retainUntilDate
        }

        private enum CodingKeys: String, CodingKey {
            case mode = "Mode"
            case retainUntilDate = "RetainUntilDate"
        }
    }

    internal struct ObjectLockRule: AWSEncodableShape & AWSDecodableShape {
        /// The default Object Lock retention mode and period that you want to apply to new objects placed in the specified bucket. Bucket settings require both a mode and a period. The period can be either Days or Years but you must select one. You cannot specify Days and Years at the same time.
        internal let defaultRetention: DefaultRetention?

        @inlinable
        internal init(defaultRetention: DefaultRetention? = nil) {
            self.defaultRetention = defaultRetention
        }

        private enum CodingKeys: String, CodingKey {
            case defaultRetention = "DefaultRetention"
        }
    }

    internal struct ObjectPart: AWSDecodableShape {
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32 checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// The part number identifying the part. This value is a positive integer between 1 and 10,000.
        internal let partNumber: Int?
        /// The size of the uploaded part in bytes.
        internal let size: Int64?

        @inlinable
        internal init(
            checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil, partNumber: Int? = nil, size: Int64? = nil
        ) {
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.partNumber = partNumber
            self.size = size
        }

        private enum CodingKeys: String, CodingKey {
            case checksumCRC32 = "ChecksumCRC32"
            case checksumCRC32C = "ChecksumCRC32C"
            case checksumSHA1 = "ChecksumSHA1"
            case checksumSHA256 = "ChecksumSHA256"
            case partNumber = "PartNumber"
            case size = "Size"
        }
    }

    internal struct ObjectVersion: AWSDecodableShape {
        /// The algorithm that was used to create a checksum of the object.
        internal let checksumAlgorithm: [ChecksumAlgorithm]?
        /// The entity tag is an MD5 hash of that version of the object.
        internal let eTag: String?
        /// Specifies whether the object is (true) or is not (false) the latest version of an object.
        internal let isLatest: Bool?
        /// The object key.
        internal let key: String?
        /// Date and time when the object was last modified.
        internal let lastModified: Date?
        /// Specifies the owner of the object.
        internal let owner: Owner?
        /// Specifies the restoration status of an object. Objects in certain storage classes must be restored before they can be retrieved. For more information about these storage classes and how to work with archived objects, see  Working with archived objects in the Amazon S3 User Guide.
        internal let restoreStatus: RestoreStatus?
        /// Size in bytes of the object.
        internal let size: Int64?
        /// The class of storage used to store the object.
        internal let storageClass: ObjectVersionStorageClass?
        /// Version ID of an object.
        internal let versionId: String?

        @inlinable
        internal init(
            checksumAlgorithm: [ChecksumAlgorithm]? = nil, eTag: String? = nil, isLatest: Bool? = nil,
            key: String? = nil, lastModified: Date? = nil, owner: Owner? = nil, restoreStatus: RestoreStatus? = nil,
            size: Int64? = nil, storageClass: ObjectVersionStorageClass? = nil, versionId: String? = nil
        ) {
            self.checksumAlgorithm = checksumAlgorithm
            self.eTag = eTag
            self.isLatest = isLatest
            self.key = key
            self.lastModified = lastModified
            self.owner = owner
            self.restoreStatus = restoreStatus
            self.size = size
            self.storageClass = storageClass
            self.versionId = versionId
        }

        private enum CodingKeys: String, CodingKey {
            case checksumAlgorithm = "ChecksumAlgorithm"
            case eTag = "ETag"
            case isLatest = "IsLatest"
            case key = "Key"
            case lastModified = "LastModified"
            case owner = "Owner"
            case restoreStatus = "RestoreStatus"
            case size = "Size"
            case storageClass = "StorageClass"
            case versionId = "VersionId"
        }
    }

    internal struct OutputLocation: AWSEncodableShape {
        /// Describes an S3 location that will receive the results of the restore request.
        internal let s3: S3Location?

        @inlinable
        internal init(s3: S3Location? = nil) {
            self.s3 = s3
        }

        internal func validate(name: String) throws {
            try self.s3?.validate(name: "\(name).s3")
        }

        private enum CodingKeys: String, CodingKey {
            case s3 = "S3"
        }
    }

    internal struct OutputSerialization: AWSEncodableShape {
        /// Describes the serialization of CSV-encoded Select results.
        internal let csv: CSVOutput?
        /// Specifies JSON as request's output serialization format.
        internal let json: JSONOutput?

        @inlinable
        internal init(csv: CSVOutput? = nil, json: JSONOutput? = nil) {
            self.csv = csv
            self.json = json
        }

        private enum CodingKeys: String, CodingKey {
            case csv = "CSV"
            case json = "JSON"
        }
    }

    internal struct Owner: AWSEncodableShape & AWSDecodableShape {
        /// Container for the display name of the owner. This value is only supported in the following Amazon Web Services Regions:   US East (N. Virginia)   US West (N. California)   US West (Oregon)   Asia Pacific (Singapore)   Asia Pacific (Sydney)   Asia Pacific (Tokyo)   Europe (Ireland)   South America (São Paulo)    This functionality is not supported for directory buckets.
        internal let displayName: String?
        /// Container for the ID of the owner.
        internal let id: String?

        @inlinable
        internal init(displayName: String? = nil, id: String? = nil) {
            self.displayName = displayName
            self.id = id
        }

        private enum CodingKeys: String, CodingKey {
            case displayName = "DisplayName"
            case id = "ID"
        }
    }

    internal struct OwnershipControls: AWSEncodableShape & AWSDecodableShape {
        /// The container element for an ownership control rule.
        internal let rules: [OwnershipControlsRule]

        @inlinable
        internal init(rules: [OwnershipControlsRule]) {
            self.rules = rules
        }

        private enum CodingKeys: String, CodingKey {
            case rules = "Rule"
        }
    }

    internal struct OwnershipControlsRule: AWSEncodableShape & AWSDecodableShape {
        internal let objectOwnership: ObjectOwnership

        @inlinable
        internal init(objectOwnership: ObjectOwnership) {
            self.objectOwnership = objectOwnership
        }

        private enum CodingKeys: String, CodingKey {
            case objectOwnership = "ObjectOwnership"
        }
    }

    internal struct ParquetInput: AWSEncodableShape {
        internal init() {}
    }

    internal struct Part: AWSDecodableShape {
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32 checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 256-bit SHA-256 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Entity tag returned when the part was uploaded.
        internal let eTag: String?
        /// Date and time at which the part was uploaded.
        internal let lastModified: Date?
        /// Part number identifying the part. This is a positive integer between 1 and 10,000.
        internal let partNumber: Int?
        /// Size in bytes of the uploaded part data.
        internal let size: Int64?

        @inlinable
        internal init(
            checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil, eTag: String? = nil, lastModified: Date? = nil, partNumber: Int? = nil,
            size: Int64? = nil
        ) {
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.eTag = eTag
            self.lastModified = lastModified
            self.partNumber = partNumber
            self.size = size
        }

        private enum CodingKeys: String, CodingKey {
            case checksumCRC32 = "ChecksumCRC32"
            case checksumCRC32C = "ChecksumCRC32C"
            case checksumSHA1 = "ChecksumSHA1"
            case checksumSHA256 = "ChecksumSHA256"
            case eTag = "ETag"
            case lastModified = "LastModified"
            case partNumber = "PartNumber"
            case size = "Size"
        }
    }

    internal struct PartitionedPrefix: AWSEncodableShape & AWSDecodableShape {
        /// Specifies the partition date source for the partitioned prefix. PartitionDateSource can be EventTime or DeliveryTime. For DeliveryTime, the time in the log file names corresponds to the delivery time for the log files.  For EventTime, The logs delivered are for a specific day only. The year, month, and day correspond to the day on which the event occurred, and the hour, minutes and seconds are set to 00 in the key.
        internal let partitionDateSource: PartitionDateSource?

        @inlinable
        internal init(partitionDateSource: PartitionDateSource? = nil) {
            self.partitionDateSource = partitionDateSource
        }

        private enum CodingKeys: String, CodingKey {
            case partitionDateSource = "PartitionDateSource"
        }
    }

    internal struct PolicyStatus: AWSDecodableShape {
        /// The policy status for this bucket. TRUE indicates that this bucket is public. FALSE indicates that the bucket is not public.
        internal let isPublic: Bool?

        @inlinable
        internal init(isPublic: Bool? = nil) {
            self.isPublic = isPublic
        }

        private enum CodingKeys: String, CodingKey {
            case isPublic = "IsPublic"
        }
    }

    internal struct Progress: AWSDecodableShape {
        /// The current number of uncompressed object bytes processed.
        internal let bytesProcessed: Int64?
        /// The current number of bytes of records payload data returned.
        internal let bytesReturned: Int64?
        /// The current number of object bytes scanned.
        internal let bytesScanned: Int64?

        @inlinable
        internal init(bytesProcessed: Int64? = nil, bytesReturned: Int64? = nil, bytesScanned: Int64? = nil) {
            self.bytesProcessed = bytesProcessed
            self.bytesReturned = bytesReturned
            self.bytesScanned = bytesScanned
        }

        private enum CodingKeys: String, CodingKey {
            case bytesProcessed = "BytesProcessed"
            case bytesReturned = "BytesReturned"
            case bytesScanned = "BytesScanned"
        }
    }

    internal struct ProgressEvent: AWSDecodableShape {
        /// The Progress event details.
        internal let details: Progress

        @inlinable
        internal init(details: Progress) {
            self.details = details
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.details = try container.decode(Progress.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PublicAccessBlockConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// Specifies whether Amazon S3 should block public access control lists (ACLs) for this bucket and objects in this bucket. Setting this element to TRUE causes the following behavior:   PUT Bucket ACL and PUT Object ACL calls fail if the specified ACL is public.   PUT Object calls fail if the request includes a public ACL.   PUT Bucket calls fail if the request includes a public ACL.   Enabling this setting doesn't affect existing policies or ACLs.
        internal let blockPublicAcls: Bool?
        /// Specifies whether Amazon S3 should block public bucket policies for this bucket. Setting this element to TRUE causes Amazon S3 to reject calls to PUT Bucket policy if the specified bucket policy allows public access.  Enabling this setting doesn't affect existing bucket policies.
        internal let blockPublicPolicy: Bool?
        /// Specifies whether Amazon S3 should ignore public ACLs for this bucket and objects in this bucket. Setting this element to TRUE causes Amazon S3 to ignore all public ACLs on this bucket and objects in this bucket. Enabling this setting doesn't affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set.
        internal let ignorePublicAcls: Bool?
        /// Specifies whether Amazon S3 should restrict public bucket policies for this bucket. Setting this element to TRUE restricts access to this bucket to only Amazon Web Services service principals and authorized users within this account if the bucket has a public policy. Enabling this setting doesn't affect previously stored bucket policies, except that public and cross-account access within any public bucket policy, including non-public delegation to specific accounts, is blocked.
        internal let restrictPublicBuckets: Bool?

        @inlinable
        internal init(
            blockPublicAcls: Bool? = nil, blockPublicPolicy: Bool? = nil, ignorePublicAcls: Bool? = nil,
            restrictPublicBuckets: Bool? = nil
        ) {
            self.blockPublicAcls = blockPublicAcls
            self.blockPublicPolicy = blockPublicPolicy
            self.ignorePublicAcls = ignorePublicAcls
            self.restrictPublicBuckets = restrictPublicBuckets
        }

        private enum CodingKeys: String, CodingKey {
            case blockPublicAcls = "BlockPublicAcls"
            case blockPublicPolicy = "BlockPublicPolicy"
            case ignorePublicAcls = "IgnorePublicAcls"
            case restrictPublicBuckets = "RestrictPublicBuckets"
        }
    }

    internal struct PutBucketAccelerateConfigurationRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader]
        internal static let _xmlRootNodeName: String? = "AccelerateConfiguration"
        /// Container for setting the transfer acceleration state.
        internal let accelerateConfiguration: AccelerateConfiguration
        /// The name of the bucket for which the accelerate configuration is set.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(
            accelerateConfiguration: AccelerateConfiguration, bucket: String,
            checksumAlgorithm: ChecksumAlgorithm? = nil, expectedBucketOwner: String? = nil
        ) {
            self.accelerateConfiguration = accelerateConfiguration
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            try container.encode(self.accelerateConfiguration)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketAclRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "AccessControlPolicy"
        /// Contains the elements that set the ACL permissions for an object per grantee.
        internal let accessControlPolicy: AccessControlPolicy?
        /// The canned ACL to apply to the bucket.
        internal let acl: BucketCannedACL?
        /// The bucket to which to apply the ACL.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The base64-encoded 128-bit MD5 digest of the data. This header must be used as a message integrity check to verify that the request body was not corrupted in transit. For more information, go to RFC 1864.  For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Allows grantee the read, write, read ACP, and write ACP permissions on the bucket.
        internal let grantFullControl: String?
        /// Allows grantee to list the objects in the bucket.
        internal let grantRead: String?
        /// Allows grantee to read the bucket ACL.
        internal let grantReadACP: String?
        /// Allows grantee to create new objects in the bucket. For the bucket and object owners of existing objects, also allows deletions and overwrites of those objects.
        internal let grantWrite: String?
        /// Allows grantee to write the ACL for the applicable bucket.
        internal let grantWriteACP: String?

        @inlinable
        internal init(
            accessControlPolicy: AccessControlPolicy? = nil, acl: BucketCannedACL? = nil, bucket: String,
            checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil, expectedBucketOwner: String? = nil,
            grantFullControl: String? = nil, grantRead: String? = nil, grantReadACP: String? = nil,
            grantWrite: String? = nil, grantWriteACP: String? = nil
        ) {
            self.accessControlPolicy = accessControlPolicy
            self.acl = acl
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.grantFullControl = grantFullControl
            self.grantRead = grantRead
            self.grantReadACP = grantReadACP
            self.grantWrite = grantWrite
            self.grantWriteACP = grantWriteACP
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            try container.encode(self.accessControlPolicy)
            request.encodeHeader(self.acl, key: "x-amz-acl")
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.grantFullControl, key: "x-amz-grant-full-control")
            request.encodeHeader(self.grantRead, key: "x-amz-grant-read")
            request.encodeHeader(self.grantReadACP, key: "x-amz-grant-read-acp")
            request.encodeHeader(self.grantWrite, key: "x-amz-grant-write")
            request.encodeHeader(self.grantWriteACP, key: "x-amz-grant-write-acp")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketAnalyticsConfigurationRequest: AWSEncodableShape {
        internal static let _xmlRootNodeName: String? = "AnalyticsConfiguration"
        /// The configuration and any analyses for the analytics filter.
        internal let analyticsConfiguration: AnalyticsConfiguration
        /// The name of the bucket to which an analytics configuration is stored.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID that identifies the analytics configuration.
        internal let id: String

        @inlinable
        internal init(
            analyticsConfiguration: AnalyticsConfiguration, bucket: String, expectedBucketOwner: String? = nil,
            id: String
        ) {
            self.analyticsConfiguration = analyticsConfiguration
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            try container.encode(self.analyticsConfiguration)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
        }

        internal func validate(name: String) throws {
            try self.analyticsConfiguration.validate(name: "\(name).analyticsConfiguration")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketCorsRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "CORSConfiguration"
        /// Specifies the bucket impacted by the corsconfiguration.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The base64-encoded 128-bit MD5 digest of the data. This header must be used as a message integrity check to verify that the request body was not corrupted in transit. For more information, go to RFC 1864.  For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// Describes the cross-origin access configuration for objects in an Amazon S3 bucket. For more information, see Enabling Cross-Origin Resource Sharing in the Amazon S3 User Guide.
        internal let corsConfiguration: CORSConfiguration
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            corsConfiguration: CORSConfiguration, expectedBucketOwner: String? = nil
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.corsConfiguration = corsConfiguration
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            try container.encode(self.corsConfiguration)
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketEncryptionRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "ServerSideEncryptionConfiguration"
        /// Specifies default encryption for a bucket using server-side encryption with different key options.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.  For directory buckets, when you use Amazon Web Services SDKs, CRC32 is the default checksum algorithm that's used for performance.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The base64-encoded 128-bit MD5 digest of the server-side encryption configuration. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.  This functionality is not supported for directory buckets.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  For directory buckets, this header is not supported in this API operation. If you specify this header, the request fails with the HTTP status code
        /// 501 Not Implemented.
        internal let expectedBucketOwner: String?
        internal let serverSideEncryptionConfiguration: ServerSideEncryptionConfiguration

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, serverSideEncryptionConfiguration: ServerSideEncryptionConfiguration
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.serverSideEncryptionConfiguration = serverSideEncryptionConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.serverSideEncryptionConfiguration)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketIntelligentTieringConfigurationRequest: AWSEncodableShape {
        internal static let _xmlRootNodeName: String? = "IntelligentTieringConfiguration"
        /// The name of the Amazon S3 bucket whose configuration you want to modify or retrieve.
        internal let bucket: String
        /// The ID used to identify the S3 Intelligent-Tiering configuration.
        internal let id: String
        /// Container for S3 Intelligent-Tiering configuration.
        internal let intelligentTieringConfiguration: IntelligentTieringConfiguration

        @inlinable
        internal init(bucket: String, id: String, intelligentTieringConfiguration: IntelligentTieringConfiguration) {
            self.bucket = bucket
            self.id = id
            self.intelligentTieringConfiguration = intelligentTieringConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeQuery(self.id, key: "id")
            try container.encode(self.intelligentTieringConfiguration)
        }

        internal func validate(name: String) throws {
            try self.intelligentTieringConfiguration.validate(name: "\(name).intelligentTieringConfiguration")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketInventoryConfigurationRequest: AWSEncodableShape {
        internal static let _xmlRootNodeName: String? = "InventoryConfiguration"
        /// The name of the bucket where the inventory configuration will be stored.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID used to identify the inventory configuration.
        internal let id: String
        /// Specifies the inventory configuration.
        internal let inventoryConfiguration: InventoryConfiguration

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, id: String,
            inventoryConfiguration: InventoryConfiguration
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
            self.inventoryConfiguration = inventoryConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
            try container.encode(self.inventoryConfiguration)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketLifecycleConfigurationOutput: AWSDecodableShape {
        /// Indicates which default minimum object size behavior is applied to the lifecycle configuration.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.     all_storage_classes_128K - Objects smaller than 128 KB will not transition to any storage class by default.     varies_by_storage_class - Objects smaller than 128 KB will transition to Glacier Flexible Retrieval or Glacier Deep Archive storage classes. By default, all other storage classes will prevent transitions smaller than 128 KB.    To customize the minimum object size for any transition you can add a filter that specifies a custom ObjectSizeGreaterThan or ObjectSizeLessThan in the body of your transition rule. Custom filters always take precedence over the default transition behavior.
        internal let transitionDefaultMinimumObjectSize: TransitionDefaultMinimumObjectSize?

        @inlinable
        internal init(transitionDefaultMinimumObjectSize: TransitionDefaultMinimumObjectSize? = nil) {
            self.transitionDefaultMinimumObjectSize = transitionDefaultMinimumObjectSize
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.transitionDefaultMinimumObjectSize = try response.decodeHeaderIfPresent(
                TransitionDefaultMinimumObjectSize.self, key: "x-amz-transition-default-minimum-object-size")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketLifecycleConfigurationRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired]
        internal static let _xmlRootNodeName: String? = "LifecycleConfiguration"
        /// The name of the bucket for which to set the configuration.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.
        internal let expectedBucketOwner: String?
        /// Container for lifecycle rules. You can add as many as 1,000 rules.
        internal let lifecycleConfiguration: BucketLifecycleConfiguration?
        /// Indicates which default minimum object size behavior is applied to the lifecycle configuration.  This parameter applies to general purpose buckets only. It is not supported for directory bucket lifecycle configurations.     all_storage_classes_128K - Objects smaller than 128 KB will not transition to any storage class by default.     varies_by_storage_class - Objects smaller than 128 KB will transition to Glacier Flexible Retrieval or Glacier Deep Archive storage classes. By default, all other storage classes will prevent transitions smaller than 128 KB.    To customize the minimum object size for any transition you can add a filter that specifies a custom ObjectSizeGreaterThan or ObjectSizeLessThan in the body of your transition rule. Custom filters always take precedence over the default transition behavior.
        internal let transitionDefaultMinimumObjectSize: TransitionDefaultMinimumObjectSize?

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, expectedBucketOwner: String? = nil,
            lifecycleConfiguration: BucketLifecycleConfiguration? = nil,
            transitionDefaultMinimumObjectSize: TransitionDefaultMinimumObjectSize? = nil
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.expectedBucketOwner = expectedBucketOwner
            self.lifecycleConfiguration = lifecycleConfiguration
            self.transitionDefaultMinimumObjectSize = transitionDefaultMinimumObjectSize
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.lifecycleConfiguration)
            request.encodeHeader(
                self.transitionDefaultMinimumObjectSize, key: "x-amz-transition-default-minimum-object-size")
        }

        internal func validate(name: String) throws {
            try self.lifecycleConfiguration?.validate(name: "\(name).lifecycleConfiguration")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketLoggingRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "BucketLoggingStatus"
        /// The name of the bucket for which to set the logging parameters.
        internal let bucket: String
        /// Container for logging status information.
        internal let bucketLoggingStatus: BucketLoggingStatus
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The MD5 hash of the PutBucketLogging request body. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?

        @inlinable
        internal init(
            bucket: String, bucketLoggingStatus: BucketLoggingStatus, checksumAlgorithm: ChecksumAlgorithm? = nil,
            contentMD5: String? = nil, expectedBucketOwner: String? = nil
        ) {
            self.bucket = bucket
            self.bucketLoggingStatus = bucketLoggingStatus
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            try container.encode(self.bucketLoggingStatus)
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketMetricsConfigurationRequest: AWSEncodableShape {
        internal static let _xmlRootNodeName: String? = "MetricsConfiguration"
        /// The name of the bucket for which the metrics configuration is set.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The ID used to identify the metrics configuration. The ID has a 64 character limit and can only contain letters, numbers, periods, dashes, and underscores.
        internal let id: String
        /// Specifies the metrics configuration.
        internal let metricsConfiguration: MetricsConfiguration

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, id: String, metricsConfiguration: MetricsConfiguration
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.id = id
            self.metricsConfiguration = metricsConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeQuery(self.id, key: "id")
            try container.encode(self.metricsConfiguration)
        }

        internal func validate(name: String) throws {
            try self.metricsConfiguration.validate(name: "\(name).metricsConfiguration")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketNotificationConfigurationRequest: AWSEncodableShape {
        internal static let _xmlRootNodeName: String? = "NotificationConfiguration"
        /// The name of the bucket.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        internal let notificationConfiguration: NotificationConfiguration
        /// Skips validation of Amazon SQS, Amazon SNS, and Lambda destinations. True or false value.
        internal let skipDestinationValidation: Bool?

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, notificationConfiguration: NotificationConfiguration,
            skipDestinationValidation: Bool? = nil
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.notificationConfiguration = notificationConfiguration
            self.skipDestinationValidation = skipDestinationValidation
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.notificationConfiguration)
            request.encodeHeader(self.skipDestinationValidation, key: "x-amz-skip-destination-validation")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketOwnershipControlsRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "OwnershipControls"
        /// The name of the Amazon S3 bucket whose OwnershipControls you want to set.
        internal let bucket: String
        /// The MD5 hash of the OwnershipControls request body.  For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The OwnershipControls (BucketOwnerEnforced, BucketOwnerPreferred, or ObjectWriter) that you want to apply to this Amazon S3 bucket.
        internal let ownershipControls: OwnershipControls

        @inlinable
        internal init(
            bucket: String, contentMD5: String? = nil, expectedBucketOwner: String? = nil,
            ownershipControls: OwnershipControls
        ) {
            self.bucket = bucket
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.ownershipControls = ownershipControls
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.ownershipControls)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketPolicyRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "Policy"
        /// The name of the bucket.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum-algorithm or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For the x-amz-checksum-algorithm header, replace  algorithm with the supported algorithm from the following list:     CRC32     CRC32C     SHA1     SHA256    For more information, see Checking object integrity in the Amazon S3 User Guide. If the individual checksum value you provide through x-amz-checksum-algorithm doesn't match the checksum algorithm you set through x-amz-sdk-checksum-algorithm,  Amazon S3 ignores any provided ChecksumAlgorithm parameter and uses the checksum algorithm that matches the provided value in x-amz-checksum-algorithm .  For directory buckets, when you use Amazon Web Services SDKs, CRC32 is the default checksum algorithm that's used for performance.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// Set this parameter to true to confirm that you want to remove your permissions to change this bucket policy in the future.  This functionality is not supported for directory buckets.
        internal let confirmRemoveSelfBucketAccess: Bool?
        /// The MD5 hash of the request body. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.  This functionality is not supported for directory buckets.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).  For directory buckets, this header is not supported in this API operation. If you specify this header, the request fails with the HTTP status code
        /// 501 Not Implemented.
        internal let expectedBucketOwner: String?
        /// The bucket policy as a JSON document. For directory buckets, the only IAM action supported in the bucket policy is s3express:CreateSession.
        internal let policy: String

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, confirmRemoveSelfBucketAccess: Bool? = nil,
            contentMD5: String? = nil, expectedBucketOwner: String? = nil, policy: String
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.confirmRemoveSelfBucketAccess = confirmRemoveSelfBucketAccess
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.policy = policy
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.confirmRemoveSelfBucketAccess, key: "x-amz-confirm-remove-self-bucket-access")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.policy)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketReplicationRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "ReplicationConfiguration"
        /// The name of the bucket
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see RFC 1864. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        internal let replicationConfiguration: ReplicationConfiguration
        /// A token to allow Object Lock to be enabled for an existing bucket.
        internal let token: String?

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, replicationConfiguration: ReplicationConfiguration, token: String? = nil
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.replicationConfiguration = replicationConfiguration
            self.token = token
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.replicationConfiguration)
            request.encodeHeader(self.token, key: "x-amz-bucket-object-lock-token")
        }

        internal func validate(name: String) throws {
            try self.replicationConfiguration.validate(name: "\(name).replicationConfiguration")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketRequestPaymentRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "RequestPaymentConfiguration"
        /// The bucket name.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see RFC 1864. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Container for Payer.
        internal let requestPaymentConfiguration: RequestPaymentConfiguration

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, requestPaymentConfiguration: RequestPaymentConfiguration
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.requestPaymentConfiguration = requestPaymentConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.requestPaymentConfiguration)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketTaggingRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "Tagging"
        /// The bucket name.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see RFC 1864. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Container for the TagSet and Tag elements.
        internal let tagging: Tagging

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, tagging: Tagging
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.tagging = tagging
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.tagging)
        }

        internal func validate(name: String) throws {
            try self.tagging.validate(name: "\(name).tagging")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketVersioningRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "VersioningConfiguration"
        /// The bucket name.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// >The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see RFC 1864. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device.
        internal let mfa: String?
        /// Container for setting the versioning state.
        internal let versioningConfiguration: VersioningConfiguration

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, mfa: String? = nil, versioningConfiguration: VersioningConfiguration
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.mfa = mfa
            self.versioningConfiguration = versioningConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.mfa, key: "x-amz-mfa")
            try container.encode(self.versioningConfiguration)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutBucketWebsiteRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "WebsiteConfiguration"
        /// The bucket name.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The base64-encoded 128-bit MD5 digest of the data. You must use this header as a message integrity check to verify that the request body was not corrupted in transit. For more information, see RFC 1864. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Container for the request.
        internal let websiteConfiguration: WebsiteConfiguration

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, websiteConfiguration: WebsiteConfiguration
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.websiteConfiguration = websiteConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.websiteConfiguration)
        }

        internal func validate(name: String) throws {
            try self.websiteConfiguration.validate(name: "\(name).websiteConfiguration")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectAclOutput: AWSDecodableShape {
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(requestCharged: RequestCharged? = nil) {
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectAclRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "AccessControlPolicy"
        /// Contains the elements that set the ACL permissions for an object per grantee.
        internal let accessControlPolicy: AccessControlPolicy?
        /// The canned ACL to apply to the object. For more information, see Canned ACL.
        internal let acl: ObjectCannedACL?
        /// The bucket name that contains the object to which you want to attach the ACL.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The base64-encoded 128-bit MD5 digest of the data. This header must be used as a message integrity check to verify that the request body was not corrupted in transit. For more information, go to RFC 1864.>  For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Allows grantee the read, write, read ACP, and write ACP permissions on the bucket. This functionality is not supported for Amazon S3 on Outposts.
        internal let grantFullControl: String?
        /// Allows grantee to list the objects in the bucket. This functionality is not supported for Amazon S3 on Outposts.
        internal let grantRead: String?
        /// Allows grantee to read the bucket ACL. This functionality is not supported for Amazon S3 on Outposts.
        internal let grantReadACP: String?
        /// Allows grantee to create new objects in the bucket. For the bucket and object owners of existing objects, also allows deletions and overwrites of those objects.
        internal let grantWrite: String?
        /// Allows grantee to write the ACL for the applicable bucket. This functionality is not supported for Amazon S3 on Outposts.
        internal let grantWriteACP: String?
        /// Key for which the PUT action was initiated.
        internal let key: String
        internal let requestPayer: RequestPayer?
        /// Version ID used to reference a specific version of the object.  This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(
            accessControlPolicy: AccessControlPolicy? = nil, acl: ObjectCannedACL? = nil, bucket: String,
            checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil, expectedBucketOwner: String? = nil,
            grantFullControl: String? = nil, grantRead: String? = nil, grantReadACP: String? = nil,
            grantWrite: String? = nil, grantWriteACP: String? = nil, key: String, requestPayer: RequestPayer? = nil,
            versionId: String? = nil
        ) {
            self.accessControlPolicy = accessControlPolicy
            self.acl = acl
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.grantFullControl = grantFullControl
            self.grantRead = grantRead
            self.grantReadACP = grantReadACP
            self.grantWrite = grantWrite
            self.grantWriteACP = grantWriteACP
            self.key = key
            self.requestPayer = requestPayer
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            try container.encode(self.accessControlPolicy)
            request.encodeHeader(self.acl, key: "x-amz-acl")
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.grantFullControl, key: "x-amz-grant-full-control")
            request.encodeHeader(self.grantRead, key: "x-amz-grant-read")
            request.encodeHeader(self.grantReadACP, key: "x-amz-grant-read-acp")
            request.encodeHeader(self.grantWrite, key: "x-amz-grant-write")
            request.encodeHeader(self.grantWriteACP, key: "x-amz-grant-write-acp")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectLegalHoldOutput: AWSDecodableShape {
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(requestCharged: RequestCharged? = nil) {
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectLegalHoldRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "LegalHold"
        /// The bucket name containing the object that you want to place a legal hold on.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The MD5 hash for the request body. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The key name for the object that you want to place a legal hold on.
        internal let key: String
        /// Container element for the legal hold configuration you want to apply to the specified object.
        internal let legalHold: ObjectLockLegalHold?
        internal let requestPayer: RequestPayer?
        /// The version ID of the object that you want to place a legal hold on.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, key: String, legalHold: ObjectLockLegalHold? = nil,
            requestPayer: RequestPayer? = nil, versionId: String? = nil
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.legalHold = legalHold
            self.requestPayer = requestPayer
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            try container.encode(self.legalHold)
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectLockConfigurationOutput: AWSDecodableShape {
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(requestCharged: RequestCharged? = nil) {
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectLockConfigurationRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "ObjectLockConfiguration"
        /// The bucket whose Object Lock configuration you want to create or replace.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The MD5 hash for the request body. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The Object Lock configuration that you want to apply to the specified bucket.
        internal let objectLockConfiguration: ObjectLockConfiguration?
        internal let requestPayer: RequestPayer?
        /// A token to allow Object Lock to be enabled for an existing bucket.
        internal let token: String?

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, objectLockConfiguration: ObjectLockConfiguration? = nil,
            requestPayer: RequestPayer? = nil, token: String? = nil
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.objectLockConfiguration = objectLockConfiguration
            self.requestPayer = requestPayer
            self.token = token
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.objectLockConfiguration)
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.token, key: "x-amz-bucket-object-lock-token")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectOutput: AWSDecodableShape {
        /// Indicates whether the uploaded object uses an S3 Bucket Key for server-side encryption with Key Management Service (KMS) keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Entity tag for the uploaded object.  General purpose buckets  - To ensure that data is not corrupted traversing the network, for objects where the ETag is the MD5 digest of the object, you can calculate the MD5 while putting an object to Amazon S3 and compare the returned ETag to the calculated MD5 value.  Directory buckets  - The ETag for the object in a directory bucket isn't the MD5 digest of the object.
        internal let eTag: String?
        /// If the expiration is configured for the object (see PutBucketLifecycleConfiguration) in the Amazon S3 User Guide, the response includes this header. It includes the expiry-date and rule-id key-value pairs that provide information about object expiration. The value of the rule-id is URL-encoded.  Object expiration information is not returned in directory buckets and this header returns the value "NotImplemented" in all responses for directory buckets.
        internal let expiration: String?
        internal let requestCharged: RequestCharged?
        /// The server-side encryption algorithm used when you store this object in Amazon S3.
        internal let serverSideEncryption: ServerSideEncryption?
        ///  The size of the object in bytes. This will only be present if you append to an object.   This functionality is only supported for objects in the Amazon S3 Express One Zone storage class in directory buckets.
        internal let size: Int64?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to confirm the encryption algorithm that's used.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide the round-trip message integrity verification of the customer-provided encryption key.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// If present, indicates the Amazon Web Services KMS Encryption Context to use for object encryption. The value of this header is a Base64-encoded string of a UTF-8 encoded JSON, which contains the encryption context as key-value pairs.  This value is stored as object metadata and automatically gets passed on to Amazon Web Services KMS for future GetObject  operations on this object.
        internal let ssekmsEncryptionContext: String?
        /// If present, indicates the ID of the KMS key that was used for object encryption.
        internal let ssekmsKeyId: String?
        /// Version ID of the object. If you enable versioning for a bucket, Amazon S3 automatically generates a unique version ID for the object being stored. Amazon S3 returns this ID in the response. When you enable versioning for a bucket, if Amazon S3 receives multiple write requests for the same object simultaneously, it stores all of the objects. For more information about versioning, see Adding Objects to Versioning-Enabled Buckets in the Amazon S3 User Guide. For information about returning the versioning state of a bucket, see GetBucketVersioning.   This functionality is not supported for directory buckets.
        internal let versionId: String?

        @inlinable
        internal init(
            bucketKeyEnabled: Bool? = nil, checksumCRC32: String? = nil, checksumCRC32C: String? = nil,
            checksumSHA1: String? = nil, checksumSHA256: String? = nil, eTag: String? = nil, expiration: String? = nil,
            requestCharged: RequestCharged? = nil, serverSideEncryption: ServerSideEncryption? = nil,
            size: Int64? = nil, sseCustomerAlgorithm: String? = nil, sseCustomerKeyMD5: String? = nil,
            ssekmsEncryptionContext: String? = nil, ssekmsKeyId: String? = nil, versionId: String? = nil
        ) {
            self.bucketKeyEnabled = bucketKeyEnabled
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.eTag = eTag
            self.expiration = expiration
            self.requestCharged = requestCharged
            self.serverSideEncryption = serverSideEncryption
            self.size = size
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsEncryptionContext = ssekmsEncryptionContext
            self.ssekmsKeyId = ssekmsKeyId
            self.versionId = versionId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.checksumCRC32 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-crc32")
            self.checksumCRC32C = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-crc32c")
            self.checksumSHA1 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-sha1")
            self.checksumSHA256 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-sha256")
            self.eTag = try response.decodeHeaderIfPresent(String.self, key: "ETag")
            self.expiration = try response.decodeHeaderIfPresent(String.self, key: "x-amz-expiration")
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.size = try response.decodeHeaderIfPresent(Int64.self, key: "x-amz-object-size")
            self.sseCustomerAlgorithm = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-algorithm")
            self.sseCustomerKeyMD5 = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-key-MD5")
            self.ssekmsEncryptionContext = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-context")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .md5ChecksumHeader, .allowStreaming]
        internal static let _xmlRootNodeName: String? = "Body"
        /// The canned ACL to apply to the object. For more information, see Canned ACL in the Amazon S3 User Guide. When adding a new object, you can use headers to grant ACL-based permissions to individual Amazon Web Services accounts or to predefined groups defined by Amazon S3. These permissions are then added to the ACL on the object. By default, all objects are private. Only the owner has full access control. For more information, see Access Control List (ACL) Overview and Managing ACLs Using the REST API in the Amazon S3 User Guide. If the bucket that you're uploading objects to uses the bucket owner enforced setting for S3 Object Ownership, ACLs are disabled and no longer affect permissions. Buckets that use this setting only accept PUT requests that don't specify an ACL or PUT requests that specify bucket owner full control ACLs, such as the bucket-owner-full-control canned ACL or an equivalent form of this ACL expressed in the XML format. PUT requests that contain other ACLs (for example, custom grants to certain Amazon Web Services accounts) fail and return a 400 error with the error code AccessControlListNotSupported. For more information, see  Controlling ownership of objects and disabling ACLs in the Amazon S3 User Guide.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let acl: ObjectCannedACL?
        /// Object data.
        internal let body: AWSHTTPBody?
        /// The bucket name to which the PUT action was initiated.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Specifies whether Amazon S3 should use an S3 Bucket Key for object encryption with server-side encryption using Key Management Service (KMS) keys (SSE-KMS).  General purpose buckets - Setting this header to true causes Amazon S3 to use an S3 Bucket Key for object encryption with SSE-KMS. Also, specifying this header with a PUT action doesn't affect bucket-level settings for S3 Bucket Key.  Directory buckets - S3 Bucket Keys are always enabled for GET and PUT operations in a directory bucket and can’t be disabled. S3 Bucket Keys aren't supported, when you copy SSE-KMS encrypted objects from general purpose buckets
        /// to directory buckets, from directory buckets to general purpose buckets, or between directory buckets, through CopyObject, UploadPartCopy, the Copy operation in Batch Operations, or  the import jobs. In this case, Amazon S3 makes a call to KMS every time a copy request is made for a KMS-encrypted object.
        internal let bucketKeyEnabled: Bool?
        /// Can be used to specify caching behavior along the request/reply chain. For more information, see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9.
        internal let cacheControl: String?
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum-algorithm or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For the x-amz-checksum-algorithm header, replace  algorithm with the supported algorithm from the following list:     CRC32     CRC32C     SHA1     SHA256    For more information, see Checking object integrity in the Amazon S3 User Guide. If the individual checksum value you provide through x-amz-checksum-algorithm doesn't match the checksum algorithm you set through x-amz-sdk-checksum-algorithm,  Amazon S3 ignores any provided ChecksumAlgorithm parameter and uses the checksum algorithm that matches the provided value in x-amz-checksum-algorithm .  The Content-MD5 or x-amz-sdk-checksum-algorithm header is required for any request to upload an object with a retention period configured using Amazon S3 Object Lock. For more information, see Uploading objects to an Object Lock enabled bucket  in the Amazon S3 User Guide.  For directory buckets, when you use Amazon Web Services SDKs, CRC32 is the default checksum algorithm that's used for performance.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32 checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32C checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 160-bit SHA-1 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 256-bit SHA-256 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Specifies presentational information for the object. For more information, see https://www.rfc-editor.org/rfc/rfc6266#section-4.
        internal let contentDisposition: String?
        /// Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field. For more information, see https://www.rfc-editor.org/rfc/rfc9110.html#field.content-encoding.
        internal let contentEncoding: String?
        /// The language the content is in.
        internal let contentLanguage: String?
        /// Size of the body in bytes. This parameter is useful when the size of the body cannot be determined automatically. For more information, see https://www.rfc-editor.org/rfc/rfc9110.html#name-content-length.
        internal let contentLength: Int64?
        /// The base64-encoded 128-bit MD5 digest of the message (without the headers) according to RFC 1864. This header can be used as a message integrity check to verify that the data is the same data that was originally sent. Although it is optional, we recommend using the Content-MD5 mechanism as an end-to-end integrity check. For more information about REST request authentication, see REST Authentication.  The Content-MD5 or x-amz-sdk-checksum-algorithm header is required for any request to upload an object with a retention period configured using Amazon S3 Object Lock. For more information, see Uploading objects to an Object Lock enabled bucket  in the Amazon S3 User Guide.   This functionality is not supported for directory buckets.
        internal let contentMD5: String?
        /// A standard MIME type describing the format of the contents. For more information, see https://www.rfc-editor.org/rfc/rfc9110.html#name-content-type.
        internal let contentType: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The date and time at which the object is no longer cacheable. For more information, see https://www.rfc-editor.org/rfc/rfc7234#section-5.3.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var expires: Date?
        /// Gives the grantee READ, READ_ACP, and WRITE_ACP permissions on the object.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantFullControl: String?
        /// Allows grantee to read the object data and its metadata.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantRead: String?
        /// Allows grantee to read the object ACL.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantReadACP: String?
        /// Allows grantee to write the ACL for the applicable object.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
        internal let grantWriteACP: String?
        /// Uploads the object only if the ETag (entity tag) value provided during the WRITE operation matches the ETag of the object in S3. If the ETag values do not match, the operation returns a 412 Precondition Failed error. If a conflicting operation occurs during the upload S3 returns a 409 ConditionalRequestConflict response. On a 409 failure you should fetch the object's ETag and retry the upload. Expects the ETag value as a string. For more information about conditional requests, see RFC 7232, or Conditional requests in the Amazon S3 User Guide.
        internal let ifMatch: String?
        /// Uploads the object only if the object key name does not already exist in the bucket specified. Otherwise, Amazon S3 returns a 412 Precondition Failed error. If a conflicting operation occurs during the upload S3 returns a 409 ConditionalRequestConflict response. On a 409 failure you should retry the upload. Expects the '*' (asterisk) character. For more information about conditional requests, see RFC 7232, or Conditional requests in the Amazon S3 User Guide.
        internal let ifNoneMatch: String?
        /// Object key for which the PUT action was initiated.
        internal let key: String
        /// A map of metadata to store with the object in S3.
        internal let metadata: [String: String]?
        /// Specifies whether a legal hold will be applied to this object. For more information about S3 Object Lock, see Object Lock in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
        internal let objectLockLegalHoldStatus: ObjectLockLegalHoldStatus?
        /// The Object Lock mode that you want to apply to this object.  This functionality is not supported for directory buckets.
        internal let objectLockMode: ObjectLockMode?
        /// The date and time when you want this object's Object Lock to expire. Must be formatted as a timestamp parameter.  This functionality is not supported for directory buckets.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var objectLockRetainUntilDate: Date?
        internal let requestPayer: RequestPayer?
        /// The server-side encryption algorithm that was used when you store this object in Amazon S3 (for example, AES256, aws:kms, aws:kms:dsse).    General purpose buckets  - You have four mutually exclusive options to protect data using server-side encryption in Amazon S3, depending on how you choose to manage the encryption keys. Specifically, the encryption key options are Amazon S3 managed keys (SSE-S3), Amazon Web Services KMS keys (SSE-KMS or DSSE-KMS), and customer-provided keys (SSE-C). Amazon S3 encrypts data with server-side encryption by using Amazon S3 managed keys (SSE-S3) by default. You can optionally tell Amazon S3 to encrypt data at rest by using server-side encryption with other key options. For more information, see Using Server-Side Encryption in the Amazon S3 User Guide.    Directory buckets  - For directory buckets, there are only two supported options for server-side encryption: server-side encryption with Amazon S3 managed keys (SSE-S3) (AES256) and server-side encryption with KMS keys (SSE-KMS) (aws:kms). We recommend that the bucket's default encryption uses the desired encryption configuration and you don't override the bucket default encryption in your  CreateSession requests or PUT object requests. Then, new objects  are automatically encrypted with the desired encryption settings. For more information, see Protecting data with server-side encryption in the Amazon S3 User Guide. For more information about the encryption overriding behaviors in directory buckets, see Specifying server-side encryption with KMS for new object uploads.  In the Zonal endpoint API calls (except CopyObject and UploadPartCopy) using the REST API, the encryption request headers must match the encryption settings that are specified in the CreateSession request.  You can't override the values of the encryption settings (x-amz-server-side-encryption, x-amz-server-side-encryption-aws-kms-key-id, x-amz-server-side-encryption-context, and x-amz-server-side-encryption-bucket-key-enabled) that are specified in the CreateSession request.  You don't need to explicitly specify these encryption settings values in Zonal endpoint API calls, and    Amazon S3 will use the encryption settings values from the CreateSession request to protect new objects in the directory bucket.    When you use the CLI or the Amazon Web Services SDKs, for CreateSession, the session token refreshes automatically to avoid service interruptions when a session expires. The CLI or the Amazon Web Services SDKs use the bucket's default encryption configuration for the  CreateSession request. It's not supported to override the encryption settings values in the CreateSession request.  So in the Zonal endpoint API calls (except CopyObject and UploadPartCopy),  the encryption request headers must match the default encryption configuration of the directory bucket.
        ///
        internal let serverSideEncryption: ServerSideEncryption?
        /// Specifies the algorithm to use when encrypting the object (for example, AES256).  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header.  This functionality is not supported for directory buckets.
        internal let sseCustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// Specifies the Amazon Web Services KMS Encryption Context as an additional encryption context to use for object encryption. The value of this header is a Base64-encoded string of a UTF-8 encoded JSON, which contains the encryption context as key-value pairs.  This value is stored as object metadata and automatically gets passed on to Amazon Web Services KMS for future GetObject operations on this object.  General purpose buckets - This value must be explicitly added during CopyObject operations if you want an additional encryption context for your object. For more information, see Encryption context in the Amazon S3 User Guide.  Directory buckets - You can optionally provide an explicit encryption context value. The value must match the default encryption context - the bucket Amazon Resource Name (ARN). An additional encryption context value is not supported.
        internal let ssekmsEncryptionContext: String?
        /// Specifies the KMS key ID (Key ID, Key ARN, or Key Alias) to use for object encryption. If the KMS key doesn't exist in the same account that's issuing the command, you must use the full Key ARN not the Key ID.  General purpose buckets - If you specify x-amz-server-side-encryption with aws:kms or aws:kms:dsse, this header specifies the ID (Key ID, Key ARN, or Key Alias) of the KMS  key to use. If you specify x-amz-server-side-encryption:aws:kms or x-amz-server-side-encryption:aws:kms:dsse, but do not provide x-amz-server-side-encryption-aws-kms-key-id, Amazon S3 uses the Amazon Web Services managed key (aws/s3) to protect the data.  Directory buckets - If you specify x-amz-server-side-encryption with aws:kms, the  x-amz-server-side-encryption-aws-kms-key-id header is implicitly assigned the ID of the KMS  symmetric encryption customer managed key that's configured for your directory bucket's default encryption setting.  If you want to specify the  x-amz-server-side-encryption-aws-kms-key-id header explicitly, you can only specify it with the ID (Key ID or Key ARN) of the KMS  customer managed key that's configured for your directory bucket's default encryption setting. Otherwise, you get an HTTP 400 Bad Request error. Only use the key ID or key ARN. The key alias format of the KMS key isn't supported. Your SSE-KMS configuration can only support 1 customer managed key per directory bucket for the lifetime of the bucket.
        /// The Amazon Web Services managed key (aws/s3) isn't supported.
        internal let ssekmsKeyId: String?
        /// By default, Amazon S3 uses the STANDARD Storage Class to store newly created objects. The STANDARD storage class provides high durability and high availability. Depending on performance needs, you can specify a different Storage Class. For more information, see Storage Classes in the Amazon S3 User Guide.    For directory buckets, only the S3 Express One Zone storage class is supported to store newly created objects.   Amazon S3 on Outposts only uses the OUTPOSTS Storage Class.
        internal let storageClass: StorageClass?
        /// The tag-set for the object. The tag-set must be encoded as URL Query parameters. (For example, "Key1=Value1")  This functionality is not supported for directory buckets.
        internal let tagging: String?
        /// If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata. For information about object metadata, see Object Key and Metadata in the Amazon S3 User Guide. In the following example, the request header sets the redirect to an object (anotherPage.html) in the same bucket:  x-amz-website-redirect-location: /anotherPage.html  In the following example, the request header sets the object redirect to another website:  x-amz-website-redirect-location: http://www.example.com/  For more information about website hosting in Amazon S3, see Hosting Websites on Amazon S3 and How to Configure Website Page Redirects in the Amazon S3 User Guide.   This functionality is not supported for directory buckets.
        internal let websiteRedirectLocation: String?
        ///  Specifies the offset for appending data to existing objects in bytes.  The offset must be equal to the size of the existing object being appended to.  If no object exists, setting this header to 0 will create a new object.   This functionality is only supported for objects in the Amazon S3 Express One Zone storage class in directory buckets.
        internal let writeOffsetBytes: Int64?

        @inlinable
        internal init(
            acl: ObjectCannedACL? = nil, body: AWSHTTPBody? = nil, bucket: String, bucketKeyEnabled: Bool? = nil,
            cacheControl: String? = nil, checksumAlgorithm: ChecksumAlgorithm? = nil, checksumCRC32: String? = nil,
            checksumCRC32C: String? = nil, checksumSHA1: String? = nil, checksumSHA256: String? = nil,
            contentDisposition: String? = nil, contentEncoding: String? = nil, contentLanguage: String? = nil,
            contentLength: Int64? = nil, contentMD5: String? = nil, contentType: String? = nil,
            expectedBucketOwner: String? = nil, expires: Date? = nil, grantFullControl: String? = nil,
            grantRead: String? = nil, grantReadACP: String? = nil, grantWriteACP: String? = nil, ifMatch: String? = nil,
            ifNoneMatch: String? = nil, key: String, metadata: [String: String]? = nil,
            objectLockLegalHoldStatus: ObjectLockLegalHoldStatus? = nil, objectLockMode: ObjectLockMode? = nil,
            objectLockRetainUntilDate: Date? = nil, requestPayer: RequestPayer? = nil,
            serverSideEncryption: ServerSideEncryption? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil, ssekmsEncryptionContext: String? = nil,
            ssekmsKeyId: String? = nil, storageClass: StorageClass? = nil, tagging: String? = nil,
            websiteRedirectLocation: String? = nil, writeOffsetBytes: Int64? = nil
        ) {
            self.acl = acl
            self.body = body
            self.bucket = bucket
            self.bucketKeyEnabled = bucketKeyEnabled
            self.cacheControl = cacheControl
            self.checksumAlgorithm = checksumAlgorithm
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.contentDisposition = contentDisposition
            self.contentEncoding = contentEncoding
            self.contentLanguage = contentLanguage
            self.contentLength = contentLength
            self.contentMD5 = contentMD5
            self.contentType = contentType
            self.expectedBucketOwner = expectedBucketOwner
            self.expires = expires
            self.grantFullControl = grantFullControl
            self.grantRead = grantRead
            self.grantReadACP = grantReadACP
            self.grantWriteACP = grantWriteACP
            self.ifMatch = ifMatch
            self.ifNoneMatch = ifNoneMatch
            self.key = key
            self.metadata = metadata
            self.objectLockLegalHoldStatus = objectLockLegalHoldStatus
            self.objectLockMode = objectLockMode
            self.objectLockRetainUntilDate = objectLockRetainUntilDate
            self.requestPayer = requestPayer
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsEncryptionContext = ssekmsEncryptionContext
            self.ssekmsKeyId = ssekmsKeyId
            self.storageClass = storageClass
            self.tagging = tagging
            self.websiteRedirectLocation = websiteRedirectLocation
            self.writeOffsetBytes = writeOffsetBytes
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodeHeader(self.acl, key: "x-amz-acl")
            try container.encode(self.body)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.bucketKeyEnabled, key: "x-amz-server-side-encryption-bucket-key-enabled")
            request.encodeHeader(self.cacheControl, key: "Cache-Control")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.checksumCRC32, key: "x-amz-checksum-crc32")
            request.encodeHeader(self.checksumCRC32C, key: "x-amz-checksum-crc32c")
            request.encodeHeader(self.checksumSHA1, key: "x-amz-checksum-sha1")
            request.encodeHeader(self.checksumSHA256, key: "x-amz-checksum-sha256")
            request.encodeHeader(self.contentDisposition, key: "Content-Disposition")
            request.encodeHeader(self.contentEncoding, key: "Content-Encoding")
            request.encodeHeader(self.contentLanguage, key: "Content-Language")
            request.encodeHeader(self.contentLength, key: "Content-Length")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.contentType, key: "Content-Type")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self._expires, key: "Expires")
            request.encodeHeader(self.grantFullControl, key: "x-amz-grant-full-control")
            request.encodeHeader(self.grantRead, key: "x-amz-grant-read")
            request.encodeHeader(self.grantReadACP, key: "x-amz-grant-read-acp")
            request.encodeHeader(self.grantWriteACP, key: "x-amz-grant-write-acp")
            request.encodeHeader(self.ifMatch, key: "If-Match")
            request.encodeHeader(self.ifNoneMatch, key: "If-None-Match")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.metadata, key: "x-amz-meta-")
            request.encodeHeader(self.objectLockLegalHoldStatus, key: "x-amz-object-lock-legal-hold")
            request.encodeHeader(self.objectLockMode, key: "x-amz-object-lock-mode")
            request.encodeHeader(self._objectLockRetainUntilDate, key: "x-amz-object-lock-retain-until-date")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.serverSideEncryption, key: "x-amz-server-side-encryption")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeHeader(self.ssekmsEncryptionContext, key: "x-amz-server-side-encryption-context")
            request.encodeHeader(self.ssekmsKeyId, key: "x-amz-server-side-encryption-aws-kms-key-id")
            request.encodeHeader(self.storageClass, key: "x-amz-storage-class")
            request.encodeHeader(self.tagging, key: "x-amz-tagging")
            request.encodeHeader(self.websiteRedirectLocation, key: "x-amz-website-redirect-location")
            request.encodeHeader(self.writeOffsetBytes, key: "x-amz-write-offset-bytes")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectRetentionOutput: AWSDecodableShape {
        internal let requestCharged: RequestCharged?

        @inlinable
        internal init(requestCharged: RequestCharged? = nil) {
            self.requestCharged = requestCharged
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectRetentionRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "Retention"
        /// The bucket name that contains the object you want to apply this Object Retention configuration to.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.
        internal let bucket: String
        /// Indicates whether this action should bypass Governance-mode restrictions.
        internal let bypassGovernanceRetention: Bool?
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The MD5 hash for the request body. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The key name for the object that you want to apply this Object Retention configuration to.
        internal let key: String
        internal let requestPayer: RequestPayer?
        /// The container element for the Object Retention configuration.
        internal let retention: ObjectLockRetention?
        /// The version ID for the object that you want to apply this Object Retention configuration to.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, bypassGovernanceRetention: Bool? = nil, checksumAlgorithm: ChecksumAlgorithm? = nil,
            contentMD5: String? = nil, expectedBucketOwner: String? = nil, key: String,
            requestPayer: RequestPayer? = nil, retention: ObjectLockRetention? = nil, versionId: String? = nil
        ) {
            self.bucket = bucket
            self.bypassGovernanceRetention = bypassGovernanceRetention
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.requestPayer = requestPayer
            self.retention = retention
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.bypassGovernanceRetention, key: "x-amz-bypass-governance-retention")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            try container.encode(self.retention)
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectTaggingOutput: AWSDecodableShape {
        /// The versionId of the object the tag-set was added to.
        internal let versionId: String?

        @inlinable
        internal init(versionId: String? = nil) {
            self.versionId = versionId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.versionId = try response.decodeHeaderIfPresent(String.self, key: "x-amz-version-id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutObjectTaggingRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "Tagging"
        /// The bucket name containing the object.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The MD5 hash for the request body. For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Name of the object key.
        internal let key: String
        internal let requestPayer: RequestPayer?
        /// Container for the TagSet and Tag elements
        internal let tagging: Tagging
        /// The versionId of the object that the tag-set will be added to.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, key: String, requestPayer: RequestPayer? = nil, tagging: Tagging,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.requestPayer = requestPayer
            self.tagging = tagging
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            try container.encode(self.tagging)
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
            try self.tagging.validate(name: "\(name).tagging")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct PutPublicAccessBlockRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .checksumRequired, .md5ChecksumHeader]
        internal static let _xmlRootNodeName: String? = "PublicAccessBlockConfiguration"
        /// The name of the Amazon S3 bucket whose PublicAccessBlock configuration you want to set.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The MD5 hash of the PutPublicAccessBlock request body.  For requests made using the Amazon Web Services Command Line Interface (CLI) or Amazon Web Services SDKs, this field is calculated automatically.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The PublicAccessBlock configuration that you want to apply to this Amazon S3 bucket. You can enable the configuration options in any combination. For more information about when Amazon S3 considers a bucket or object public, see The Meaning of "Public" in the Amazon S3 User Guide.
        internal let publicAccessBlockConfiguration: PublicAccessBlockConfiguration

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, publicAccessBlockConfiguration: PublicAccessBlockConfiguration
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.publicAccessBlockConfiguration = publicAccessBlockConfiguration
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.publicAccessBlockConfiguration)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct QueueConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// A collection of bucket events for which to send notifications
        internal let events: [Event]
        internal let filter: NotificationConfigurationFilter?
        internal let id: String?
        /// The Amazon Resource Name (ARN) of the Amazon SQS queue to which Amazon S3 publishes a message when it detects events of the specified type.
        internal let queueArn: String

        @inlinable
        internal init(
            events: [Event], filter: NotificationConfigurationFilter? = nil, id: String? = nil, queueArn: String
        ) {
            self.events = events
            self.filter = filter
            self.id = id
            self.queueArn = queueArn
        }

        private enum CodingKeys: String, CodingKey {
            case events = "Event"
            case filter = "Filter"
            case id = "Id"
            case queueArn = "Queue"
        }
    }

    internal struct RecordsEvent: AWSDecodableShape {
        /// The byte array of partial, one or more result records. S3 Select doesn't guarantee that a record will be self-contained in one record frame. To ensure continuous streaming of data, S3 Select might split the same record across multiple record frames instead of aggregating the results in memory. Some S3 clients (for example, the SDK for Java) handle this behavior by creating a ByteStream out of the response by default. Other clients might not handle this behavior by default. In those cases, you must aggregate the results on the client side and parse the response.
        internal let payload: AWSEventPayload

        @inlinable
        internal init(payload: AWSEventPayload) {
            self.payload = payload
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.payload = try container.decode(AWSEventPayload.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct Redirect: AWSEncodableShape & AWSDecodableShape {
        /// The host name to use in the redirect request.
        internal let hostName: String?
        /// The HTTP redirect code to use on the response. Not required if one of the siblings is present.
        internal let httpRedirectCode: String?
        /// Protocol to use when redirecting requests. The default is the protocol that is used in the original request.
        internal let `protocol`: `Protocol`?
        /// The object key prefix to use in the redirect request. For example, to redirect requests for all pages with prefix docs/ (objects in the docs/ folder) to documents/, you can set a condition block with KeyPrefixEquals set to docs/ and in the Redirect set ReplaceKeyPrefixWith to /documents. Not required if one of the siblings is present. Can be present only if ReplaceKeyWith is not provided.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let replaceKeyPrefixWith: String?
        /// The specific object key to use in the redirect request. For example, redirect request to error.html. Not required if one of the siblings is present. Can be present only if ReplaceKeyPrefixWith is not provided.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let replaceKeyWith: String?

        @inlinable
        internal init(
            hostName: String? = nil, httpRedirectCode: String? = nil, protocol: `Protocol`? = nil,
            replaceKeyPrefixWith: String? = nil, replaceKeyWith: String? = nil
        ) {
            self.hostName = hostName
            self.httpRedirectCode = httpRedirectCode
            self.`protocol` = `protocol`
            self.replaceKeyPrefixWith = replaceKeyPrefixWith
            self.replaceKeyWith = replaceKeyWith
        }

        private enum CodingKeys: String, CodingKey {
            case hostName = "HostName"
            case httpRedirectCode = "HttpRedirectCode"
            case `protocol` = "Protocol"
            case replaceKeyPrefixWith = "ReplaceKeyPrefixWith"
            case replaceKeyWith = "ReplaceKeyWith"
        }
    }

    internal struct RedirectAllRequestsTo: AWSEncodableShape & AWSDecodableShape {
        /// Name of the host where requests are redirected.
        internal let hostName: String
        /// Protocol to use when redirecting requests. The default is the protocol that is used in the original request.
        internal let `protocol`: `Protocol`?

        @inlinable
        internal init(hostName: String, protocol: `Protocol`? = nil) {
            self.hostName = hostName
            self.`protocol` = `protocol`
        }

        private enum CodingKeys: String, CodingKey {
            case hostName = "HostName"
            case `protocol` = "Protocol"
        }
    }

    internal struct ReplicaModifications: AWSEncodableShape & AWSDecodableShape {
        /// Specifies whether Amazon S3 replicates modifications on replicas.
        internal let status: ReplicaModificationsStatus

        @inlinable
        internal init(status: ReplicaModificationsStatus) {
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case status = "Status"
        }
    }

    internal struct ReplicationConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// The Amazon Resource Name (ARN) of the Identity and Access Management (IAM) role that Amazon S3 assumes when replicating objects. For more information, see How to Set Up Replication in the Amazon S3 User Guide.
        internal let role: String
        /// A container for one or more replication rules. A replication configuration must have at least one rule and can contain a maximum of 1,000 rules.
        internal let rules: [ReplicationRule]

        @inlinable
        internal init(role: String, rules: [ReplicationRule]) {
            self.role = role
            self.rules = rules
        }

        internal func validate(name: String) throws {
            try self.rules.forEach {
                try $0.validate(name: "\(name).rules[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case role = "Role"
            case rules = "Rule"
        }
    }

    internal struct ReplicationRule: AWSEncodableShape & AWSDecodableShape {
        internal let deleteMarkerReplication: DeleteMarkerReplication?
        /// A container for information about the replication destination and its configurations including enabling the S3 Replication Time Control (S3 RTC).
        internal let destination: Destination
        /// Optional configuration to replicate existing source bucket objects.   This parameter is no longer supported. To replicate existing objects, see Replicating existing objects with S3 Batch Replication in the Amazon S3 User Guide.
        internal let existingObjectReplication: ExistingObjectReplication?
        internal let filter: ReplicationRuleFilter?
        /// A unique identifier for the rule. The maximum value is 255 characters.
        internal let id: String?
        /// An object key name prefix that identifies the object or objects to which the rule applies. The maximum prefix length is 1,024 characters. To include all objects in a bucket, specify an empty string.   Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let prefix: String?
        /// The priority indicates which rule has precedence whenever two or more replication rules conflict. Amazon S3 will attempt to replicate objects according to all replication rules. However, if there are two or more rules with the same destination bucket, then objects will be replicated according to the rule with the highest priority. The higher the number, the higher the priority.  For more information, see Replication in the Amazon S3 User Guide.
        internal let priority: Int?
        /// A container that describes additional filters for identifying the source objects that you want to replicate. You can choose to enable or disable the replication of these objects. Currently, Amazon S3 supports only the filter that you can specify for objects created with server-side encryption using a customer managed key stored in Amazon Web Services Key Management Service (SSE-KMS).
        internal let sourceSelectionCriteria: SourceSelectionCriteria?
        /// Specifies whether the rule is enabled.
        internal let status: ReplicationRuleStatus

        @inlinable
        internal init(
            deleteMarkerReplication: DeleteMarkerReplication? = nil, destination: Destination,
            existingObjectReplication: ExistingObjectReplication? = nil, filter: ReplicationRuleFilter? = nil,
            id: String? = nil, priority: Int? = nil, sourceSelectionCriteria: SourceSelectionCriteria? = nil,
            status: ReplicationRuleStatus
        ) {
            self.deleteMarkerReplication = deleteMarkerReplication
            self.destination = destination
            self.existingObjectReplication = existingObjectReplication
            self.filter = filter
            self.id = id
            self.prefix = nil
            self.priority = priority
            self.sourceSelectionCriteria = sourceSelectionCriteria
            self.status = status
        }

        @available(*, deprecated, message: "Members prefix have been deprecated")
        @inlinable
        internal init(
            deleteMarkerReplication: DeleteMarkerReplication? = nil, destination: Destination,
            existingObjectReplication: ExistingObjectReplication? = nil, filter: ReplicationRuleFilter? = nil,
            id: String? = nil, prefix: String? = nil, priority: Int? = nil,
            sourceSelectionCriteria: SourceSelectionCriteria? = nil, status: ReplicationRuleStatus
        ) {
            self.deleteMarkerReplication = deleteMarkerReplication
            self.destination = destination
            self.existingObjectReplication = existingObjectReplication
            self.filter = filter
            self.id = id
            self.prefix = prefix
            self.priority = priority
            self.sourceSelectionCriteria = sourceSelectionCriteria
            self.status = status
        }

        internal func validate(name: String) throws {
            try self.filter?.validate(name: "\(name).filter")
        }

        private enum CodingKeys: String, CodingKey {
            case deleteMarkerReplication = "DeleteMarkerReplication"
            case destination = "Destination"
            case existingObjectReplication = "ExistingObjectReplication"
            case filter = "Filter"
            case id = "ID"
            case prefix = "Prefix"
            case priority = "Priority"
            case sourceSelectionCriteria = "SourceSelectionCriteria"
            case status = "Status"
        }
    }

    internal struct ReplicationRuleAndOperator: AWSEncodableShape & AWSDecodableShape {
        /// An object key name prefix that identifies the subset of objects to which the rule applies.
        internal let prefix: String?
        /// An array of tags containing key and value pairs.
        internal let tags: [Tag]?

        @inlinable
        internal init(prefix: String? = nil, tags: [Tag]? = nil) {
            self.prefix = prefix
            self.tags = tags
        }

        internal func validate(name: String) throws {
            try self.tags?.forEach {
                try $0.validate(name: "\(name).tags[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case prefix = "Prefix"
            case tags = "Tag"
        }
    }

    internal struct ReplicationRuleFilter: AWSEncodableShape & AWSDecodableShape {
        /// A container for specifying rule filters. The filters determine the subset of objects to which the rule applies. This element is required only if you specify more than one filter. For example:    If you specify both a Prefix and a Tag filter, wrap these filters in an And tag.   If you specify a filter based on multiple tags, wrap the Tag elements in an And tag.
        internal let and: ReplicationRuleAndOperator?
        /// An object key name prefix that identifies the subset of objects to which the rule applies.  Replacement must be made for object keys containing special characters (such as carriage returns) when using  XML requests. For more information, see  XML related object key constraints.
        internal let prefix: String?
        /// A container for specifying a tag key and value.  The rule applies only to objects that have the tag in their tag set.
        internal let tag: Tag?

        @inlinable
        internal init(and: ReplicationRuleAndOperator? = nil, prefix: String? = nil, tag: Tag? = nil) {
            self.and = and
            self.prefix = prefix
            self.tag = tag
        }

        internal func validate(name: String) throws {
            try self.and?.validate(name: "\(name).and")
            try self.tag?.validate(name: "\(name).tag")
        }

        private enum CodingKeys: String, CodingKey {
            case and = "And"
            case prefix = "Prefix"
            case tag = "Tag"
        }
    }

    internal struct ReplicationTime: AWSEncodableShape & AWSDecodableShape {
        ///  Specifies whether the replication time is enabled.
        internal let status: ReplicationTimeStatus
        ///  A container specifying the time by which replication should be complete for all objects and operations on objects.
        internal let time: ReplicationTimeValue

        @inlinable
        internal init(status: ReplicationTimeStatus, time: ReplicationTimeValue) {
            self.status = status
            self.time = time
        }

        private enum CodingKeys: String, CodingKey {
            case status = "Status"
            case time = "Time"
        }
    }

    internal struct ReplicationTimeValue: AWSEncodableShape & AWSDecodableShape {
        ///  Contains an integer specifying time in minutes.  Valid value: 15
        internal let minutes: Int?

        @inlinable
        internal init(minutes: Int? = nil) {
            self.minutes = minutes
        }

        private enum CodingKeys: String, CodingKey {
            case minutes = "Minutes"
        }
    }

    internal struct RequestPaymentConfiguration: AWSEncodableShape {
        /// Specifies who pays for the download and request fees.
        internal let payer: Payer

        @inlinable
        internal init(payer: Payer) {
            self.payer = payer
        }

        private enum CodingKeys: String, CodingKey {
            case payer = "Payer"
        }
    }

    internal struct RequestProgress: AWSEncodableShape {
        /// Specifies whether periodic QueryProgress frames should be sent. Valid values: TRUE, FALSE. Default value: FALSE.
        internal let enabled: Bool?

        @inlinable
        internal init(enabled: Bool? = nil) {
            self.enabled = enabled
        }

        private enum CodingKeys: String, CodingKey {
            case enabled = "Enabled"
        }
    }

    internal struct RestoreObjectOutput: AWSDecodableShape {
        internal let requestCharged: RequestCharged?
        /// Indicates the path in the provided S3 output location where Select results will be restored to.
        internal let restoreOutputPath: String?

        @inlinable
        internal init(requestCharged: RequestCharged? = nil, restoreOutputPath: String? = nil) {
            self.requestCharged = requestCharged
            self.restoreOutputPath = restoreOutputPath
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.restoreOutputPath = try response.decodeHeaderIfPresent(String.self, key: "x-amz-restore-output-path")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct RestoreObjectRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader]
        internal static let _xmlRootNodeName: String? = "RestoreRequest"
        /// The bucket name containing the object to restore.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Object key for which the action was initiated.
        internal let key: String
        internal let requestPayer: RequestPayer?
        internal let restoreRequest: RestoreRequest?
        /// VersionId used to reference a specific version of the object.
        internal let versionId: String?

        @inlinable
        internal init(
            bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil, expectedBucketOwner: String? = nil,
            key: String, requestPayer: RequestPayer? = nil, restoreRequest: RestoreRequest? = nil,
            versionId: String? = nil
        ) {
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.requestPayer = requestPayer
            self.restoreRequest = restoreRequest
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            try container.encode(self.restoreRequest)
            request.encodeQuery(self.versionId, key: "versionId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
            try self.restoreRequest?.validate(name: "\(name).restoreRequest")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct RestoreRequest: AWSEncodableShape {
        /// Lifetime of the active copy in days. Do not use with restores that specify OutputLocation. The Days element is required for regular restores, and must not be provided for select requests.
        internal let days: Int?
        /// The optional description for the job.
        internal let description: String?
        /// S3 Glacier related parameters pertaining to this job. Do not use with restores that specify OutputLocation.
        internal let glacierJobParameters: GlacierJobParameters?
        /// Describes the location where the restore job's output is stored.
        internal let outputLocation: OutputLocation?
        ///  Amazon S3 Select is no longer available to new customers. Existing customers of Amazon S3 Select can continue to use the feature as usual. Learn more   Describes the parameters for Select job types.
        internal let selectParameters: SelectParameters?
        /// Retrieval tier at which the restore will be processed.
        internal let tier: Tier?
        ///  Amazon S3 Select is no longer available to new customers. Existing customers of Amazon S3 Select can continue to use the feature as usual. Learn more   Type of restore request.
        internal let type: RestoreRequestType?

        @inlinable
        internal init(
            days: Int? = nil, description: String? = nil, glacierJobParameters: GlacierJobParameters? = nil,
            outputLocation: OutputLocation? = nil, selectParameters: SelectParameters? = nil, tier: Tier? = nil,
            type: RestoreRequestType? = nil
        ) {
            self.days = days
            self.description = description
            self.glacierJobParameters = glacierJobParameters
            self.outputLocation = outputLocation
            self.selectParameters = selectParameters
            self.tier = tier
            self.type = type
        }

        internal func validate(name: String) throws {
            try self.outputLocation?.validate(name: "\(name).outputLocation")
        }

        private enum CodingKeys: String, CodingKey {
            case days = "Days"
            case description = "Description"
            case glacierJobParameters = "GlacierJobParameters"
            case outputLocation = "OutputLocation"
            case selectParameters = "SelectParameters"
            case tier = "Tier"
            case type = "Type"
        }
    }

    internal struct RestoreStatus: AWSDecodableShape {
        /// Specifies whether the object is currently being restored. If the object restoration is in progress, the header returns the value TRUE. For example:  x-amz-optional-object-attributes: IsRestoreInProgress="true"  If the object restoration has completed, the header returns the value FALSE. For example:  x-amz-optional-object-attributes: IsRestoreInProgress="false", RestoreExpiryDate="2012-12-21T00:00:00.000Z"  If the object hasn't been restored, there is no header response.
        internal let isRestoreInProgress: Bool?
        /// Indicates when the restored copy will expire. This value is populated only if the object has already been restored. For example:  x-amz-optional-object-attributes: IsRestoreInProgress="false", RestoreExpiryDate="2012-12-21T00:00:00.000Z"
        internal let restoreExpiryDate: Date?

        @inlinable
        internal init(isRestoreInProgress: Bool? = nil, restoreExpiryDate: Date? = nil) {
            self.isRestoreInProgress = isRestoreInProgress
            self.restoreExpiryDate = restoreExpiryDate
        }

        private enum CodingKeys: String, CodingKey {
            case isRestoreInProgress = "IsRestoreInProgress"
            case restoreExpiryDate = "RestoreExpiryDate"
        }
    }

    internal struct RoutingRule: AWSEncodableShape & AWSDecodableShape {
        /// A container for describing a condition that must be met for the specified redirect to apply. For example, 1. If request is for pages in the /docs folder, redirect to the /documents folder. 2. If request results in HTTP error 4xx, redirect request to another host where you might process the error.
        internal let condition: Condition?
        /// Container for redirect information. You can redirect requests to another host, to another page, or with another protocol. In the event of an error, you can specify a different error code to return.
        internal let redirect: Redirect

        @inlinable
        internal init(condition: Condition? = nil, redirect: Redirect) {
            self.condition = condition
            self.redirect = redirect
        }

        private enum CodingKeys: String, CodingKey {
            case condition = "Condition"
            case redirect = "Redirect"
        }
    }

    internal struct S3KeyFilter: AWSEncodableShape & AWSDecodableShape {
        internal let filterRules: [FilterRule]?

        @inlinable
        internal init(filterRules: [FilterRule]? = nil) {
            self.filterRules = filterRules
        }

        private enum CodingKeys: String, CodingKey {
            case filterRules = "FilterRule"
        }
    }

    internal struct S3Location: AWSEncodableShape {
        internal struct _AccessControlListEncoding: ArrayCoderProperties { internal static let member = "Grant" }
        internal struct _UserMetadataEncoding: ArrayCoderProperties { internal static let member = "MetadataEntry" }

        /// A list of grants that control access to the staged results.
        @OptionalCustomCoding<ArrayCoder<_AccessControlListEncoding, Grant>>
        internal var accessControlList: [Grant]?
        /// The name of the bucket where the restore results will be placed.
        internal let bucketName: String
        /// The canned ACL to apply to the restore results.
        internal let cannedACL: ObjectCannedACL?
        internal let encryption: Encryption?
        /// The prefix that is prepended to the restore results for this request.
        internal let prefix: String
        /// The class of storage used to store the restore results.
        internal let storageClass: StorageClass?
        /// The tag-set that is applied to the restore results.
        internal let tagging: Tagging?
        /// A list of metadata to store with the restore results in S3.
        @OptionalCustomCoding<ArrayCoder<_UserMetadataEncoding, MetadataEntry>>
        internal var userMetadata: [MetadataEntry]?

        @inlinable
        internal init(
            accessControlList: [Grant]? = nil, bucketName: String, cannedACL: ObjectCannedACL? = nil,
            encryption: Encryption? = nil, prefix: String, storageClass: StorageClass? = nil, tagging: Tagging? = nil,
            userMetadata: [MetadataEntry]? = nil
        ) {
            self.accessControlList = accessControlList
            self.bucketName = bucketName
            self.cannedACL = cannedACL
            self.encryption = encryption
            self.prefix = prefix
            self.storageClass = storageClass
            self.tagging = tagging
            self.userMetadata = userMetadata
        }

        internal func validate(name: String) throws {
            try self.tagging?.validate(name: "\(name).tagging")
        }

        private enum CodingKeys: String, CodingKey {
            case accessControlList = "AccessControlList"
            case bucketName = "BucketName"
            case cannedACL = "CannedACL"
            case encryption = "Encryption"
            case prefix = "Prefix"
            case storageClass = "StorageClass"
            case tagging = "Tagging"
            case userMetadata = "UserMetadata"
        }
    }

    internal struct S3TablesDestination: AWSEncodableShape {
        ///  The Amazon Resource Name (ARN) for the table bucket that's specified as the  destination in the metadata table configuration. The destination table bucket must be in the same Region and Amazon Web Services account as the general purpose bucket.
        internal let tableBucketArn: String
        ///  The name for the metadata table in your metadata table configuration. The specified metadata table name must be unique within the aws_s3_metadata namespace in the destination  table bucket.
        internal let tableName: String

        @inlinable
        internal init(tableBucketArn: String, tableName: String) {
            self.tableBucketArn = tableBucketArn
            self.tableName = tableName
        }

        private enum CodingKeys: String, CodingKey {
            case tableBucketArn = "TableBucketArn"
            case tableName = "TableName"
        }
    }

    internal struct S3TablesDestinationResult: AWSDecodableShape {
        ///  The Amazon Resource Name (ARN) for the metadata table in the metadata table configuration. The  specified metadata table name must be unique within the aws_s3_metadata namespace  in the destination table bucket.
        internal let tableArn: String
        ///  The Amazon Resource Name (ARN) for the table bucket that's specified as the  destination in the metadata table configuration. The destination table bucket must be in the same Region and Amazon Web Services account as the general purpose bucket.
        internal let tableBucketArn: String
        ///  The name for the metadata table in your metadata table configuration. The specified metadata table name must be unique within the aws_s3_metadata namespace in the destination  table bucket.
        internal let tableName: String
        ///  The table bucket namespace for the metadata table in your metadata table configuration. This value  is always aws_s3_metadata.
        internal let tableNamespace: String

        @inlinable
        internal init(tableArn: String, tableBucketArn: String, tableName: String, tableNamespace: String) {
            self.tableArn = tableArn
            self.tableBucketArn = tableBucketArn
            self.tableName = tableName
            self.tableNamespace = tableNamespace
        }

        private enum CodingKeys: String, CodingKey {
            case tableArn = "TableArn"
            case tableBucketArn = "TableBucketArn"
            case tableName = "TableName"
            case tableNamespace = "TableNamespace"
        }
    }

    internal struct SSEKMS: AWSEncodableShape & AWSDecodableShape {
        /// Specifies the ID of the Key Management Service (KMS) symmetric encryption customer managed key to use for encrypting inventory reports.
        internal let keyId: String

        @inlinable
        internal init(keyId: String) {
            self.keyId = keyId
        }

        private enum CodingKeys: String, CodingKey {
            case keyId = "KeyId"
        }
    }

    internal struct SSES3: AWSEncodableShape & AWSDecodableShape {
        internal init() {}
    }

    internal struct ScanRange: AWSEncodableShape {
        /// Specifies the end of the byte range. This parameter is optional. Valid values: non-negative integers. The default value is one less than the size of the object being queried. If only the End parameter is supplied, it is interpreted to mean scan the last N bytes of the file. For example, 50 means scan the last 50 bytes.
        internal let end: Int64?
        /// Specifies the start of the byte range. This parameter is optional. Valid values: non-negative integers. The default value is 0. If only start is supplied, it means scan from that point to the end of the file. For example, 50 means scan from byte 50 until the end of the file.
        internal let start: Int64?

        @inlinable
        internal init(end: Int64? = nil, start: Int64? = nil) {
            self.end = end
            self.start = start
        }

        private enum CodingKeys: String, CodingKey {
            case end = "End"
            case start = "Start"
        }
    }

    internal struct SelectObjectContentOutput: AWSDecodableShape {
        internal static let _options: AWSShapeOptions = [.rawPayload]
        /// The array of results.
        internal let payload: AWSEventStream<SelectObjectContentEventStream>

        @inlinable
        internal init(payload: AWSEventStream<SelectObjectContentEventStream>) {
            self.payload = payload
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.payload = try container.decode(AWSEventStream<SelectObjectContentEventStream>.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct SelectObjectContentRequest: AWSEncodableShape {
        /// The S3 bucket.
        internal let bucket: String
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The expression that is used to query the object.
        internal let expression: String
        /// The type of the provided expression (for example, SQL).
        internal let expressionType: ExpressionType
        /// Describes the format of the data in the object that is being queried.
        internal let inputSerialization: InputSerialization
        /// The object key.
        internal let key: String
        /// Describes the format of the data that you want Amazon S3 to return in response.
        internal let outputSerialization: OutputSerialization
        /// Specifies if periodic request progress information should be enabled.
        internal let requestProgress: RequestProgress?
        /// Specifies the byte range of the object to get the records from. A record is processed when its first byte is contained by the range. This parameter is optional, but when specified, it must not be empty. See RFC 2616, Section 14.35.1 about how to specify the start and end of the range.  ScanRangemay be used in the following ways:    50100 - process only the records starting between the bytes 50 and 100 (inclusive, counting from zero)    50 - process only the records starting after the byte 50    50 - process only the records within the last 50 bytes of the file.
        internal let scanRange: ScanRange?
        /// The server-side encryption (SSE) algorithm used to encrypt the object. This parameter is needed only when the object was created  using a checksum algorithm. For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.
        internal let sseCustomerAlgorithm: String?
        /// The server-side encryption (SSE) customer managed key. This parameter is needed only when the object was created using a checksum algorithm.  For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.
        internal let sseCustomerKey: String?
        /// The MD5 server-side encryption (SSE) customer managed key. This parameter is needed only when the object was created using a checksum  algorithm. For more information, see Protecting data using SSE-C keys in the Amazon S3 User Guide.
        internal let sseCustomerKeyMD5: String?

        @inlinable
        internal init(
            bucket: String, expectedBucketOwner: String? = nil, expression: String, expressionType: ExpressionType,
            inputSerialization: InputSerialization, key: String, outputSerialization: OutputSerialization,
            requestProgress: RequestProgress? = nil, scanRange: ScanRange? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil
        ) {
            self.bucket = bucket
            self.expectedBucketOwner = expectedBucketOwner
            self.expression = expression
            self.expressionType = expressionType
            self.inputSerialization = inputSerialization
            self.key = key
            self.outputSerialization = outputSerialization
            self.requestProgress = requestProgress
            self.scanRange = scanRange
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            try container.encode(self.expression, forKey: .expression)
            try container.encode(self.expressionType, forKey: .expressionType)
            try container.encode(self.inputSerialization, forKey: .inputSerialization)
            request.encodePath(self.key, key: "Key")
            try container.encode(self.outputSerialization, forKey: .outputSerialization)
            try container.encodeIfPresent(self.requestProgress, forKey: .requestProgress)
            try container.encodeIfPresent(self.scanRange, forKey: .scanRange)
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: String, CodingKey {
            case expression = "Expression"
            case expressionType = "ExpressionType"
            case inputSerialization = "InputSerialization"
            case outputSerialization = "OutputSerialization"
            case requestProgress = "RequestProgress"
            case scanRange = "ScanRange"
        }
    }

    internal struct SelectParameters: AWSEncodableShape {
        ///  Amazon S3 Select is no longer available to new customers. Existing customers of Amazon S3 Select can continue to use the feature as usual. Learn more   The expression that is used to query the object.
        internal let expression: String
        /// The type of the provided expression (for example, SQL).
        internal let expressionType: ExpressionType
        /// Describes the serialization format of the object.
        internal let inputSerialization: InputSerialization
        /// Describes how the results of the Select job are serialized.
        internal let outputSerialization: OutputSerialization

        @inlinable
        internal init(
            expression: String, expressionType: ExpressionType, inputSerialization: InputSerialization,
            outputSerialization: OutputSerialization
        ) {
            self.expression = expression
            self.expressionType = expressionType
            self.inputSerialization = inputSerialization
            self.outputSerialization = outputSerialization
        }

        private enum CodingKeys: String, CodingKey {
            case expression = "Expression"
            case expressionType = "ExpressionType"
            case inputSerialization = "InputSerialization"
            case outputSerialization = "OutputSerialization"
        }
    }

    internal struct ServerSideEncryptionByDefault: AWSEncodableShape & AWSDecodableShape {
        /// Amazon Web Services Key Management Service (KMS) customer managed key ID to use for the default encryption.      General purpose buckets - This parameter is allowed if and only if SSEAlgorithm is set to aws:kms or aws:kms:dsse.    Directory buckets - This parameter is allowed if and only if SSEAlgorithm is set to aws:kms.    You can specify the key ID, key alias, or the Amazon Resource Name (ARN) of the KMS key.   Key ID: 1234abcd-12ab-34cd-56ef-1234567890ab    Key ARN: arn:aws:kms:us-east-2:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab    Key Alias: alias/alias-name    If you are using encryption with cross-account or Amazon Web Services service operations, you must use a fully qualified KMS key ARN. For more information, see Using encryption for cross-account operations.     General purpose buckets - If you're specifying a customer managed KMS key, we recommend using a fully qualified KMS key ARN. If you use a KMS key alias instead, then KMS resolves the key within the requester’s account. This behavior can result in data that's encrypted with a KMS key that belongs to the requester, and not the bucket owner. Also, if you use a key ID, you can run into a LogDestination undeliverable error when creating a VPC flow log.     Directory buckets - When you specify an KMS customer managed key for encryption in your directory bucket, only use the key ID or key ARN. The key alias format of the KMS key isn't supported.     Amazon S3 only supports symmetric encryption KMS keys. For more information, see Asymmetric keys in Amazon Web Services KMS in the Amazon Web Services Key Management Service Developer Guide.
        internal let kmsMasterKeyID: String?
        /// Server-side encryption algorithm to use for the default encryption.  For directory buckets, there are only two supported values for server-side encryption: AES256 and aws:kms.
        internal let sseAlgorithm: ServerSideEncryption

        @inlinable
        internal init(kmsMasterKeyID: String? = nil, sseAlgorithm: ServerSideEncryption) {
            self.kmsMasterKeyID = kmsMasterKeyID
            self.sseAlgorithm = sseAlgorithm
        }

        private enum CodingKeys: String, CodingKey {
            case kmsMasterKeyID = "KMSMasterKeyID"
            case sseAlgorithm = "SSEAlgorithm"
        }
    }

    internal struct ServerSideEncryptionConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// Container for information about a particular server-side encryption configuration rule.
        internal let rules: [ServerSideEncryptionRule]

        @inlinable
        internal init(rules: [ServerSideEncryptionRule]) {
            self.rules = rules
        }

        private enum CodingKeys: String, CodingKey {
            case rules = "Rule"
        }
    }

    internal struct ServerSideEncryptionRule: AWSEncodableShape & AWSDecodableShape {
        /// Specifies the default server-side encryption to apply to new objects in the bucket. If a PUT Object request doesn't specify any server-side encryption, this default encryption will be applied.
        internal let applyServerSideEncryptionByDefault: ServerSideEncryptionByDefault?
        /// Specifies whether Amazon S3 should use an S3 Bucket Key with server-side encryption using KMS (SSE-KMS) for new objects in the bucket. Existing objects are not affected. Setting the BucketKeyEnabled element to true causes Amazon S3 to use an S3 Bucket Key.      General purpose buckets - By default, S3 Bucket Key is not enabled. For more information, see Amazon S3 Bucket Keys in the Amazon S3 User Guide.    Directory buckets - S3 Bucket Keys are always enabled for GET and PUT operations in a directory bucket and can’t be disabled. S3 Bucket Keys aren't supported, when you copy SSE-KMS encrypted objects from general purpose buckets
        /// to directory buckets, from directory buckets to general purpose buckets, or between directory buckets, through CopyObject, UploadPartCopy, the Copy operation in Batch Operations, or  the import jobs. In this case, Amazon S3 makes a call to KMS every time a copy request is made for a KMS-encrypted object.
        internal let bucketKeyEnabled: Bool?

        @inlinable
        internal init(
            applyServerSideEncryptionByDefault: ServerSideEncryptionByDefault? = nil, bucketKeyEnabled: Bool? = nil
        ) {
            self.applyServerSideEncryptionByDefault = applyServerSideEncryptionByDefault
            self.bucketKeyEnabled = bucketKeyEnabled
        }

        private enum CodingKeys: String, CodingKey {
            case applyServerSideEncryptionByDefault = "ApplyServerSideEncryptionByDefault"
            case bucketKeyEnabled = "BucketKeyEnabled"
        }
    }

    internal struct SessionCredentials: AWSDecodableShape {
        /// A unique identifier that's associated with a secret access key. The access key ID and the secret access key are used together to sign programmatic Amazon Web Services requests cryptographically.
        internal let accessKeyId: String
        /// Temporary security credentials expire after a specified interval. After temporary credentials expire, any calls that you make with those credentials will fail. So you must generate a new set of temporary credentials. Temporary credentials cannot be extended or refreshed beyond the original specified interval.
        internal let expiration: Date
        /// A key that's used with the access key ID to cryptographically sign programmatic Amazon Web Services requests. Signing a request identifies the sender and prevents the request from being altered.
        internal let secretAccessKey: String
        /// A part of the temporary security credentials. The session token is used to validate the temporary security credentials.
        internal let sessionToken: String

        @inlinable
        internal init(accessKeyId: String, expiration: Date, secretAccessKey: String, sessionToken: String) {
            self.accessKeyId = accessKeyId
            self.expiration = expiration
            self.secretAccessKey = secretAccessKey
            self.sessionToken = sessionToken
        }

        private enum CodingKeys: String, CodingKey {
            case accessKeyId = "AccessKeyId"
            case expiration = "Expiration"
            case secretAccessKey = "SecretAccessKey"
            case sessionToken = "SessionToken"
        }
    }

    internal struct SimplePrefix: AWSEncodableShape & AWSDecodableShape {
        internal init() {}
    }

    internal struct SourceSelectionCriteria: AWSEncodableShape & AWSDecodableShape {
        /// A filter that you can specify for selections for modifications on replicas. Amazon S3 doesn't replicate replica modifications by default. In the latest version of replication configuration (when Filter is specified), you can specify this element and set the status to Enabled to replicate modifications on replicas.   If you don't specify the Filter element, Amazon S3 assumes that the replication configuration is the earlier version, V1. In the earlier version, this element is not allowed
        internal let replicaModifications: ReplicaModifications?
        ///  A container for filter information for the selection of Amazon S3 objects encrypted with Amazon Web Services KMS. If you include SourceSelectionCriteria in the replication configuration, this element is required.
        internal let sseKmsEncryptedObjects: SseKmsEncryptedObjects?

        @inlinable
        internal init(
            replicaModifications: ReplicaModifications? = nil, sseKmsEncryptedObjects: SseKmsEncryptedObjects? = nil
        ) {
            self.replicaModifications = replicaModifications
            self.sseKmsEncryptedObjects = sseKmsEncryptedObjects
        }

        private enum CodingKeys: String, CodingKey {
            case replicaModifications = "ReplicaModifications"
            case sseKmsEncryptedObjects = "SseKmsEncryptedObjects"
        }
    }

    internal struct SseKmsEncryptedObjects: AWSEncodableShape & AWSDecodableShape {
        /// Specifies whether Amazon S3 replicates objects created with server-side encryption using an Amazon Web Services KMS key stored in Amazon Web Services Key Management Service.
        internal let status: SseKmsEncryptedObjectsStatus

        @inlinable
        internal init(status: SseKmsEncryptedObjectsStatus) {
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case status = "Status"
        }
    }

    internal struct Stats: AWSDecodableShape {
        /// The total number of uncompressed object bytes processed.
        internal let bytesProcessed: Int64?
        /// The total number of bytes of records payload data returned.
        internal let bytesReturned: Int64?
        /// The total number of object bytes scanned.
        internal let bytesScanned: Int64?

        @inlinable
        internal init(bytesProcessed: Int64? = nil, bytesReturned: Int64? = nil, bytesScanned: Int64? = nil) {
            self.bytesProcessed = bytesProcessed
            self.bytesReturned = bytesReturned
            self.bytesScanned = bytesScanned
        }

        private enum CodingKeys: String, CodingKey {
            case bytesProcessed = "BytesProcessed"
            case bytesReturned = "BytesReturned"
            case bytesScanned = "BytesScanned"
        }
    }

    internal struct StatsEvent: AWSDecodableShape {
        /// The Stats event details.
        internal let details: Stats

        @inlinable
        internal init(details: Stats) {
            self.details = details
        }

        internal init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            self.details = try container.decode(Stats.self)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct StorageClassAnalysis: AWSEncodableShape & AWSDecodableShape {
        /// Specifies how data related to the storage class analysis for an Amazon S3 bucket should be exported.
        internal let dataExport: StorageClassAnalysisDataExport?

        @inlinable
        internal init(dataExport: StorageClassAnalysisDataExport? = nil) {
            self.dataExport = dataExport
        }

        private enum CodingKeys: String, CodingKey {
            case dataExport = "DataExport"
        }
    }

    internal struct StorageClassAnalysisDataExport: AWSEncodableShape & AWSDecodableShape {
        /// The place to store the data for an analysis.
        internal let destination: AnalyticsExportDestination
        /// The version of the output schema to use when exporting data. Must be V_1.
        internal let outputSchemaVersion: StorageClassAnalysisSchemaVersion

        @inlinable
        internal init(destination: AnalyticsExportDestination, outputSchemaVersion: StorageClassAnalysisSchemaVersion) {
            self.destination = destination
            self.outputSchemaVersion = outputSchemaVersion
        }

        private enum CodingKeys: String, CodingKey {
            case destination = "Destination"
            case outputSchemaVersion = "OutputSchemaVersion"
        }
    }

    internal struct Tag: AWSEncodableShape & AWSDecodableShape {
        /// Name of the object key.
        internal let key: String
        /// Value of the tag.
        internal let value: String

        @inlinable
        internal init(key: String, value: String) {
            self.key = key
            self.value = value
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: String, CodingKey {
            case key = "Key"
            case value = "Value"
        }
    }

    internal struct Tagging: AWSEncodableShape {
        internal struct _TagSetEncoding: ArrayCoderProperties { internal static let member = "Tag" }

        /// A collection for a set of tags
        @CustomCoding<ArrayCoder<_TagSetEncoding, Tag>>
        internal var tagSet: [Tag]

        @inlinable
        internal init(tagSet: [Tag]) {
            self.tagSet = tagSet
        }

        internal func validate(name: String) throws {
            try self.tagSet.forEach {
                try $0.validate(name: "\(name).tagSet[]")
            }
        }

        private enum CodingKeys: String, CodingKey {
            case tagSet = "TagSet"
        }
    }

    internal struct TargetGrant: AWSEncodableShape & AWSDecodableShape {
        /// Container for the person being granted permissions.
        internal let grantee: Grantee?
        /// Logging permissions assigned to the grantee for the bucket.
        internal let permission: BucketLogsPermission?

        @inlinable
        internal init(grantee: Grantee? = nil, permission: BucketLogsPermission? = nil) {
            self.grantee = grantee
            self.permission = permission
        }

        private enum CodingKeys: String, CodingKey {
            case grantee = "Grantee"
            case permission = "Permission"
        }
    }

    internal struct TargetObjectKeyFormat: AWSEncodableShape & AWSDecodableShape {
        /// Partitioned S3 key for log objects.
        internal let partitionedPrefix: PartitionedPrefix?
        /// To use the simple format for S3 keys for log objects. To specify SimplePrefix format, set SimplePrefix to {}.
        internal let simplePrefix: SimplePrefix?

        @inlinable
        internal init(partitionedPrefix: PartitionedPrefix? = nil, simplePrefix: SimplePrefix? = nil) {
            self.partitionedPrefix = partitionedPrefix
            self.simplePrefix = simplePrefix
        }

        private enum CodingKeys: String, CodingKey {
            case partitionedPrefix = "PartitionedPrefix"
            case simplePrefix = "SimplePrefix"
        }
    }

    internal struct Tiering: AWSEncodableShape & AWSDecodableShape {
        /// S3 Intelligent-Tiering access tier. See Storage class for automatically optimizing frequently and infrequently accessed objects for a list of access tiers in the S3 Intelligent-Tiering storage class.
        internal let accessTier: IntelligentTieringAccessTier
        /// The number of consecutive days of no access after which an object will be eligible to be transitioned to the corresponding tier. The minimum number of days specified for Archive Access tier must be at least 90 days and Deep Archive Access tier must be at least 180 days. The maximum can be up to 2 years (730 days).
        internal let days: Int

        @inlinable
        internal init(accessTier: IntelligentTieringAccessTier, days: Int) {
            self.accessTier = accessTier
            self.days = days
        }

        private enum CodingKeys: String, CodingKey {
            case accessTier = "AccessTier"
            case days = "Days"
        }
    }

    internal struct TopicConfiguration: AWSEncodableShape & AWSDecodableShape {
        /// The Amazon S3 bucket event about which to send notifications. For more information, see Supported Event Types in the Amazon S3 User Guide.
        internal let events: [Event]
        internal let filter: NotificationConfigurationFilter?
        internal let id: String?
        /// The Amazon Resource Name (ARN) of the Amazon SNS topic to which Amazon S3 publishes a message when it detects events of the specified type.
        internal let topicArn: String

        @inlinable
        internal init(
            events: [Event], filter: NotificationConfigurationFilter? = nil, id: String? = nil, topicArn: String
        ) {
            self.events = events
            self.filter = filter
            self.id = id
            self.topicArn = topicArn
        }

        private enum CodingKeys: String, CodingKey {
            case events = "Event"
            case filter = "Filter"
            case id = "Id"
            case topicArn = "Topic"
        }
    }

    internal struct Transition: AWSEncodableShape & AWSDecodableShape {
        /// Indicates when objects are transitioned to the specified storage class. The date value must be in ISO 8601 format. The time is always midnight UTC.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var date: Date?
        /// Indicates the number of days after creation when objects are transitioned to the specified storage class. The value must be a positive integer.
        internal let days: Int?
        /// The storage class to which you want the object to transition.
        internal let storageClass: TransitionStorageClass?

        @inlinable
        internal init(date: Date? = nil, days: Int? = nil, storageClass: TransitionStorageClass? = nil) {
            self.date = date
            self.days = days
            self.storageClass = storageClass
        }

        private enum CodingKeys: String, CodingKey {
            case date = "Date"
            case days = "Days"
            case storageClass = "StorageClass"
        }
    }

    internal struct UploadPartCopyOutput: AWSDecodableShape {
        /// Indicates whether the multipart upload uses an S3 Bucket Key for server-side encryption with Key Management Service (KMS) keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// Container for all response elements.
        internal let copyPartResult: CopyPartResult
        /// The version of the source object that was copied, if you have enabled versioning on the source bucket.  This functionality is not supported when the source object is in a directory bucket.
        internal let copySourceVersionId: String?
        internal let requestCharged: RequestCharged?
        /// The server-side encryption algorithm used when you store this object in Amazon S3 (for example, AES256, aws:kms).
        internal let serverSideEncryption: ServerSideEncryption?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to confirm the encryption algorithm that's used.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide the round-trip message integrity verification of the customer-provided encryption key.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// If present, indicates the ID of the KMS key that was used for object encryption.
        internal let ssekmsKeyId: String?

        @inlinable
        internal init(
            bucketKeyEnabled: Bool? = nil, copyPartResult: CopyPartResult, copySourceVersionId: String? = nil,
            requestCharged: RequestCharged? = nil, serverSideEncryption: ServerSideEncryption? = nil,
            sseCustomerAlgorithm: String? = nil, sseCustomerKeyMD5: String? = nil, ssekmsKeyId: String? = nil
        ) {
            self.bucketKeyEnabled = bucketKeyEnabled
            self.copyPartResult = copyPartResult
            self.copySourceVersionId = copySourceVersionId
            self.requestCharged = requestCharged
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsKeyId = ssekmsKeyId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            let container = try decoder.singleValueContainer()
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.copyPartResult = try container.decode(CopyPartResult.self)
            self.copySourceVersionId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-copy-source-version-id")
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.sseCustomerAlgorithm = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-algorithm")
            self.sseCustomerKeyMD5 = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-key-MD5")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct UploadPartCopyRequest: AWSEncodableShape {
        /// The bucket name.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Copying objects across different Amazon Web Services Regions isn't supported when the source or destination bucket is in Amazon Web Services Local Zones. The source and destination buckets must have the same parent Amazon Web Services Region. Otherwise,  you get an HTTP 400 Bad Request error with the error code InvalidRequest.   Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Specifies the source object for the copy operation. You specify the value in one of two formats, depending on whether you want to access the source object through an access point:   For objects not accessed through an access point, specify the name of the source bucket and key of the source object, separated by a slash (/). For example, to copy the object reports/january.pdf from the bucket awsexamplebucket, use awsexamplebucket/reports/january.pdf. The value must be URL-encoded.   For objects accessed through access points, specify the Amazon Resource Name (ARN) of the object as accessed through the access point, in the format arn:aws:s3:::accesspoint//object/. For example, to copy the object reports/january.pdf through access point my-access-point owned by account 123456789012 in Region us-west-2, use the URL encoding of arn:aws:s3:us-west-2:123456789012:accesspoint/my-access-point/object/reports/january.pdf. The value must be URL encoded.    Amazon S3 supports copy operations using Access points only when the source and destination buckets are in the same Amazon Web Services Region.   Access points are not supported by directory buckets.    Alternatively, for objects accessed through Amazon S3 on Outposts, specify the ARN of the object as accessed in the format arn:aws:s3-outposts:::outpost//object/. For example, to copy the object reports/january.pdf through outpost my-outpost owned by account 123456789012 in Region us-west-2, use the URL encoding of arn:aws:s3-outposts:us-west-2:123456789012:outpost/my-outpost/object/reports/january.pdf. The value must be URL-encoded.     If your bucket has versioning enabled, you could have multiple versions of the same object. By default, x-amz-copy-source identifies the current version of the source object to copy. To copy a specific version of the source object to copy, append ?versionId= to the x-amz-copy-source request header (for example, x-amz-copy-source: /awsexamplebucket/reports/january.pdf?versionId=QUpfdndhfd8438MNFDN93jdnJFkdmqnh893).  If the current version is a delete marker and you don't specify a versionId in the x-amz-copy-source request header, Amazon S3 returns a 404 Not Found error, because the object does not exist. If you specify versionId in the x-amz-copy-source and the versionId is a delete marker, Amazon S3 returns an HTTP 400 Bad Request error, because you are not allowed to specify a delete marker as a version for the x-amz-copy-source.    Directory buckets - S3 Versioning isn't enabled and supported for directory buckets.
        internal let copySource: String
        /// Copies the object if its entity tag (ETag) matches the specified tag. If both of the x-amz-copy-source-if-match and x-amz-copy-source-if-unmodified-since headers are present in the request as follows:  x-amz-copy-source-if-match condition evaluates to true, and;  x-amz-copy-source-if-unmodified-since condition evaluates to false; Amazon S3 returns 200 OK and copies the data.
        internal let copySourceIfMatch: String?
        /// Copies the object if it has been modified since the specified time. If both of the x-amz-copy-source-if-none-match and x-amz-copy-source-if-modified-since headers are present in the request as follows:  x-amz-copy-source-if-none-match condition evaluates to false, and;  x-amz-copy-source-if-modified-since condition evaluates to true; Amazon S3 returns 412 Precondition Failed response code.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var copySourceIfModifiedSince: Date?
        /// Copies the object if its entity tag (ETag) is different than the specified ETag. If both of the x-amz-copy-source-if-none-match and x-amz-copy-source-if-modified-since headers are present in the request as follows:  x-amz-copy-source-if-none-match condition evaluates to false, and;  x-amz-copy-source-if-modified-since condition evaluates to true; Amazon S3 returns 412 Precondition Failed response code.
        internal let copySourceIfNoneMatch: String?
        /// Copies the object if it hasn't been modified since the specified time. If both of the x-amz-copy-source-if-match and x-amz-copy-source-if-unmodified-since headers are present in the request as follows:  x-amz-copy-source-if-match condition evaluates to true, and;  x-amz-copy-source-if-unmodified-since condition evaluates to false; Amazon S3 returns 200 OK and copies the data.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var copySourceIfUnmodifiedSince: Date?
        /// The range of bytes to copy from the source object. The range value must use the form bytes=first-last, where the first and last are the zero-based byte offsets to copy. For example, bytes=0-9 indicates that you want to copy the first 10 bytes of the source. You can copy a range only if the source object is greater than 5 MB.
        internal let copySourceRange: String?
        /// Specifies the algorithm to use when decrypting the source object (for example, AES256).  This functionality is not supported when the source object is in a directory bucket.
        internal let copySourceSSECustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use to decrypt the source object. The encryption key provided in this header must be one that was used when the source object was created.  This functionality is not supported when the source object is in a directory bucket.
        internal let copySourceSSECustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported when the source object is in a directory bucket.
        internal let copySourceSSECustomerKeyMD5: String?
        /// The account ID of the expected destination bucket owner. If the account ID that you provide does not match the actual owner of the destination bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// The account ID of the expected source bucket owner. If the account ID that you provide does not match the actual owner of the source bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedSourceBucketOwner: String?
        /// Object key for which the multipart upload was initiated.
        internal let key: String
        /// Part number of part being copied. This is a positive integer between 1 and 10,000.
        internal let partNumber: Int
        internal let requestPayer: RequestPayer?
        /// Specifies the algorithm to use when encrypting the object (for example, AES256).  This functionality is not supported when the destination bucket is a directory bucket.
        internal let sseCustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header. This must be the same encryption key specified in the initiate multipart upload request.  This functionality is not supported when the destination bucket is a directory bucket.
        internal let sseCustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported when the destination bucket is a directory bucket.
        internal let sseCustomerKeyMD5: String?
        /// Upload ID identifying the multipart upload whose part is being copied.
        internal let uploadId: String

        @inlinable
        internal init(
            bucket: String, copySource: String, copySourceIfMatch: String? = nil,
            copySourceIfModifiedSince: Date? = nil, copySourceIfNoneMatch: String? = nil,
            copySourceIfUnmodifiedSince: Date? = nil, copySourceRange: String? = nil,
            copySourceSSECustomerAlgorithm: String? = nil, copySourceSSECustomerKey: String? = nil,
            copySourceSSECustomerKeyMD5: String? = nil, expectedBucketOwner: String? = nil,
            expectedSourceBucketOwner: String? = nil, key: String, partNumber: Int, requestPayer: RequestPayer? = nil,
            sseCustomerAlgorithm: String? = nil, sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil,
            uploadId: String
        ) {
            self.bucket = bucket
            self.copySource = copySource
            self.copySourceIfMatch = copySourceIfMatch
            self.copySourceIfModifiedSince = copySourceIfModifiedSince
            self.copySourceIfNoneMatch = copySourceIfNoneMatch
            self.copySourceIfUnmodifiedSince = copySourceIfUnmodifiedSince
            self.copySourceRange = copySourceRange
            self.copySourceSSECustomerAlgorithm = copySourceSSECustomerAlgorithm
            self.copySourceSSECustomerKey = copySourceSSECustomerKey
            self.copySourceSSECustomerKeyMD5 = copySourceSSECustomerKeyMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.expectedSourceBucketOwner = expectedSourceBucketOwner
            self.key = key
            self.partNumber = partNumber
            self.requestPayer = requestPayer
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.uploadId = uploadId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            _ = encoder.container(keyedBy: CodingKeys.self)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.copySource, key: "x-amz-copy-source")
            request.encodeHeader(self.copySourceIfMatch, key: "x-amz-copy-source-if-match")
            request.encodeHeader(self._copySourceIfModifiedSince, key: "x-amz-copy-source-if-modified-since")
            request.encodeHeader(self.copySourceIfNoneMatch, key: "x-amz-copy-source-if-none-match")
            request.encodeHeader(self._copySourceIfUnmodifiedSince, key: "x-amz-copy-source-if-unmodified-since")
            request.encodeHeader(self.copySourceRange, key: "x-amz-copy-source-range")
            request.encodeHeader(
                self.copySourceSSECustomerAlgorithm, key: "x-amz-copy-source-server-side-encryption-customer-algorithm")
            request.encodeHeader(
                self.copySourceSSECustomerKey, key: "x-amz-copy-source-server-side-encryption-customer-key")
            request.encodeHeader(
                self.copySourceSSECustomerKeyMD5, key: "x-amz-copy-source-server-side-encryption-customer-key-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodeHeader(self.expectedSourceBucketOwner, key: "x-amz-source-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeQuery(self.partNumber, key: "partNumber")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeQuery(self.uploadId, key: "uploadId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.copySource, name: "copySource", parent: name, pattern: ".+\\/.+")
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct UploadPartOutput: AWSDecodableShape {
        /// Indicates whether the multipart upload uses an S3 Bucket Key for server-side encryption with Key Management Service (KMS) keys (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// The base64-encoded, 32-bit CRC-32 checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// The base64-encoded, 32-bit CRC-32C checksum of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// The base64-encoded, 160-bit SHA-1 digest of the object. This will only be present if it was uploaded with the object. When you use the API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// The base64-encoded, 256-bit SHA-256 digest of the object. This will only be present if it was uploaded with the object. When you use an API operation on an object that was uploaded using multipart uploads, this value may not be a direct checksum value of the full object. Instead, it's a calculation based on the checksum values of each individual part. For more information about how checksums are calculated with multipart uploads, see  Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Entity tag for the uploaded object.
        internal let eTag: String?
        internal let requestCharged: RequestCharged?
        /// The server-side encryption algorithm used when you store this object in Amazon S3 (for example, AES256, aws:kms).
        internal let serverSideEncryption: ServerSideEncryption?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to confirm the encryption algorithm that's used.  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// If server-side encryption with a customer-provided encryption key was requested, the response will include this header to provide the round-trip message integrity verification of the customer-provided encryption key.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// If present, indicates the ID of the KMS key that was used for object encryption.
        internal let ssekmsKeyId: String?

        @inlinable
        internal init(
            bucketKeyEnabled: Bool? = nil, checksumCRC32: String? = nil, checksumCRC32C: String? = nil,
            checksumSHA1: String? = nil, checksumSHA256: String? = nil, eTag: String? = nil,
            requestCharged: RequestCharged? = nil, serverSideEncryption: ServerSideEncryption? = nil,
            sseCustomerAlgorithm: String? = nil, sseCustomerKeyMD5: String? = nil, ssekmsKeyId: String? = nil
        ) {
            self.bucketKeyEnabled = bucketKeyEnabled
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.eTag = eTag
            self.requestCharged = requestCharged
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsKeyId = ssekmsKeyId
        }

        internal init(from decoder: Decoder) throws {
            let response = decoder.userInfo[.awsResponse]! as! ResponseDecodingContainer
            self.bucketKeyEnabled = try response.decodeHeaderIfPresent(
                Bool.self, key: "x-amz-server-side-encryption-bucket-key-enabled")
            self.checksumCRC32 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-crc32")
            self.checksumCRC32C = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-crc32c")
            self.checksumSHA1 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-sha1")
            self.checksumSHA256 = try response.decodeHeaderIfPresent(String.self, key: "x-amz-checksum-sha256")
            self.eTag = try response.decodeHeaderIfPresent(String.self, key: "ETag")
            self.requestCharged = try response.decodeHeaderIfPresent(RequestCharged.self, key: "x-amz-request-charged")
            self.serverSideEncryption = try response.decodeHeaderIfPresent(
                ServerSideEncryption.self, key: "x-amz-server-side-encryption")
            self.sseCustomerAlgorithm = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-algorithm")
            self.sseCustomerKeyMD5 = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-customer-key-MD5")
            self.ssekmsKeyId = try response.decodeHeaderIfPresent(
                String.self, key: "x-amz-server-side-encryption-aws-kms-key-id")
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct UploadPartRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.checksumHeader, .md5ChecksumHeader, .allowStreaming]
        internal static let _xmlRootNodeName: String? = "Body"
        /// Object data.
        internal let body: AWSHTTPBody?
        /// The name of the bucket to which the multipart upload was initiated.  Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
        internal let bucket: String
        /// Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For more information, see Checking object integrity in the Amazon S3 User Guide. If you provide an individual checksum, Amazon S3 ignores any provided ChecksumAlgorithm parameter. This checksum algorithm must be the same for all parts and it match the checksum value supplied in the CreateMultipartUpload request.
        internal let checksumAlgorithm: ChecksumAlgorithm?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32 checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32C checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumCRC32C: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 160-bit SHA-1 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA1: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 256-bit SHA-256 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
        internal let checksumSHA256: String?
        /// Size of the body in bytes. This parameter is useful when the size of the body cannot be determined automatically.
        internal let contentLength: Int64?
        /// The base64-encoded 128-bit MD5 digest of the part data. This parameter is auto-populated when using the command from the CLI. This parameter is required if object lock parameters are specified.  This functionality is not supported for directory buckets.
        internal let contentMD5: String?
        /// The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
        internal let expectedBucketOwner: String?
        /// Object key for which the multipart upload was initiated.
        internal let key: String
        /// Part number of part being uploaded. This is a positive integer between 1 and 10,000.
        internal let partNumber: Int
        internal let requestPayer: RequestPayer?
        /// Specifies the algorithm to use when encrypting the object (for example, AES256).  This functionality is not supported for directory buckets.
        internal let sseCustomerAlgorithm: String?
        /// Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header. This must be the same encryption key specified in the initiate multipart upload request.  This functionality is not supported for directory buckets.
        internal let sseCustomerKey: String?
        /// Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported for directory buckets.
        internal let sseCustomerKeyMD5: String?
        /// Upload ID identifying the multipart upload whose part is being uploaded.
        internal let uploadId: String

        @inlinable
        internal init(
            body: AWSHTTPBody? = nil, bucket: String, checksumAlgorithm: ChecksumAlgorithm? = nil,
            checksumCRC32: String? = nil, checksumCRC32C: String? = nil, checksumSHA1: String? = nil,
            checksumSHA256: String? = nil, contentLength: Int64? = nil, contentMD5: String? = nil,
            expectedBucketOwner: String? = nil, key: String, partNumber: Int, requestPayer: RequestPayer? = nil,
            sseCustomerAlgorithm: String? = nil, sseCustomerKey: String? = nil, sseCustomerKeyMD5: String? = nil,
            uploadId: String
        ) {
            self.body = body
            self.bucket = bucket
            self.checksumAlgorithm = checksumAlgorithm
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.contentLength = contentLength
            self.contentMD5 = contentMD5
            self.expectedBucketOwner = expectedBucketOwner
            self.key = key
            self.partNumber = partNumber
            self.requestPayer = requestPayer
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKey = sseCustomerKey
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.uploadId = uploadId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            try container.encode(self.body)
            request.encodePath(self.bucket, key: "Bucket")
            request.encodeHeader(self.checksumAlgorithm, key: "x-amz-sdk-checksum-algorithm")
            request.encodeHeader(self.checksumCRC32, key: "x-amz-checksum-crc32")
            request.encodeHeader(self.checksumCRC32C, key: "x-amz-checksum-crc32c")
            request.encodeHeader(self.checksumSHA1, key: "x-amz-checksum-sha1")
            request.encodeHeader(self.checksumSHA256, key: "x-amz-checksum-sha256")
            request.encodeHeader(self.contentLength, key: "Content-Length")
            request.encodeHeader(self.contentMD5, key: "Content-MD5")
            request.encodeHeader(self.expectedBucketOwner, key: "x-amz-expected-bucket-owner")
            request.encodePath(self.key, key: "Key")
            request.encodeQuery(self.partNumber, key: "partNumber")
            request.encodeHeader(self.requestPayer, key: "x-amz-request-payer")
            request.encodeHeader(self.sseCustomerAlgorithm, key: "x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(self.sseCustomerKey, key: "x-amz-server-side-encryption-customer-key")
            request.encodeHeader(self.sseCustomerKeyMD5, key: "x-amz-server-side-encryption-customer-key-MD5")
            request.encodeQuery(self.uploadId, key: "uploadId")
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, min: 1)
        }

        private enum CodingKeys: CodingKey {}
    }

    internal struct VersioningConfiguration: AWSEncodableShape {
        /// Specifies whether MFA delete is enabled in the bucket versioning configuration. This element is only returned if the bucket has been configured with MFA delete. If the bucket has never been so configured, this element is not returned.
        internal let mfaDelete: MFADelete?
        /// The versioning state of the bucket.
        internal let status: BucketVersioningStatus?

        @inlinable
        internal init(mfaDelete: MFADelete? = nil, status: BucketVersioningStatus? = nil) {
            self.mfaDelete = mfaDelete
            self.status = status
        }

        private enum CodingKeys: String, CodingKey {
            case mfaDelete = "MfaDelete"
            case status = "Status"
        }
    }

    internal struct WebsiteConfiguration: AWSEncodableShape {
        internal struct _RoutingRulesEncoding: ArrayCoderProperties { internal static let member = "RoutingRule" }

        /// The name of the error document for the website.
        internal let errorDocument: ErrorDocument?
        /// The name of the index document for the website.
        internal let indexDocument: IndexDocument?
        /// The redirect behavior for every request to this bucket's website endpoint.  If you specify this property, you can't specify any other property.
        internal let redirectAllRequestsTo: RedirectAllRequestsTo?
        /// Rules that define when a redirect is applied and the redirect behavior.
        @OptionalCustomCoding<ArrayCoder<_RoutingRulesEncoding, RoutingRule>>
        internal var routingRules: [RoutingRule]?

        @inlinable
        internal init(
            errorDocument: ErrorDocument? = nil, indexDocument: IndexDocument? = nil,
            redirectAllRequestsTo: RedirectAllRequestsTo? = nil, routingRules: [RoutingRule]? = nil
        ) {
            self.errorDocument = errorDocument
            self.indexDocument = indexDocument
            self.redirectAllRequestsTo = redirectAllRequestsTo
            self.routingRules = routingRules
        }

        internal func validate(name: String) throws {
            try self.errorDocument?.validate(name: "\(name).errorDocument")
        }

        private enum CodingKeys: String, CodingKey {
            case errorDocument = "ErrorDocument"
            case indexDocument = "IndexDocument"
            case redirectAllRequestsTo = "RedirectAllRequestsTo"
            case routingRules = "RoutingRules"
        }
    }

    internal struct WriteGetObjectResponseRequest: AWSEncodableShape {
        internal static let _options: AWSShapeOptions = [.allowStreaming, .allowChunkedStreaming]
        internal static let _xmlRootNodeName: String? = "Body"
        /// Indicates that a range of bytes was specified.
        internal let acceptRanges: String?
        /// The object data.
        internal let body: AWSHTTPBody?
        ///  Indicates whether the object stored in Amazon S3 uses an S3 bucket key for server-side encryption with Amazon Web Services KMS (SSE-KMS).
        internal let bucketKeyEnabled: Bool?
        /// Specifies caching behavior along the request/reply chain.
        internal let cacheControl: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This specifies the base64-encoded, 32-bit CRC-32 checksum of the object returned by the Object Lambda function. This may not match the checksum for the object stored in Amazon S3. Amazon S3 will perform validation of the checksum values only when the original GetObject request required checksum validation. For more information about checksums, see Checking object integrity in the Amazon S3 User Guide. Only one checksum header can be specified at a time. If you supply multiple checksum headers, this request will fail.
        internal let checksumCRC32: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This specifies the base64-encoded, 32-bit CRC-32C checksum of the object returned by the Object Lambda function. This may not match the checksum for the object stored in Amazon S3. Amazon S3 will perform validation of the checksum values only when the original GetObject request required checksum validation. For more information about checksums, see Checking object integrity in the Amazon S3 User Guide. Only one checksum header can be specified at a time. If you supply multiple checksum headers, this request will fail.
        internal let checksumCRC32C: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This specifies the base64-encoded, 160-bit SHA-1 digest of the object returned by the Object Lambda function. This may not match the checksum for the object stored in Amazon S3. Amazon S3 will perform validation of the checksum values only when the original GetObject request required checksum validation. For more information about checksums, see Checking object integrity in the Amazon S3 User Guide. Only one checksum header can be specified at a time. If you supply multiple checksum headers, this request will fail.
        internal let checksumSHA1: String?
        /// This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This specifies the base64-encoded, 256-bit SHA-256 digest of the object returned by the Object Lambda function. This may not match the checksum for the object stored in Amazon S3. Amazon S3 will perform validation of the checksum values only when the original GetObject request required checksum validation. For more information about checksums, see Checking object integrity in the Amazon S3 User Guide. Only one checksum header can be specified at a time. If you supply multiple checksum headers, this request will fail.
        internal let checksumSHA256: String?
        /// Specifies presentational information for the object.
        internal let contentDisposition: String?
        /// Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field.
        internal let contentEncoding: String?
        /// The language the content is in.
        internal let contentLanguage: String?
        /// The size of the content body in bytes.
        internal let contentLength: Int64?
        /// The portion of the object returned in the response.
        internal let contentRange: String?
        /// A standard MIME type describing the format of the object data.
        internal let contentType: String?
        /// Specifies whether an object stored in Amazon S3 is (true) or is not (false) a delete marker.
        internal let deleteMarker: Bool?
        /// A string that uniquely identifies an error condition. Returned in the  tag of the error XML response for a corresponding GetObject call. Cannot be used with a successful StatusCode header or when the transformed object is provided in the body. All error codes from S3 are sentence-cased. The regular expression (regex) value is "^[A-Z][a-zA-Z]+$".
        internal let errorCode: String?
        /// Contains a generic description of the error condition. Returned in the  tag of the error XML response for a corresponding GetObject call. Cannot be used with a successful StatusCode header or when the transformed object is provided in body.
        internal let errorMessage: String?
        /// An opaque identifier assigned by a web server to a specific version of a resource found at a URL.
        internal let eTag: String?
        /// If the object expiration is configured (see PUT Bucket lifecycle), the response includes this header. It includes the expiry-date and rule-id key-value pairs that provide the object expiration information. The value of the rule-id is URL-encoded.
        internal let expiration: String?
        /// The date and time at which the object is no longer cacheable.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var expires: Date?
        /// The date and time that the object was last modified.
        @OptionalCustomCoding<HTTPHeaderDateCoder>
        internal var lastModified: Date?
        /// A map of metadata to store with the object in S3.
        internal let metadata: [String: String]?
        /// Set to the number of metadata entries not returned in x-amz-meta headers. This can happen if you create metadata using an API like SOAP that supports more flexible metadata than the REST API. For example, using SOAP, you can create metadata whose values are not legal HTTP headers.
        internal let missingMeta: Int?
        /// Indicates whether an object stored in Amazon S3 has an active legal hold.
        internal let objectLockLegalHoldStatus: ObjectLockLegalHoldStatus?
        /// Indicates whether an object stored in Amazon S3 has Object Lock enabled. For more information about S3 Object Lock, see Object Lock.
        internal let objectLockMode: ObjectLockMode?
        /// The date and time when Object Lock is configured to expire.
        @OptionalCustomCoding<ISO8601DateCoder>
        internal var objectLockRetainUntilDate: Date?
        /// The count of parts this object has.
        internal let partsCount: Int?
        /// Indicates if request involves bucket that is either a source or destination in a Replication rule. For more information about S3 Replication, see Replication.
        internal let replicationStatus: ReplicationStatus?
        internal let requestCharged: RequestCharged?
        /// Route prefix to the HTTP URL generated.
        internal let requestRoute: String
        /// A single use encrypted token that maps WriteGetObjectResponse to the end user GetObject request.
        internal let requestToken: String
        /// Provides information about object restoration operation and expiration time of the restored object copy.
        internal let restore: String?
        ///  The server-side encryption algorithm used when storing requested object in Amazon S3 (for example, AES256, aws:kms).
        internal let serverSideEncryption: ServerSideEncryption?
        /// Encryption algorithm used if server-side encryption with a customer-provided encryption key was specified for object stored in Amazon S3.
        internal let sseCustomerAlgorithm: String?
        ///  128-bit MD5 digest of customer-provided encryption key used in Amazon S3 to encrypt data stored in S3. For more information, see Protecting data using server-side encryption with customer-provided encryption keys (SSE-C).
        internal let sseCustomerKeyMD5: String?
        ///  If present, specifies the ID (Key ID, Key ARN, or Key Alias) of the Amazon Web Services Key Management Service (Amazon Web Services KMS) symmetric encryption customer managed key that was used for stored in Amazon S3 object.
        internal let ssekmsKeyId: String?
        /// The integer status code for an HTTP response of a corresponding GetObject request. The following is a list of status codes.    200 - OK     206 - Partial Content     304 - Not Modified     400 - Bad Request     401 - Unauthorized     403 - Forbidden     404 - Not Found     405 - Method Not Allowed     409 - Conflict     411 - Length Required     412 - Precondition Failed     416 - Range Not Satisfiable     500 - Internal Server Error     503 - Service Unavailable
        internal let statusCode: Int?
        /// Provides storage class information of the object. Amazon S3 returns this header for all objects except for S3 Standard storage class objects. For more information, see Storage Classes.
        internal let storageClass: StorageClass?
        /// The number of tags, if any, on the object.
        internal let tagCount: Int?
        /// An ID used to reference a specific version of the object.
        internal let versionId: String?

        @inlinable
        internal init(
            acceptRanges: String? = nil, body: AWSHTTPBody? = nil, bucketKeyEnabled: Bool? = nil,
            cacheControl: String? = nil, checksumCRC32: String? = nil, checksumCRC32C: String? = nil,
            checksumSHA1: String? = nil, checksumSHA256: String? = nil, contentDisposition: String? = nil,
            contentEncoding: String? = nil, contentLanguage: String? = nil, contentLength: Int64? = nil,
            contentRange: String? = nil, contentType: String? = nil, deleteMarker: Bool? = nil,
            errorCode: String? = nil, errorMessage: String? = nil, eTag: String? = nil, expiration: String? = nil,
            expires: Date? = nil, lastModified: Date? = nil, metadata: [String: String]? = nil, missingMeta: Int? = nil,
            objectLockLegalHoldStatus: ObjectLockLegalHoldStatus? = nil, objectLockMode: ObjectLockMode? = nil,
            objectLockRetainUntilDate: Date? = nil, partsCount: Int? = nil, replicationStatus: ReplicationStatus? = nil,
            requestCharged: RequestCharged? = nil, requestRoute: String, requestToken: String, restore: String? = nil,
            serverSideEncryption: ServerSideEncryption? = nil, sseCustomerAlgorithm: String? = nil,
            sseCustomerKeyMD5: String? = nil, ssekmsKeyId: String? = nil, statusCode: Int? = nil,
            storageClass: StorageClass? = nil, tagCount: Int? = nil, versionId: String? = nil
        ) {
            self.acceptRanges = acceptRanges
            self.body = body
            self.bucketKeyEnabled = bucketKeyEnabled
            self.cacheControl = cacheControl
            self.checksumCRC32 = checksumCRC32
            self.checksumCRC32C = checksumCRC32C
            self.checksumSHA1 = checksumSHA1
            self.checksumSHA256 = checksumSHA256
            self.contentDisposition = contentDisposition
            self.contentEncoding = contentEncoding
            self.contentLanguage = contentLanguage
            self.contentLength = contentLength
            self.contentRange = contentRange
            self.contentType = contentType
            self.deleteMarker = deleteMarker
            self.errorCode = errorCode
            self.errorMessage = errorMessage
            self.eTag = eTag
            self.expiration = expiration
            self.expires = expires
            self.lastModified = lastModified
            self.metadata = metadata
            self.missingMeta = missingMeta
            self.objectLockLegalHoldStatus = objectLockLegalHoldStatus
            self.objectLockMode = objectLockMode
            self.objectLockRetainUntilDate = objectLockRetainUntilDate
            self.partsCount = partsCount
            self.replicationStatus = replicationStatus
            self.requestCharged = requestCharged
            self.requestRoute = requestRoute
            self.requestToken = requestToken
            self.restore = restore
            self.serverSideEncryption = serverSideEncryption
            self.sseCustomerAlgorithm = sseCustomerAlgorithm
            self.sseCustomerKeyMD5 = sseCustomerKeyMD5
            self.ssekmsKeyId = ssekmsKeyId
            self.statusCode = statusCode
            self.storageClass = storageClass
            self.tagCount = tagCount
            self.versionId = versionId
        }

        internal func encode(to encoder: Encoder) throws {
            let request = encoder.userInfo[.awsRequest]! as! RequestEncodingContainer
            var container = encoder.singleValueContainer()
            request.encodeHeader(self.acceptRanges, key: "x-amz-fwd-header-accept-ranges")
            try container.encode(self.body)
            request.encodeHeader(
                self.bucketKeyEnabled, key: "x-amz-fwd-header-x-amz-server-side-encryption-bucket-key-enabled")
            request.encodeHeader(self.cacheControl, key: "x-amz-fwd-header-Cache-Control")
            request.encodeHeader(self.checksumCRC32, key: "x-amz-fwd-header-x-amz-checksum-crc32")
            request.encodeHeader(self.checksumCRC32C, key: "x-amz-fwd-header-x-amz-checksum-crc32c")
            request.encodeHeader(self.checksumSHA1, key: "x-amz-fwd-header-x-amz-checksum-sha1")
            request.encodeHeader(self.checksumSHA256, key: "x-amz-fwd-header-x-amz-checksum-sha256")
            request.encodeHeader(self.contentDisposition, key: "x-amz-fwd-header-Content-Disposition")
            request.encodeHeader(self.contentEncoding, key: "x-amz-fwd-header-Content-Encoding")
            request.encodeHeader(self.contentLanguage, key: "x-amz-fwd-header-Content-Language")
            request.encodeHeader(self.contentLength, key: "Content-Length")
            request.encodeHeader(self.contentRange, key: "x-amz-fwd-header-Content-Range")
            request.encodeHeader(self.contentType, key: "x-amz-fwd-header-Content-Type")
            request.encodeHeader(self.deleteMarker, key: "x-amz-fwd-header-x-amz-delete-marker")
            request.encodeHeader(self.errorCode, key: "x-amz-fwd-error-code")
            request.encodeHeader(self.errorMessage, key: "x-amz-fwd-error-message")
            request.encodeHeader(self.eTag, key: "x-amz-fwd-header-ETag")
            request.encodeHeader(self.expiration, key: "x-amz-fwd-header-x-amz-expiration")
            request.encodeHeader(self._expires, key: "x-amz-fwd-header-Expires")
            request.encodeHeader(self._lastModified, key: "x-amz-fwd-header-Last-Modified")
            request.encodeHeader(self.metadata, key: "x-amz-meta-")
            request.encodeHeader(self.missingMeta, key: "x-amz-fwd-header-x-amz-missing-meta")
            request.encodeHeader(self.objectLockLegalHoldStatus, key: "x-amz-fwd-header-x-amz-object-lock-legal-hold")
            request.encodeHeader(self.objectLockMode, key: "x-amz-fwd-header-x-amz-object-lock-mode")
            request.encodeHeader(
                self._objectLockRetainUntilDate, key: "x-amz-fwd-header-x-amz-object-lock-retain-until-date")
            request.encodeHeader(self.partsCount, key: "x-amz-fwd-header-x-amz-mp-parts-count")
            request.encodeHeader(self.replicationStatus, key: "x-amz-fwd-header-x-amz-replication-status")
            request.encodeHeader(self.requestCharged, key: "x-amz-fwd-header-x-amz-request-charged")
            request.encodeHeader(self.requestRoute, key: "x-amz-request-route")
            request.encodeHostPrefix(self.requestRoute, key: "RequestRoute")
            request.encodeHeader(self.requestToken, key: "x-amz-request-token")
            request.encodeHeader(self.restore, key: "x-amz-fwd-header-x-amz-restore")
            request.encodeHeader(self.serverSideEncryption, key: "x-amz-fwd-header-x-amz-server-side-encryption")
            request.encodeHeader(
                self.sseCustomerAlgorithm, key: "x-amz-fwd-header-x-amz-server-side-encryption-customer-algorithm")
            request.encodeHeader(
                self.sseCustomerKeyMD5, key: "x-amz-fwd-header-x-amz-server-side-encryption-customer-key-MD5")
            request.encodeHeader(self.ssekmsKeyId, key: "x-amz-fwd-header-x-amz-server-side-encryption-aws-kms-key-id")
            request.encodeHeader(self.statusCode, key: "x-amz-fwd-status")
            request.encodeHeader(self.storageClass, key: "x-amz-fwd-header-x-amz-storage-class")
            request.encodeHeader(self.tagCount, key: "x-amz-fwd-header-x-amz-tagging-count")
            request.encodeHeader(self.versionId, key: "x-amz-fwd-header-x-amz-version-id")
        }

        private enum CodingKeys: CodingKey {}
    }
}

// MARK: - Errors

/// Error enum for S3
internal struct S3ErrorType: AWSErrorType {
    enum Code: String {
        case bucketAlreadyExists = "BucketAlreadyExists"
        case bucketAlreadyOwnedByYou = "BucketAlreadyOwnedByYou"
        case encryptionTypeMismatch = "EncryptionTypeMismatch"
        case invalidObjectState = "InvalidObjectState"
        case invalidRequest = "InvalidRequest"
        case invalidWriteOffset = "InvalidWriteOffset"
        case noSuchBucket = "NoSuchBucket"
        case noSuchKey = "NoSuchKey"
        case noSuchUpload = "NoSuchUpload"
        case notFound = "NotFound"
        case objectAlreadyInActiveTierError = "ObjectAlreadyInActiveTierError"
        case objectNotInActiveTierError = "ObjectNotInActiveTierError"
        case tooManyParts = "TooManyParts"
    }

    private let error: Code
    internal let context: AWSErrorContext?

    /// initialize S3
    internal init?(errorCode: String, context: AWSErrorContext) {
        guard let error = Code(rawValue: errorCode) else { return nil }
        self.error = error
        self.context = context
    }

    internal init(_ error: Code) {
        self.error = error
        self.context = nil
    }

    /// return error code string
    internal var errorCode: String { self.error.rawValue }

    /// The requested bucket name is not available. The bucket namespace is shared by all users of the system. Select a different name and try again.
    internal static var bucketAlreadyExists: Self { .init(.bucketAlreadyExists) }
    /// The bucket you tried to create already exists, and you own it. Amazon S3 returns this error in all Amazon Web Services Regions except in the North Virginia Region. For legacy compatibility, if you re-create an existing bucket that you already own in the North Virginia Region, Amazon S3 returns 200 OK and resets the bucket access control lists (ACLs).
    internal static var bucketAlreadyOwnedByYou: Self { .init(.bucketAlreadyOwnedByYou) }
    ///  The existing object was created with a different encryption type.  Subsequent write requests must include the appropriate encryption  parameters in the request or while creating the session.
    internal static var encryptionTypeMismatch: Self { .init(.encryptionTypeMismatch) }
    /// Object is archived and inaccessible until restored. If the object you are retrieving is stored in the S3 Glacier Flexible Retrieval storage class, the S3 Glacier Deep Archive storage class, the S3 Intelligent-Tiering Archive Access tier, or the S3 Intelligent-Tiering Deep Archive Access tier, before you can retrieve the object you must first restore a copy using RestoreObject. Otherwise, this operation returns an InvalidObjectState error. For information about restoring archived objects, see Restoring Archived Objects in the Amazon S3 User Guide.
    internal static var invalidObjectState: Self { .init(.invalidObjectState) }
    /// You may receive this error in multiple cases. Depending on the reason for the error, you may receive one of the messages below:   Cannot specify both a write offset value and user-defined object metadata for existing objects.   Checksum Type mismatch occurred, expected checksum Type: sha1, actual checksum Type: crc32c.   Request body cannot be empty when 'write offset' is specified.
    internal static var invalidRequest: Self { .init(.invalidRequest) }
    ///  The write offset value that you specified does not match the current object size.
    internal static var invalidWriteOffset: Self { .init(.invalidWriteOffset) }
    /// The specified bucket does not exist.
    internal static var noSuchBucket: Self { .init(.noSuchBucket) }
    /// The specified key does not exist.
    internal static var noSuchKey: Self { .init(.noSuchKey) }
    /// The specified multipart upload does not exist.
    internal static var noSuchUpload: Self { .init(.noSuchUpload) }
    /// The specified content does not exist.
    internal static var notFound: Self { .init(.notFound) }
    /// This action is not allowed against this storage tier.
    internal static var objectAlreadyInActiveTierError: Self { .init(.objectAlreadyInActiveTierError) }
    /// The source object of the COPY action is not in the active tier and is only stored in Amazon S3 Glacier.
    internal static var objectNotInActiveTierError: Self { .init(.objectNotInActiveTierError) }
    ///  You have attempted to add more parts than the maximum of 10000  that are allowed for this object. You can use the CopyObject operation  to copy this object to another and then add more data to the newly copied object.
    internal static var tooManyParts: Self { .init(.tooManyParts) }
}

extension S3ErrorType: Equatable {
    internal static func == (lhs: S3ErrorType, rhs: S3ErrorType) -> Bool {
        lhs.error == rhs.error
    }
}

extension S3ErrorType: CustomStringConvertible {
    internal var description: String {
        return "\(self.error.rawValue): \(self.message ?? "")"
    }
}
