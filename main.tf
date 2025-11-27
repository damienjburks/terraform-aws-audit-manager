# Main resource definitions for AWS Audit Manager module

################################################################################
# AWS Audit Manager Account Registration
################################################################################

resource "aws_auditmanager_account_registration" "main" {
  count = var.enable_audit_manager ? 1 : 0

  # Ensure bucket and IAM resources are created first
  depends_on = [
    aws_s3_bucket.evidence,
    aws_s3_bucket_policy.evidence,
    aws_iam_role.audit_manager,
    aws_iam_role_policy_attachment.audit_manager_s3
  ]
}


################################################################################
# AWS Audit Manager Organization Admin Account
################################################################################

resource "aws_auditmanager_organization_admin_account_registration" "main" {
  count = local.enable_organization_mode ? 1 : 0

  admin_account_id = var.delegated_admin_account_id

  # Ensure Audit Manager is enabled first
  depends_on = [
    aws_auditmanager_account_registration.main
  ]
}
