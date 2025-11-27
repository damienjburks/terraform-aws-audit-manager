# Terraform AWS Audit Manager Module

A production-ready Terraform module for enabling and configuring AWS Audit Manager in both single AWS accounts and multi-account AWS Organizations.

## Overview

AWS Audit Manager helps you continuously audit your AWS usage to simplify risk assessment and compliance with regulations and industry standards. This Terraform module provides a comprehensive, reusable solution for deploying and managing AWS Audit Manager infrastructure.

### Key Capabilities

- **Automated Evidence Collection**: Continuously collect evidence from AWS services
- **Compliance Frameworks**: Support for standard frameworks (CIS, PCI-DSS, GDPR, HIPAA, SOC 2) and custom frameworks
- **Secure Evidence Storage**: Encrypted S3 storage with lifecycle management
- **Multi-Account Support**: Deploy across AWS Organizations with centralized management
- **Assessment Management**: Create and manage compliance assessments programmatically

### Use Cases

- **Continuous Compliance Monitoring**: Automate evidence collection for regulatory compliance
- **Security Audits**: Conduct regular security assessments against industry standards
- **Risk Assessment**: Identify and track compliance risks across your AWS environment
- **Audit Preparation**: Maintain audit-ready evidence for external auditors
- **Custom Compliance**: Implement organization-specific compliance requirements

## Features

- ✅ **Single Account Mode**: Enable Audit Manager in a standalone AWS account
- ✅ **Organization Mode**: Deploy across AWS Organizations with delegated administrator
- ✅ **Evidence Storage**: Automated S3 bucket creation with KMS encryption and lifecycle policies
- ✅ **Assessment Management**: Create assessments from standard AWS frameworks or custom frameworks
- ✅ **Security Best Practices**: KMS encryption, public access blocking, versioning, and least privilege IAM policies
- ✅ **Flexible Configuration**: Customizable evidence retention, bucket names, KMS keys, and tagging
- ✅ **Comprehensive Examples**: Ready-to-use examples for common deployment scenarios

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 4.0.0 |

### AWS Permissions Required

The AWS credentials used must have permissions to:
- Enable AWS Audit Manager (`auditmanager:*`)
- Create and manage S3 buckets (`s3:*`)
- Create and manage KMS keys (`kms:*`)
- Create and manage IAM roles and policies (`iam:*`)
- Create Audit Manager assessments (`auditmanager:CreateAssessment`)
- (Organization mode) Register delegated administrators (`organizations:RegisterDelegatedAdministrator`)

## Supported AWS Regions

AWS Audit Manager is available in the following regions:

| Region | Region Name |
|--------|-------------|
| us-east-1 | US East (N. Virginia) |
| us-east-2 | US East (Ohio) |
| us-west-1 | US West (N. California) |
| us-west-2 | US West (Oregon) |
| eu-west-1 | Europe (Ireland) |
| eu-west-2 | Europe (London) |
| eu-central-1 | Europe (Frankfurt) |
| ap-southeast-1 | Asia Pacific (Singapore) |
| ap-southeast-2 | Asia Pacific (Sydney) |
| ap-northeast-1 | Asia Pacific (Tokyo) |
| ap-south-1 | Asia Pacific (Mumbai) |
| ca-central-1 | Canada (Central) |

## Usage

### Basic Single Account Deployment

```hcl
module "audit_manager" {
  source = "terraform-aws-modules/audit-manager/aws"

  enable_audit_manager = true
  aws_region          = "us-east-1"

  # Evidence storage configuration
  create_evidence_bucket  = true
  create_kms_key         = true
  evidence_retention_days = 2555  # 7 years

  tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Purpose     = "Compliance"
  }
}
```

### Organization-Wide Deployment

```hcl
module "audit_manager" {
  source = "terraform-aws-modules/audit-manager/aws"

  enable_audit_manager       = true
  organization_mode          = true
  delegated_admin_account_id = "123456789012"
  aws_region                = "us-east-1"

  # Evidence storage in delegated admin account
  create_evidence_bucket  = true
  create_kms_key         = true

  tags = {
    Environment  = "production"
    Organization = "MyOrg"
    ManagedBy    = "Terraform"
  }
}
```

### With Standard Framework Assessment

```hcl
module "audit_manager" {
  source = "terraform-aws-modules/audit-manager/aws"

  enable_audit_manager = true
  aws_region          = "us-east-1"

  # Create CIS Benchmark assessment
  assessments = [
    {
      name         = "cis-aws-foundations-v1.4"
      framework_id = "12345678-1234-1234-1234-123456789012"  # Replace with actual UUID from AWS CLI
      description  = "CIS AWS Foundations Benchmark v1.4.0 assessment"
      scope = {
        aws_accounts = ["123456789012"]
        aws_services = ["ec2", "s3", "iam", "cloudtrail", "config"]
      }
      roles = [
        {
          role_arn  = "arn:aws:iam::123456789012:role/AuditProcessOwner"
          role_type = "PROCESS_OWNER"
        }
      ]
    }
  ]

  tags = {
    Environment = "production"
    Framework   = "CIS"
  }
}
```

### With Custom KMS Key and Bucket

```hcl
module "audit_manager" {
  source = "terraform-aws-modules/audit-manager/aws"

  enable_audit_manager = true
  aws_region          = "us-east-1"

  # Use existing KMS key
  create_kms_key              = false
  evidence_bucket_kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # Custom bucket name
  evidence_bucket_name = "my-audit-evidence-bucket"

  # Custom retention
  evidence_retention_days = 1825  # 5 years

  tags = {
    Environment = "production"
  }
}
```

### Multiple Assessments

```hcl
module "audit_manager" {
  source = "terraform-aws-modules/audit-manager/aws"

  enable_audit_manager = true
  aws_region          = "us-east-1"

  assessments = [
    {
      name         = "cis-benchmark"
      framework_id = "12345678-1234-1234-1234-123456789012"  # Replace with CIS framework UUID
      scope = {
        aws_accounts = ["123456789012"]
        aws_services = ["ec2", "s3", "iam"]
      }
      roles = [
        {
          role_arn  = "arn:aws:iam::123456789012:role/AuditOwner"
          role_type = "PROCESS_OWNER"
        }
      ]
    },
    {
      name         = "pci-dss"
      framework_id = "87654321-4321-4321-4321-210987654321"  # Replace with PCI DSS framework UUID
      scope = {
        aws_accounts = ["123456789012"]
        aws_services = ["ec2", "rds", "s3"]
      }
      roles = [
        {
          role_arn  = "arn:aws:iam::123456789012:role/PCIAuditor"
          role_type = "PROCESS_OWNER"
        }
      ]
    }
  ]
}
```

## Examples

Comprehensive examples are available in the `examples/` directory:

- **[Single Account Deployment](./examples/single-account/)** - Basic single-account setup with assessments
- **[Organization Deployment](./examples/organization/)** - Multi-account organization-wide deployment
- **[Custom Framework Assessment](./examples/custom-framework/)** - Using custom compliance frameworks

Each example includes:
- Complete Terraform configuration
- Variable definitions with defaults
- Output values
- Detailed README with usage instructions

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_audit_manager | Enable AWS Audit Manager in the account | `bool` | `true` | no |
| organization_mode | Enable organization-wide Audit Manager configuration | `bool` | `false` | no |
| delegated_admin_account_id | AWS account ID for delegated administrator (required for organization mode) | `string` | `null` | no |
| aws_region | AWS region for Audit Manager deployment (must support Audit Manager) | `string` | n/a | yes |
| create_evidence_bucket | Whether to create the S3 evidence bucket | `bool` | `true` | no |
| evidence_bucket_name | Custom S3 bucket name for evidence storage | `string` | `null` | no |
| evidence_bucket_prefix | Prefix for generated bucket name | `string` | `"audit-manager-evidence"` | no |
| create_kms_key | Whether to create a KMS key for evidence encryption | `bool` | `false` | no |
| evidence_bucket_kms_key_arn | ARN of existing KMS key for bucket encryption | `string` | `null` | no |
| evidence_retention_days | Days to retain evidence (1-3650) | `number` | `2555` | no |
| enable_bucket_versioning | Enable versioning on evidence bucket | `bool` | `true` | no |
| assessments | List of assessments to create | `list(object)` | `[]` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |
| evidence_bucket_tags | Additional tags for evidence bucket | `map(string)` | `{}` | no |

### Assessment Object Structure

```hcl
{
  name         = string                    # Assessment name
  framework_id = string                    # Framework UUID (use AWS CLI to find)
  description  = optional(string)          # Assessment description
  scope = {
    aws_accounts = list(string)            # Account IDs in scope
    aws_services = list(string)            # Service names in scope
  }
  roles = list({
    role_arn  = string                     # IAM role ARN
    role_type = string                     # "PROCESS_OWNER" or "RESOURCE_OWNER"
  })
  assessment_reports_destination = optional({
    destination      = string              # S3 URI (defaults to evidence bucket)
    destination_type = string              # "S3"
  })
}
```

## Outputs

| Name | Description |
|------|-------------|
| audit_manager_enabled | Whether AWS Audit Manager is enabled |
| audit_manager_service_role_arn | ARN of the IAM service role for Audit Manager |
| evidence_bucket_id | ID of the S3 evidence bucket |
| evidence_bucket_arn | ARN of the S3 evidence bucket |
| evidence_bucket_name | Name of the S3 evidence bucket |
| kms_key_id | ID of the KMS key (if created) |
| kms_key_arn | ARN of the KMS key (if created) |
| assessment_ids | Map of assessment names to IDs |
| assessment_arns | Map of assessment names to ARNs |
| delegated_admin_account_id | Delegated administrator account ID (organization mode) |

## Security Considerations

This module implements AWS security best practices:

### Encryption

- **At Rest**: All evidence stored in S3 is encrypted using AWS KMS (customer-managed or AWS-managed keys)
- **In Transit**: HTTPS/TLS enforced for all S3 access via bucket policy
- **Key Rotation**: KMS key rotation enabled by default for created keys

### Access Control

- **Public Access Prevention**: All S3 public access blocked (4 settings enabled)
- **Least Privilege IAM**: Service roles scoped to minimum required permissions
- **Bucket Policies**: Restrict access to Audit Manager service principal only
- **Condition Keys**: Use aws:SourceAccount to prevent confused deputy attacks

### Data Integrity

- **Versioning**: S3 bucket versioning enabled to protect against accidental deletion
- **Lifecycle Policies**: Automated retention management with configurable periods
- **Audit Logging**: S3 access logging enabled for compliance audit trail

### Compliance

- **Evidence Retention**: Configurable retention periods (default 7 years for common compliance)
- **Immutable Evidence**: Versioning prevents evidence tampering
- **Audit Trail**: Complete logging of all access to evidence

## Finding Framework IDs

**Important**: AWS Audit Manager requires framework UUIDs (not ARNs) when creating assessments. Framework UUIDs are unique identifiers in the format `12345678-1234-1234-1234-123456789012`.

### How to Find Framework UUIDs

```bash
# List all standard AWS frameworks
aws auditmanager list-assessment-frameworks \
  --framework-type Standard \
  --region us-east-1 \
  --query 'frameworkMetadataList[*].[name,id]' \
  --output table

# List custom frameworks
aws auditmanager list-assessment-frameworks \
  --framework-type Custom \
  --region us-east-1 \
  --query 'frameworkMetadataList[*].[name,id]' \
  --output table
```

### Common Standard Frameworks

Below are common framework names. Use the AWS CLI command above to get the actual UUIDs for your region:

#### Security & Best Practices
- CIS AWS Foundations Benchmark v1.2.0
- CIS AWS Foundations Benchmark v1.4.0
- AWS Control Tower

#### Payment Card Industry
- PCI DSS v3.2.1

#### Privacy & Data Protection
- GDPR

#### Healthcare
- HIPAA

#### Service Organization Controls
- SOC 2

#### Government & Federal
- NIST 800-53 Rev. 5
- FedRAMP Moderate

> [!NOTE]
> Framework UUIDs are region-specific and may change. Always use the AWS CLI to get current UUIDs for your region.

## Best Practices

### Evidence Storage

1. **Retention Periods**: Set retention based on your compliance requirements (common: 7 years)
2. **Bucket Naming**: Use descriptive, consistent naming conventions
3. **Encryption**: Always use KMS encryption for sensitive evidence
4. **Backup**: Consider cross-region replication for critical evidence

### Assessment Configuration

1. **Scope Appropriately**: Only include services relevant to your compliance needs
2. **Role Assignment**: Designate clear process and resource owners
3. **Regular Reviews**: Schedule periodic assessment reviews
4. **Automation**: Use Terraform to maintain consistent assessment configurations

### Organization Deployment

1. **Delegated Admin**: Choose a dedicated security/compliance account
2. **Centralized Evidence**: Store all evidence in the delegated admin account
3. **Member Account Prep**: Ensure AWS Config and CloudTrail are enabled in all accounts
4. **Access Control**: Limit access to the delegated admin account

### Cost Optimization

1. **Lifecycle Policies**: Use appropriate retention periods to manage storage costs
2. **Service Scope**: Only audit services that are in use
3. **Assessment Frequency**: Balance compliance needs with cost
4. **Evidence Cleanup**: Regularly review and clean up old evidence

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## Authors

Module is maintained by [Damien Burks](https://github.com/damienjburks). Contributions are welcomed!

## Additional Resources

- [AWS Audit Manager Documentation](https://docs.aws.amazon.com/audit-manager/)
- [AWS Audit Manager User Guide](https://docs.aws.amazon.com/audit-manager/latest/userguide/)
- [AWS Audit Manager API Reference](https://docs.aws.amazon.com/audit-manager/latest/APIReference/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
