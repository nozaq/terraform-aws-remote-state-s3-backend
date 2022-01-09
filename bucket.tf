locals {
  define_lifecycle_rule  = var.noncurrent_version_expiration != null || length(var.noncurrent_version_transitions) > 0
  replication_role_count = var.iam_role_arn == null && var.enable_replication ? 1 : 0
}

#---------------------------------------------------------------------------------------------------
# KMS Key to Encrypt S3 Bucket
#---------------------------------------------------------------------------------------------------
resource "aws_kms_key" "this" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.kms_key_enable_key_rotation

  tags = var.tags
}

resource "aws_kms_key" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.kms_key_enable_key_rotation

  tags = var.tags
}

#---------------------------------------------------------------------------------------------------
# IAM Role for Replication
# https://docs.aws.amazon.com/AmazonS3/latest/dev/crr-replication-config-for-kms-objects.html
#---------------------------------------------------------------------------------------------------
resource "aws_iam_role" "replication" {
  count = local.replication_role_count

  name_prefix        = var.iam_role_name_prefix
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
POLICY

  tags = var.tags
}

resource "aws_iam_policy" "replication" {
  count = local.replication_role_count

  name_prefix = var.iam_policy_name_prefix
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.replica[0].arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.this.arn}",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${data.aws_region.state.name}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.state.arn}/*"
          ]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": "${aws_kms_key.replica[0].arn}",
      "Condition": {
        "StringLike": {
          "kms:ViaService": "s3.${data.aws_region.replica[0].name}.amazonaws.com",
          "kms:EncryptionContext:aws:s3:arn": [
            "${aws_s3_bucket.replica[0].arn}/*"
          ]
        }
      }
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  count = local.replication_role_count

  name       = var.iam_policy_attachment_name
  roles      = [aws_iam_role.replication[0].name]
  policy_arn = aws_iam_policy.replication[0].arn
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
# Buckets
#---------------------------------------------------------------------------------------------------
data "aws_region" "state" {
}

data "aws_region" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica
}

resource "aws_s3_bucket" "replica" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  bucket_prefix = var.override_s3_bucket_name ? null : var.replica_bucket_prefix
  bucket        = var.override_s3_bucket_name ? var.s3_bucket_name_replica : null
  force_destroy = var.s3_bucket_force_destroy

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.replica[0].arn
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.define_lifecycle_rule ? [true] : []

    content {
      enabled = true
      dynamic "noncurrent_version_transition" {
        for_each = var.noncurrent_version_transitions

        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
      dynamic "noncurrent_version_expiration" {
        for_each = var.noncurrent_version_expiration != null ? [var.noncurrent_version_expiration] : []

        content {
          days = noncurrent_version_expiration.value.days
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "state_force_ssl" {
  bucket = aws_s3_bucket.state.id
  policy = data.aws_iam_policy_document.state_force_ssl.json

  depends_on = [aws_s3_bucket_public_access_block.state]
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

resource "aws_s3_bucket" "state" {
  bucket_prefix = var.override_s3_bucket_name ? null : var.state_bucket_prefix
  bucket        = var.override_s3_bucket_name ? var.s3_bucket_name : null
  acl           = "private"
  force_destroy = var.s3_bucket_force_destroy

  versioning {
    enabled = true
  }

  dynamic "logging" {
    for_each = var.s3_logging_target_bucket != null ? [true] : []
    content {
      target_bucket = var.s3_logging_target_bucket
      target_prefix = var.s3_logging_target_prefix
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.this.arn
      }
    }
  }

  dynamic "replication_configuration" {
    for_each = var.enable_replication == true ? [1] : []
    content {
      role = var.iam_role_arn != null ? var.iam_role_arn : aws_iam_role.replication[0].arn

      rules {
        id     = "replica_configuration"
        prefix = ""
        status = "Enabled"

        source_selection_criteria {
          sse_kms_encrypted_objects {
            enabled = true
          }
        }

        destination {
          bucket             = aws_s3_bucket.replica[0].arn
          storage_class      = "STANDARD"
          replica_kms_key_id = aws_kms_key.replica[0].arn
        }
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.define_lifecycle_rule ? [true] : []

    content {
      enabled = true
      dynamic "noncurrent_version_transition" {
        for_each = var.noncurrent_version_transitions

        content {
          days          = noncurrent_version_transition.value.days
          storage_class = noncurrent_version_transition.value.storage_class
        }
      }
      dynamic "noncurrent_version_expiration" {
        for_each = var.noncurrent_version_expiration != null ? [var.noncurrent_version_expiration] : []

        content {
          days = noncurrent_version_expiration.value.days
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_policy" "replica_force_ssl" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replica

  bucket = aws_s3_bucket.replica[0].id
  policy = data.aws_iam_policy_document.replica_force_ssl[0].json

  depends_on = [aws_s3_bucket_public_access_block.replica]
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
