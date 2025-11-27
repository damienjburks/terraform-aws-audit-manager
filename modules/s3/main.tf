# S3 Evidence Bucket Module

################################################################################
# S3 Bucket for Evidence Storage
################################################################################

resource "aws_s3_bucket" "evidence" {
  count = var.create_bucket ? 1 : 0

  bucket = var.bucket_name

  tags = var.tags

  lifecycle {
    prevent_destroy = false
  }
}

################################################################################
# S3 Bucket Encryption Configuration
################################################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "evidence" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
    bucket_key_enabled = var.kms_key_arn != null ? true : false
  }
}

################################################################################
# S3 Bucket Versioning Configuration
################################################################################

resource "aws_s3_bucket_versioning" "evidence" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

################################################################################
# S3 Bucket Public Access Block
################################################################################

resource "aws_s3_bucket_public_access_block" "evidence" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

################################################################################
# S3 Bucket Lifecycle Configuration
################################################################################

resource "aws_s3_bucket_lifecycle_configuration" "evidence" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  rule {
    id     = "evidence-retention"
    status = "Enabled"

    expiration {
      days = var.retention_days
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

################################################################################
# S3 Bucket Logging Configuration
################################################################################

resource "aws_s3_bucket_logging" "evidence" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  target_bucket = aws_s3_bucket.evidence[0].id
  target_prefix = "access-logs/"
}

################################################################################
# S3 Bucket Policy
################################################################################

resource "aws_s3_bucket_policy" "evidence" {
  count = var.create_bucket ? 1 : 0

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
            "aws:SourceAccount" = var.account_id
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
            "aws:SourceAccount" = var.account_id
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
