# Local value computations

################################################################################
# Supported Regions
################################################################################

locals {
  # List of AWS regions that support Audit Manager
  supported_audit_manager_regions = [
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",
    "eu-west-1",
    "eu-west-2",
    "eu-central-1",
    "ap-southeast-1",
    "ap-southeast-2",
    "ap-northeast-1",
    "ap-south-1",
    "ca-central-1"
  ]
}

################################################################################
# Resource Naming
################################################################################

locals {
  # Generate evidence bucket name: use custom name if provided, otherwise generate from prefix
  evidence_bucket_name = var.evidence_bucket_name != null ? var.evidence_bucket_name : "${var.evidence_bucket_prefix}-${data.aws_caller_identity.current.account_id}-${var.aws_region}"

  # KMS key alias for evidence bucket encryption
  kms_key_alias = "alias/audit-manager-evidence-${data.aws_caller_identity.current.account_id}"
}

################################################################################
# Conditional Resource Creation Flags
################################################################################

locals {
  # Create evidence bucket only if enabled and Audit Manager is enabled
  create_evidence_bucket = var.enable_audit_manager && var.create_evidence_bucket

  # Create KMS key only if enabled and Audit Manager is enabled
  create_kms_key = var.enable_audit_manager && var.create_kms_key

  # Enable organization mode only if Audit Manager is enabled and organization_mode is true
  enable_organization_mode = var.enable_audit_manager && var.organization_mode

  # Create assessments only if Audit Manager is enabled and assessments list is not empty
  create_assessments = var.enable_audit_manager && length(var.assessments) > 0
}
