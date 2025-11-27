output "key_id" {
  description = "ID of the KMS key"
  value       = var.create_key ? aws_kms_key.evidence[0].key_id : null
}

output "key_arn" {
  description = "ARN of the KMS key"
  value       = var.create_key ? aws_kms_key.evidence[0].arn : null
}
