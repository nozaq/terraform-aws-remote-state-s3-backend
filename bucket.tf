locals {
  define_lifecycle_rule = var.noncurrent_version_expiration != null || length(var.noncurrent_version_transitions) > 0
}

data "aws_region" "state" {
}

#---------------------------------------------------------------------------------------------------
# KMS Key to Encrypt S3 Bucket
#---------------------------------------------------------------------------------------------------

data "aws_kms_key" "existing_kms_key" {
  count  = length(var.existing_kms_key[*])
  key_id = var.existing_kms_key
}

resource "aws_kms_key" "this" {
  count                   = length(data.aws_kms_key.existing_kms_key) == 1 ? 0 : 1
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.kms_key_enable_key_rotation

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.kms_key_alias}"
  target_key_id = length(data.aws_kms_key.existing_kms_key) == 1 ? data.aws_kms_key.existing_kms_key[0].key_id : aws_kms_key.this[0].key_id
}

#---------------------------------------------------------------------------------------------------
# Bucket Policies
#---------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "state_force_ssl" {
  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      aws_s3_bucket.state.arn,
      "${aws_s3_bucket.state.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

#---------------------------------------------------------------------------------------------------
# Bucket
#---------------------------------------------------------------------------------------------------

resource "aws_s3_bucket_policy" "state_force_ssl" {
  bucket = aws_s3_bucket.state.id
  policy = data.aws_iam_policy_document.state_force_ssl.json

  depends_on = [aws_s3_bucket_public_access_block.state]
}

resource "aws_s3_bucket" "state" {
  bucket_prefix = var.override_s3_bucket_name ? null : var.state_bucket_prefix
  bucket        = var.override_s3_bucket_name ? var.s3_bucket_name : null
  force_destroy = var.s3_bucket_force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "state" {
  depends_on = [aws_s3_bucket_ownership_controls.state]
  bucket     = aws_s3_bucket.state.id
  acl        = "private"
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "state" {
  count = var.s3_logging_target_bucket != null ? 1 : 0

  bucket        = aws_s3_bucket.state.id
  target_bucket = var.s3_logging_target_bucket
  target_prefix = var.s3_logging_target_prefix
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = length(data.aws_kms_key.existing_kms_key) == 1 ? data.aws_kms_key.existing_kms_key[0].arn : aws_kms_key.this[0].arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "state" {
  count  = local.define_lifecycle_rule ? 1 : 0
  bucket = aws_s3_bucket.state.id

  rule {
    id     = "auto-archive"
    status = "Enabled"

    dynamic "noncurrent_version_transition" {
      for_each = var.noncurrent_version_transitions

      content {
        noncurrent_days = noncurrent_version_transition.value.days
        storage_class   = noncurrent_version_transition.value.storage_class
      }
    }

    dynamic "noncurrent_version_expiration" {
      for_each = var.noncurrent_version_expiration != null ? [var.noncurrent_version_expiration] : []

      content {
        noncurrent_days = noncurrent_version_expiration.value.days
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
