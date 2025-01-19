# AWS IAM Policies for CodeCommit and MFA Enforcement

This repository contains various IAM policies related to AWS CodeCommit and Multi-Factor Authentication (MFA) enforcement. Below is an overview of each policy file and its intended use.

## Files in the Repository

1. **CodeCommitFullNoDelete-TrustPolicy.json**:
   - This trust policy is essential for using AWS CodeCommit. It allows assuming roles only if Multi-Factor Authentication (MFA) is enabled.
   - **Note**: You must attach the AWS managed policy `AWSCodeCommitFullAccess` alongside this policy for full functionality in CodeCommit.

2. **DenyCodeCommitDeletion.json**:
   - A supplemental policy to specifically deny deletion of CodeCommit repositories.
   - **Recommendation**: For enhanced security, consider attaching this policy alongside the primary CodeCommit policy.

3. **enforce_mfa_allow_codecommit.json**:
   - **Important**: Currently, this policy is not functioning as intended. It's recommended not to use this policy until further adjustments are made.

4. **enforce_mfa.json**:
   - A policy designed to enforce MFA requirements for various IAM actions. This is straight from aws: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage-mfa-only.html

5. **whitelist_ip.json**:
   - This policy restricts access based on IP whitelisting.

## Usage Guidelines

- To effectively use CodeCommit while enforcing MFA and preventing repository deletion, apply `CodeCommitFullNoDelete-TrustPolicy.json` and attach the `AWSCodeCommitFullAccess` managed policy.
- Optionally, add `DenyCodeCommitDeletion.json` for an additional layer of security against repository deletions.
- Ensure MFA is enabled for all users assuming these roles, as per the conditions set in the trust policy.
- Review and modify the `enforce_mfa.json` and `whitelist_ip.json` as per your organizational security requirements.

## Additional Notes

- The `enforce_mfa_allow_codecommit.json` policy is currently not recommended for use due to issues with its implementation.
- Always test policies in a controlled environment before applying them in a production setting to ensure they function as expected and do not disrupt normal operations.
