# Output value declarations

################################################################################
# Audit Manager Status Outputs
################################################################################

output "audit_manager_enabled" {
  description = "Whether AWS Audit Manager is enabled in the account"
  value       = var.enable_audit_manager
}

output "audit_manager_service_role_arn" {
  description = "ARN of the IAM service role for AWS Audit Manager"
  value       = module.iam.role_arn
}

################################################################################
# Evidence Bucket Outputs
################################################################################

output "evidence_bucket_id" {
  description = "ID of the S3 bucket used for evidence storage"
  value       = module.s3.bucket_id
}

output "evidence_bucket_arn" {
  description = "ARN of the S3 bucket used for evidence storage"
  value       = module.s3.bucket_arn
}

output "evidence_bucket_name" {
  description = "Name of the S3 bucket used for evidence storage"
  value       = module.s3.bucket_name
}

################################################################################
# KMS Key Outputs
################################################################################

output "kms_key_id" {
  description = "ID of the KMS key used for evidence bucket encryption (if created)"
  value       = module.kms.key_id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for evidence bucket encryption (if created)"
  value       = module.kms.key_arn
}

################################################################################
# Assessment Outputs
################################################################################

output "assessment_ids" {
  description = "Map of assessment names to their IDs"
  value       = module.assessments.assessment_ids
}

output "assessment_arns" {
  description = "Map of assessment names to ARNs"
  value       = module.assessments.assessment_arns
}

################################################################################
# Organization Mode Outputs
################################################################################

output "delegated_admin_account_id" {
  description = "AWS account ID of the delegated administrator for Audit Manager in organization mode"
  value       = local.enable_organization_mode ? var.delegated_admin_account_id : null
}
