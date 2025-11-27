# Single Account AWS Audit Manager Example

This example demonstrates how to deploy AWS Audit Manager in a single AWS account using the terraform-aws-audit-manager module.

## Overview

This configuration will:
- Enable AWS Audit Manager in your AWS account
- Create an S3 bucket for evidence storage with encryption
- Create a KMS key for evidence encryption
- Set up IAM roles and policies for Audit Manager
- Optionally create assessments based on standard frameworks

## Prerequisites

- AWS account with appropriate permissions
- Terraform >= 1.0.0
- AWS Provider >= 4.0.0
- AWS region that supports Audit Manager (see supported regions in main module README)

## Required Permissions

The AWS credentials used must have permissions to:
- Enable AWS Audit Manager
- Create S3 buckets and configure bucket policies
- Create KMS keys and key policies
- Create IAM roles and policies
- Create Audit Manager assessments

## Usage

### Basic Deployment

1. Initialize Terraform:
```bash
terraform init
```

2. Review the planned changes:
```bash
terraform plan
```

3. Apply the configuration:
```bash
terraform apply
```

### With Assessments

To create assessments, you need to provide the framework UUID (not ARN). First, find the framework UUID:

```bash
# List available frameworks and their UUIDs
aws auditmanager list-assessment-frameworks \
  --framework-type Standard \
  --region us-east-1 \
  --query 'frameworkMetadataList[*].[name,id]' \
  --output table
```

Then provide the `assessments` variable with the UUID:

```hcl
assessments = [
  {
    name         = "cis-aws-foundations"
    framework_id = "12345678-1234-1234-1234-123456789012"  # Replace with actual UUID from AWS CLI
    description  = "CIS AWS Foundations Benchmark assessment"
    scope = {
      aws_accounts = ["123456789012"] # Your AWS account ID
      aws_services = ["ec2", "s3", "iam", "cloudtrail"]
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

You can customize the deployment by modifying the variables:

```hcl
# terraform.tfvars
aws_region              = "us-east-1"
evidence_bucket_prefix  = "my-audit-evidence"
create_kms_key          = true
evidence_retention_days = 2555

tags = {
  Environment = "production"
  Team        = "security"
  CostCenter  = "compliance"
}
```

## Finding Framework UUIDs

**Important**: You must use framework UUIDs (not ARNs) when creating assessments.

Use the AWS CLI to find framework UUIDs:

```bash
aws auditmanager list-assessment-frameworks \
  --framework-type Standard \
  --region us-east-1 \
  --query 'frameworkMetadataList[*].[name,id]' \
  --output table
```

Common framework names to look for:
- CIS AWS Foundations Benchmark v1.2.0
- CIS AWS Foundations Benchmark v1.4.0
- PCI DSS v3.2.1
- GDPR
- HIPAA
- SOC 2

## Outputs

After deployment, the following outputs will be available:

- `audit_manager_enabled`: Confirmation that Audit Manager is enabled
- `evidence_bucket_name`: Name of the S3 bucket storing evidence
- `evidence_bucket_arn`: ARN of the evidence bucket
- `kms_key_arn`: ARN of the KMS key used for encryption
- `service_role_arn`: ARN of the IAM service role for Audit Manager
- `assessment_ids`: Map of assessment names to their IDs

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note**: The evidence bucket may contain data. Ensure you have backed up any necessary evidence before destroying resources.

## Security Considerations

- Evidence bucket has encryption enabled by default
- Public access to the evidence bucket is blocked
- Bucket versioning is enabled to protect against accidental deletion
- KMS key rotation is enabled
- IAM policies follow the principle of least privilege
- Secure transport (HTTPS) is enforced for S3 access

## Cost Considerations

This deployment will incur costs for:
- S3 storage for evidence
- KMS key (if created)
- AWS Audit Manager service charges
- Data transfer costs

Refer to AWS pricing documentation for current rates.
