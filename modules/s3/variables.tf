variable "create_bucket" {
  type        = bool
  description = "Whether to create the S3 bucket"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of KMS key for encryption (null for AWS managed encryption)"
  default     = null
}

variable "enable_versioning" {
  type        = bool
  description = "Enable bucket versioning"
}

variable "retention_days" {
  type        = number
  description = "Number of days to retain evidence"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
