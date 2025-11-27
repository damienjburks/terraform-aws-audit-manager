# Custom Framework AWS Audit Manager Example

This example demonstrates how to use AWS Audit Manager with custom frameworks using the terraform-aws-audit-manager module.

## Overview

This configuration will:
- Enable AWS Audit Manager in your AWS account
- Create an S3 bucket for evidence storage with encryption
- Create a KMS key for evidence encryption
- Set up IAM roles and policies for Audit Manager
- Create assessments using custom frameworks that you define

## What are Custom Frameworks?

Custom frameworks allow you to:
- Define your own compliance requirements and controls
- Combine controls from multiple standard frameworks
- Create organization-specific audit requirements
- Tailor evidence collection to your specific needs

## Prerequisites

- AWS account with appropriate permissions
- Terraform >= 1.0.0
- AWS Provider >= 4.0.0
- A custom framework already created in AWS Audit Manager
- AWS region that supports Audit Manager

## Creating a Custom Framework

Before using this example, you need to create a custom framework in AWS Audit Manager:

### Option 1: Using AWS Console

1. Navigate to AWS Audit Manager in the AWS Console
2. Go to "Framework library" → "Custom frameworks"
3. Click "Create custom framework"
4. Define your control sets and controls
5. Save the framework and note its ARN

### Option 2: Using Terraform

You can create a custom framework using the `aws_auditmanager_framework` resource:

```hcl
resource "aws_auditmanager_framework" "custom" {
  name = "my-custom-framework"
  description = "Custom compliance framework for my organization"

  control_sets {
    name = "Security Controls"
    
    controls {
      id = "arn:aws:auditmanager:us-east-1:aws:control/AWS-Config-Enabled"
    }
    
    controls {
      id = "arn:aws:auditmanager:us-east-1:aws:control/CloudTrail-Enabled"
    }
  }

  control_sets {
    name = "Data Protection"
    
    controls {
      id = "arn:aws:auditmanager:us-east-1:aws:control/S3-Bucket-Encryption"
    }
  }
}
```

## Usage

### Step 1: Create Your Custom Framework

First, create your custom framework (see above) and obtain its ARN.

### Step 2: Configure the Assessment

Create a `terraform.tfvars` file with your custom framework configuration:

```hcl
aws_region = "us-east-1"

assessments = [
  {
    name         = "my-custom-assessment"
    framework_id = "arn:aws:auditmanager:us-east-1:123456789012:framework/abc123-def456-ghi789"
    description  = "Assessment using my organization's custom framework"
    scope = {
      aws_accounts = ["123456789012"]
      aws_services = [
        "s3",
        "ec2",
        "rds",
        "lambda",
        "dynamodb"
      ]
    }
    roles = [
      {
        role_arn  = "arn:aws:iam::123456789012:role/AuditOwner"
        role_type = "PROCESS_OWNER"
      },
      {
        role_arn  = "arn:aws:iam::123456789012:role/ResourceOwner"
        role_type = "RESOURCE_OWNER"
      }
    ]
  }
]

tags = {
  Environment = "production"
  Framework   = "custom"
  Owner       = "security-team"
}
```

### Step 3: Deploy

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

## Example Custom Framework Scenarios

### Scenario 1: Combining Multiple Standard Controls

Create a framework that combines controls from CIS, PCI DSS, and GDPR:

```hcl
resource "aws_auditmanager_framework" "hybrid" {
  name = "hybrid-compliance-framework"
  
  control_sets {
    name = "CIS Critical Controls"
    controls {
      id = "arn:aws:auditmanager:us-east-1:aws:control/CIS-1.1"
    }
  }
  
  control_sets {
    name = "PCI DSS Requirements"
    controls {
      id = "arn:aws:auditmanager:us-east-1:aws:control/PCI-DSS-2.1"
    }
  }
  
  control_sets {
    name = "GDPR Requirements"
    controls {
      id = "arn:aws:auditmanager:us-east-1:aws:control/GDPR-Article-32"
    }
  }
}
```

### Scenario 2: Organization-Specific Requirements

Create a framework for your organization's specific requirements:

```hcl
resource "aws_auditmanager_framework" "org_specific" {
  name = "acme-corp-security-framework"
  
  control_sets {
    name = "ACME Data Classification"
    # Add custom controls specific to your data classification policy
  }
  
  control_sets {
    name = "ACME Access Management"
    # Add custom controls for your access management requirements
  }
}
```

### Scenario 3: Industry-Specific Compliance

Create a framework tailored to your industry:

```hcl
resource "aws_auditmanager_framework" "fintech" {
  name = "fintech-compliance-framework"
  
  control_sets {
    name = "Financial Data Protection"
    # Controls specific to financial services
  }
  
  control_sets {
    name = "Transaction Monitoring"
    # Controls for transaction audit trails
  }
}
```

## Multiple Custom Assessments

You can create multiple assessments with different custom frameworks:

```hcl
assessments = [
  {
    name         = "security-assessment"
    framework_id = "arn:aws:auditmanager:us-east-1:123456789012:framework/security-framework-id"
    description  = "Security-focused assessment"
    scope = {
      aws_accounts = ["123456789012"]
      aws_services = ["iam", "kms", "guardduty", "securityhub"]
    }
    roles = [
      {
        role_arn  = "arn:aws:iam::123456789012:role/SecurityAuditor"
        role_type = "PROCESS_OWNER"
      }
    ]
  },
  {
    name         = "data-protection-assessment"
    framework_id = "arn:aws:auditmanager:us-east-1:123456789012:framework/data-protection-id"
    description  = "Data protection and privacy assessment"
    scope = {
      aws_accounts = ["123456789012"]
      aws_services = ["s3", "rds", "dynamodb", "kms"]
    }
    roles = [
      {
        role_arn  = "arn:aws:iam::123456789012:role/DataProtectionOfficer"
        role_type = "PROCESS_OWNER"
      }
    ]
  }
]
```

## Custom Report Destinations

You can specify custom destinations for assessment reports:

```hcl
assessments = [
  {
    name         = "custom-assessment"
    framework_id = "arn:aws:auditmanager:us-east-1:123456789012:framework/custom-id"
    scope = {
      aws_accounts = ["123456789012"]
      aws_services = ["s3", "ec2"]
    }
    roles = [
      {
        role_arn  = "arn:aws:iam::123456789012:role/AuditOwner"
        role_type = "PROCESS_OWNER"
      }
    ]
    assessment_reports_destination = {
      destination      = "s3://my-audit-reports-bucket"
      destination_type = "S3"
    }
  }
]
```

## Outputs

After deployment, the following outputs will be available:

- `audit_manager_enabled`: Confirmation that Audit Manager is enabled
- `evidence_bucket_name`: Name of the S3 bucket storing evidence
- `evidence_bucket_arn`: ARN of the evidence bucket
- `kms_key_arn`: ARN of the KMS key used for encryption
- `service_role_arn`: ARN of the IAM service role for Audit Manager
- `assessment_ids`: Map of assessment names to their IDs
- `assessment_arns`: Map of assessment names to their ARNs

## Best Practices

### Framework Design

1. **Start Simple**: Begin with a small set of controls and expand over time
2. **Reuse Standard Controls**: Leverage existing AWS controls when possible
3. **Document Requirements**: Clearly document why each control is included
4. **Version Control**: Track changes to your framework definitions in Git

### Assessment Configuration

1. **Scope Appropriately**: Only include services that are relevant to your controls
2. **Assign Clear Roles**: Designate specific individuals as process and resource owners
3. **Regular Reviews**: Schedule periodic reviews of assessment results
4. **Automate Remediation**: Use assessment findings to trigger automated remediation

### Evidence Management

1. **Retention Policies**: Set appropriate retention periods based on compliance requirements
2. **Access Control**: Limit access to evidence to authorized personnel only
3. **Backup Strategy**: Implement backups for critical evidence
4. **Audit Trails**: Enable logging for all access to evidence

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note**: This will not delete your custom framework definition, only the assessment and infrastructure resources.

## Troubleshooting

### Framework Not Found

- Verify the framework ARN is correct
- Ensure the framework exists in the same region
- Check that you have permissions to access the framework

### Assessment Creation Fails

- Verify all specified services are valid AWS service names
- Check that IAM roles exist and have correct trust relationships
- Ensure account IDs in scope are valid

### Evidence Collection Issues

- Verify AWS Config is enabled for the services in scope
- Check that CloudTrail is enabled
- Ensure the service role has necessary permissions

## Additional Resources

- [AWS Audit Manager Custom Frameworks Documentation](https://docs.aws.amazon.com/audit-manager/latest/userguide/custom-frameworks.html)
- [AWS Audit Manager Control Library](https://docs.aws.amazon.com/audit-manager/latest/userguide/control-library.html)
- [Creating Custom Controls](https://docs.aws.amazon.com/audit-manager/latest/userguide/create-controls.html)

## Cost Considerations

Custom framework assessments incur the same costs as standard framework assessments:
- S3 storage for evidence
- KMS key usage
- AWS Audit Manager service charges
- Data transfer costs

The number of controls in your custom framework may affect evidence collection volume and storage costs.
