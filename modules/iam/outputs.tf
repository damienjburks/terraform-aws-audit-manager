output "role_arn" {
  description = "ARN of the IAM service role"
  value       = var.create_role ? aws_iam_role.audit_manager[0].arn : null
}

output "role_name" {
  description = "Name of the IAM service role"
  value       = var.create_role ? aws_iam_role.audit_manager[0].name : null
}
