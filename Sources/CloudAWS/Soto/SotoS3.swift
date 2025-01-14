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
    @preconcurrency import Foundation
#else
    import Foundation
#endif

/// Service object for interacting with AWS S3 service.
internal struct S3: AWSService {
    /// Client used for communication with AWS
    internal let client: AWSClient
    /// Service configuration
    internal let config: AWSServiceConfig

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
}

extension S3 {
    /// Initializer required by `AWSService.with(middlewares:timeout:byteBufferAllocator:options)`. You are not able to use this initializer directly as there are not public
    /// initializers for `AWSServiceConfig.Patch`. Please use `AWSService.with(middlewares:timeout:byteBufferAllocator:options)` instead.
    internal init(from: S3, patch: AWSServiceConfig.Patch) {
        self.client = from.client
        self.config = from.config.with(patch: patch)
    }
}
