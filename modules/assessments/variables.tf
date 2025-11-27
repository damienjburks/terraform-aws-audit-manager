variable "create_assessments" {
  type        = bool
  description = "Whether to create assessments"
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
}

variable "evidence_bucket_name" {
  type        = string
  description = "Name of the evidence bucket for default reports destination"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "audit_manager_enabled" {
  description = "Dependency to ensure Audit Manager is enabled"
  default     = null
}
