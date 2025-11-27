# Organization-Wide AWS Audit Manager Example

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
# AWS Audit Manager Module - Organization Configuration
################################################################################

module "audit_manager" {
  source = "../.."

  # Core configuration - Organization mode
  enable_audit_manager       = true
  organization_mode          = true
  delegated_admin_account_id = var.delegated_admin_account_id
  aws_region                 = var.aws_region

  # Evidence storage configuration
  create_evidence_bucket   = true
  evidence_bucket_prefix   = var.evidence_bucket_prefix
  create_kms_key           = var.create_kms_key
  evidence_retention_days  = var.evidence_retention_days
  enable_bucket_versioning = true

  # Assessment configuration for organization-wide assessments
  assessments = var.assessments

  # Tags
  tags = var.tags
}
