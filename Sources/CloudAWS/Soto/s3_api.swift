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

import SotoCore

#if os(Linux) && compiler(<5.10)
    // swift-corelibs-foundation hasn't been updated with Sendable conformances
    @preconcurrency import Foundation
#else
    import Foundation
#endif

/// Service object for interacting with AWS S3 service.
internal struct S3: AWSService {
    // MARK: Member variables

    /// Client used for communication with AWS
    internal let client: AWSClient
    /// Service configuration
    internal let config: AWSServiceConfig

    // MARK: Initialization

    /// Initialize the S3 client
    /// - parameters:
    ///     - client: AWSClient used to process requests
    ///     - region: Region of server you want to communicate with. This will override the partition parameter.
    ///     - partition: AWS partition where service resides, standard (.aws), china (.awscn), government (.awsusgov).
    ///     - endpoint: Custom endpoint URL to use instead of standard AWS servers
    ///     - timeout: Timeout value for HTTP requests
    ///     - byteBufferAllocator: Allocator for ByteBuffers
    ///     - options: Service options
    internal init(
        client: AWSClient,
        region: SotoCore.Region? = nil,
        partition: AWSPartition = .aws,
        endpoint: String? = nil,
        timeout: TimeAmount? = nil,
        byteBufferAllocator: ByteBufferAllocator = ByteBufferAllocator(),
        options: AWSServiceConfig.Options = []
    ) {
        self.client = client
        self.config = AWSServiceConfig(
            region: region,
            partition: region?.partition ?? partition,
            serviceName: "S3",
            serviceIdentifier: "s3",
            serviceProtocol: .restxml,
            apiVersion: "2006-03-01",
            endpoint: endpoint,
            serviceEndpoints: Self.serviceEndpoints,
            variantEndpoints: Self.variantEndpoints,
            errorType: S3ErrorType.self,
            xmlNamespace: "http://s3.amazonaws.com/doc/2006-03-01/",
            middleware: S3Middleware(),
            timeout: timeout,
            byteBufferAllocator: byteBufferAllocator,
            options: options
        )
    }

    /// Initialize the S3 client
    /// - parameters:
    ///     - client: AWSClient used to process requests
    ///     - region: Region of server you want to communicate with. This will override the partition parameter.
    ///     - partition: AWS partition where service resides, standard (.aws), china (.awscn), government (.awsusgov).
    ///     - endpoint: Custom endpoint URL to use instead of standard AWS servers
    ///     - middleware: Middleware chain used to edit requests before they are sent and responses before they are decoded
    ///     - timeout: Timeout value for HTTP requests
    ///     - byteBufferAllocator: Allocator for ByteBuffers
    ///     - options: Service options
    internal init(
        client: AWSClient,
        region: SotoCore.Region? = nil,
        partition: AWSPartition = .aws,
        endpoint: String? = nil,
        middleware: some AWSMiddlewareProtocol,
        timeout: TimeAmount? = nil,
        byteBufferAllocator: ByteBufferAllocator = ByteBufferAllocator(),
        options: AWSServiceConfig.Options = []
    ) {
        self.client = client
        self.config = AWSServiceConfig(
            region: region,
            partition: region?.partition ?? partition,
            serviceName: "S3",
            serviceIdentifier: "s3",
            serviceProtocol: .restxml,
            apiVersion: "2006-03-01",
            endpoint: endpoint,
            serviceEndpoints: Self.serviceEndpoints,
            variantEndpoints: Self.variantEndpoints,
            errorType: S3ErrorType.self,
            xmlNamespace: "http://s3.amazonaws.com/doc/2006-03-01/",
            middleware: AWSMiddlewareStack {
                middleware
                S3Middleware()
            },
            timeout: timeout,
            byteBufferAllocator: byteBufferAllocator,
            options: options
        )
    }

    /// custom endpoints for regions
    static var serviceEndpoints: [String: String] {
        [
            "af-south-1": "s3.af-south-1.amazonaws.com",
            "ap-east-1": "s3.ap-east-1.amazonaws.com",
            "ap-northeast-1": "s3.ap-northeast-1.amazonaws.com",
            "ap-northeast-2": "s3.ap-northeast-2.amazonaws.com",
            "ap-northeast-3": "s3.ap-northeast-3.amazonaws.com",
            "ap-south-1": "s3.ap-south-1.amazonaws.com",
            "ap-south-2": "s3.ap-south-2.amazonaws.com",
            "ap-southeast-1": "s3.ap-southeast-1.amazonaws.com",
            "ap-southeast-2": "s3.ap-southeast-2.amazonaws.com",
            "ap-southeast-3": "s3.ap-southeast-3.amazonaws.com",
            "ap-southeast-4": "s3.ap-southeast-4.amazonaws.com",
            "ap-southeast-5": "s3.ap-southeast-5.amazonaws.com",
            "aws-global": "s3.amazonaws.com",
            "ca-central-1": "s3.ca-central-1.amazonaws.com",
            "ca-west-1": "s3.ca-west-1.amazonaws.com",
            "eu-central-1": "s3.eu-central-1.amazonaws.com",
            "eu-central-2": "s3.eu-central-2.amazonaws.com",
            "eu-north-1": "s3.eu-north-1.amazonaws.com",
            "eu-south-1": "s3.eu-south-1.amazonaws.com",
            "eu-south-2": "s3.eu-south-2.amazonaws.com",
            "eu-west-1": "s3.eu-west-1.amazonaws.com",
            "eu-west-2": "s3.eu-west-2.amazonaws.com",
            "eu-west-3": "s3.eu-west-3.amazonaws.com",
            "il-central-1": "s3.il-central-1.amazonaws.com",
            "me-central-1": "s3.me-central-1.amazonaws.com",
            "me-south-1": "s3.me-south-1.amazonaws.com",
            "s3-external-1": "s3-external-1.amazonaws.com",
            "sa-east-1": "s3.sa-east-1.amazonaws.com",
            "us-east-1": "s3.us-east-1.amazonaws.com",
            "us-east-2": "s3.us-east-2.amazonaws.com",
            "us-gov-east-1": "s3.us-gov-east-1.amazonaws.com",
            "us-gov-west-1": "s3.us-gov-west-1.amazonaws.com",
            "us-west-1": "s3.us-west-1.amazonaws.com",
            "us-west-2": "s3.us-west-2.amazonaws.com",
        ]
    }

    /// FIPS and dualstack endpoints
    static var variantEndpoints: [EndpointVariantType: AWSServiceConfig.EndpointVariant] {
        [
            [.dualstack]: .init(endpoints: [
                "af-south-1": "s3.dualstack.af-south-1.amazonaws.com",
                "ap-east-1": "s3.dualstack.ap-east-1.amazonaws.com",
                "ap-northeast-1": "s3.dualstack.ap-northeast-1.amazonaws.com",
                "ap-northeast-2": "s3.dualstack.ap-northeast-2.amazonaws.com",
                "ap-northeast-3": "s3.dualstack.ap-northeast-3.amazonaws.com",
                "ap-south-1": "s3.dualstack.ap-south-1.amazonaws.com",
                "ap-south-2": "s3.dualstack.ap-south-2.amazonaws.com",
                "ap-southeast-1": "s3.dualstack.ap-southeast-1.amazonaws.com",
                "ap-southeast-2": "s3.dualstack.ap-southeast-2.amazonaws.com",
                "ap-southeast-3": "s3.dualstack.ap-southeast-3.amazonaws.com",
                "ap-southeast-4": "s3.dualstack.ap-southeast-4.amazonaws.com",
                "ap-southeast-5": "s3.dualstack.ap-southeast-5.amazonaws.com",
                "aws-global": "s3.dualstack.aws-global.amazonaws.com",
                "ca-central-1": "s3.dualstack.ca-central-1.amazonaws.com",
                "ca-west-1": "s3.dualstack.ca-west-1.amazonaws.com",
                "cn-north-1": "s3.dualstack.cn-north-1.amazonaws.com.cn",
                "cn-northwest-1": "s3.dualstack.cn-northwest-1.amazonaws.com.cn",
                "eu-central-1": "s3.dualstack.eu-central-1.amazonaws.com",
                "eu-central-2": "s3.dualstack.eu-central-2.amazonaws.com",
                "eu-north-1": "s3.dualstack.eu-north-1.amazonaws.com",
                "eu-south-1": "s3.dualstack.eu-south-1.amazonaws.com",
                "eu-south-2": "s3.dualstack.eu-south-2.amazonaws.com",
                "eu-west-1": "s3.dualstack.eu-west-1.amazonaws.com",
                "eu-west-2": "s3.dualstack.eu-west-2.amazonaws.com",
                "eu-west-3": "s3.dualstack.eu-west-3.amazonaws.com",
                "il-central-1": "s3.dualstack.il-central-1.amazonaws.com",
                "me-central-1": "s3.dualstack.me-central-1.amazonaws.com",
                "me-south-1": "s3.dualstack.me-south-1.amazonaws.com",
                "s3-external-1": "s3.dualstack.s3-external-1.amazonaws.com",
                "sa-east-1": "s3.dualstack.sa-east-1.amazonaws.com",
                "us-east-1": "s3.dualstack.us-east-1.amazonaws.com",
                "us-east-2": "s3.dualstack.us-east-2.amazonaws.com",
                "us-gov-east-1": "s3.dualstack.us-gov-east-1.amazonaws.com",
                "us-gov-west-1": "s3.dualstack.us-gov-west-1.amazonaws.com",
                "us-west-1": "s3.dualstack.us-west-1.amazonaws.com",
                "us-west-2": "s3.dualstack.us-west-2.amazonaws.com",
            ]),
            [.dualstack, .fips]: .init(endpoints: [
                "aws-global": "s3-fips.dualstack.aws-global.amazonaws.com",
                "ca-central-1": "s3-fips.dualstack.ca-central-1.amazonaws.com",
                "ca-west-1": "s3-fips.dualstack.ca-west-1.amazonaws.com",
                "s3-external-1": "s3-fips.dualstack.s3-external-1.amazonaws.com",
                "us-east-1": "s3-fips.dualstack.us-east-1.amazonaws.com",
                "us-east-2": "s3-fips.dualstack.us-east-2.amazonaws.com",
                "us-west-1": "s3-fips.dualstack.us-west-1.amazonaws.com",
                "us-west-2": "s3-fips.dualstack.us-west-2.amazonaws.com",
            ]),
            [.fips]: .init(endpoints: [
                "ca-central-1": "s3-fips.ca-central-1.amazonaws.com",
                "ca-west-1": "s3-fips.ca-west-1.amazonaws.com",
                "us-east-1": "s3-fips.us-east-1.amazonaws.com",
                "us-east-2": "s3-fips.us-east-2.amazonaws.com",
                "us-gov-east-1": "s3-fips.us-gov-east-1.amazonaws.com",
                "us-gov-west-1": "s3-fips.us-gov-west-1.amazonaws.com",
                "us-iso-east-1": "s3-fips.us-iso-east-1.c2s.ic.gov",
                "us-iso-west-1": "s3-fips.us-iso-west-1.c2s.ic.gov",
                "us-isob-east-1": "s3-fips.us-isob-east-1.sc2s.sgov.gov",
                "us-west-1": "s3-fips.us-west-1.amazonaws.com",
                "us-west-2": "s3-fips.us-west-2.amazonaws.com",
            ]),
        ]
    }

    // MARK: API Calls

    ///  This action creates an Amazon S3 bucket. To create an Amazon S3 on Outposts bucket, see  CreateBucket .  Creates a new S3 bucket. To create a bucket, you must set up Amazon S3 and have a valid Amazon Web Services Access Key ID to authenticate requests. Anonymous requests are never allowed to create buckets. By creating the bucket, you become the bucket owner. There are two types of buckets: general purpose buckets and directory buckets. For more information about these bucket types, see Creating, configuring, and working with Amazon S3 buckets in the Amazon S3 User Guide.     General purpose buckets - If you send your CreateBucket request to the s3.amazonaws.com global endpoint, the request goes to the us-east-1 Region. So the signature calculations in Signature Version 4 must use us-east-1 as the Region, even if the location constraint in the request specifies another Region where the bucket is to be created. If you create a bucket in a Region other than US East (N. Virginia), your application must be able to handle 307 redirect. For more information, see Virtual hosting of buckets in the Amazon S3 User Guide.    Directory buckets  - For directory buckets, you must make requests for this API operation to the Regional endpoint. These endpoints support path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported.
    /// For more information about endpoints in Availability Zones, see Regional and Zonal endpoints for directory buckets in Availability Zones in the Amazon S3 User Guide. For more information about endpoints in Local Zones, see Available Local Zone for directory buckets in the Amazon S3 User Guide.     Permissions     General purpose bucket permissions - In addition to the s3:CreateBucket permission, the following permissions are required in a policy when your CreateBucket request includes specific headers:     Access control lists (ACLs) - In your CreateBucket request, if you specify an access control list (ACL) and set it to public-read, public-read-write, authenticated-read, or if you explicitly specify any other custom ACLs, both s3:CreateBucket and s3:PutBucketAcl permissions are required. In your CreateBucket request, if you set the ACL to private, or if you don't specify any ACLs, only the s3:CreateBucket permission is required.     Object Lock - In your CreateBucket request, if you set x-amz-bucket-object-lock-enabled to true, the s3:PutBucketObjectLockConfiguration and s3:PutBucketVersioning permissions are required.    S3 Object Ownership - If your CreateBucket request includes the x-amz-object-ownership header, then the s3:PutBucketOwnershipControls permission is required.  To set an ACL on a bucket as part of a CreateBucket request, you must explicitly set S3 Object Ownership for the bucket to a different value than the default, BucketOwnerEnforced. Additionally, if your desired bucket ACL grants public access, you must first create the bucket (without the bucket ACL) and then explicitly disable Block Public Access on the bucket before using PutBucketAcl to set the ACL. If you try to create a bucket with a public ACL, the request will fail.  For the majority of modern use cases in S3, we recommend that you keep all Block Public Access settings enabled and keep ACLs disabled. If you would like to share data with users outside of your account, you can use bucket policies as needed. For more information, see Controlling ownership of objects and disabling ACLs for your bucket  and Blocking public access to your Amazon S3 storage  in the Amazon S3 User Guide.      S3 Block Public Access - If your specific use case requires granting public access to your S3 resources, you can disable Block Public Access. Specifically, you can create a new bucket with Block Public Access enabled, then separately call the  DeletePublicAccessBlock API. To use this operation, you must have the s3:PutBucketPublicAccessBlock permission. For more information about S3 Block Public Access, see Blocking public access to your Amazon S3 storage  in the Amazon S3 User Guide.       Directory bucket permissions - You must have the s3express:CreateBucket permission in an IAM identity-based policy instead of a bucket policy. Cross-account access to this API operation isn't supported. This operation can only be performed by the Amazon Web Services account that owns the resource. For more information about directory bucket policies and permissions, see Amazon Web Services Identity and Access Management (IAM) for S3 Express One Zone in the Amazon S3 User Guide.  The permissions for ACLs, Object Lock, S3 Object Ownership, and S3 Block Public Access are not supported for directory buckets. For directory buckets, all Block Public Access settings are enabled at the bucket level and S3 Object Ownership is set to Bucket owner enforced (ACLs disabled). These settings can't be modified.  For more information about permissions for creating and working with directory buckets, see Directory buckets in the Amazon S3 User Guide. For more information about supported S3 features for directory buckets, see Features of S3 Express One Zone in the Amazon S3 User Guide.     HTTP Host header syntax   Directory buckets  - The HTTP Host header syntax is s3express-control.region-code.amazonaws.com.   The following operations are related to CreateBucket:    PutObject     DeleteBucket
    @Sendable
    @inlinable
    internal func createBucket(_ input: CreateBucketRequest, logger: Logger = AWSClient.loggingDisabled) async throws
        -> CreateBucketOutput
    {
        try await self.client.execute(
            operation: "CreateBucket",
            path: "/{Bucket}",
            httpMethod: .PUT,
            serviceConfig: self.config,
            input: input,
            logger: logger
        )
    }
    ///  This action creates an Amazon S3 bucket. To create an Amazon S3 on Outposts bucket, see  CreateBucket .  Creates a new S3 bucket. To create a bucket, you must set up Amazon S3 and have a valid Amazon Web Services Access Key ID to authenticate requests. Anonymous requests are never allowed to create buckets. By creating the bucket, you become the bucket owner. There are two types of buckets: general purpose buckets and directory buckets. For more information about these bucket types, see Creating, configuring, and working with Amazon S3 buckets in the Amazon S3 User Guide.     General purpose buckets - If you send your CreateBucket request to the s3.amazonaws.com global endpoint, the request goes to the us-east-1 Region. So the signature calculations in Signature Version 4 must use us-east-1 as the Region, even if the location constraint in the request specifies another Region where the bucket is to be created. If you create a bucket in a Region other than US East (N. Virginia), your application must be able to handle 307 redirect. For more information, see Virtual hosting of buckets in the Amazon S3 User Guide.    Directory buckets  - For directory buckets, you must make requests for this API operation to the Regional endpoint. These endpoints support path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported.
    /// For more information about endpoints in Availability Zones, see Regional and Zonal endpoints for directory buckets in Availability Zones in the Amazon S3 User Guide. For more information about endpoints in Local Zones, see Available Local Zone for directory buckets in the Amazon S3 User Guide.     Permissions     General purpose bucket permissions - In addition to the s3:CreateBucket permission, the following permissions are required in a policy when your CreateBucket request includes specific headers:     Access control lists (ACLs) - In your CreateBucket request, if you specify an access control list (ACL) and set it to public-read, public-read-write, authenticated-read, or if you explicitly specify any other custom ACLs, both s3:CreateBucket and s3:PutBucketAcl permissions are required. In your CreateBucket request, if you set the ACL to private, or if you don't specify any ACLs, only the s3:CreateBucket permission is required.     Object Lock - In your CreateBucket request, if you set x-amz-bucket-object-lock-enabled to true, the s3:PutBucketObjectLockConfiguration and s3:PutBucketVersioning permissions are required.    S3 Object Ownership - If your CreateBucket request includes the x-amz-object-ownership header, then the s3:PutBucketOwnershipControls permission is required.  To set an ACL on a bucket as part of a CreateBucket request, you must explicitly set S3 Object Ownership for the bucket to a different value than the default, BucketOwnerEnforced. Additionally, if your desired bucket ACL grants public access, you must first create the bucket (without the bucket ACL) and then explicitly disable Block Public Access on the bucket before using PutBucketAcl to set the ACL. If you try to create a bucket with a public ACL, the request will fail.  For the majority of modern use cases in S3, we recommend that you keep all Block Public Access settings enabled and keep ACLs disabled. If you would like to share data with users outside of your account, you can use bucket policies as needed. For more information, see Controlling ownership of objects and disabling ACLs for your bucket  and Blocking public access to your Amazon S3 storage  in the Amazon S3 User Guide.      S3 Block Public Access - If your specific use case requires granting public access to your S3 resources, you can disable Block Public Access. Specifically, you can create a new bucket with Block Public Access enabled, then separately call the  DeletePublicAccessBlock API. To use this operation, you must have the s3:PutBucketPublicAccessBlock permission. For more information about S3 Block Public Access, see Blocking public access to your Amazon S3 storage  in the Amazon S3 User Guide.       Directory bucket permissions - You must have the s3express:CreateBucket permission in an IAM identity-based policy instead of a bucket policy. Cross-account access to this API operation isn't supported. This operation can only be performed by the Amazon Web Services account that owns the resource. For more information about directory bucket policies and permissions, see Amazon Web Services Identity and Access Management (IAM) for S3 Express One Zone in the Amazon S3 User Guide.  The permissions for ACLs, Object Lock, S3 Object Ownership, and S3 Block Public Access are not supported for directory buckets. For directory buckets, all Block Public Access settings are enabled at the bucket level and S3 Object Ownership is set to Bucket owner enforced (ACLs disabled). These settings can't be modified.  For more information about permissions for creating and working with directory buckets, see Directory buckets in the Amazon S3 User Guide. For more information about supported S3 features for directory buckets, see Features of S3 Express One Zone in the Amazon S3 User Guide.     HTTP Host header syntax   Directory buckets  - The HTTP Host header syntax is s3express-control.region-code.amazonaws.com.   The following operations are related to CreateBucket:    PutObject     DeleteBucket
    ///
    /// Parameters:
    ///   - acl: The canned ACL to apply to the bucket.  This functionality is not supported for directory buckets.
    ///   - bucket: The name of the bucket to create.  General purpose buckets - For information about bucket naming restrictions, see Bucket naming rules in the Amazon S3 User Guide.  Directory buckets  - When you use this operation with a directory bucket, you must use path-style requests in the format https://s3express-control.region-code.amazonaws.com/bucket-name . Virtual-hosted-style requests aren't supported. Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must also follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide
    ///   - createBucketConfiguration: The configuration information for the bucket.
    ///   - grantFullControl: Allows grantee the read, write, read ACP, and write ACP permissions on the bucket.  This functionality is not supported for directory buckets.
    ///   - grantRead: Allows grantee to list the objects in the bucket.  This functionality is not supported for directory buckets.
    ///   - grantReadACP: Allows grantee to read the bucket ACL.  This functionality is not supported for directory buckets.
    ///   - grantWrite: Allows grantee to create new objects in the bucket. For the bucket and object owners of existing objects, also allows deletions and overwrites of those objects.  This functionality is not supported for directory buckets.
    ///   - grantWriteACP: Allows grantee to write the ACL for the applicable bucket.  This functionality is not supported for directory buckets.
    ///   - objectLockEnabledForBucket: Specifies whether you want S3 Object Lock to be enabled for the new bucket.  This functionality is not supported for directory buckets.
    ///   - objectOwnership:
    ///   - logger: Logger use during operation
    @inlinable
    internal func createBucket(
        acl: BucketCannedACL? = nil,
        bucket: String,
        createBucketConfiguration: CreateBucketConfiguration? = nil,
        grantFullControl: String? = nil,
        grantRead: String? = nil,
        grantReadACP: String? = nil,
        grantWrite: String? = nil,
        grantWriteACP: String? = nil,
        objectLockEnabledForBucket: Bool? = nil,
        objectOwnership: ObjectOwnership? = nil,
        logger: Logger = AWSClient.loggingDisabled
    ) async throws -> CreateBucketOutput {
        let input = CreateBucketRequest(
            acl: acl,
            bucket: bucket,
            createBucketConfiguration: createBucketConfiguration,
            grantFullControl: grantFullControl,
            grantRead: grantRead,
            grantReadACP: grantReadACP,
            grantWrite: grantWrite,
            grantWriteACP: grantWriteACP,
            objectLockEnabledForBucket: objectLockEnabledForBucket,
            objectOwnership: objectOwnership
        )
        return try await self.createBucket(input, logger: logger)
    }

    /// Retrieves an object from Amazon S3. In the GetObject request, specify the full key name for the object.  General purpose buckets - Both the virtual-hosted-style requests and the path-style requests are supported. For a virtual hosted-style request example, if you have the object photos/2006/February/sample.jpg, specify the object key name as /photos/2006/February/sample.jpg. For a path-style request example, if you have the object photos/2006/February/sample.jpg in the bucket named examplebucket, specify the object key name as /examplebucket/photos/2006/February/sample.jpg. For more information about request types, see HTTP Host Header Bucket Specification in the Amazon S3 User Guide.  Directory buckets - Only virtual-hosted-style requests are supported. For a virtual hosted-style request example, if you have the object photos/2006/February/sample.jpg in the bucket named examplebucket--use1-az5--x-s3, specify the object key name as /photos/2006/February/sample.jpg. Also, when you make requests to this API operation, your requests are sent to the Zonal endpoint. These endpoints support virtual-hosted-style requests in the format https://bucket-name.s3express-zone-id.region-code.amazonaws.com/key-name . Path-style requests are not supported. For more information about endpoints in Availability Zones, see Regional and Zonal endpoints for directory buckets in Availability Zones in the Amazon S3 User Guide. For more information about endpoints in Local Zones, see Available Local Zone for directory buckets in the Amazon S3 User Guide.  Permissions     General purpose bucket permissions - You must have the required permissions in a policy. To use GetObject, you must have the READ access to the object (or version). If you grant READ access to the anonymous user, the GetObject operation returns the object without using an authorization header. For more information, see Specifying permissions in a policy in the Amazon S3 User Guide. If you include a versionId in your request header, you must have the s3:GetObjectVersion permission to access a specific version of an object. The s3:GetObject permission is not required in this scenario. If you request the current version of an object without a specific versionId in the request header, only the s3:GetObject permission is required. The s3:GetObjectVersion permission is not required in this scenario.  If the object that you request doesn’t exist, the error that Amazon S3 returns depends on whether you also have the s3:ListBucket permission.   If you have the s3:ListBucket permission on the bucket, Amazon S3 returns an HTTP status code 404 Not Found error.   If you don’t have the s3:ListBucket permission, Amazon S3 returns an HTTP status code 403 Access Denied error.      Directory bucket permissions - To grant access to this API operation on a directory bucket, we recommend that you use the  CreateSession API operation for session-based authorization. Specifically, you grant the s3express:CreateSession permission to the directory bucket in a bucket policy or an IAM identity-based policy. Then, you make the CreateSession API call on the bucket to obtain a session token. With the session token in your request header, you can make API requests to this operation. After the session token expires, you make another CreateSession API call to generate a new session token for use.
    /// Amazon Web Services CLI or SDKs create session and refresh the session token automatically to avoid service interruptions when a session expires. For more information about authorization, see  CreateSession . If the object is encrypted using SSE-KMS, you must also have the kms:GenerateDataKey and kms:Decrypt permissions in IAM identity-based policies and KMS key policies for the KMS key.    Storage classes  If the object you are retrieving is stored in the S3 Glacier Flexible Retrieval storage class, the S3 Glacier Deep Archive storage class, the S3 Intelligent-Tiering Archive Access tier, or the S3 Intelligent-Tiering Deep Archive Access tier, before you can retrieve the object you must first restore a copy using RestoreObject. Otherwise, this operation returns an InvalidObjectState error. For information about restoring archived objects, see Restoring Archived Objects in the Amazon S3 User Guide.  Directory buckets  - For directory buckets, only the S3 Express One Zone storage class is supported to store newly created objects.
    /// Unsupported storage class values won't write a destination object and will respond with the HTTP status code 400 Bad Request.  Encryption  Encryption request headers, like x-amz-server-side-encryption, should not be sent for the GetObject requests, if your object uses server-side encryption with Amazon S3 managed encryption keys (SSE-S3), server-side encryption with Key Management Service (KMS) keys (SSE-KMS), or dual-layer server-side encryption with Amazon Web Services KMS keys (DSSE-KMS). If you include the header in your GetObject requests for the object that uses these types of keys, you’ll get an HTTP 400 Bad Request error.  Directory buckets - For directory buckets, there are only two supported options for server-side encryption: SSE-S3 and SSE-KMS. SSE-C isn't supported. For more information, see Protecting data with server-side encryption in the Amazon S3 User Guide.  Overriding response header values through the request  There are times when you want to override certain response header values of a GetObject response. For example, you might override the Content-Disposition response header value through your GetObject request. You can override values for a set of response headers. These modified response header values are included only in a successful response, that is, when the HTTP status code 200 OK is returned. The headers you can override using the following query parameters in the request are a subset of the headers that Amazon S3 accepts when you create an object.  The response headers that you can override for the GetObject response are Cache-Control, Content-Disposition, Content-Encoding, Content-Language, Content-Type, and Expires. To override values for a set of response headers in the GetObject response, you can use the following query parameters in the request.    response-cache-control     response-content-disposition     response-content-encoding     response-content-language     response-content-type     response-expires     When you use these parameters, you must sign the request by using either an Authorization header or a presigned URL. These parameters cannot be used with an unsigned (anonymous) request.   HTTP Host header syntax   Directory buckets  - The HTTP Host header syntax is  Bucket-name.s3express-zone-id.region-code.amazonaws.com.   The following operations are related to GetObject:    ListBuckets     GetObjectAcl
    @Sendable
    @inlinable
    internal func getObject(_ input: GetObjectRequest, logger: Logger = AWSClient.loggingDisabled) async throws
        -> GetObjectOutput
    {
        try await self.client.execute(
            operation: "GetObject",
            path: "/{Bucket}/{Key+}?x-id=GetObject",
            httpMethod: .GET,
            serviceConfig: self.config,
            input: input,
            logger: logger
        )
    }
    /// Retrieves an object from Amazon S3. In the GetObject request, specify the full key name for the object.  General purpose buckets - Both the virtual-hosted-style requests and the path-style requests are supported. For a virtual hosted-style request example, if you have the object photos/2006/February/sample.jpg, specify the object key name as /photos/2006/February/sample.jpg. For a path-style request example, if you have the object photos/2006/February/sample.jpg in the bucket named examplebucket, specify the object key name as /examplebucket/photos/2006/February/sample.jpg. For more information about request types, see HTTP Host Header Bucket Specification in the Amazon S3 User Guide.  Directory buckets - Only virtual-hosted-style requests are supported. For a virtual hosted-style request example, if you have the object photos/2006/February/sample.jpg in the bucket named examplebucket--use1-az5--x-s3, specify the object key name as /photos/2006/February/sample.jpg. Also, when you make requests to this API operation, your requests are sent to the Zonal endpoint. These endpoints support virtual-hosted-style requests in the format https://bucket-name.s3express-zone-id.region-code.amazonaws.com/key-name . Path-style requests are not supported. For more information about endpoints in Availability Zones, see Regional and Zonal endpoints for directory buckets in Availability Zones in the Amazon S3 User Guide. For more information about endpoints in Local Zones, see Available Local Zone for directory buckets in the Amazon S3 User Guide.  Permissions     General purpose bucket permissions - You must have the required permissions in a policy. To use GetObject, you must have the READ access to the object (or version). If you grant READ access to the anonymous user, the GetObject operation returns the object without using an authorization header. For more information, see Specifying permissions in a policy in the Amazon S3 User Guide. If you include a versionId in your request header, you must have the s3:GetObjectVersion permission to access a specific version of an object. The s3:GetObject permission is not required in this scenario. If you request the current version of an object without a specific versionId in the request header, only the s3:GetObject permission is required. The s3:GetObjectVersion permission is not required in this scenario.  If the object that you request doesn’t exist, the error that Amazon S3 returns depends on whether you also have the s3:ListBucket permission.   If you have the s3:ListBucket permission on the bucket, Amazon S3 returns an HTTP status code 404 Not Found error.   If you don’t have the s3:ListBucket permission, Amazon S3 returns an HTTP status code 403 Access Denied error.      Directory bucket permissions - To grant access to this API operation on a directory bucket, we recommend that you use the  CreateSession API operation for session-based authorization. Specifically, you grant the s3express:CreateSession permission to the directory bucket in a bucket policy or an IAM identity-based policy. Then, you make the CreateSession API call on the bucket to obtain a session token. With the session token in your request header, you can make API requests to this operation. After the session token expires, you make another CreateSession API call to generate a new session token for use.
    /// Amazon Web Services CLI or SDKs create session and refresh the session token automatically to avoid service interruptions when a session expires. For more information about authorization, see  CreateSession . If the object is encrypted using SSE-KMS, you must also have the kms:GenerateDataKey and kms:Decrypt permissions in IAM identity-based policies and KMS key policies for the KMS key.    Storage classes  If the object you are retrieving is stored in the S3 Glacier Flexible Retrieval storage class, the S3 Glacier Deep Archive storage class, the S3 Intelligent-Tiering Archive Access tier, or the S3 Intelligent-Tiering Deep Archive Access tier, before you can retrieve the object you must first restore a copy using RestoreObject. Otherwise, this operation returns an InvalidObjectState error. For information about restoring archived objects, see Restoring Archived Objects in the Amazon S3 User Guide.  Directory buckets  - For directory buckets, only the S3 Express One Zone storage class is supported to store newly created objects.
    /// Unsupported storage class values won't write a destination object and will respond with the HTTP status code 400 Bad Request.  Encryption  Encryption request headers, like x-amz-server-side-encryption, should not be sent for the GetObject requests, if your object uses server-side encryption with Amazon S3 managed encryption keys (SSE-S3), server-side encryption with Key Management Service (KMS) keys (SSE-KMS), or dual-layer server-side encryption with Amazon Web Services KMS keys (DSSE-KMS). If you include the header in your GetObject requests for the object that uses these types of keys, you’ll get an HTTP 400 Bad Request error.  Directory buckets - For directory buckets, there are only two supported options for server-side encryption: SSE-S3 and SSE-KMS. SSE-C isn't supported. For more information, see Protecting data with server-side encryption in the Amazon S3 User Guide.  Overriding response header values through the request  There are times when you want to override certain response header values of a GetObject response. For example, you might override the Content-Disposition response header value through your GetObject request. You can override values for a set of response headers. These modified response header values are included only in a successful response, that is, when the HTTP status code 200 OK is returned. The headers you can override using the following query parameters in the request are a subset of the headers that Amazon S3 accepts when you create an object.  The response headers that you can override for the GetObject response are Cache-Control, Content-Disposition, Content-Encoding, Content-Language, Content-Type, and Expires. To override values for a set of response headers in the GetObject response, you can use the following query parameters in the request.    response-cache-control     response-content-disposition     response-content-encoding     response-content-language     response-content-type     response-expires     When you use these parameters, you must sign the request by using either an Authorization header or a presigned URL. These parameters cannot be used with an unsigned (anonymous) request.   HTTP Host header syntax   Directory buckets  - The HTTP Host header syntax is  Bucket-name.s3express-zone-id.region-code.amazonaws.com.   The following operations are related to GetObject:    ListBuckets     GetObjectAcl
    ///
    /// Parameters:
    ///   - bucket: The bucket name containing the object.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Object Lambda access points - When you use this action with an Object Lambda access point, you must direct requests to the Object Lambda access point hostname. The Object Lambda access point hostname takes the form AccessPointName-AccountId.s3-object-lambda.Region.amazonaws.com.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
    ///   - checksumMode: To retrieve the checksum, this mode must be enabled.  General purpose buckets - In addition, if you enable checksum mode and the object is uploaded with a checksum and encrypted with an Key Management Service (KMS) key, you must have permission to use the kms:Decrypt action to retrieve the checksum.
    ///   - expectedBucketOwner: The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
    ///   - ifMatch: Return the object only if its entity tag (ETag) is the same as the one specified in this header; otherwise, return a 412 Precondition Failed error. If both of the If-Match and If-Unmodified-Since headers are present in the request as follows: If-Match condition evaluates to true, and; If-Unmodified-Since condition evaluates to false; then, S3 returns 200 OK and the data requested.  For more information about conditional requests, see RFC 7232.
    ///   - ifModifiedSince: Return the object only if it has been modified since the specified time; otherwise, return a 304 Not Modified error. If both of the If-None-Match and If-Modified-Since headers are present in the request as follows: If-None-Match condition evaluates to false, and; If-Modified-Since condition evaluates to true; then, S3 returns 304 Not Modified status code. For more information about conditional requests, see RFC 7232.
    ///   - ifNoneMatch: Return the object only if its entity tag (ETag) is different from the one specified in this header; otherwise, return a 304 Not Modified error. If both of the If-None-Match and If-Modified-Since headers are present in the request as follows: If-None-Match condition evaluates to false, and; If-Modified-Since condition evaluates to true; then, S3 returns 304 Not Modified HTTP status code. For more information about conditional requests, see RFC 7232.
    ///   - ifUnmodifiedSince: Return the object only if it has not been modified since the specified time; otherwise, return a 412 Precondition Failed error. If both of the If-Match and If-Unmodified-Since headers are present in the request as follows: If-Match condition evaluates to true, and; If-Unmodified-Since condition evaluates to false; then, S3 returns 200 OK and the data requested.  For more information about conditional requests, see RFC 7232.
    ///   - key: Key of the object to get.
    ///   - partNumber: Part number of the object being read. This is a positive integer between 1 and 10,000. Effectively performs a 'ranged' GET request for the part specified. Useful for downloading just a part of an object.
    ///   - range: Downloads the specified byte range of an object. For more information about the HTTP Range header, see https://www.rfc-editor.org/rfc/rfc9110.html#name-range.  Amazon S3 doesn't support retrieving multiple ranges of data per GET request.
    ///   - requestPayer:
    ///   - responseCacheControl: Sets the Cache-Control header of the response.
    ///   - responseContentDisposition: Sets the Content-Disposition header of the response.
    ///   - responseContentEncoding: Sets the Content-Encoding header of the response.
    ///   - responseContentLanguage: Sets the Content-Language header of the response.
    ///   - responseContentType: Sets the Content-Type header of the response.
    ///   - responseExpires: Sets the Expires header of the response.
    ///   - sseCustomerAlgorithm: Specifies the algorithm to use when decrypting the object (for example, AES256). If you encrypt an object by using server-side encryption with customer-provided encryption keys (SSE-C) when you store the object in Amazon S3, then when you GET the object, you must use the following headers:    x-amz-server-side-encryption-customer-algorithm     x-amz-server-side-encryption-customer-key     x-amz-server-side-encryption-customer-key-MD5    For more information about SSE-C, see Server-Side Encryption (Using Customer-Provided Encryption Keys) in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
    ///   - sseCustomerKey: Specifies the customer-provided encryption key that you originally provided for Amazon S3 to encrypt the data before storing it. This value is used to decrypt the object when recovering it and must match the one used when storing the data. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header. If you encrypt an object by using server-side encryption with customer-provided encryption keys (SSE-C) when you store the object in Amazon S3, then when you GET the object, you must use the following headers:    x-amz-server-side-encryption-customer-algorithm     x-amz-server-side-encryption-customer-key     x-amz-server-side-encryption-customer-key-MD5    For more information about SSE-C, see Server-Side Encryption (Using Customer-Provided Encryption Keys) in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
    ///   - sseCustomerKeyMD5: Specifies the 128-bit MD5 digest of the customer-provided encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error. If you encrypt an object by using server-side encryption with customer-provided encryption keys (SSE-C) when you store the object in Amazon S3, then when you GET the object, you must use the following headers:    x-amz-server-side-encryption-customer-algorithm     x-amz-server-side-encryption-customer-key     x-amz-server-side-encryption-customer-key-MD5    For more information about SSE-C, see Server-Side Encryption (Using Customer-Provided Encryption Keys) in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
    ///   - versionId: Version ID used to reference a specific version of the object. By default, the GetObject operation returns the current version of an object. To return a different version, use the versionId subresource.    If you include a versionId in your request header, you must have the s3:GetObjectVersion permission to access a specific version of an object. The s3:GetObject permission is not required in this scenario.   If you request the current version of an object without a specific versionId in the request header, only the s3:GetObject permission is required. The s3:GetObjectVersion permission is not required in this scenario.    Directory buckets - S3 Versioning isn't enabled and supported for directory buckets. For this API operation, only the null value of the version ID is supported by directory buckets. You can only specify null to the versionId query parameter in the request.    For more information about versioning, see PutBucketVersioning.
    ///   - logger: Logger use during operation
    @inlinable
    internal func getObject(
        bucket: String,
        checksumMode: ChecksumMode? = nil,
        expectedBucketOwner: String? = nil,
        ifMatch: String? = nil,
        ifModifiedSince: Date? = nil,
        ifNoneMatch: String? = nil,
        ifUnmodifiedSince: Date? = nil,
        key: String,
        partNumber: Int? = nil,
        range: String? = nil,
        requestPayer: RequestPayer? = nil,
        responseCacheControl: String? = nil,
        responseContentDisposition: String? = nil,
        responseContentEncoding: String? = nil,
        responseContentLanguage: String? = nil,
        responseContentType: String? = nil,
        responseExpires: Date? = nil,
        sseCustomerAlgorithm: String? = nil,
        sseCustomerKey: String? = nil,
        sseCustomerKeyMD5: String? = nil,
        versionId: String? = nil,
        logger: Logger = AWSClient.loggingDisabled
    ) async throws -> GetObjectOutput {
        let input = GetObjectRequest(
            bucket: bucket,
            checksumMode: checksumMode,
            expectedBucketOwner: expectedBucketOwner,
            ifMatch: ifMatch,
            ifModifiedSince: ifModifiedSince,
            ifNoneMatch: ifNoneMatch,
            ifUnmodifiedSince: ifUnmodifiedSince,
            key: key,
            partNumber: partNumber,
            range: range,
            requestPayer: requestPayer,
            responseCacheControl: responseCacheControl,
            responseContentDisposition: responseContentDisposition,
            responseContentEncoding: responseContentEncoding,
            responseContentLanguage: responseContentLanguage,
            responseContentType: responseContentType,
            responseExpires: responseExpires,
            sseCustomerAlgorithm: sseCustomerAlgorithm,
            sseCustomerKey: sseCustomerKey,
            sseCustomerKeyMD5: sseCustomerKeyMD5,
            versionId: versionId
        )
        return try await self.getObject(input, logger: logger)
    }

    /// Adds an object to a bucket.    Amazon S3 never adds partial objects; if you receive a success response, Amazon S3 added the entire object to the bucket. You cannot use PutObject to only update a single piece of metadata for an existing object. You must put the entire object with updated metadata if you want to update some values.   If your bucket uses the bucket owner enforced setting for Object Ownership, ACLs are disabled and no longer affect permissions. All objects written to the bucket by any account will be owned by the bucket owner.    Directory buckets - For directory buckets, you must make requests for this API operation to the Zonal endpoint. These endpoints support virtual-hosted-style requests in the format https://bucket-name.s3express-zone-id.region-code.amazonaws.com/key-name . Path-style requests are not supported. For more information about endpoints in Availability Zones, see Regional and Zonal endpoints for directory buckets in Availability Zones in the Amazon S3 User Guide. For more information about endpoints in Local Zones, see Available Local Zone for directory buckets in the Amazon S3 User Guide.    Amazon S3 is a distributed system. If it receives multiple write requests for the same object simultaneously, it overwrites all but the last object written. However, Amazon S3 provides features that can modify this behavior:    S3 Object Lock - To prevent objects from being deleted or overwritten, you can use Amazon S3 Object Lock in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.     S3 Versioning - When you enable versioning for a bucket, if Amazon S3 receives multiple write requests for the same object simultaneously, it stores all versions of the objects. For each write request that is made to the same object, Amazon S3 automatically generates a unique version ID of that object being stored in Amazon S3. You can retrieve, replace, or delete any version of the object. For more information about versioning, see Adding Objects to Versioning-Enabled Buckets in the Amazon S3 User Guide. For information about returning the versioning state of a bucket, see GetBucketVersioning.   This functionality is not supported for directory buckets.     Permissions     General purpose bucket permissions - The following permissions are required in your policies when your PutObject request includes specific headers.     s3:PutObject - To successfully complete the PutObject request, you must always have the s3:PutObject permission on a bucket to add an object to it.     s3:PutObjectAcl - To successfully change the objects ACL of your PutObject request, you must have the s3:PutObjectAcl.     s3:PutObjectTagging - To successfully set the tag-set with your PutObject request, you must have the s3:PutObjectTagging.      Directory bucket permissions - To grant access to this API operation on a directory bucket, we recommend that you use the  CreateSession API operation for session-based authorization. Specifically, you grant the s3express:CreateSession permission to the directory bucket in a bucket policy or an IAM identity-based policy. Then, you make the CreateSession API call on the bucket to obtain a session token. With the session token in your request header, you can make API requests to this operation. After the session token expires, you make another CreateSession API call to generate a new session token for use.
    /// Amazon Web Services CLI or SDKs create session and refresh the session token automatically to avoid service interruptions when a session expires. For more information about authorization, see  CreateSession . If the object is encrypted with SSE-KMS, you must also have the kms:GenerateDataKey and kms:Decrypt permissions in IAM identity-based policies and KMS key policies for the KMS key.    Data integrity with Content-MD5     General purpose bucket - To ensure that data is not corrupted traversing the network, use the Content-MD5 header. When you use this header, Amazon S3 checks the object against the provided MD5 value and, if they do not match, Amazon S3 returns an error. Alternatively, when the object's ETag is its MD5 digest, you can calculate the MD5 while putting the object to Amazon S3 and compare the returned ETag to the calculated MD5 value.    Directory bucket - This functionality is not supported for directory buckets.    HTTP Host header syntax   Directory buckets  - The HTTP Host header syntax is  Bucket-name.s3express-zone-id.region-code.amazonaws.com.   For more information about related Amazon S3 APIs, see the following:    CopyObject     DeleteObject
    @Sendable
    @inlinable
    internal func putObject(_ input: PutObjectRequest, logger: Logger = AWSClient.loggingDisabled) async throws
        -> PutObjectOutput
    {
        try await self.client.execute(
            operation: "PutObject",
            path: "/{Bucket}/{Key+}?x-id=PutObject",
            httpMethod: .PUT,
            serviceConfig: self.config,
            input: input,
            logger: logger
        )
    }
    /// Adds an object to a bucket.    Amazon S3 never adds partial objects; if you receive a success response, Amazon S3 added the entire object to the bucket. You cannot use PutObject to only update a single piece of metadata for an existing object. You must put the entire object with updated metadata if you want to update some values.   If your bucket uses the bucket owner enforced setting for Object Ownership, ACLs are disabled and no longer affect permissions. All objects written to the bucket by any account will be owned by the bucket owner.    Directory buckets - For directory buckets, you must make requests for this API operation to the Zonal endpoint. These endpoints support virtual-hosted-style requests in the format https://bucket-name.s3express-zone-id.region-code.amazonaws.com/key-name . Path-style requests are not supported. For more information about endpoints in Availability Zones, see Regional and Zonal endpoints for directory buckets in Availability Zones in the Amazon S3 User Guide. For more information about endpoints in Local Zones, see Available Local Zone for directory buckets in the Amazon S3 User Guide.    Amazon S3 is a distributed system. If it receives multiple write requests for the same object simultaneously, it overwrites all but the last object written. However, Amazon S3 provides features that can modify this behavior:    S3 Object Lock - To prevent objects from being deleted or overwritten, you can use Amazon S3 Object Lock in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.     S3 Versioning - When you enable versioning for a bucket, if Amazon S3 receives multiple write requests for the same object simultaneously, it stores all versions of the objects. For each write request that is made to the same object, Amazon S3 automatically generates a unique version ID of that object being stored in Amazon S3. You can retrieve, replace, or delete any version of the object. For more information about versioning, see Adding Objects to Versioning-Enabled Buckets in the Amazon S3 User Guide. For information about returning the versioning state of a bucket, see GetBucketVersioning.   This functionality is not supported for directory buckets.     Permissions     General purpose bucket permissions - The following permissions are required in your policies when your PutObject request includes specific headers.     s3:PutObject - To successfully complete the PutObject request, you must always have the s3:PutObject permission on a bucket to add an object to it.     s3:PutObjectAcl - To successfully change the objects ACL of your PutObject request, you must have the s3:PutObjectAcl.     s3:PutObjectTagging - To successfully set the tag-set with your PutObject request, you must have the s3:PutObjectTagging.      Directory bucket permissions - To grant access to this API operation on a directory bucket, we recommend that you use the  CreateSession API operation for session-based authorization. Specifically, you grant the s3express:CreateSession permission to the directory bucket in a bucket policy or an IAM identity-based policy. Then, you make the CreateSession API call on the bucket to obtain a session token. With the session token in your request header, you can make API requests to this operation. After the session token expires, you make another CreateSession API call to generate a new session token for use.
    /// Amazon Web Services CLI or SDKs create session and refresh the session token automatically to avoid service interruptions when a session expires. For more information about authorization, see  CreateSession . If the object is encrypted with SSE-KMS, you must also have the kms:GenerateDataKey and kms:Decrypt permissions in IAM identity-based policies and KMS key policies for the KMS key.    Data integrity with Content-MD5     General purpose bucket - To ensure that data is not corrupted traversing the network, use the Content-MD5 header. When you use this header, Amazon S3 checks the object against the provided MD5 value and, if they do not match, Amazon S3 returns an error. Alternatively, when the object's ETag is its MD5 digest, you can calculate the MD5 while putting the object to Amazon S3 and compare the returned ETag to the calculated MD5 value.    Directory bucket - This functionality is not supported for directory buckets.    HTTP Host header syntax   Directory buckets  - The HTTP Host header syntax is  Bucket-name.s3express-zone-id.region-code.amazonaws.com.   For more information about related Amazon S3 APIs, see the following:    CopyObject     DeleteObject
    ///
    /// Parameters:
    ///   - acl: The canned ACL to apply to the object. For more information, see Canned ACL in the Amazon S3 User Guide. When adding a new object, you can use headers to grant ACL-based permissions to individual Amazon Web Services accounts or to predefined groups defined by Amazon S3. These permissions are then added to the ACL on the object. By default, all objects are private. Only the owner has full access control. For more information, see Access Control List (ACL) Overview and Managing ACLs Using the REST API in the Amazon S3 User Guide. If the bucket that you're uploading objects to uses the bucket owner enforced setting for S3 Object Ownership, ACLs are disabled and no longer affect permissions. Buckets that use this setting only accept PUT requests that don't specify an ACL or PUT requests that specify bucket owner full control ACLs, such as the bucket-owner-full-control canned ACL or an equivalent form of this ACL expressed in the XML format. PUT requests that contain other ACLs (for example, custom grants to certain Amazon Web Services accounts) fail and return a 400 error with the error code AccessControlListNotSupported. For more information, see  Controlling ownership of objects and disabling ACLs in the Amazon S3 User Guide.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
    ///   - body: Object data.
    ///   - bucket: The bucket name to which the PUT action was initiated.   Directory buckets - When you use this operation with a directory bucket, you must use virtual-hosted-style requests in the format  Bucket-name.s3express-zone-id.region-code.amazonaws.com. Path-style requests are not supported.  Directory bucket names must be unique in the chosen Zone (Availability Zone or Local Zone). Bucket names must follow the format  bucket-base-name--zone-id--x-s3 (for example,  DOC-EXAMPLE-BUCKET--usw2-az1--x-s3). For information about bucket naming restrictions, see Directory bucket naming rules in the Amazon S3 User Guide.  Access points - When you use this action with an access point, you must provide the alias of the access point in place of the bucket name or specify the access point ARN. When using the access point ARN, you must direct requests to the access point hostname. The access point hostname takes the form AccessPointName-AccountId.s3-accesspoint.Region.amazonaws.com. When using this action with an access point through the Amazon Web Services SDKs, you provide the access point ARN in place of the bucket name. For more information about access point ARNs, see Using access points in the Amazon S3 User Guide.  Access points and Object Lambda access points are not supported by directory buckets.   S3 on Outposts - When you use this action with Amazon S3 on Outposts, you must direct requests to the S3 on Outposts hostname. The S3 on Outposts hostname takes the form  AccessPointName-AccountId.outpostID.s3-outposts.Region.amazonaws.com. When you use this action with S3 on Outposts through the Amazon Web Services SDKs, you provide the Outposts access point ARN in place of the bucket name. For more information about S3 on Outposts ARNs, see What is S3 on Outposts? in the Amazon S3 User Guide.
    ///   - bucketKeyEnabled: Specifies whether Amazon S3 should use an S3 Bucket Key for object encryption with server-side encryption using Key Management Service (KMS) keys (SSE-KMS).  General purpose buckets - Setting this header to true causes Amazon S3 to use an S3 Bucket Key for object encryption with SSE-KMS. Also, specifying this header with a PUT action doesn't affect bucket-level settings for S3 Bucket Key.  Directory buckets - S3 Bucket Keys are always enabled for GET and PUT operations in a directory bucket and can’t be disabled. S3 Bucket Keys aren't supported, when you copy SSE-KMS encrypted objects from general purpose buckets
    ///   - cacheControl: Can be used to specify caching behavior along the request/reply chain. For more information, see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9.
    ///   - checksumAlgorithm: Indicates the algorithm used to create the checksum for the object when you use the SDK. This header will not provide any additional functionality if you don't use the SDK. When you send this header, there must be a corresponding x-amz-checksum-algorithm or x-amz-trailer header sent. Otherwise, Amazon S3 fails the request with the HTTP status code 400 Bad Request. For the x-amz-checksum-algorithm header, replace  algorithm with the supported algorithm from the following list:     CRC32     CRC32C     SHA1     SHA256    For more information, see Checking object integrity in the Amazon S3 User Guide. If the individual checksum value you provide through x-amz-checksum-algorithm doesn't match the checksum algorithm you set through x-amz-sdk-checksum-algorithm,  Amazon S3 ignores any provided ChecksumAlgorithm parameter and uses the checksum algorithm that matches the provided value in x-amz-checksum-algorithm .  The Content-MD5 or x-amz-sdk-checksum-algorithm header is required for any request to upload an object with a retention period configured using Amazon S3 Object Lock. For more information, see Uploading objects to an Object Lock enabled bucket  in the Amazon S3 User Guide.  For directory buckets, when you use Amazon Web Services SDKs, CRC32 is the default checksum algorithm that's used for performance.
    ///   - checksumCRC32: This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32 checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
    ///   - checksumCRC32C: This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 32-bit CRC-32C checksum of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
    ///   - checksumSHA1: This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 160-bit SHA-1 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
    ///   - checksumSHA256: This header can be used as a data integrity check to verify that the data received is the same data that was originally sent. This header specifies the base64-encoded, 256-bit SHA-256 digest of the object. For more information, see Checking object integrity in the Amazon S3 User Guide.
    ///   - contentDisposition: Specifies presentational information for the object. For more information, see https://www.rfc-editor.org/rfc/rfc6266#section-4.
    ///   - contentEncoding: Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field. For more information, see https://www.rfc-editor.org/rfc/rfc9110.html#field.content-encoding.
    ///   - contentLanguage: The language the content is in.
    ///   - contentLength: Size of the body in bytes. This parameter is useful when the size of the body cannot be determined automatically. For more information, see https://www.rfc-editor.org/rfc/rfc9110.html#name-content-length.
    ///   - contentMD5: The base64-encoded 128-bit MD5 digest of the message (without the headers) according to RFC 1864. This header can be used as a message integrity check to verify that the data is the same data that was originally sent. Although it is optional, we recommend using the Content-MD5 mechanism as an end-to-end integrity check. For more information about REST request authentication, see REST Authentication.  The Content-MD5 or x-amz-sdk-checksum-algorithm header is required for any request to upload an object with a retention period configured using Amazon S3 Object Lock. For more information, see Uploading objects to an Object Lock enabled bucket  in the Amazon S3 User Guide.   This functionality is not supported for directory buckets.
    ///   - contentType: A standard MIME type describing the format of the contents. For more information, see https://www.rfc-editor.org/rfc/rfc9110.html#name-content-type.
    ///   - expectedBucketOwner: The account ID of the expected bucket owner. If the account ID that you provide does not match the actual owner of the bucket, the request fails with the HTTP status code 403 Forbidden (access denied).
    ///   - expires: The date and time at which the object is no longer cacheable. For more information, see https://www.rfc-editor.org/rfc/rfc7234#section-5.3.
    ///   - grantFullControl: Gives the grantee READ, READ_ACP, and WRITE_ACP permissions on the object.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
    ///   - grantRead: Allows grantee to read the object data and its metadata.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
    ///   - grantReadACP: Allows grantee to read the object ACL.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
    ///   - grantWriteACP: Allows grantee to write the ACL for the applicable object.    This functionality is not supported for directory buckets.   This functionality is not supported for Amazon S3 on Outposts.
    ///   - ifMatch: Uploads the object only if the ETag (entity tag) value provided during the WRITE operation matches the ETag of the object in S3. If the ETag values do not match, the operation returns a 412 Precondition Failed error. If a conflicting operation occurs during the upload S3 returns a 409 ConditionalRequestConflict response. On a 409 failure you should fetch the object's ETag and retry the upload. Expects the ETag value as a string. For more information about conditional requests, see RFC 7232, or Conditional requests in the Amazon S3 User Guide.
    ///   - ifNoneMatch: Uploads the object only if the object key name does not already exist in the bucket specified. Otherwise, Amazon S3 returns a 412 Precondition Failed error. If a conflicting operation occurs during the upload S3 returns a 409 ConditionalRequestConflict response. On a 409 failure you should retry the upload. Expects the '*' (asterisk) character. For more information about conditional requests, see RFC 7232, or Conditional requests in the Amazon S3 User Guide.
    ///   - key: Object key for which the PUT action was initiated.
    ///   - metadata: A map of metadata to store with the object in S3.
    ///   - objectLockLegalHoldStatus: Specifies whether a legal hold will be applied to this object. For more information about S3 Object Lock, see Object Lock in the Amazon S3 User Guide.  This functionality is not supported for directory buckets.
    ///   - objectLockMode: The Object Lock mode that you want to apply to this object.  This functionality is not supported for directory buckets.
    ///   - objectLockRetainUntilDate: The date and time when you want this object's Object Lock to expire. Must be formatted as a timestamp parameter.  This functionality is not supported for directory buckets.
    ///   - requestPayer:
    ///   - serverSideEncryption: The server-side encryption algorithm that was used when you store this object in Amazon S3 (for example, AES256, aws:kms, aws:kms:dsse).    General purpose buckets  - You have four mutually exclusive options to protect data using server-side encryption in Amazon S3, depending on how you choose to manage the encryption keys. Specifically, the encryption key options are Amazon S3 managed keys (SSE-S3), Amazon Web Services KMS keys (SSE-KMS or DSSE-KMS), and customer-provided keys (SSE-C). Amazon S3 encrypts data with server-side encryption by using Amazon S3 managed keys (SSE-S3) by default. You can optionally tell Amazon S3 to encrypt data at rest by using server-side encryption with other key options. For more information, see Using Server-Side Encryption in the Amazon S3 User Guide.    Directory buckets  - For directory buckets, there are only two supported options for server-side encryption: server-side encryption with Amazon S3 managed keys (SSE-S3) (AES256) and server-side encryption with KMS keys (SSE-KMS) (aws:kms). We recommend that the bucket's default encryption uses the desired encryption configuration and you don't override the bucket default encryption in your  CreateSession requests or PUT object requests. Then, new objects  are automatically encrypted with the desired encryption settings. For more information, see Protecting data with server-side encryption in the Amazon S3 User Guide. For more information about the encryption overriding behaviors in directory buckets, see Specifying server-side encryption with KMS for new object uploads.  In the Zonal endpoint API calls (except CopyObject and UploadPartCopy) using the REST API, the encryption request headers must match the encryption settings that are specified in the CreateSession request.  You can't override the values of the encryption settings (x-amz-server-side-encryption, x-amz-server-side-encryption-aws-kms-key-id, x-amz-server-side-encryption-context, and x-amz-server-side-encryption-bucket-key-enabled) that are specified in the CreateSession request.  You don't need to explicitly specify these encryption settings values in Zonal endpoint API calls, and    Amazon S3 will use the encryption settings values from the CreateSession request to protect new objects in the directory bucket.    When you use the CLI or the Amazon Web Services SDKs, for CreateSession, the session token refreshes automatically to avoid service interruptions when a session expires. The CLI or the Amazon Web Services SDKs use the bucket's default encryption configuration for the  CreateSession request. It's not supported to override the encryption settings values in the CreateSession request.  So in the Zonal endpoint API calls (except CopyObject and UploadPartCopy),  the encryption request headers must match the default encryption configuration of the directory bucket.
    ///   - sseCustomerAlgorithm: Specifies the algorithm to use when encrypting the object (for example, AES256).  This functionality is not supported for directory buckets.
    ///   - sseCustomerKey: Specifies the customer-provided encryption key for Amazon S3 to use in encrypting data. This value is used to store the object and then it is discarded; Amazon S3 does not store the encryption key. The key must be appropriate for use with the algorithm specified in the x-amz-server-side-encryption-customer-algorithm header.  This functionality is not supported for directory buckets.
    ///   - sseCustomerKeyMD5: Specifies the 128-bit MD5 digest of the encryption key according to RFC 1321. Amazon S3 uses this header for a message integrity check to ensure that the encryption key was transmitted without error.  This functionality is not supported for directory buckets.
    ///   - ssekmsEncryptionContext: Specifies the Amazon Web Services KMS Encryption Context as an additional encryption context to use for object encryption. The value of this header is a Base64-encoded string of a UTF-8 encoded JSON, which contains the encryption context as key-value pairs.  This value is stored as object metadata and automatically gets passed on to Amazon Web Services KMS for future GetObject operations on this object.  General purpose buckets - This value must be explicitly added during CopyObject operations if you want an additional encryption context for your object. For more information, see Encryption context in the Amazon S3 User Guide.  Directory buckets - You can optionally provide an explicit encryption context value. The value must match the default encryption context - the bucket Amazon Resource Name (ARN). An additional encryption context value is not supported.
    ///   - ssekmsKeyId: Specifies the KMS key ID (Key ID, Key ARN, or Key Alias) to use for object encryption. If the KMS key doesn't exist in the same account that's issuing the command, you must use the full Key ARN not the Key ID.  General purpose buckets - If you specify x-amz-server-side-encryption with aws:kms or aws:kms:dsse, this header specifies the ID (Key ID, Key ARN, or Key Alias) of the KMS  key to use. If you specify x-amz-server-side-encryption:aws:kms or x-amz-server-side-encryption:aws:kms:dsse, but do not provide x-amz-server-side-encryption-aws-kms-key-id, Amazon S3 uses the Amazon Web Services managed key (aws/s3) to protect the data.  Directory buckets - If you specify x-amz-server-side-encryption with aws:kms, the  x-amz-server-side-encryption-aws-kms-key-id header is implicitly assigned the ID of the KMS  symmetric encryption customer managed key that's configured for your directory bucket's default encryption setting.  If you want to specify the  x-amz-server-side-encryption-aws-kms-key-id header explicitly, you can only specify it with the ID (Key ID or Key ARN) of the KMS  customer managed key that's configured for your directory bucket's default encryption setting. Otherwise, you get an HTTP 400 Bad Request error. Only use the key ID or key ARN. The key alias format of the KMS key isn't supported. Your SSE-KMS configuration can only support 1 customer managed key per directory bucket for the lifetime of the bucket.
    ///   - storageClass: By default, Amazon S3 uses the STANDARD Storage Class to store newly created objects. The STANDARD storage class provides high durability and high availability. Depending on performance needs, you can specify a different Storage Class. For more information, see Storage Classes in the Amazon S3 User Guide.    For directory buckets, only the S3 Express One Zone storage class is supported to store newly created objects.   Amazon S3 on Outposts only uses the OUTPOSTS Storage Class.
    ///   - tagging: The tag-set for the object. The tag-set must be encoded as URL Query parameters. (For example, "Key1=Value1")  This functionality is not supported for directory buckets.
    ///   - websiteRedirectLocation: If the bucket is configured as a website, redirects requests for this object to another object in the same bucket or to an external URL. Amazon S3 stores the value of this header in the object metadata. For information about object metadata, see Object Key and Metadata in the Amazon S3 User Guide. In the following example, the request header sets the redirect to an object (anotherPage.html) in the same bucket:  x-amz-website-redirect-location: /anotherPage.html  In the following example, the request header sets the object redirect to another website:  x-amz-website-redirect-location: http://www.example.com/  For more information about website hosting in Amazon S3, see Hosting Websites on Amazon S3 and How to Configure Website Page Redirects in the Amazon S3 User Guide.   This functionality is not supported for directory buckets.
    ///   - writeOffsetBytes:  Specifies the offset for appending data to existing objects in bytes.  The offset must be equal to the size of the existing object being appended to.  If no object exists, setting this header to 0 will create a new object.   This functionality is only supported for objects in the Amazon S3 Express One Zone storage class in directory buckets.
    ///   - logger: Logger use during operation
    @inlinable
    internal func putObject(
        acl: ObjectCannedACL? = nil,
        body: AWSHTTPBody? = nil,
        bucket: String,
        bucketKeyEnabled: Bool? = nil,
        cacheControl: String? = nil,
        checksumAlgorithm: ChecksumAlgorithm? = nil,
        checksumCRC32: String? = nil,
        checksumCRC32C: String? = nil,
        checksumSHA1: String? = nil,
        checksumSHA256: String? = nil,
        contentDisposition: String? = nil,
        contentEncoding: String? = nil,
        contentLanguage: String? = nil,
        contentLength: Int64? = nil,
        contentMD5: String? = nil,
        contentType: String? = nil,
        expectedBucketOwner: String? = nil,
        expires: Date? = nil,
        grantFullControl: String? = nil,
        grantRead: String? = nil,
        grantReadACP: String? = nil,
        grantWriteACP: String? = nil,
        ifMatch: String? = nil,
        ifNoneMatch: String? = nil,
        key: String,
        metadata: [String: String]? = nil,
        objectLockLegalHoldStatus: ObjectLockLegalHoldStatus? = nil,
        objectLockMode: ObjectLockMode? = nil,
        objectLockRetainUntilDate: Date? = nil,
        requestPayer: RequestPayer? = nil,
        serverSideEncryption: ServerSideEncryption? = nil,
        sseCustomerAlgorithm: String? = nil,
        sseCustomerKey: String? = nil,
        sseCustomerKeyMD5: String? = nil,
        ssekmsEncryptionContext: String? = nil,
        ssekmsKeyId: String? = nil,
        storageClass: StorageClass? = nil,
        tagging: String? = nil,
        websiteRedirectLocation: String? = nil,
        writeOffsetBytes: Int64? = nil,
        logger: Logger = AWSClient.loggingDisabled
    ) async throws -> PutObjectOutput {
        let input = PutObjectRequest(
            acl: acl,
            body: body,
            bucket: bucket,
            bucketKeyEnabled: bucketKeyEnabled,
            cacheControl: cacheControl,
            checksumAlgorithm: checksumAlgorithm,
            checksumCRC32: checksumCRC32,
            checksumCRC32C: checksumCRC32C,
            checksumSHA1: checksumSHA1,
            checksumSHA256: checksumSHA256,
            contentDisposition: contentDisposition,
            contentEncoding: contentEncoding,
            contentLanguage: contentLanguage,
            contentLength: contentLength,
            contentMD5: contentMD5,
            contentType: contentType,
            expectedBucketOwner: expectedBucketOwner,
            expires: expires,
            grantFullControl: grantFullControl,
            grantRead: grantRead,
            grantReadACP: grantReadACP,
            grantWriteACP: grantWriteACP,
            ifMatch: ifMatch,
            ifNoneMatch: ifNoneMatch,
            key: key,
            metadata: metadata,
            objectLockLegalHoldStatus: objectLockLegalHoldStatus,
            objectLockMode: objectLockMode,
            objectLockRetainUntilDate: objectLockRetainUntilDate,
            requestPayer: requestPayer,
            serverSideEncryption: serverSideEncryption,
            sseCustomerAlgorithm: sseCustomerAlgorithm,
            sseCustomerKey: sseCustomerKey,
            sseCustomerKeyMD5: sseCustomerKeyMD5,
            ssekmsEncryptionContext: ssekmsEncryptionContext,
            ssekmsKeyId: ssekmsKeyId,
            storageClass: storageClass,
            tagging: tagging,
            websiteRedirectLocation: websiteRedirectLocation,
            writeOffsetBytes: writeOffsetBytes
        )
        return try await self.putObject(input, logger: logger)
    }
}

extension S3 {
    /// Initializer required by `AWSService.with(middlewares:timeout:byteBufferAllocator:options)`. You are not able to use this initializer directly as there are not public
    /// initializers for `AWSServiceConfig.Patch`. Please use `AWSService.with(middlewares:timeout:byteBufferAllocator:options)` instead.
    internal init(from: S3, patch: AWSServiceConfig.Patch) {
        self.client = from.client
        self.config = from.config.with(patch: patch)
    }
}
