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

extension STS {
    // MARK: Enums

    // MARK: Shapes

    internal struct AssumeRoleRequest: AWSEncodableShape {
        /// The duration, in seconds, of the role session. The value specified can range from 900 seconds (15 minutes) up to the maximum session duration set for the role. The maximum session duration setting can have a value from 1 hour to 12 hours. If you specify a value higher than this setting or the administrator setting (whichever is lower), the operation fails. For example, if you specify a session duration of 12 hours, but your administrator set the maximum session duration to 6 hours, your operation fails.  Role chaining limits your Amazon Web Services CLI or Amazon Web Services API role session to a maximum of one hour. When you use the AssumeRole API operation to assume a role, you can specify the duration of your role session with the DurationSeconds parameter. You can specify a parameter value of up to 43200 seconds (12 hours), depending on the maximum session duration setting for your role. However, if you assume a role using role chaining and provide a DurationSeconds parameter value greater than one hour, the operation fails. To learn how to view the maximum value for your role, see Update the maximum session duration for a role. By default, the value is set to 3600 seconds.   The DurationSeconds parameter is separate from the duration of a console session that you might request using the returned credentials. The request to the federation endpoint for a console sign-in token takes a SessionDuration parameter that specifies the maximum length of the console session. For more information, see Creating a URL that Enables Federated Users to Access the Amazon Web Services Management Console in the IAM User Guide.
        internal let durationSeconds: Int?
        /// A unique identifier that might be required when you assume a role in another account. If the administrator of the account to which the role belongs provided you with an external ID, then provide that value in the ExternalId parameter. This value can be any string, such as a passphrase or account number. A cross-account role is usually set up to trust everyone in an account. Therefore, the administrator of the trusting account might send an external ID to the administrator of the trusted account. That way, only someone with the ID can assume the role, rather than everyone in the account. For more information about the external ID, see How to Use an External ID When Granting Access to Your Amazon Web Services Resources to a Third Party in the IAM User Guide. The regex used to validate this parameter is a string of  characters consisting of upper- and lower-case alphanumeric characters with no spaces.  You can also include underscores or any of the following characters: =,.@:/-
        internal let externalId: String?
        /// An IAM policy in JSON format that you want to use as an inline session policy. This parameter is optional. Passing policies to this operation returns new  temporary credentials. The resulting session's permissions are the intersection of the  role's identity-based policy and the session policies. You can use the role's temporary  credentials in subsequent Amazon Web Services API calls to access resources in the account that owns  the role. You cannot use session policies to grant more permissions than those allowed  by the identity-based policy of the role that is being assumed. For more information, see Session Policies in the IAM User Guide. The plaintext that you use for both inline and managed session policies can't exceed 2,048 characters. The JSON policy characters can be any ASCII character from the space character to the end of the valid character list (\u0020 through \u00FF). It can also include the tab (\u0009), linefeed (\u000A), and carriage return (\u000D) characters.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.  For more information about role session permissions, see Session policies.
        internal let policy: String?
        /// The Amazon Resource Names (ARNs) of the IAM managed policies that you want to use as managed session policies. The policies must exist in the same account as the role. This parameter is optional. You can provide up to 10 managed policy ARNs. However, the plaintext that you use for both inline and managed session policies can't exceed 2,048 characters. For more information about ARNs, see Amazon Resource Names (ARNs) and Amazon Web Services Service Namespaces in the Amazon Web Services General Reference.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.  Passing policies to this operation returns new  temporary credentials. The resulting session's permissions are the intersection of the  role's identity-based policy and the session policies. You can use the role's temporary  credentials in subsequent Amazon Web Services API calls to access resources in the account that owns  the role. You cannot use session policies to grant more permissions than those allowed  by the identity-based policy of the role that is being assumed. For more information, see Session Policies in the IAM User Guide.
        @OptionalCustomCoding<StandardArrayCoder<PolicyDescriptorType>>
        internal var policyArns: [PolicyDescriptorType]?
        /// A list of previously acquired trusted context assertions in the format of a JSON array. The trusted context assertion is signed and encrypted by Amazon Web Services STS. The following is an example of a ProvidedContext value that includes a single trusted context assertion and the ARN of the context provider from which the trusted context assertion was generated.  [{"ProviderArn":"arn:aws:iam::aws:contextProvider/IdentityCenter","ContextAssertion":"trusted-context-assertion"}]
        @OptionalCustomCoding<StandardArrayCoder<ProvidedContext>>
        internal var providedContexts: [ProvidedContext]?
        /// The Amazon Resource Name (ARN) of the role to assume.
        internal let roleArn: String
        /// An identifier for the assumed role session. Use the role session name to uniquely identify a session when the same role is assumed by different principals or for different reasons. In cross-account scenarios, the role session name is visible to, and can be logged by the account that owns the role. The role session name is also used in the ARN of the assumed role principal. This means that subsequent cross-account API requests that use the temporary security credentials will expose the role session name to the external account in their CloudTrail logs. For security purposes, administrators can view this field in CloudTrail logs to help identify who performed an action in Amazon Web Services. Your administrator might require that you specify your user name as the session name when you assume the role. For more information, see  sts:RoleSessionName . The regex used to validate this parameter is a string of characters  consisting of upper- and lower-case alphanumeric characters with no spaces. You can  also include underscores or any of the following characters: =,.@-
        internal let roleSessionName: String
        /// The identification number of the MFA device that is associated with the user who is making the AssumeRole call. Specify this value if the trust policy of the role being assumed includes a condition that requires MFA authentication. The value is either the serial number for a hardware device (such as GAHT12345678) or an Amazon Resource Name (ARN) for a virtual device (such as arn:aws:iam::123456789012:mfa/user). The regex used to validate this parameter is a string of characters  consisting of upper- and lower-case alphanumeric characters with no spaces. You can  also include underscores or any of the following characters: =,.@-
        internal let serialNumber: String?
        /// The source identity specified by the principal that is calling the AssumeRole operation. The source identity value persists across chained role sessions. You can require users to specify a source identity when they assume a role. You do this by using the  sts:SourceIdentity condition key in a role trust policy. You can use source identity information in CloudTrail logs to determine who took actions with a role. You can use the aws:SourceIdentity condition key to further control access to Amazon Web Services resources based on the value of source identity. For more information about using source identity, see Monitor and control actions taken with assumed roles in the IAM User Guide. The regex used to validate this parameter is a string of characters consisting of upper- and lower-case alphanumeric characters with no spaces. You can also include underscores or any of the following characters: =,.@-. You cannot use a value that begins with the text aws:. This prefix is reserved for Amazon Web Services internal use.
        internal let sourceIdentity: String?
        /// A list of session tags that you want to pass. Each session tag consists of a key name and an associated value. For more information about session tags, see Tagging Amazon Web Services STS Sessions in the IAM User Guide. This parameter is optional. You can pass up to 50 session tags. The plaintext session tag keys can’t exceed 128 characters, and the values can’t exceed 256 characters. For these and additional limits, see IAM and STS Character Limits in the IAM User Guide.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.  You can pass a session tag with the same key as a tag that is already attached to the role. When you do, session tags override a role tag with the same key.  Tag key–value pairs are not case sensitive, but case is preserved. This means that you cannot have separate Department and department tag keys. Assume that the role has the Department=Marketing tag and you pass the department=engineering session tag. Department and department are not saved as separate tags, and the session tag passed in the request takes precedence over the role tag. Additionally, if you used temporary credentials to perform this operation, the new session inherits any transitive session tags from the calling session. If you pass a session tag with the same key as an inherited tag, the operation fails. To view the inherited tags for a session, see the CloudTrail logs. For more information, see Viewing Session Tags in CloudTrail in the IAM User Guide.
        @OptionalCustomCoding<StandardArrayCoder<Tag>>
        internal var tags: [Tag]?
        /// The value provided by the MFA device, if the trust policy of the role being assumed requires MFA. (In other words, if the policy includes a condition that tests for MFA). If the role being assumed requires MFA and if the TokenCode value is missing or expired, the AssumeRole call returns an "access denied" error. The format for this parameter, as described by its regex pattern, is a sequence of six numeric digits.
        internal let tokenCode: String?
        /// A list of keys for session tags that you want to set as transitive. If you set a tag key as transitive, the corresponding key and value passes to subsequent sessions in a role chain. For more information, see Chaining Roles with Session Tags in the IAM User Guide. This parameter is optional. The transitive status of a session tag does not impact its packed binary size. If you choose not to specify a transitive tag key, then no tags are passed from this session to any subsequent sessions.
        @OptionalCustomCoding<StandardArrayCoder<String>>
        internal var transitiveTagKeys: [String]?

        @inlinable
        internal init(
            durationSeconds: Int? = nil, externalId: String? = nil, policy: String? = nil,
            policyArns: [PolicyDescriptorType]? = nil, providedContexts: [ProvidedContext]? = nil, roleArn: String,
            roleSessionName: String, serialNumber: String? = nil, sourceIdentity: String? = nil, tags: [Tag]? = nil,
            tokenCode: String? = nil, transitiveTagKeys: [String]? = nil
        ) {
            self.durationSeconds = durationSeconds
            self.externalId = externalId
            self.policy = policy
            self.policyArns = policyArns
            self.providedContexts = providedContexts
            self.roleArn = roleArn
            self.roleSessionName = roleSessionName
            self.serialNumber = serialNumber
            self.sourceIdentity = sourceIdentity
            self.tags = tags
            self.tokenCode = tokenCode
            self.transitiveTagKeys = transitiveTagKeys
        }

        internal func validate(name: String) throws {
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, max: 43200)
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, min: 900)
            try self.validate(self.externalId, name: "externalId", parent: name, max: 1224)
            try self.validate(self.externalId, name: "externalId", parent: name, min: 2)
            try self.validate(self.externalId, name: "externalId", parent: name, pattern: "^[\\w+=,.@:\\/-]*$")
            try self.validate(self.policy, name: "policy", parent: name, min: 1)
            try self.validate(
                self.policy, name: "policy", parent: name, pattern: "^[\\u0009\\u000A\\u000D\\u0020-\\u00FF]+$")
            try self.policyArns?.forEach {
                try $0.validate(name: "\(name).policyArns[]")
            }
            try self.providedContexts?.forEach {
                try $0.validate(name: "\(name).providedContexts[]")
            }
            try self.validate(self.providedContexts, name: "providedContexts", parent: name, max: 5)
            try self.validate(self.roleArn, name: "roleArn", parent: name, max: 2048)
            try self.validate(self.roleArn, name: "roleArn", parent: name, min: 20)
            try self.validate(
                self.roleArn, name: "roleArn", parent: name,
                pattern:
                    "^[\\u0009\\u000A\\u000D\\u0020-\\u007E\\u0085\\u00A0-\\uD7FF\\uE000-\\uFFFD\\u10000-\\u10FFFF]+$")
            try self.validate(self.roleSessionName, name: "roleSessionName", parent: name, max: 64)
            try self.validate(self.roleSessionName, name: "roleSessionName", parent: name, min: 2)
            try self.validate(self.roleSessionName, name: "roleSessionName", parent: name, pattern: "^[\\w+=,.@-]*$")
            try self.validate(self.serialNumber, name: "serialNumber", parent: name, max: 256)
            try self.validate(self.serialNumber, name: "serialNumber", parent: name, min: 9)
            try self.validate(self.serialNumber, name: "serialNumber", parent: name, pattern: "^[\\w+=/:,.@-]*$")
            try self.validate(self.sourceIdentity, name: "sourceIdentity", parent: name, max: 64)
            try self.validate(self.sourceIdentity, name: "sourceIdentity", parent: name, min: 2)
            try self.validate(self.sourceIdentity, name: "sourceIdentity", parent: name, pattern: "^[\\w+=,.@-]*$")
            try self.tags?.forEach {
                try $0.validate(name: "\(name).tags[]")
            }
            try self.validate(self.tags, name: "tags", parent: name, max: 50)
            try self.validate(self.tokenCode, name: "tokenCode", parent: name, max: 6)
            try self.validate(self.tokenCode, name: "tokenCode", parent: name, min: 6)
            try self.validate(self.tokenCode, name: "tokenCode", parent: name, pattern: "^[\\d]*$")
            try self.transitiveTagKeys?.forEach {
                try validate($0, name: "transitiveTagKeys[]", parent: name, max: 128)
                try validate($0, name: "transitiveTagKeys[]", parent: name, min: 1)
                try validate(
                    $0, name: "transitiveTagKeys[]", parent: name, pattern: "^[\\p{L}\\p{Z}\\p{N}_.:/=+\\-@]+$")
            }
            try self.validate(self.transitiveTagKeys, name: "transitiveTagKeys", parent: name, max: 50)
        }

        private enum CodingKeys: String, CodingKey {
            case durationSeconds = "DurationSeconds"
            case externalId = "ExternalId"
            case policy = "Policy"
            case policyArns = "PolicyArns"
            case providedContexts = "ProvidedContexts"
            case roleArn = "RoleArn"
            case roleSessionName = "RoleSessionName"
            case serialNumber = "SerialNumber"
            case sourceIdentity = "SourceIdentity"
            case tags = "Tags"
            case tokenCode = "TokenCode"
            case transitiveTagKeys = "TransitiveTagKeys"
        }
    }

    internal struct AssumeRoleResponse: AWSDecodableShape {
        /// The Amazon Resource Name (ARN) and the assumed role ID, which are identifiers that you can use to refer to the resulting temporary security credentials. For example, you can reference these credentials as a principal in a resource-based policy by using the ARN or assumed role ID. The ARN and ID include the RoleSessionName that you specified when you called AssumeRole.
        internal let assumedRoleUser: AssumedRoleUser?
        /// The temporary security credentials, which include an access key ID, a secret access key, and a security (or session) token.  The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.
        internal let credentials: Credentials?
        /// A percentage value that indicates the packed size of the session policies and session  tags combined passed in the request. The request fails if the packed size is greater than 100 percent,  which means the policies and tags exceeded the allowed space.
        internal let packedPolicySize: Int?
        /// The source identity specified by the principal that is calling the AssumeRole operation. You can require users to specify a source identity when they assume a role. You do this by using the sts:SourceIdentity condition key in a role trust policy. You can use source identity information in CloudTrail logs to determine who took actions with a role. You can use the aws:SourceIdentity condition key to further control access to Amazon Web Services resources based on the value of source identity. For more information about using source identity, see Monitor and control actions taken with assumed roles in the IAM User Guide. The regex used to validate this parameter is a string of characters consisting of upper- and lower-case alphanumeric characters with no spaces. You can also include underscores or any of the following characters: =,.@-
        internal let sourceIdentity: String?

        @inlinable
        internal init(
            assumedRoleUser: AssumedRoleUser? = nil, credentials: Credentials? = nil, packedPolicySize: Int? = nil,
            sourceIdentity: String? = nil
        ) {
            self.assumedRoleUser = assumedRoleUser
            self.credentials = credentials
            self.packedPolicySize = packedPolicySize
            self.sourceIdentity = sourceIdentity
        }

        private enum CodingKeys: String, CodingKey {
            case assumedRoleUser = "AssumedRoleUser"
            case credentials = "Credentials"
            case packedPolicySize = "PackedPolicySize"
            case sourceIdentity = "SourceIdentity"
        }
    }

    internal struct AssumeRoleWithSAMLRequest: AWSEncodableShape {
        /// The duration, in seconds, of the role session. Your role session lasts for the duration that you specify for the DurationSeconds parameter, or until the time specified in the SAML authentication response's SessionNotOnOrAfter value, whichever is shorter. You can provide a DurationSeconds value from 900 seconds (15 minutes) up to the maximum session duration setting for the role. This setting can have a value from 1 hour to 12 hours. If you specify a value higher than this setting, the operation fails. For example, if you specify a session duration of 12 hours, but your administrator set the maximum session duration to 6 hours, your operation fails. To learn how to view the maximum value for your role, see View the Maximum Session Duration Setting for a Role in the IAM User Guide. By default, the value is set to 3600 seconds.   The DurationSeconds parameter is separate from the duration of a console session that you might request using the returned credentials. The request to the federation endpoint for a console sign-in token takes a SessionDuration parameter that specifies the maximum length of the console session. For more information, see Creating a URL that Enables Federated Users to Access the Amazon Web Services Management Console in the IAM User Guide.
        internal let durationSeconds: Int?
        /// An IAM policy in JSON format that you want to use as an inline session policy. This parameter is optional. Passing policies to this operation returns new  temporary credentials. The resulting session's permissions are the intersection of the  role's identity-based policy and the session policies. You can use the role's temporary  credentials in subsequent Amazon Web Services API calls to access resources in the account that owns  the role. You cannot use session policies to grant more permissions than those allowed  by the identity-based policy of the role that is being assumed. For more information, see Session Policies in the IAM User Guide.  The plaintext that you use for both inline and managed session policies can't exceed 2,048 characters. The JSON policy characters can be any ASCII character from the space character to the end of the valid character list (\u0020 through \u00FF). It can also include the tab (\u0009), linefeed (\u000A), and carriage return (\u000D) characters. For more information about role session permissions, see Session policies.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.
        internal let policy: String?
        /// The Amazon Resource Names (ARNs) of the IAM managed policies that you want to use as managed session policies. The policies must exist in the same account as the role. This parameter is optional. You can provide up to 10 managed policy ARNs. However, the plaintext that you use for both inline and managed session policies can't exceed 2,048 characters. For more information about ARNs, see Amazon Resource Names (ARNs) and Amazon Web Services Service Namespaces in the Amazon Web Services General Reference.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.  Passing policies to this operation returns new  temporary credentials. The resulting session's permissions are the intersection of the  role's identity-based policy and the session policies. You can use the role's temporary  credentials in subsequent Amazon Web Services API calls to access resources in the account that owns  the role. You cannot use session policies to grant more permissions than those allowed  by the identity-based policy of the role that is being assumed. For more information, see Session Policies in the IAM User Guide.
        @OptionalCustomCoding<StandardArrayCoder<PolicyDescriptorType>>
        internal var policyArns: [PolicyDescriptorType]?
        /// The Amazon Resource Name (ARN) of the SAML provider in IAM that describes the IdP.
        internal let principalArn: String
        /// The Amazon Resource Name (ARN) of the role that the caller is assuming.
        internal let roleArn: String
        /// The base64 encoded SAML authentication response provided by the IdP. For more information, see Configuring a Relying Party and Adding Claims in the IAM User Guide.
        internal let samlAssertion: String

        @inlinable
        internal init(
            durationSeconds: Int? = nil, policy: String? = nil, policyArns: [PolicyDescriptorType]? = nil,
            principalArn: String, roleArn: String, samlAssertion: String
        ) {
            self.durationSeconds = durationSeconds
            self.policy = policy
            self.policyArns = policyArns
            self.principalArn = principalArn
            self.roleArn = roleArn
            self.samlAssertion = samlAssertion
        }

        internal func validate(name: String) throws {
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, max: 43200)
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, min: 900)
            try self.validate(self.policy, name: "policy", parent: name, max: 2048)
            try self.validate(self.policy, name: "policy", parent: name, min: 1)
            try self.validate(
                self.policy, name: "policy", parent: name, pattern: "^[\\u0009\\u000A\\u000D\\u0020-\\u00FF]+$")
            try self.policyArns?.forEach {
                try $0.validate(name: "\(name).policyArns[]")
            }
            try self.validate(self.principalArn, name: "principalArn", parent: name, max: 2048)
            try self.validate(self.principalArn, name: "principalArn", parent: name, min: 20)
            try self.validate(
                self.principalArn, name: "principalArn", parent: name,
                pattern:
                    "^[\\u0009\\u000A\\u000D\\u0020-\\u007E\\u0085\\u00A0-\\uD7FF\\uE000-\\uFFFD\\u10000-\\u10FFFF]+$")
            try self.validate(self.roleArn, name: "roleArn", parent: name, max: 2048)
            try self.validate(self.roleArn, name: "roleArn", parent: name, min: 20)
            try self.validate(
                self.roleArn, name: "roleArn", parent: name,
                pattern:
                    "^[\\u0009\\u000A\\u000D\\u0020-\\u007E\\u0085\\u00A0-\\uD7FF\\uE000-\\uFFFD\\u10000-\\u10FFFF]+$")
            try self.validate(self.samlAssertion, name: "samlAssertion", parent: name, max: 100000)
            try self.validate(self.samlAssertion, name: "samlAssertion", parent: name, min: 4)
        }

        private enum CodingKeys: String, CodingKey {
            case durationSeconds = "DurationSeconds"
            case policy = "Policy"
            case policyArns = "PolicyArns"
            case principalArn = "PrincipalArn"
            case roleArn = "RoleArn"
            case samlAssertion = "SAMLAssertion"
        }
    }

    internal struct AssumeRoleWithSAMLResponse: AWSDecodableShape {
        /// The identifiers for the temporary security credentials that the operation returns.
        internal let assumedRoleUser: AssumedRoleUser?
        ///  The value of the Recipient attribute of the SubjectConfirmationData element of the SAML assertion.
        internal let audience: String?
        /// The temporary security credentials, which include an access key ID, a secret access key, and a security (or session) token.  The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.
        internal let credentials: Credentials?
        /// The value of the Issuer element of the SAML assertion.
        internal let issuer: String?
        /// A hash value based on the concatenation of the following:   The Issuer response value.   The Amazon Web Services account ID.   The friendly name (the last part of the ARN) of the SAML provider in IAM.   The combination of NameQualifier and Subject can be used to uniquely identify a user. The following pseudocode shows how the hash value is calculated:  BASE64 ( SHA1 ( "https://example.com/saml" + "123456789012" + "/MySAMLIdP" ) )
        internal let nameQualifier: String?
        /// A percentage value that indicates the packed size of the session policies and session  tags combined passed in the request. The request fails if the packed size is greater than 100 percent,  which means the policies and tags exceeded the allowed space.
        internal let packedPolicySize: Int?
        /// The value in the SourceIdentity attribute in the SAML assertion. The source identity value persists across chained role sessions. You can require users to set a source identity value when they assume a role. You do this by using the sts:SourceIdentity condition key in a role trust policy. That way, actions that are taken with the role are associated with that user. After the source identity is set, the value cannot be changed. It is present in the request for all actions that are taken by the role and persists across chained role sessions. You can configure your SAML identity provider to use an attribute associated with your users, like user name or email, as the source identity when calling AssumeRoleWithSAML. You do this by adding an attribute to the SAML assertion. For more information about using source identity, see Monitor and control actions taken with assumed roles in the IAM User Guide. The regex used to validate this parameter is a string of characters  consisting of upper- and lower-case alphanumeric characters with no spaces. You can  also include underscores or any of the following characters: =,.@-
        internal let sourceIdentity: String?
        /// The value of the NameID element in the Subject element of the SAML assertion.
        internal let subject: String?
        ///  The format of the name ID, as defined by the Format attribute in the NameID element of the SAML assertion. Typical examples of the format are transient or persistent.  If the format includes the prefix urn:oasis:names:tc:SAML:2.0:nameid-format, that prefix is removed. For example, urn:oasis:names:tc:SAML:2.0:nameid-format:transient is returned as transient. If the format includes any other prefix, the format is returned with no modifications.
        internal let subjectType: String?

        @inlinable
        internal init(
            assumedRoleUser: AssumedRoleUser? = nil, audience: String? = nil, credentials: Credentials? = nil,
            issuer: String? = nil, nameQualifier: String? = nil, packedPolicySize: Int? = nil,
            sourceIdentity: String? = nil, subject: String? = nil, subjectType: String? = nil
        ) {
            self.assumedRoleUser = assumedRoleUser
            self.audience = audience
            self.credentials = credentials
            self.issuer = issuer
            self.nameQualifier = nameQualifier
            self.packedPolicySize = packedPolicySize
            self.sourceIdentity = sourceIdentity
            self.subject = subject
            self.subjectType = subjectType
        }

        private enum CodingKeys: String, CodingKey {
            case assumedRoleUser = "AssumedRoleUser"
            case audience = "Audience"
            case credentials = "Credentials"
            case issuer = "Issuer"
            case nameQualifier = "NameQualifier"
            case packedPolicySize = "PackedPolicySize"
            case sourceIdentity = "SourceIdentity"
            case subject = "Subject"
            case subjectType = "SubjectType"
        }
    }

    internal struct AssumeRoleWithWebIdentityRequest: AWSEncodableShape {
        /// The duration, in seconds, of the role session. The value can range from 900 seconds (15 minutes) up to the maximum session duration setting for the role. This setting can have a value from 1 hour to 12 hours. If you specify a value higher than this setting, the operation fails. For example, if you specify a session duration of 12 hours, but your administrator set the maximum session duration to 6 hours, your operation fails. To learn how to view the maximum value for your role, see View the Maximum Session Duration Setting for a Role in the IAM User Guide. By default, the value is set to 3600 seconds.   The DurationSeconds parameter is separate from the duration of a console session that you might request using the returned credentials. The request to the federation endpoint for a console sign-in token takes a SessionDuration parameter that specifies the maximum length of the console session. For more information, see Creating a URL that Enables Federated Users to Access the Amazon Web Services Management Console in the IAM User Guide.
        internal let durationSeconds: Int?
        /// An IAM policy in JSON format that you want to use as an inline session policy. This parameter is optional. Passing policies to this operation returns new  temporary credentials. The resulting session's permissions are the intersection of the  role's identity-based policy and the session policies. You can use the role's temporary  credentials in subsequent Amazon Web Services API calls to access resources in the account that owns  the role. You cannot use session policies to grant more permissions than those allowed  by the identity-based policy of the role that is being assumed. For more information, see Session Policies in the IAM User Guide. The plaintext that you use for both inline and managed session policies can't exceed 2,048 characters. The JSON policy characters can be any ASCII character from the space character to the end of the valid character list (\u0020 through \u00FF). It can also include the tab (\u0009), linefeed (\u000A), and carriage return (\u000D) characters. For more information about role session permissions, see Session policies.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.
        internal let policy: String?
        /// The Amazon Resource Names (ARNs) of the IAM managed policies that you want to use as managed session policies. The policies must exist in the same account as the role. This parameter is optional. You can provide up to 10 managed policy ARNs. However, the plaintext that you use for both inline and managed session policies can't exceed 2,048 characters. For more information about ARNs, see Amazon Resource Names (ARNs) and Amazon Web Services Service Namespaces in the Amazon Web Services General Reference.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.  Passing policies to this operation returns new  temporary credentials. The resulting session's permissions are the intersection of the  role's identity-based policy and the session policies. You can use the role's temporary  credentials in subsequent Amazon Web Services API calls to access resources in the account that owns  the role. You cannot use session policies to grant more permissions than those allowed  by the identity-based policy of the role that is being assumed. For more information, see Session Policies in the IAM User Guide.
        @OptionalCustomCoding<StandardArrayCoder<PolicyDescriptorType>>
        internal var policyArns: [PolicyDescriptorType]?
        /// The fully qualified host component of the domain name of the OAuth 2.0 identity provider. Do not specify this value for an OpenID Connect identity provider. Currently www.amazon.com and graph.facebook.com are the only supported identity providers for OAuth 2.0 access tokens. Do not include URL schemes and port numbers. Do not specify this value for OpenID Connect ID tokens.
        internal let providerId: String?
        /// The Amazon Resource Name (ARN) of the role that the caller is assuming.  Additional considerations apply to Amazon Cognito identity pools that assume cross-account IAM roles. The trust policies of these roles must accept the cognito-identity.amazonaws.com service principal and must contain the cognito-identity.amazonaws.com:aud condition key to restrict role assumption to users from your intended identity pools. A policy that trusts Amazon Cognito identity pools without this condition creates a risk that a user from an unintended identity pool can assume the role. For more information, see  Trust policies for IAM roles in Basic (Classic) authentication  in the Amazon Cognito Developer Guide.
        internal let roleArn: String
        /// An identifier for the assumed role session. Typically, you pass the name or identifier that is associated with the user who is using your application. That way, the temporary security credentials that your application will use are associated with that user. This session name is included as part of the ARN and assumed role ID in the AssumedRoleUser response element. For security purposes, administrators can view this field in CloudTrail logs to help identify who performed an action in Amazon Web Services. Your administrator might require that you specify your user name as the session name when you assume the role. For more information, see  sts:RoleSessionName . The regex used to validate this parameter is a string of characters  consisting of upper- and lower-case alphanumeric characters with no spaces. You can  also include underscores or any of the following characters: =,.@-
        internal let roleSessionName: String
        /// The OAuth 2.0 access token or OpenID Connect ID token that is provided by the identity provider. Your application must get this token by authenticating the user who is using your application with a web identity provider before the application makes an AssumeRoleWithWebIdentity call. Timestamps in the token must be formatted as either an integer or a long integer. Only tokens with RSA algorithms (RS256) are supported.
        internal let webIdentityToken: String

        @inlinable
        internal init(
            durationSeconds: Int? = nil, policy: String? = nil, policyArns: [PolicyDescriptorType]? = nil,
            providerId: String? = nil, roleArn: String, roleSessionName: String, webIdentityToken: String
        ) {
            self.durationSeconds = durationSeconds
            self.policy = policy
            self.policyArns = policyArns
            self.providerId = providerId
            self.roleArn = roleArn
            self.roleSessionName = roleSessionName
            self.webIdentityToken = webIdentityToken
        }

        internal func validate(name: String) throws {
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, max: 43200)
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, min: 900)
            try self.validate(self.policy, name: "policy", parent: name, max: 2048)
            try self.validate(self.policy, name: "policy", parent: name, min: 1)
            try self.validate(
                self.policy, name: "policy", parent: name, pattern: "^[\\u0009\\u000A\\u000D\\u0020-\\u00FF]+$")
            try self.policyArns?.forEach {
                try $0.validate(name: "\(name).policyArns[]")
            }
            try self.validate(self.providerId, name: "providerId", parent: name, max: 2048)
            try self.validate(self.providerId, name: "providerId", parent: name, min: 4)
            try self.validate(self.roleArn, name: "roleArn", parent: name, max: 2048)
            try self.validate(self.roleArn, name: "roleArn", parent: name, min: 20)
            try self.validate(
                self.roleArn, name: "roleArn", parent: name,
                pattern:
                    "^[\\u0009\\u000A\\u000D\\u0020-\\u007E\\u0085\\u00A0-\\uD7FF\\uE000-\\uFFFD\\u10000-\\u10FFFF]+$")
            try self.validate(self.roleSessionName, name: "roleSessionName", parent: name, max: 64)
            try self.validate(self.roleSessionName, name: "roleSessionName", parent: name, min: 2)
            try self.validate(self.roleSessionName, name: "roleSessionName", parent: name, pattern: "^[\\w+=,.@-]*$")
            try self.validate(self.webIdentityToken, name: "webIdentityToken", parent: name, max: 20000)
            try self.validate(self.webIdentityToken, name: "webIdentityToken", parent: name, min: 4)
        }

        private enum CodingKeys: String, CodingKey {
            case durationSeconds = "DurationSeconds"
            case policy = "Policy"
            case policyArns = "PolicyArns"
            case providerId = "ProviderId"
            case roleArn = "RoleArn"
            case roleSessionName = "RoleSessionName"
            case webIdentityToken = "WebIdentityToken"
        }
    }

    internal struct AssumeRoleWithWebIdentityResponse: AWSDecodableShape {
        /// The Amazon Resource Name (ARN) and the assumed role ID, which are identifiers that you can use to refer to the resulting temporary security credentials. For example, you can reference these credentials as a principal in a resource-based policy by using the ARN or assumed role ID. The ARN and ID include the RoleSessionName that you specified when you called AssumeRole.
        internal let assumedRoleUser: AssumedRoleUser?
        /// The intended audience (also known as client ID) of the web identity token. This is traditionally the client identifier issued to the application that requested the web identity token.
        internal let audience: String?
        /// The temporary security credentials, which include an access key ID, a secret access key, and a security token.  The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.
        internal let credentials: Credentials?
        /// A percentage value that indicates the packed size of the session policies and session  tags combined passed in the request. The request fails if the packed size is greater than 100 percent,  which means the policies and tags exceeded the allowed space.
        internal let packedPolicySize: Int?
        ///  The issuing authority of the web identity token presented. For OpenID Connect ID tokens, this contains the value of the iss field. For OAuth 2.0 access tokens, this contains the value of the ProviderId parameter that was passed in the AssumeRoleWithWebIdentity request.
        internal let provider: String?
        /// The value of the source identity that is returned in the JSON web token (JWT) from the identity provider. You can require users to set a source identity value when they assume a role. You do this by using the sts:SourceIdentity condition key in a role trust policy. That way, actions that are taken with the role are associated with that user. After the source identity is set, the value cannot be changed. It is present in the request for all actions that are taken by the role and persists across chained role sessions. You can configure your identity provider to use an attribute associated with your users, like user name or email, as the source identity when calling AssumeRoleWithWebIdentity. You do this by adding a claim to the JSON web token. To learn more about OIDC tokens and claims, see Using Tokens with User Pools in the Amazon Cognito Developer Guide. For more information about using source identity, see Monitor and control actions taken with assumed roles in the IAM User Guide. The regex used to validate this parameter is a string of characters  consisting of upper- and lower-case alphanumeric characters with no spaces. You can  also include underscores or any of the following characters: =,.@-
        internal let sourceIdentity: String?
        /// The unique user identifier that is returned by the identity provider. This identifier is associated with the WebIdentityToken that was submitted with the AssumeRoleWithWebIdentity call. The identifier is typically unique to the user and the application that acquired the WebIdentityToken (pairwise identifier). For OpenID Connect ID tokens, this field contains the value returned by the identity provider as the token's sub (Subject) claim.
        internal let subjectFromWebIdentityToken: String?

        @inlinable
        internal init(
            assumedRoleUser: AssumedRoleUser? = nil, audience: String? = nil, credentials: Credentials? = nil,
            packedPolicySize: Int? = nil, provider: String? = nil, sourceIdentity: String? = nil,
            subjectFromWebIdentityToken: String? = nil
        ) {
            self.assumedRoleUser = assumedRoleUser
            self.audience = audience
            self.credentials = credentials
            self.packedPolicySize = packedPolicySize
            self.provider = provider
            self.sourceIdentity = sourceIdentity
            self.subjectFromWebIdentityToken = subjectFromWebIdentityToken
        }

        private enum CodingKeys: String, CodingKey {
            case assumedRoleUser = "AssumedRoleUser"
            case audience = "Audience"
            case credentials = "Credentials"
            case packedPolicySize = "PackedPolicySize"
            case provider = "Provider"
            case sourceIdentity = "SourceIdentity"
            case subjectFromWebIdentityToken = "SubjectFromWebIdentityToken"
        }
    }

    internal struct AssumeRootRequest: AWSEncodableShape {
        /// The duration, in seconds, of the privileged session. The value can range from 0 seconds up to the maximum session duration of 900 seconds (15 minutes). If you specify a value higher than this setting, the operation fails. By default, the value is set to 900 seconds.
        internal let durationSeconds: Int?
        /// The member account principal ARN or account ID.
        internal let targetPrincipal: String
        /// The identity based policy that scopes the session to the privileged tasks that can be performed. You can use one of following Amazon Web Services managed policies to scope root session actions. You can add additional customer managed policies to further limit the permissions for the root session.    IAMAuditRootUserCredentials     IAMCreateRootUserPassword     IAMDeleteRootUserCredentials     S3UnlockBucketPolicy     SQSUnlockQueuePolicy
        internal let taskPolicyArn: PolicyDescriptorType

        @inlinable
        internal init(durationSeconds: Int? = nil, targetPrincipal: String, taskPolicyArn: PolicyDescriptorType) {
            self.durationSeconds = durationSeconds
            self.targetPrincipal = targetPrincipal
            self.taskPolicyArn = taskPolicyArn
        }

        internal func validate(name: String) throws {
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, max: 900)
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, min: 0)
            try self.validate(self.targetPrincipal, name: "targetPrincipal", parent: name, max: 2048)
            try self.validate(self.targetPrincipal, name: "targetPrincipal", parent: name, min: 12)
            try self.taskPolicyArn.validate(name: "\(name).taskPolicyArn")
        }

        private enum CodingKeys: String, CodingKey {
            case durationSeconds = "DurationSeconds"
            case targetPrincipal = "TargetPrincipal"
            case taskPolicyArn = "TaskPolicyArn"
        }
    }

    internal struct AssumeRootResponse: AWSDecodableShape {
        /// The temporary security credentials, which include an access key ID, a secret access key, and a security token.  The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.
        internal let credentials: Credentials?
        /// The source identity specified by the principal that is calling the AssumeRoot operation. You can use the aws:SourceIdentity condition key to control access based on the value of source identity. For more information about using source identity, see Monitor and control actions taken with assumed roles in the IAM User Guide. The regex used to validate this parameter is a string of characters consisting of upper- and lower-case alphanumeric characters with no spaces. You can also include underscores or any of the following characters: =,.@-
        internal let sourceIdentity: String?

        @inlinable
        internal init(credentials: Credentials? = nil, sourceIdentity: String? = nil) {
            self.credentials = credentials
            self.sourceIdentity = sourceIdentity
        }

        private enum CodingKeys: String, CodingKey {
            case credentials = "Credentials"
            case sourceIdentity = "SourceIdentity"
        }
    }

    internal struct AssumedRoleUser: AWSDecodableShape {
        /// The ARN of the temporary security credentials that are returned from the AssumeRole action. For more information about ARNs and how to use them in policies, see IAM Identifiers in the IAM User Guide.
        internal let arn: String
        /// A unique identifier that contains the role ID and the role session name of the role that is being assumed. The role ID is generated by Amazon Web Services when the role is created.
        internal let assumedRoleId: String

        @inlinable
        internal init(arn: String, assumedRoleId: String) {
            self.arn = arn
            self.assumedRoleId = assumedRoleId
        }

        private enum CodingKeys: String, CodingKey {
            case arn = "Arn"
            case assumedRoleId = "AssumedRoleId"
        }
    }

    internal struct Credentials: AWSDecodableShape {
        /// The access key ID that identifies the temporary security credentials.
        internal let accessKeyId: String
        /// The date on which the current credentials expire.
        internal let expiration: Date
        /// The secret access key that can be used to sign requests.
        internal let secretAccessKey: String
        /// The token that users must pass to the service API to use the temporary credentials.
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

    internal struct DecodeAuthorizationMessageRequest: AWSEncodableShape {
        /// The encoded message that was returned with the response.
        internal let encodedMessage: String

        @inlinable
        internal init(encodedMessage: String) {
            self.encodedMessage = encodedMessage
        }

        internal func validate(name: String) throws {
            try self.validate(self.encodedMessage, name: "encodedMessage", parent: name, max: 10240)
            try self.validate(self.encodedMessage, name: "encodedMessage", parent: name, min: 1)
        }

        private enum CodingKeys: String, CodingKey {
            case encodedMessage = "EncodedMessage"
        }
    }

    internal struct DecodeAuthorizationMessageResponse: AWSDecodableShape {
        /// The API returns a response with the decoded message.
        internal let decodedMessage: String?

        @inlinable
        internal init(decodedMessage: String? = nil) {
            self.decodedMessage = decodedMessage
        }

        private enum CodingKeys: String, CodingKey {
            case decodedMessage = "DecodedMessage"
        }
    }

    internal struct FederatedUser: AWSDecodableShape {
        /// The ARN that specifies the federated user that is associated with the credentials. For more information about ARNs and how to use them in policies, see IAM Identifiers in the IAM User Guide.
        internal let arn: String
        /// The string that identifies the federated user associated with the credentials, similar to the unique ID of an IAM user.
        internal let federatedUserId: String

        @inlinable
        internal init(arn: String, federatedUserId: String) {
            self.arn = arn
            self.federatedUserId = federatedUserId
        }

        private enum CodingKeys: String, CodingKey {
            case arn = "Arn"
            case federatedUserId = "FederatedUserId"
        }
    }

    internal struct GetAccessKeyInfoRequest: AWSEncodableShape {
        /// The identifier of an access key. This parameter allows (through its regex pattern) a string of characters that can consist of any upper- or lowercase letter or digit.
        internal let accessKeyId: String

        @inlinable
        internal init(accessKeyId: String) {
            self.accessKeyId = accessKeyId
        }

        internal func validate(name: String) throws {
            try self.validate(self.accessKeyId, name: "accessKeyId", parent: name, max: 128)
            try self.validate(self.accessKeyId, name: "accessKeyId", parent: name, min: 16)
            try self.validate(self.accessKeyId, name: "accessKeyId", parent: name, pattern: "^[\\w]*$")
        }

        private enum CodingKeys: String, CodingKey {
            case accessKeyId = "AccessKeyId"
        }
    }

    internal struct GetAccessKeyInfoResponse: AWSDecodableShape {
        /// The number used to identify the Amazon Web Services account.
        internal let account: String?

        @inlinable
        internal init(account: String? = nil) {
            self.account = account
        }

        private enum CodingKeys: String, CodingKey {
            case account = "Account"
        }
    }

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

    internal struct GetFederationTokenRequest: AWSEncodableShape {
        /// The duration, in seconds, that the session should last. Acceptable durations for federation sessions range from 900 seconds (15 minutes) to 129,600 seconds (36 hours), with 43,200 seconds (12 hours) as the default. Sessions obtained using root user credentials are restricted to a maximum of 3,600 seconds (one hour). If the specified duration is longer than one hour, the session obtained by using root user credentials defaults to one hour.
        internal let durationSeconds: Int?
        /// The name of the federated user. The name is used as an identifier for the temporary security credentials (such as Bob). For example, you can reference the federated user name in a resource-based policy, such as in an Amazon S3 bucket policy. The regex used to validate this parameter is a string of characters  consisting of upper- and lower-case alphanumeric characters with no spaces. You can  also include underscores or any of the following characters: =,.@-
        internal let name: String
        /// An IAM policy in JSON format that you want to use as an inline session policy. You must pass an inline or managed session policy to this operation. You can pass a single JSON policy document to use as an inline session policy. You can also specify up to 10 managed policy Amazon Resource Names (ARNs) to use as managed session policies. This parameter is optional. However, if you do not pass any session policies, then the resulting federated user session has no permissions. When you pass session policies, the session permissions are the intersection of the IAM user policies and the session policies that you pass. This gives you a way to further restrict the permissions for a federated user. You cannot use session policies to grant more permissions than those that are defined in the permissions policy of the IAM user. For more information, see Session Policies in the IAM User Guide. The resulting credentials can be used to access a resource that has a resource-based policy. If that policy specifically references the federated user session in the Principal element of the policy, the session has the permissions allowed by the policy. These permissions are granted in addition to the permissions that are granted by the session policies. The plaintext that you use for both inline and managed session policies can't exceed 2,048 characters. The JSON policy characters can be any ASCII character from the space character to the end of the valid character list (\u0020 through \u00FF). It can also include the tab (\u0009), linefeed (\u000A), and carriage return (\u000D) characters.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.
        internal let policy: String?
        /// The Amazon Resource Names (ARNs) of the IAM managed policies that you want to use as a managed session policy. The policies must exist in the same account as the IAM user that is requesting federated access. You must pass an inline or managed session policy to this operation. You can pass a single JSON policy document to use as an inline session policy. You can also specify up to 10 managed policy Amazon Resource Names (ARNs) to use as managed session policies. The plaintext that you use for both inline and managed session policies can't exceed 2,048 characters. You can provide up to 10 managed policy ARNs. For more information about ARNs, see Amazon Resource Names (ARNs) and Amazon Web Services Service Namespaces in the Amazon Web Services General Reference. This parameter is optional. However, if you do not pass any session policies, then the resulting federated user session has no permissions. When you pass session policies, the session permissions are the intersection of the IAM user policies and the session policies that you pass. This gives you a way to further restrict the permissions for a federated user. You cannot use session policies to grant more permissions than those that are defined in the permissions policy of the IAM user. For more information, see Session Policies in the IAM User Guide. The resulting credentials can be used to access a resource that has a resource-based policy. If that policy specifically references the federated user session in the Principal element of the policy, the session has the permissions allowed by the policy. These permissions are granted in addition to the permissions that are granted by the session policies.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.
        @OptionalCustomCoding<StandardArrayCoder<PolicyDescriptorType>>
        internal var policyArns: [PolicyDescriptorType]?
        /// A list of session tags. Each session tag consists of a key name and an associated value. For more information about session tags, see Passing Session Tags in STS in the IAM User Guide. This parameter is optional. You can pass up to 50 session tags. The plaintext session tag keys can’t exceed 128 characters and the values can’t exceed 256 characters. For these and additional limits, see IAM and STS Character Limits in the IAM User Guide.  An Amazon Web Services conversion compresses the passed inline session policy, managed policy ARNs, and session tags into a packed binary format that has a separate limit. Your request can fail for this limit even if your plaintext meets the other requirements. The PackedPolicySize response element indicates by percentage how close the policies and tags for your request are to the upper size limit.  You can pass a session tag with the same key as a tag that is already attached to the user you are federating. When you do, session tags override a user tag with the same key.  Tag key–value pairs are not case sensitive, but case is preserved. This means that you cannot have separate Department and department tag keys. Assume that the role has the Department=Marketing tag and you pass the department=engineering session tag. Department and department are not saved as separate tags, and the session tag passed in the request takes precedence over the role tag.
        @OptionalCustomCoding<StandardArrayCoder<Tag>>
        internal var tags: [Tag]?

        @inlinable
        internal init(
            durationSeconds: Int? = nil, name: String, policy: String? = nil, policyArns: [PolicyDescriptorType]? = nil,
            tags: [Tag]? = nil
        ) {
            self.durationSeconds = durationSeconds
            self.name = name
            self.policy = policy
            self.policyArns = policyArns
            self.tags = tags
        }

        internal func validate(name: String) throws {
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, max: 129600)
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, min: 900)
            try self.validate(self.name, name: "name", parent: name, max: 32)
            try self.validate(self.name, name: "name", parent: name, min: 2)
            try self.validate(self.name, name: "name", parent: name, pattern: "^[\\w+=,.@-]*$")
            try self.validate(self.policy, name: "policy", parent: name, max: 2048)
            try self.validate(self.policy, name: "policy", parent: name, min: 1)
            try self.validate(
                self.policy, name: "policy", parent: name, pattern: "^[\\u0009\\u000A\\u000D\\u0020-\\u00FF]+$")
            try self.policyArns?.forEach {
                try $0.validate(name: "\(name).policyArns[]")
            }
            try self.tags?.forEach {
                try $0.validate(name: "\(name).tags[]")
            }
            try self.validate(self.tags, name: "tags", parent: name, max: 50)
        }

        private enum CodingKeys: String, CodingKey {
            case durationSeconds = "DurationSeconds"
            case name = "Name"
            case policy = "Policy"
            case policyArns = "PolicyArns"
            case tags = "Tags"
        }
    }

    internal struct GetFederationTokenResponse: AWSDecodableShape {
        /// The temporary security credentials, which include an access key ID, a secret access key, and a security (or session) token.  The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.
        internal let credentials: Credentials?
        /// Identifiers for the federated user associated with the credentials (such as arn:aws:sts::123456789012:federated-user/Bob or 123456789012:Bob). You can use the federated user's ARN in your resource-based policies, such as an Amazon S3 bucket policy.
        internal let federatedUser: FederatedUser?
        /// A percentage value that indicates the packed size of the session policies and session  tags combined passed in the request. The request fails if the packed size is greater than 100 percent,  which means the policies and tags exceeded the allowed space.
        internal let packedPolicySize: Int?

        @inlinable
        internal init(
            credentials: Credentials? = nil, federatedUser: FederatedUser? = nil, packedPolicySize: Int? = nil
        ) {
            self.credentials = credentials
            self.federatedUser = federatedUser
            self.packedPolicySize = packedPolicySize
        }

        private enum CodingKeys: String, CodingKey {
            case credentials = "Credentials"
            case federatedUser = "FederatedUser"
            case packedPolicySize = "PackedPolicySize"
        }
    }

    internal struct GetSessionTokenRequest: AWSEncodableShape {
        /// The duration, in seconds, that the credentials should remain valid. Acceptable durations for IAM user sessions range from 900 seconds (15 minutes) to 129,600 seconds (36 hours), with 43,200 seconds (12 hours) as the default. Sessions for Amazon Web Services account owners are restricted to a maximum of 3,600 seconds (one hour). If the duration is longer than one hour, the session for Amazon Web Services account owners defaults to one hour.
        internal let durationSeconds: Int?
        /// The identification number of the MFA device that is associated with the IAM user who is making the GetSessionToken call. Specify this value if the IAM user has a policy that requires MFA authentication. The value is either the serial number for a hardware device (such as GAHT12345678) or an Amazon Resource Name (ARN) for a virtual device (such as arn:aws:iam::123456789012:mfa/user). You can find the device for an IAM user by going to the Amazon Web Services Management Console and viewing the user's security credentials.  The regex used to validate this parameter is a string of  characters consisting of upper- and lower-case alphanumeric characters with no spaces.  You can also include underscores or any of the following characters: =,.@:/-
        internal let serialNumber: String?
        /// The value provided by the MFA device, if MFA is required. If any policy requires the IAM user to submit an MFA code, specify this value. If MFA authentication is required, the user must provide a code when requesting a set of temporary security credentials. A user who fails to provide the code receives an "access denied" response when requesting resources that require MFA authentication. The format for this parameter, as described by its regex pattern, is a sequence of six numeric digits.
        internal let tokenCode: String?

        @inlinable
        internal init(durationSeconds: Int? = nil, serialNumber: String? = nil, tokenCode: String? = nil) {
            self.durationSeconds = durationSeconds
            self.serialNumber = serialNumber
            self.tokenCode = tokenCode
        }

        internal func validate(name: String) throws {
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, max: 129600)
            try self.validate(self.durationSeconds, name: "durationSeconds", parent: name, min: 900)
            try self.validate(self.serialNumber, name: "serialNumber", parent: name, max: 256)
            try self.validate(self.serialNumber, name: "serialNumber", parent: name, min: 9)
            try self.validate(self.serialNumber, name: "serialNumber", parent: name, pattern: "^[\\w+=/:,.@-]*$")
            try self.validate(self.tokenCode, name: "tokenCode", parent: name, max: 6)
            try self.validate(self.tokenCode, name: "tokenCode", parent: name, min: 6)
            try self.validate(self.tokenCode, name: "tokenCode", parent: name, pattern: "^[\\d]*$")
        }

        private enum CodingKeys: String, CodingKey {
            case durationSeconds = "DurationSeconds"
            case serialNumber = "SerialNumber"
            case tokenCode = "TokenCode"
        }
    }

    internal struct GetSessionTokenResponse: AWSDecodableShape {
        /// The temporary security credentials, which include an access key ID, a secret access key, and a security (or session) token.  The size of the security token that STS API operations return is not fixed. We strongly recommend that you make no assumptions about the maximum size.
        internal let credentials: Credentials?

        @inlinable
        internal init(credentials: Credentials? = nil) {
            self.credentials = credentials
        }

        private enum CodingKeys: String, CodingKey {
            case credentials = "Credentials"
        }
    }

    internal struct PolicyDescriptorType: AWSEncodableShape {
        /// The Amazon Resource Name (ARN) of the IAM managed policy to use as a session policy for the role. For more information about ARNs, see Amazon Resource Names (ARNs) and Amazon Web Services Service Namespaces in the Amazon Web Services General Reference.
        internal let arn: String?

        @inlinable
        internal init(arn: String? = nil) {
            self.arn = arn
        }

        internal func validate(name: String) throws {
            try self.validate(self.arn, name: "arn", parent: name, max: 2048)
            try self.validate(self.arn, name: "arn", parent: name, min: 20)
            try self.validate(
                self.arn, name: "arn", parent: name,
                pattern:
                    "^[\\u0009\\u000A\\u000D\\u0020-\\u007E\\u0085\\u00A0-\\uD7FF\\uE000-\\uFFFD\\u10000-\\u10FFFF]+$")
        }

        private enum CodingKeys: String, CodingKey {
            case arn = "arn"
        }
    }

    internal struct ProvidedContext: AWSEncodableShape {
        /// The signed and encrypted trusted context assertion generated by the context provider. The trusted context assertion is signed and encrypted by Amazon Web Services STS.
        internal let contextAssertion: String?
        /// The context provider ARN from which the trusted context assertion was generated.
        internal let providerArn: String?

        @inlinable
        internal init(contextAssertion: String? = nil, providerArn: String? = nil) {
            self.contextAssertion = contextAssertion
            self.providerArn = providerArn
        }

        internal func validate(name: String) throws {
            try self.validate(self.contextAssertion, name: "contextAssertion", parent: name, max: 2048)
            try self.validate(self.contextAssertion, name: "contextAssertion", parent: name, min: 4)
            try self.validate(self.providerArn, name: "providerArn", parent: name, max: 2048)
            try self.validate(self.providerArn, name: "providerArn", parent: name, min: 20)
            try self.validate(
                self.providerArn, name: "providerArn", parent: name,
                pattern:
                    "^[\\u0009\\u000A\\u000D\\u0020-\\u007E\\u0085\\u00A0-\\uD7FF\\uE000-\\uFFFD\\u10000-\\u10FFFF]+$")
        }

        private enum CodingKeys: String, CodingKey {
            case contextAssertion = "ContextAssertion"
            case providerArn = "ProviderArn"
        }
    }

    internal struct Tag: AWSEncodableShape {
        /// The key for a session tag. You can pass up to 50 session tags. The plain text session tag keys can’t exceed 128 characters. For these and additional limits, see IAM and STS Character Limits in the IAM User Guide.
        internal let key: String
        /// The value for a session tag. You can pass up to 50 session tags. The plain text session tag values can’t exceed 256 characters. For these and additional limits, see IAM and STS Character Limits in the IAM User Guide.
        internal let value: String

        @inlinable
        internal init(key: String, value: String) {
            self.key = key
            self.value = value
        }

        internal func validate(name: String) throws {
            try self.validate(self.key, name: "key", parent: name, max: 128)
            try self.validate(self.key, name: "key", parent: name, min: 1)
            try self.validate(self.key, name: "key", parent: name, pattern: "^[\\p{L}\\p{Z}\\p{N}_.:/=+\\-@]+$")
            try self.validate(self.value, name: "value", parent: name, max: 256)
            try self.validate(self.value, name: "value", parent: name, pattern: "^[\\p{L}\\p{Z}\\p{N}_.:/=+\\-@]*$")
        }

        private enum CodingKeys: String, CodingKey {
            case key = "Key"
            case value = "Value"
        }
    }
}

// MARK: - Errors

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
