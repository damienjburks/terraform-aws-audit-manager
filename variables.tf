# Input variable declarations

################################################################################
# Core Configuration Variables
################################################################################

variable "enable_audit_manager" {
  type        = bool
  description = "Enable AWS Audit Manager in the account. When true, the module will configure Audit Manager and create necessary resources."
  default     = true
}

variable "organization_mode" {
  type        = bool
  description = "Enable organization-wide Audit Manager configuration. When true, the module will register a delegated administrator and configure multi-account evidence collection."
  default     = false
}

variable "delegated_admin_account_id" {
  type        = string
  description = "AWS account ID to designate as the delegated administrator for Audit Manager in organization mode. Required when organization_mode is true."
  default     = null

  validation {
    condition     = var.delegated_admin_account_id == null || can(regex("^[0-9]{12}$", var.delegated_admin_account_id))
    error_message = "Delegated admin account ID must be a 12-digit number. Example: 123456789012"
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region where Audit Manager will be deployed. Must be a region that supports AWS Audit Manager."

  validation {
    condition = contains([
      "us-east-1", "us-east-2", "us-west-1", "us-west-2",
      "eu-west-1", "eu-west-2", "eu-central-1",
      "ap-southeast-1", "ap-southeast-2", "ap-northeast-1", "ap-south-1",
      "ca-central-1"
    ], var.aws_region)
    error_message = "AWS region must be one that supports Audit Manager. Supported regions: us-east-1, us-east-2, us-west-1, us-west-2, eu-west-1, eu-west-2, eu-central-1, ap-southeast-1, ap-southeast-2, ap-northeast-1, ap-south-1, ca-central-1"
  }
}

################################################################################
# Evidence Storage Configuration Variables
################################################################################

variable "evidence_bucket_name" {
  type        = string
  description = "Custom S3 bucket name for evidence storage. If not provided, a bucket name will be generated using the evidence_bucket_prefix. Must follow AWS S3 naming rules: 3-63 characters, lowercase letters, numbers, and hyphens only."
  default     = null

  validation {
    condition     = var.evidence_bucket_name == null || can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.evidence_bucket_name))
    error_message = "Bucket name must be 3-63 characters, lowercase letters, numbers, and hyphens only. Must start and end with a letter or number. Example: my-audit-evidence-bucket"
  }
}

variable "evidence_bucket_prefix" {
  type        = string
  description = "Prefix used to generate the evidence bucket name when evidence_bucket_name is not specified. The final bucket name will be: {prefix}-{account_id}-{region}"
  default     = "audit-manager-evidence"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.evidence_bucket_prefix))
    error_message = "Bucket prefix must contain only lowercase letters, numbers, and hyphens. Must start and end with a letter or number."
  }
}

variable "create_evidence_bucket" {
  type        = bool
  description = "Whether to create the S3 evidence bucket. Set to false if using an existing bucket."
  default     = true
}

variable "evidence_bucket_kms_key_arn" {
  type        = string
  description = "ARN of an existing KMS key to use for evidence bucket encryption. If not provided and create_kms_key is false, AWS managed encryption will be used."
  default     = null

  validation {
    condition     = var.evidence_bucket_kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.evidence_bucket_kms_key_arn))
    error_message = "KMS key ARN must be a valid AWS KMS key ARN. Example: arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
  }
}

variable "create_kms_key" {
  type        = bool
  description = "Whether to create a new KMS key for evidence bucket encryption. If false and evidence_bucket_kms_key_arn is not provided, AWS managed encryption will be used."
  default     = false
}

variable "evidence_retention_days" {
  type        = number
  description = "Number of days to retain evidence in the S3 bucket before automatic deletion. Default is 2555 days (7 years) to meet common compliance requirements."
  default     = 2555

  validation {
    condition     = var.evidence_retention_days > 0 && var.evidence_retention_days <= 3650
    error_message = "Evidence retention days must be between 1 and 3650 (10 years). Common values: 2555 (7 years), 1825 (5 years), 365 (1 year)."
  }
}

variable "enable_bucket_versioning" {
  type        = bool
  description = "Enable versioning on the evidence S3 bucket to protect against accidental deletion and maintain evidence integrity."
  default     = true
}

################################################################################
# Assessment Configuration Variables
################################################################################

variable "assessments" {
  type = list(object({
    name         = string
    framework_id = string
    description  = optional(string)
    scope = object({
      aws_accounts = list(string)
      aws_services = list(string)
    })
    roles = list(object({
      role_arn  = string
      role_type = string
    }))
    assessment_reports_destination = optional(object({
      destination      = string
      destination_type = string
    }))
  }))
  description = "List of assessments to create in Audit Manager. Each assessment requires a name, framework UUID (not ARN - use 'aws auditmanager list-assessment-frameworks' to find UUIDs), scope (accounts and services), and assigned roles."
  default     = []

  validation {
    condition = alltrue([
      for assessment in var.assessments :
      can(regex("^[a-zA-Z0-9-_]+$", assessment.name))
    ])
    error_message = "Assessment names must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition = alltrue([
      for assessment in var.assessments :
      alltrue([
        for account_id in assessment.scope.aws_accounts :
        can(regex("^[0-9]{12}$", account_id))
      ])
    ])
    error_message = "All AWS account IDs in assessment scopes must be 12-digit numbers."
  }

  validation {
    condition = alltrue([
      for assessment in var.assessments :
      alltrue([
        for role in assessment.roles :
        can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", role.role_arn))
      ])
    ])
    error_message = "All role ARNs must be valid IAM role ARNs. Example: arn:aws:iam::123456789012:role/AuditManagerRole"
  }

  validation {
    condition = alltrue([
      for assessment in var.assessments :
      alltrue([
        for role in assessment.roles :
        contains(["PROCESS_OWNER", "RESOURCE_OWNER"], role.role_type)
      ])
    ])
    error_message = "Role types must be either 'PROCESS_OWNER' or 'RESOURCE_OWNER'."
  }
}

################################################################################
# Tagging and Metadata Variables
################################################################################

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources created by this module. Tags help with resource organization, cost allocation, and compliance tracking."
  default     = {}
}

variable "evidence_bucket_tags" {
  type        = map(string)
  description = "Additional tags to apply specifically to the evidence S3 bucket. These tags will be merged with the common tags."
  default     = {}
}
