# Outputs for Organization Example

output "audit_manager_enabled" {
  description = "Whether AWS Audit Manager is enabled"
  value       = module.audit_manager.audit_manager_enabled
}

output "delegated_admin_account_id" {
  description = "AWS account ID of the delegated administrator"
  value       = module.audit_manager.delegated_admin_account_id
}

output "evidence_bucket_name" {
  description = "Name of the evidence S3 bucket"
  value       = module.audit_manager.evidence_bucket_name
}

output "evidence_bucket_arn" {
  description = "ARN of the evidence S3 bucket"
  value       = module.audit_manager.evidence_bucket_arn
}

output "kms_key_arn" {
  description = "ARN of the KMS key for evidence encryption"
  value       = module.audit_manager.kms_key_arn
}

output "service_role_arn" {
  description = "ARN of the Audit Manager service role"
  value       = module.audit_manager.audit_manager_service_role_arn
}

output "assessment_ids" {
  description = "Map of assessment names to IDs"
  value       = module.audit_manager.assessment_ids
}

output "assessment_arns" {
  description = "Map of assessment names to ARNs"
  value       = module.audit_manager.assessment_arns
}
