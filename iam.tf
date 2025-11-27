# IAM Resources for AWS Audit Manager

################################################################################
# IAM Service Role for Audit Manager
################################################################################

resource "aws_iam_role" "audit_manager" {
  count = var.enable_audit_manager ? 1 : 0

  name        = "AWSAuditManagerServiceRole-${data.aws_caller_identity.current.account_id}"
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
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name      = "AWSAuditManagerServiceRole"
      Purpose   = "AWS Audit Manager Service Role"
      ManagedBy = "Terraform"
    }
  )
}

################################################################################
# IAM Policy for S3 Evidence Bucket Access
################################################################################

resource "aws_iam_policy" "audit_manager_s3" {
  count = var.enable_audit_manager && local.create_evidence_bucket ? 1 : 0

  name        = "AWSAuditManagerS3Access-${data.aws_caller_identity.current.account_id}"
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
          aws_s3_bucket.evidence[0].arn,
          "${aws_s3_bucket.evidence[0].arn}/*"
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
        Resource = local.create_kms_key ? [aws_kms_key.evidence[0].arn] : (
          var.evidence_bucket_kms_key_arn != null ? [var.evidence_bucket_kms_key_arn] : []
        )
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name      = "AWSAuditManagerS3Access"
      Purpose   = "AWS Audit Manager S3 Access Policy"
      ManagedBy = "Terraform"
    }
  )
}

################################################################################
# Attach S3 Policy to Service Role
################################################################################

resource "aws_iam_role_policy_attachment" "audit_manager_s3" {
  count = var.enable_audit_manager && local.create_evidence_bucket ? 1 : 0

  role       = aws_iam_role.audit_manager[0].name
  policy_arn = aws_iam_policy.audit_manager_s3[0].arn
}

################################################################################
# S3 Bucket Policy for Audit Manager Access
################################################################################

resource "aws_s3_bucket_policy" "evidence" {
  count = local.create_evidence_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSAuditManagerWriteAccess"
        Effect = "Allow"
        Principal = {
          Service = "auditmanager.amazonaws.com"
        }
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.evidence[0].arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid    = "AWSAuditManagerReadAccess"
        Effect = "Allow"
        Principal = {
          Service = "auditmanager.amazonaws.com"
        }
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.evidence[0].arn,
          "${aws_s3_bucket.evidence[0].arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.evidence[0].arn,
          "${aws_s3_bucket.evidence[0].arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
