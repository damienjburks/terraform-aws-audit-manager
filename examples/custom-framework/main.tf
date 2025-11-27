# Custom Framework AWS Audit Manager Example

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

################################################################################
# AWS Audit Manager Module - Custom Framework Configuration
################################################################################

module "audit_manager" {
  source = "../.."

  # Core configuration
  enable_audit_manager = true
  organization_mode    = false
  aws_region           = var.aws_region

  # Evidence storage configuration
  create_evidence_bucket   = true
  evidence_bucket_prefix   = var.evidence_bucket_prefix
  create_kms_key           = true
  evidence_retention_days  = var.evidence_retention_days
  enable_bucket_versioning = true

  # Custom framework assessments
  assessments = var.assessments

  # Tags
  tags = var.tags
}
