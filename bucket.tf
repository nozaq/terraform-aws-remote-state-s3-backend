#---------------------------------------------------------------------------------------------------
# KMS Key to Encrypt S3 Bucket
#---------------------------------------------------------------------------------------------------
resource "aws_kms_key" "this" {
  description             = var.kms_key_description
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.kms_key_enable_key_rotation

  tags = {
    Terraform = true
  }
}

#---------------------------------------------------------------------------------------------------
# IAM Role for Replication
#---------------------------------------------------------------------------------------------------
resource "aws_iam_role" "replication" {
  name_prefix = var.iam_role_name_prefix

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
}

resource "aws_iam_policy" "replication" {
  name_prefix = var.iam_policy_name_prefix

  policy = <<POLICY
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
        "s3:GetObjectVersion",
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
      "Resource": "${aws_s3_bucket.replica.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  name       = var.iam_policy_attachment_name
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}

#---------------------------------------------------------------------------------------------------
# Buckets
#---------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "replica" {
  provider      = aws.replica
  bucket_prefix = var.replica_bucket_prefix
  region        = var.replica_bucket_region

  versioning {
    enabled = true
  }

  tags = {
    Terraform = "true"
  }
}

resource "aws_s3_bucket" "state" {
  bucket_prefix = var.state_bucket_prefix
  acl           = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "${aws_kms_key.this.arn}"
      }
    }
  }

  replication_configuration {
    role = aws_iam_role.replication.arn

    rules {
      id     = "replica_configuration"
      prefix = ""
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.replica.arn
        storage_class = "STANDARD"
      }
    }
  }

  tags = {
    Terraform = "true"
  }
}
