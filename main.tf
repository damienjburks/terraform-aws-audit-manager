# Main Terraform configuration for AWS Audit Manager

################################################################################
# KMS Module - Evidence Bucket Encryption
################################################################################

module "kms" {
  source = "./modules/kms"

  create_key = local.create_kms_key
  account_id = data.aws_caller_identity.current.account_id
  region     = var.aws_region
  key_alias  = local.kms_key_alias

  tags = merge(
    var.tags,
    {
      Name      = "audit-manager-evidence-key"
      Purpose   = "AWS Audit Manager Evidence Encryption"
      ManagedBy = "Terraform"
    }
  )
}

################################################################################
# S3 Module - Evidence Bucket
################################################################################

module "s3" {
  source = "./modules/s3"

  create_bucket     = local.create_evidence_bucket
  bucket_name       = local.evidence_bucket_name
  kms_key_arn       = var.evidence_bucket_kms_key_arn != null ? var.evidence_bucket_kms_key_arn : module.kms.key_arn
  enable_versioning = var.enable_bucket_versioning
  retention_days    = var.evidence_retention_days
  account_id        = data.aws_caller_identity.current.account_id

  tags = merge(
    var.tags,
    var.evidence_bucket_tags,
    {
      Name        = local.evidence_bucket_name
      Purpose     = "AWS Audit Manager Evidence Storage"
      ManagedBy   = "Terraform"
      Environment = "audit"
    }
  )

  depends_on = [module.kms]
}

################################################################################
# IAM Module - Service Role and Policies
################################################################################

module "iam" {
  source = "./modules/iam"

  create_role          = var.enable_audit_manager
  create_bucket_policy = local.create_evidence_bucket
  account_id           = data.aws_caller_identity.current.account_id
  bucket_arn           = module.s3.bucket_arn
  kms_key_arn          = var.evidence_bucket_kms_key_arn != null ? var.evidence_bucket_kms_key_arn : module.kms.key_arn

  tags = merge(
    var.tags,
    {
      Name      = "AWSAuditManagerServiceRole"
      Purpose   = "AWS Audit Manager Service Role"
      ManagedBy = "Terraform"
    }
  )

  depends_on = [module.s3]
}

################################################################################
# AWS Audit Manager Account Registration
################################################################################

resource "aws_auditmanager_account_registration" "main" {
  count = var.enable_audit_manager ? 1 : 0

  depends_on = [
    module.s3,
    module.iam
  ]
}

################################################################################
# AWS Audit Manager Organization Admin Account
################################################################################

resource "aws_auditmanager_organization_admin_account_registration" "main" {
  count = local.enable_organization_mode ? 1 : 0

  admin_account_id = var.delegated_admin_account_id

  depends_on = [
    aws_auditmanager_account_registration.main
  ]
}

################################################################################
# Assessments Module
################################################################################

module "assessments" {
  source = "./modules/assessments"

  create_assessments     = local.create_assessments
  assessments            = var.assessments
  evidence_bucket_name   = local.evidence_bucket_name
  audit_manager_enabled  = aws_auditmanager_account_registration.main
  tags                   = var.tags

  depends_on = [
    aws_auditmanager_account_registration.main,
    module.s3
  ]
}
