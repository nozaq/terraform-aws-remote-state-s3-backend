#---------------------------------------------------------------------------------------------------
# IAM Policy
# See below for permissions necessary to run Terraform.
# https://www.terraform.io/docs/backends/types/s3.html#example-configuration
#---------------------------------------------------------------------------------------------------
resource "aws_iam_policy" "terraform" {
  count = var.terraform_iam_policy_create ? 1 : 0

  name_prefix = var.terraform_iam_policy_name_prefix

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.state.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${aws_s3_bucket.state.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "${aws_dynamodb_table.lock.arn}"
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
}
