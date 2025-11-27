# Variables for Single Account Example

variable "aws_region" {
  type        = string
  description = "AWS region for Audit Manager deployment"
  default     = "us-east-1"
}

variable "evidence_bucket_prefix" {
  type        = string
  description = "Prefix for the evidence bucket name"
  default     = "audit-manager-evidence"
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
  description = "List of assessments to create"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Purpose     = "AuditManager"
  }
}
