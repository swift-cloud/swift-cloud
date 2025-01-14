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

extension STS {
    internal struct GetCallerIdentityRequest: AWSEncodableShape {
        internal init() {}
    }

    internal struct GetCallerIdentityResponse: AWSDecodableShape {
        /// The Amazon Web Services account ID number of the account that owns or contains the calling entity.
        internal let account: String?
        /// The Amazon Web Services ARN associated with the calling entity.
        internal let arn: String?
        /// The unique identifier of the calling entity. The exact value depends on the type of entity that is making the call. The values returned are those listed in the aws:userid column in the Principal table found on the Policy Variables reference page in the IAM User Guide.
        internal let userId: String?

        @inlinable
        internal init(account: String? = nil, arn: String? = nil, userId: String? = nil) {
            self.account = account
            self.arn = arn
            self.userId = userId
        }

        private enum CodingKeys: String, CodingKey {
            case account = "Account"
            case arn = "Arn"
            case userId = "UserId"
        }
    }
}

/// Error enum for STS
internal struct STSErrorType: AWSErrorType {
    enum Code: String {
        case expiredTokenException = "ExpiredTokenException"
        case idpCommunicationErrorException = "IDPCommunicationError"
        case idpRejectedClaimException = "IDPRejectedClaim"
        case invalidAuthorizationMessageException = "InvalidAuthorizationMessageException"
        case invalidIdentityTokenException = "InvalidIdentityToken"
        case malformedPolicyDocumentException = "MalformedPolicyDocument"
        case packedPolicyTooLargeException = "PackedPolicyTooLarge"
        case regionDisabledException = "RegionDisabledException"
    }

    private let error: Code
    internal let context: AWSErrorContext?

    /// initialize STS
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

    /// The web identity token that was passed is expired or is not valid. Get a new identity token from the identity provider and then retry the request.
    internal static var expiredTokenException: Self { .init(.expiredTokenException) }
    /// The request could not be fulfilled because the identity provider (IDP) that was asked to verify the incoming identity token could not be reached. This is often a transient error caused by network conditions. Retry the request a limited number of times so that you don't exceed the request rate. If the error persists, the identity provider might be down or not responding.
    internal static var idpCommunicationErrorException: Self { .init(.idpCommunicationErrorException) }
    /// The identity provider (IdP) reported that authentication failed. This might be because the claim is invalid. If this error is returned for the AssumeRoleWithWebIdentity operation, it can also mean that the claim has expired or has been explicitly revoked.
    internal static var idpRejectedClaimException: Self { .init(.idpRejectedClaimException) }
    /// The error returned if the message passed to DecodeAuthorizationMessage was invalid. This can happen if the token contains invalid characters, such as line breaks, or if the message has expired.
    internal static var invalidAuthorizationMessageException: Self { .init(.invalidAuthorizationMessageException) }
    /// The web identity token that was passed could not be validated by Amazon Web Services. Get a new identity token from the identity provider and then retry the request.
    internal static var invalidIdentityTokenException: Self { .init(.invalidIdentityTokenException) }
    /// The request was rejected because the policy document was malformed. The error message describes the specific error.
    internal static var malformedPolicyDocumentException: Self { .init(.malformedPolicyDocumentException) }
    /// The request was rejected because the total packed size of the session policies and session tags combined was too large. An Amazon Web Services conversion compresses the session policy document, session policy ARNs, and session tags into a packed binary format that has a separate limit. The error message indicates by percentage how close the policies and tags are to the upper size limit. For more information, see Passing Session Tags in STS in the IAM User Guide. You could receive this error even though you meet other defined session policy and session tag limits. For more information, see IAM and STS Entity Character Limits in the IAM User Guide.
    internal static var packedPolicyTooLargeException: Self { .init(.packedPolicyTooLargeException) }
    /// STS is not activated in the requested region for the account that is being asked to generate credentials. The account administrator must use the IAM console to activate STS in that region. For more information, see Activating and Deactivating STS in an Amazon Web Services Region in the IAM User Guide.
    internal static var regionDisabledException: Self { .init(.regionDisabledException) }
}

extension STSErrorType: Equatable {
    internal static func == (lhs: STSErrorType, rhs: STSErrorType) -> Bool {
        lhs.error == rhs.error
    }
}

extension STSErrorType: CustomStringConvertible {
    internal var description: String {
        return "\(self.error.rawValue): \(self.message ?? "")"
    }
}
