# Security Policy

## Supported Versions

We actively support the latest version of **dllm-tf** and provide security patches for recent major versions. Users are encouraged to use the most current version to benefit from the latest updates and security features.

| Version    | Supported          |
|------------|---------------------|
| Latest     | :white_check_mark:  |
| Older      | :x:                 |

## Reporting a Vulnerability

If you discover a security vulnerability in **dllm-tf**, please follow these guidelines to report it:

1. **Do not publicly disclose** the vulnerability.
2. Contact us by emailing [dllmnus@googlegroups.com](mailto:dllmnus@googlegroups.com) with the subject line: **"Security Issue in dllm-tf"**.
3. Provide a clear and detailed description of the issue, including:
   - Steps to reproduce
   - Potential impact
   - Any proof-of-concept code (if available)
4. You will receive an acknowledgment within 48 hours, and updates as the issue is addressed.

### Responsible Disclosure Policy

We ask that reporters act in good faith by not disclosing security vulnerabilities until the **dllm-tf** team has confirmed and issued a fix. All valid security vulnerabilities are prioritized and patched based on severity.

## Security Best Practices

To ensure secure deployment and management of the **dllm-tf** project, follow these guidelines:

- **IAM Policies**: Use the principle of least privilege when granting access to Terraform resources and modules. Limit AWS credentials to the minimum permissions required.
- **Secure State Files**: Store Terraform state files in a secure, encrypted location (e.g., AWS S3 with encryption enabled and versioning).
- **Environment Variables**: Do not hard-code sensitive values in Terraform code. Use environment variables or secrets management tools (e.g., AWS Secrets Manager).
- **Dependencies**: Regularly review and update provider dependencies in your Terraform files to keep the project up-to-date with security patches.

## Additional Security Information

For additional information, refer to:

- [AWS Security Best Practices](https://aws.amazon.com/architecture/security/)
- [Terraform Security Documentation](https://www.terraform.io/docs/security/index.html)

Thank you for helping to keep **dllm-tf** secure!

