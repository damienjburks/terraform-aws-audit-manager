output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = var.create_bucket ? aws_s3_bucket.evidence[0].id : null
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = var.create_bucket ? aws_s3_bucket.evidence[0].arn : null
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = var.create_bucket ? aws_s3_bucket.evidence[0].bucket : null
}
