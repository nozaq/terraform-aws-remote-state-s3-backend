# terraform-aws-remote-state-s3-backend

[![Github Actions](https://github.com/pcanham/terraform-aws-remote-state-s3-backend/actions/workflows/main.yml/badge.svg)](https://github.com/pcanham/terraform-aws-remote-state-s3-backend/actions/workflows/main.yml)
[![Releases](https://img.shields.io/github/v/release/pcanham/terraform-aws-remote-state-s3-backend)](https://github.com/pcanham/terraform-aws-remote-state-s3-backend/releases/latest)

[Terraform Module Registry](https://registry.terraform.io/modules/nozaq/remote-state-s3-backend/aws)

A terraform module to set up [remote state management](https://www.terraform.io/docs/state/remote.html) with [S3 backend](https://www.terraform.io/docs/backends/types/s3.html) for your account. It creates an encrypted S3 bucket to store state files and a DynamoDB table for state locking and consistency checking.
Resources are defined following best practices as described in [the official document](https://www.terraform.io/docs/backends/types/s3.html#multi-account-aws-architecture) and [ozbillwang/terraform-best-practices](https://github.com/ozbillwang/terraform-best-practices).

## Features

- Create a S3 bucket to store remote state files.
- Encrypt state files with KMS.
- Enable bucket replication and object versioning to prevent accidental data loss.
- Automatically transit non-current versions in S3 buckets to AWS S3 Glacier to optimize the storage cost.
- Optionally you can set to expire aged non-current versions(disabled by default).
- Optionally you can set fixed S3 bucket name to be user friendly(false by default).
- Create a DynamoDB table for state locking, encryption is optional.
- Optionally create an IAM policy to allow permissions which Terraform needs.

## Usage

The module outputs `terraform_iam_policy` which can be attached to IAM users, groups or roles running Terraform. This will allow the entity accessing remote state files and the locking table. This can optionally be disabled with `terraform_iam_policy_create = false`

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "replica"
  region = "us-west-1"
}

module "remote_state" {
  source = "github.com/pcanham/terraform-aws-remote-state-s3-backend"

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}

resource "aws_iam_user" "terraform" {
  name = "TerraformUser"
}

resource "aws_iam_user_policy_attachment" "remote_state_access" {
  user       = aws_iam_user.terraform.name
  policy_arn = module.remote_state.terraform_iam_policy.arn
}
```

Note that you need to provide two providers, one for the main state bucket and the other for the bucket to which the main state bucket is replicated to. Two providers must point to different AWS regions.

Once resources are created, you can configure your terraform files to use the S3 backend as follows.

```hcl
terraform {
  backend "s3" {
    bucket         = "THE_NAME_OF_THE_STATE_BUCKET"
    key            = "some_environment/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    kms_key_id     = "THE_ID_OF_THE_KMS_KEY"
    dynamodb_table = "THE_ID_OF_THE_DYNAMODB_TABLE"
  }
}
```

`THE_NAME_OF_THE_STATE_BUCKET`, `THE_ID_OF_THE_DYNAMODB_TABLE` and `THE_ID_OF_THE_KMS_KEY` can be replaced by `state_bucket.bucket`, `dynamodb_table.id` and `kms_key.id` in outputs from this module respectively.

See [the official document](https://www.terraform.io/docs/backends/types/s3.html#example-configuration) for more detail.

## Compatibility

- Starting from v1.0, this module requires [Terraform Provider for AWS](https://github.com/terraform-providers/terraform-provider-aws) v4.0 or later. [Version 1.0 Upgrade Guide](./docs/upgrade-1.0.md) described the recommended procedure after the upgrade.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
