# terraform-aws-remote-state-s3-backend

[![Github Actions](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/workflows/Terraform/badge.svg)](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/actions?workflow=Terraform)

[Terraform Module Registry](https://registry.terraform.io/modules/nozaq/remote-state-s3-backend/aws)

A terraform module to set up [remote state management](https://www.terraform.io/docs/state/remote.html) with [S3 backend](https://www.terraform.io/docs/backends/types/s3.html) for your account. It creates an encrypted S3 bucket to store state files and a DynamoDB table for state locking and consistency checking.
Resources are defined following best practices as described in [the official document](https://www.terraform.io/docs/backends/types/s3.html#multi-account-aws-architecture) and [ozbillwang/terraform-best-practices](https://github.com/ozbillwang/terraform-best-practices).

## Features

- Create a S3 bucket to store remote state files.
- Encrypt state files with KMS.
- Enable bucket replication and object versioning to prevent accidental data loss.
- Automatically transit non-current versions in S3 buckets to AWS S3 Glacier to optimize the storage cost.
- Optionally you can set to expire aged non-current versions(disabled by default).
- Create a DynamoDB table for state locking.
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
  source = "nozaq/remote-state-s3-backend/aws"

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
    bucket  = "THE_NAME_OF_THE_STATE_BUCKET"
    key     = "some_environment/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    kms_key_id = "THE_ID_OF_THE_KMS_KEY"
  }
}
```

`THE_NAME_OF_THE_STATE_BUCKET` and `THE_ID_OF_THE_KMS_KEY` can be replaced by `state_bucket.bucket`  and `kms_key.id`  in outputs from this module respectively.

See [the official document](https://www.terraform.io/docs/backends/types/s3.html#example-configuration) for more detail.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dynamodb\_table\_billing\_mode | Controls how you are charged for read and write throughput and how you manage capacity. | string | `"PAY_PER_REQUEST"` | no |
| dynamodb\_table\_name | The name of the DynamoDB table to use for state locking. | string | `"remote-state-lock"` | no |
| iam\_policy\_attachment\_name | The name of the attachment. | string | `"tf-iam-role-attachment-replication-configuration"` | no |
| iam\_policy\_name\_prefix | Creates a unique name beginning with the specified prefix. | string | `"remote-state-replication-policy"` | no |
| iam\_role\_arn | Use IAM role of specified ARN for s3 replication instead of creating it. | string | `"null"` | no |
| iam\_role\_name\_prefix | Creates a unique name beginning with the specified prefix. | string | `"remote-state-replication-role"` | no |
| kms\_key\_deletion\_window\_in\_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. | string | `"30"` | no |
| kms\_key\_description | The description of the key as viewed in AWS console. | string | `"The key used to encrypt the remote state bucket."` | no |
| kms\_key\_enable\_key\_rotation | Specifies whether key rotation is enabled. | string | `"true"` | no |
| noncurrent\_version\_expiration | Specifies when noncurrent object versions expire. See the aws\_s3\_bucket document for detail. | object | `"null"` | no |
| noncurrent\_version\_transitions | Specifies when noncurrent object versions transitions. See the aws\_s3\_bucket document for detail. | object | `[ { "days": 7, "storage_class": "GLACIER" } ]` | no |
| replica\_bucket\_prefix | Creates a unique replica bucket name beginning with the specified prefix. | string | `"tf-remote-state-replica"` | no |
| s3\_bucket\_force\_destroy | A boolean that indicates all objects should be deleted from S3 buckets so that the buckets can be destroyed without error. These objects are not recoverable. | string | `"false"` | no |
| state\_bucket\_prefix | Creates a unique state bucket name beginning with the specified prefix. | string | `"tf-remote-state"` | no |
| tags | A mapping of tags to assign to resources. | map | `{ "Terraform": "true" }` | no |
| terraform\_iam\_policy\_create | Specifies whether to terraform IAM policy is created. | boolean | `true` | no |
| terraform\_iam\_policy\_name\_prefix | Creates a unique name beginning with the specified prefix. | string | `"terraform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| dynamodb\_table | The DynamoDB table to manage lock states. |
| kms\_key | The KMS customer master key to encrypt state buckets. |
| replica\_bucket | The S3 bucket to replicate the state S3 bucket. |
| state\_bucket | The S3 bucket to store the remote state file. |
| terraform\_iam\_policy | The IAM Policy to access remote state environment. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
