locals {
  replication_role_count = var.iam_role_arn == null && var.enable_replication ? 1 : 0
}

data "aws_region" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica
}

#---------------------------------------------------------------------------------------------------
# KMS Key to Encrypt S3 Bucket
#---------------------------------------------------------------------------------------------------

resource "aws_kms_key" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.kms_key_enable_key_rotation

  tags = var.tags
}

#---------------------------------------------------------------------------------------------------
# Roles & Policies
#---------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "s3_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM Role for Replication
# https://docs.aws.amazon.com/AmazonS3/latest/dev/crr-replication-config-for-kms-objects.html
resource "aws_iam_role" "replication" {
  count = local.replication_role_count

  name_prefix        = var.override_iam_role_name ? null : var.iam_role_name_prefix
  name               = var.override_iam_role_name ? var.iam_role_name : null
  assume_role_policy = data.aws_iam_policy_document.s3_assume_role.json

  permissions_boundary = var.iam_role_permissions_boundary
  tags                 = var.tags
}

#trivy:ignore:AVD-AWS-0057
data "aws_iam_policy_document" "s3_replication" {
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.state.arn,
      "${aws_s3_bucket.state.arn}/*"
    ]
  }
  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.state.arn}/*"
    ]
  }
  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.replica[0].arn}/*"
    ]
  }
  statement {
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.this.arn,
    ]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = "s3.${data.aws_region.state.name}.amazonaws.com"
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = "${aws_s3_bucket.state.arn}/*"
    }
  }
  statement {
    actions = [
      "kms:Encrypt",
      "kms:GenerateDataKey"
    ]
    resources = [
      aws_kms_key.replica[0].arn,
    ]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = "s3.${data.aws_region.replica[0].name}.amazonaws.com"
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = "${aws_s3_bucket.replica[0].arn}/*"
    }
  }


}

resource "aws_iam_policy" "replication" {
  count = local.replication_role_count

  name_prefix = var.override_iam_policy_name ? null : var.iam_policy_name_prefix
  name        = var.override_iam_policy_name ? var.iam_policy_name : null
  policy      = data.aws_iam_policy_document.s3_replication.json

  tags = var.tags
}

resource "aws_iam_policy_attachment" "replication" {
  count = local.replication_role_count

  name       = var.iam_policy_attachment_name
  roles      = [aws_iam_role.replication[0].name]
  policy_arn = aws_iam_policy.replication[0].arn
}

data "aws_iam_policy_document" "replica_force_ssl" {
  count = var.enable_replication ? 1 : 0

  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      aws_s3_bucket.replica[0].arn,
      "${aws_s3_bucket.replica[0].arn}/*"
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

#trivy:ignore:AVD-AWS-0089
resource "aws_s3_bucket" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  bucket_prefix = var.override_s3_bucket_name ? null : var.replica_bucket_prefix
  bucket        = var.override_s3_bucket_name ? var.s3_bucket_name_replica : null
  force_destroy = var.s3_bucket_force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  bucket = aws_s3_bucket.replica[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "replica" {
  depends_on = [aws_s3_bucket_ownership_controls.replica]
  count      = var.enable_replication ? 1 : 0
  provider   = aws.replica


  bucket = aws_s3_bucket.replica[0].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  bucket = aws_s3_bucket.replica[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  bucket = aws_s3_bucket.replica[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.replica[0].arn
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "replica" {
  count    = var.enable_replication && local.define_lifecycle_rule ? 1 : 0
  provider = aws.replica

  bucket = aws_s3_bucket.replica[0].id

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

resource "aws_s3_bucket_policy" "replica_force_ssl" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  bucket = aws_s3_bucket.replica[0].id
  policy = data.aws_iam_policy_document.replica_force_ssl[0].json

  depends_on = [aws_s3_bucket_public_access_block.replica]
}

resource "aws_s3_bucket_public_access_block" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  bucket                  = aws_s3_bucket.replica[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_replication_configuration" "state" {
  count  = var.enable_replication == true ? 1 : 0
  bucket = aws_s3_bucket.state.id

  role = var.iam_role_arn != null ? var.iam_role_arn : aws_iam_role.replication[0].arn

  rule {
    id     = "replica_configuration"
    status = "Enabled"

    filter {}

    delete_marker_replication {
      status = "Disabled"
    }

    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }

    destination {
      bucket        = aws_s3_bucket.replica[0].arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = aws_kms_key.replica[0].arn
      }
    }
  }

  # Versioning can't be disabled when the replication configuration exists.
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-and-other-bucket-configs.html#replication-and-versioning
  depends_on = [aws_s3_bucket_versioning.state]
}
