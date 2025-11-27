# Outputs for Custom Framework Example

output "audit_manager_enabled" {
  description = "Whether AWS Audit Manager is enabled"
  value       = module.audit_manager.audit_manager_enabled
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
  description = "Map of custom framework assessment names to IDs"
  value       = module.audit_manager.assessment_ids
}

output "assessment_arns" {
  description = "Map of custom framework assessment names to ARNs"
  value       = module.audit_manager.assessment_arns
}
