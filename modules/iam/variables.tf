variable "create_role" {
  type        = bool
  description = "Whether to create the IAM role"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "bucket_arn" {
  type        = string
  description = "ARN of the S3 evidence bucket"
  default     = null
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
