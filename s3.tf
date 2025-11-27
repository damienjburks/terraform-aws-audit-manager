# S3 Evidence Bucket Resources

################################################################################
# S3 Bucket for Evidence Storage
################################################################################

resource "aws_s3_bucket" "evidence" {
  count = local.create_evidence_bucket ? 1 : 0

  bucket = local.evidence_bucket_name

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

  # Prevent accidental deletion of evidence bucket
  lifecycle {
    prevent_destroy = false # Set to true in production to prevent accidental deletion
  }
}

################################################################################
# S3 Bucket Encryption Configuration
################################################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "evidence" {
  count = local.create_evidence_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  rule {
    apply_server_side_encryption_by_default {
      # Use custom KMS key if provided, otherwise use created KMS key, otherwise use AWS managed encryption
      sse_algorithm = var.evidence_bucket_kms_key_arn != null || local.create_kms_key ? "aws:kms" : "AES256"
      kms_master_key_id = var.evidence_bucket_kms_key_arn != null ? var.evidence_bucket_kms_key_arn : (
        local.create_kms_key ? aws_kms_key.evidence[0].arn : null
      )
    }
    bucket_key_enabled = var.evidence_bucket_kms_key_arn != null || local.create_kms_key ? true : false
  }
}

################################################################################
# S3 Bucket Versioning Configuration
################################################################################

resource "aws_s3_bucket_versioning" "evidence" {
  count = local.create_evidence_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  versioning_configuration {
    status = var.enable_bucket_versioning ? "Enabled" : "Suspended"
  }
}

################################################################################
# S3 Bucket Public Access Block
################################################################################

resource "aws_s3_bucket_public_access_block" "evidence" {
  count = local.create_evidence_bucket ? 1 : 0

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
  count = local.create_evidence_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  # Evidence retention rule
  rule {
    id     = "evidence-retention"
    status = "Enabled"

    # Expire current version after retention period
    expiration {
      days = var.evidence_retention_days
    }

    # Expire noncurrent versions after 90 days
    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    # Abort incomplete multipart uploads after 7 days
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

################################################################################
# S3 Bucket Logging Configuration
################################################################################

resource "aws_s3_bucket_logging" "evidence" {
  count = local.create_evidence_bucket ? 1 : 0

  bucket = aws_s3_bucket.evidence[0].id

  target_bucket = aws_s3_bucket.evidence[0].id
  target_prefix = "access-logs/"
}
