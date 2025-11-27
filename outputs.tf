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
  value       = var.enable_audit_manager ? aws_iam_role.audit_manager[0].arn : null
}

################################################################################
# Evidence Bucket Outputs
################################################################################

output "evidence_bucket_id" {
  description = "ID of the S3 bucket used for evidence storage"
  value       = local.create_evidence_bucket ? aws_s3_bucket.evidence[0].id : null
}

output "evidence_bucket_arn" {
  description = "ARN of the S3 bucket used for evidence storage"
  value       = local.create_evidence_bucket ? aws_s3_bucket.evidence[0].arn : null
}

output "evidence_bucket_name" {
  description = "Name of the S3 bucket used for evidence storage"
  value       = local.create_evidence_bucket ? aws_s3_bucket.evidence[0].bucket : null
}

################################################################################
# KMS Key Outputs
################################################################################

output "kms_key_id" {
  description = "ID of the KMS key used for evidence bucket encryption (if created)"
  value       = local.create_kms_key ? aws_kms_key.evidence[0].key_id : null
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for evidence bucket encryption (if created)"
  value       = local.create_kms_key ? aws_kms_key.evidence[0].arn : null
}

################################################################################
# Assessment Outputs
################################################################################

output "assessment_ids" {
  description = "Map of assessment names to their IDs"
  value = local.create_assessments ? {
    for name, assessment in aws_auditmanager_assessment.main : name => assessment.id
  } : {}
}

output "assessment_arns" {
  description = "Map of assessment names to their ARNs"
  value = local.create_assessments ? {
    for name, assessment in aws_auditmanager_assessment.main : name => assessment.arn
  } : {}
}

################################################################################
# Organization Mode Outputs
################################################################################

output "delegated_admin_account_id" {
  description = "AWS account ID of the delegated administrator for Audit Manager in organization mode"
  value       = local.enable_organization_mode ? var.delegated_admin_account_id : null
}
