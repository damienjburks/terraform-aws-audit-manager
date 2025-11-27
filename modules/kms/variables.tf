variable "create_key" {
  type        = bool
  description = "Whether to create the KMS key"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "key_alias" {
  type        = string
  description = "Alias for the KMS key"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
