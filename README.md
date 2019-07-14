# terraform-aws-remote-state-s3-backend

[![CircleCI](https://circleci.com/gh/nozaq/terraform-aws-remote-state-s3-backend/tree/master.svg?style=svg)](https://circleci.com/gh/nozaq/terraform-aws-remote-state-s3-backend/tree/master)

[Terraform Module Registry](https://registry.terraform.io/modules/nozaq/remote-state-s3-backend/aws)

A terraform module to set up [remote state management](https://www.terraform.io/docs/state/remote.html) with [S3 backend](https://www.terraform.io/docs/backends/types/s3.html) for your account. It creates a S3 bucket to store state files and a DynamoDB table for state locking and consistency checking.
Resources are defined following best practices as described in [the official document] and [ozbillwang/terraform-best-practices].

## Features

- Create a S3 bucket to store remote state files.
- Enable bucket replication and object versioning to prevent accidental data loss.
- Create a DynamoDB table for state locking.
- Create an IAM policy to allow permissions which Terraform needs.

## Usage

The module outputs `terraform_iam_policy` which can be attached to IAM users, groups or roles running Terraform. This will allow the entity accessing remote state files and the locking table.

```hcl
provider "aws" {
}

provider "aws" {
  alias  = "replica"
}

module "remote_state" {
  source = "nozaq/remote-state-s3-backend/aws"

  replica_bucket_region = "us-west-1"

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
Once resources are created, you can configure your terraform files to use the S3 backend as described in [the document](https://www.terraform.io/docs/backends/types/s3.html#example-configuration).

