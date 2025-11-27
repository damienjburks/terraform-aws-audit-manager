# Variables for Organization Example

variable "aws_region" {
  type        = string
  description = "AWS region for Audit Manager deployment"
  default     = "us-east-1"
}

variable "delegated_admin_account_id" {
  type        = string
  description = "AWS account ID to designate as delegated administrator for Audit Manager"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.delegated_admin_account_id))
    error_message = "Delegated admin account ID must be a 12-digit number."
  }
}

variable "evidence_bucket_prefix" {
  type        = string
  description = "Prefix for the evidence bucket name"
  default     = "org-audit-manager-evidence"
}

variable "create_kms_key" {
  type        = bool
  description = "Whether to create a KMS key for evidence encryption"
  default     = true
}

variable "evidence_retention_days" {
  type        = number
  description = "Number of days to retain evidence"
  default     = 2555 # 7 years
}

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
  description = "List of organization-wide assessments to create"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Purpose     = "OrganizationAuditManager"
  }
}
