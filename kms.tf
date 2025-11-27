# KMS Key Resources for Evidence Bucket Encryption

################################################################################
# KMS Key for Evidence Bucket
################################################################################

resource "aws_kms_key" "evidence" {
  count = local.create_kms_key ? 1 : 0

  description             = "KMS key for AWS Audit Manager evidence bucket encryption"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  # Prevent accidental deletion of KMS key
  lifecycle {
    prevent_destroy = false # Set to true in production to prevent accidental deletion
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Audit Manager Service"
        Effect = "Allow"
        Principal = {
          Service = "auditmanager.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "s3.${var.aws_region}.amazonaws.com"
          }
        }
      },
      {
        Sid    = "Allow S3 Service"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })

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
# KMS Key Alias
################################################################################

resource "aws_kms_alias" "evidence" {
  count = local.create_kms_key ? 1 : 0

  name          = local.kms_key_alias
  target_key_id = aws_kms_key.evidence[0].key_id
}
