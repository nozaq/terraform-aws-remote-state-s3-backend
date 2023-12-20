#---------------------------------------------------------------------------------------------------
# IAM Policy
# See below for permissions necessary to run Terraform.
# https://www.terraform.io/docs/backends/types/s3.html#example-configuration
#
# terragrunt users would also need additional permissions.
# https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/74
#---------------------------------------------------------------------------------------------------

#tfsec:ignore:aws-iam-no-policy-wildcards
data "aws_iam_policy_document" "terraform" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketVersioning",
    ]
    resources = [aws_s3_bucket.state.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = ["${aws_s3_bucket.state.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
    ]
    resources = [aws_dynamodb_table.lock.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:ListKeys"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey",
    ]
    resources = [aws_kms_key.this.arn]
  }
}

#trivy:ignore:AVD-AWS-0057
resource "aws_iam_policy" "terraform" {
  count = var.terraform_iam_policy_create ? 1 : 0

  name_prefix = var.override_terraform_iam_policy_name ? null : var.terraform_iam_policy_name_prefix
  name        = var.override_terraform_iam_policy_name ? var.terraform_iam_policy_name : null
  policy      = data.aws_iam_policy_document.terraform.json
  tags        = var.tags
}
