# IAM Module for AWS Audit Manager

################################################################################
# IAM Service Role for Audit Manager
################################################################################

resource "aws_iam_role" "audit_manager" {
  count = var.create_role ? 1 : 0

  name        = "AWSAuditManagerServiceRole-${var.account_id}"
  description = "Service role for AWS Audit Manager to collect evidence"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "auditmanager.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
          }
        }
      }
    ]
  })

  tags = var.tags
}

################################################################################
# IAM Policy for S3 Evidence Bucket Access
################################################################################

resource "aws_iam_policy" "audit_manager_s3" {
  count = var.create_role && var.bucket_arn != null ? 1 : 0

  name        = "AWSAuditManagerS3Access-${var.account_id}"
  description = "Policy allowing AWS Audit Manager to write evidence to S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          var.bucket_arn,
          "${var.bucket_arn}/*"
        ]
      },
      {
        Sid    = "AllowKMSAccess"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = var.kms_key_arn != null ? [var.kms_key_arn] : []
      }
    ]
  })

  tags = var.tags
}

################################################################################
# Attach S3 Policy to Service Role
################################################################################

resource "aws_iam_role_policy_attachment" "audit_manager_s3" {
  count = var.create_role && var.bucket_arn != null ? 1 : 0

  role       = aws_iam_role.audit_manager[0].name
  policy_arn = aws_iam_policy.audit_manager_s3[0].arn
}
