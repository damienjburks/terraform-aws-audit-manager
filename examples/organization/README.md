# Organization-Wide AWS Audit Manager Example

This example demonstrates how to deploy AWS Audit Manager across an AWS Organization using the terraform-aws-audit-manager module.

## Overview

This configuration will:
- Enable AWS Audit Manager in your AWS Organization
- Register a delegated administrator account for Audit Manager
- Create an S3 bucket for organization-wide evidence storage
- Create a KMS key for evidence encryption
- Set up IAM roles and policies for Audit Manager
- Enable evidence collection from all member accounts
- Optionally create organization-wide assessments

## Prerequisites

- AWS Organization with multiple member accounts
- Management account access (to register delegated administrator)
- Terraform >= 1.0.0
- AWS Provider >= 4.0.0
- AWS region that supports Audit Manager

## Required Permissions

### Management Account Permissions

The AWS credentials used in the management account must have permissions to:
- Register delegated administrators for AWS Audit Manager
- Enable AWS Organizations integration

### Delegated Administrator Account Permissions

The delegated administrator account must have permissions to:
- Enable AWS Audit Manager
- Create S3 buckets and configure bucket policies
- Create KMS keys and key policies
- Create IAM roles and policies
- Create Audit Manager assessments
- Access organization member account information

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    AWS Organization                          │
│                                                              │
│  ┌────────────────────┐         ┌────────────────────┐     │
│  │ Management Account │────────▶│ Delegated Admin    │     │
│  │                    │         │ Account            │     │
│  └────────────────────┘         └────────────────────┘     │
│                                           │                  │
│                                           │                  │
│                                           ▼                  │
│                              ┌──────────────────────┐       │
│                              │ Evidence Collection  │       │
│                              │ from All Accounts    │       │
│                              └──────────────────────┘       │
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │ Member   │  │ Member   │  │ Member   │  │ Member   │  │
│  │ Account 1│  │ Account 2│  │ Account 3│  │ Account N│  │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Usage

### Step 1: Deploy from Management Account

This module should be deployed from the **management account** of your AWS Organization.

1. Set the delegated administrator account ID:

```hcl
# terraform.tfvars
delegated_admin_account_id = "123456789012" # Your delegated admin account ID
aws_region                 = "us-east-1"
```

2. Initialize Terraform:
```bash
terraform init
```

3. Review the planned changes:
```bash
terraform plan
```

4. Apply the configuration:
```bash
terraform apply
```

### Step 2: Create Organization-Wide Assessments

To create assessments that span multiple accounts:

```hcl
assessments = [
  {
    name         = "org-wide-cis-benchmark"
    framework_id = "arn:aws:auditmanager:us-east-1:aws:framework/CIS_AWS_Foundations_Benchmark_v1.4.0"
    description  = "Organization-wide CIS AWS Foundations Benchmark assessment"
    scope = {
      # Include all organization member accounts
      aws_accounts = [
        "123456789012",
        "234567890123",
        "345678901234"
      ]
      # Services to audit across all accounts
      aws_services = [
        "ec2",
        "s3",
        "iam",
        "cloudtrail",
        "config",
        "guardduty"
      ]
    }
    roles = [
      {
        role_arn  = "arn:aws:iam::123456789012:role/AuditOwner"
        role_type = "PROCESS_OWNER"
      }
    ]
  }
]
```

### Custom Configuration

```hcl
# terraform.tfvars
aws_region                 = "us-east-1"
delegated_admin_account_id = "123456789012"
evidence_bucket_prefix     = "org-audit-evidence"
create_kms_key             = true
evidence_retention_days    = 2555

tags = {
  Environment  = "production"
  Organization = "MyOrg"
  Team         = "security"
  Compliance   = "required"
}
```

## Important Considerations

### Delegated Administrator Selection

Choose a delegated administrator account that:
- Is a member account (not the management account)
- Has appropriate security controls
- Is dedicated to security/compliance functions
- Has limited access to prevent unauthorized changes

### Evidence Collection

- Evidence is collected from all member accounts automatically
- Evidence is stored in the delegated administrator account's S3 bucket
- Member accounts must have AWS Config enabled for comprehensive evidence collection
- CloudTrail should be enabled organization-wide

### Cross-Account Access

The delegated administrator account will have read-only access to:
- AWS Config data in member accounts
- CloudTrail logs
- Other AWS service configurations as defined by the framework

## Outputs

After deployment, the following outputs will be available:

- `audit_manager_enabled`: Confirmation that Audit Manager is enabled
- `delegated_admin_account_id`: The delegated administrator account ID
- `evidence_bucket_name`: Name of the S3 bucket storing evidence
- `evidence_bucket_arn`: ARN of the evidence bucket
- `kms_key_arn`: ARN of the KMS key used for encryption
- `service_role_arn`: ARN of the IAM service role for Audit Manager
- `assessment_ids`: Map of assessment names to their IDs
- `assessment_arns`: Map of assessment names to their ARNs

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Important**: 
- Deregistering the delegated administrator will remove organization-wide access
- Evidence data in S3 will be retained unless explicitly deleted
- Ensure you have backed up any necessary evidence before destroying resources

## Security Considerations

- Evidence bucket is encrypted with KMS
- Public access to evidence bucket is blocked
- Bucket versioning protects against accidental deletion
- Cross-account access is limited to read-only evidence collection
- IAM policies follow the principle of least privilege
- Secure transport (HTTPS) is enforced

## Compliance Frameworks

Common frameworks for organization-wide assessments:

- **CIS AWS Foundations Benchmark**: Comprehensive security best practices
- **PCI DSS**: Payment card industry compliance
- **GDPR**: Data protection and privacy
- **HIPAA**: Healthcare data protection
- **SOC 2**: Service organization controls
- **NIST 800-53**: Federal security controls

## Troubleshooting

### Delegated Administrator Registration Fails

- Ensure you're running from the management account
- Verify AWS Organizations is enabled
- Check that the delegated admin account is a member account

### Evidence Collection Issues

- Verify AWS Config is enabled in member accounts
- Check that CloudTrail is enabled organization-wide
- Ensure member accounts have appropriate service control policies (SCPs)

### Permission Errors

- Verify the delegated admin account has necessary permissions
- Check that organization-wide service access is enabled for Audit Manager
- Review IAM policies and trust relationships

## Cost Considerations

Organization-wide deployment will incur costs for:
- S3 storage for evidence from all accounts
- KMS key usage
- AWS Audit Manager service charges per account
- Data transfer between accounts
- AWS Config (if not already enabled)

Costs scale with the number of member accounts and services being audited.
