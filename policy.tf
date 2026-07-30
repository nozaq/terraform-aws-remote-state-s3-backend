#---------------------------------------------------------------------------------------------------
# IAM Policy
# See below for permissions necessary to run Terraform.
# https://developer.hashicorp.com/terraform/language/backend/s3#example-configuration
#
# State locking is handled by S3 itself, which stores a lock file next to the state file
# as `<key>.tflock`. Deleting the lock file must be allowed to release the lock.
# https://developer.hashicorp.com/terraform/language/backend/s3#state-locking
#
# terragrunt users would also need additional permissions.
# https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/74
#---------------------------------------------------------------------------------------------------

resource "aws_iam_policy" "terraform" {
  count = var.terraform_iam_policy_create ? 1 : 0

  name_prefix = var.override_terraform_iam_policy_name ? null : var.terraform_iam_policy_name_prefix
  name        = var.override_terraform_iam_policy_name ? var.terraform_iam_policy_name : null
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:GetBucketVersioning"],
      "Resource": "${aws_s3_bucket.state.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${aws_s3_bucket.state.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": "${aws_s3_bucket.state.arn}/*.tflock"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:ListKeys"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:GenerateDataKey"
      ],
      "Resource": "${aws_kms_key.this.arn}"
    }
  ]
}
POLICY

  tags = var.tags
}
