#---------------------------------------------------------------------------------------------------
# IAM Policy
# See below for permissions necessary to run Terraform.
# https://www.terraform.io/docs/backends/types/s3.html#example-configuration
#
# terragrunt users would also need additional permissions.
# https://github.com/nozaq/terraform-aws-remote-state-s3-backend/issues/74
#---------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "terraform" {
  count = var.terraform_iam_policy_create ? 1 : 0

  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketVersioning"
    ]
    resources = [aws_s3_bucket.state.arn]
  }

  statement {
    actions = concat(
      [
        "s3:GetObject",
        "s3:PutObject"
      ],
      var.terraform_iam_policy_add_lockfile_permissions ? ["s3:DeleteObject"] : []
    )
    resources = ["${aws_s3_bucket.state.arn}/*"]
  }

  dynamic "statement" {
    for_each = var.create_dynamodb_table ? [1] : []
    content {
      actions = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:DescribeTable"
      ]
      resources = [aws_dynamodb_table.lock[0].arn]
    }
  }

  statement {
    actions   = ["kms:ListKeys"]
    resources = ["*"]
  }

  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey"
    ]
    resources = [aws_kms_key.this.arn]
  }
}

resource "aws_iam_policy" "terraform" {
  count = var.terraform_iam_policy_create ? 1 : 0

  name_prefix = var.override_terraform_iam_policy_name ? null : var.terraform_iam_policy_name_prefix
  name        = var.override_terraform_iam_policy_name ? var.terraform_iam_policy_name : null
  policy      = data.aws_iam_policy_document.terraform[0].json
  tags        = var.tags
}
