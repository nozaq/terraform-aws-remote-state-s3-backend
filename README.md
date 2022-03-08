# terraform-aws-remote-state-s3-backend

[![Github Actions](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/actions/workflows/main.yml/badge.svg)](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/actions/workflows/main.yml)
[![Releases](https://img.shields.io/github/v/release/nozaq/terraform-aws-remote-state-s3-backend)](https://github.com/nozaq/terraform-aws-remote-state-s3-backend/releases/latest)

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
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_aws.replica"></a> [aws.replica](#provider\_aws.replica) | >= 4.0 |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|:--------:|
| <a name="input_dynamodb_enable_server_side_encryption"></a> [dynamodb\_enable\_server\_side\_encryption](#input\_dynamodb\_enable\_server\_side\_encryption) | Whether or not to enable encryption at rest using an AWS managed KMS customer master key (CMK) | `bool` | no |
| <a name="input_dynamodb_table_billing_mode"></a> [dynamodb\_table\_billing\_mode](#input\_dynamodb\_table\_billing\_mode) | Controls how you are charged for read and write throughput and how you manage capacity. | `string` | no |
| <a name="input_dynamodb_table_name"></a> [dynamodb\_table\_name](#input\_dynamodb\_table\_name) | The name of the DynamoDB table to use for state locking. | `string` | no |
| <a name="input_enable_replication"></a> [enable\_replication](#input\_enable\_replication) | Set this to true to enable S3 bucket replication in another region | `bool` | no |
| <a name="input_iam_policy_attachment_name"></a> [iam\_policy\_attachment\_name](#input\_iam\_policy\_attachment\_name) | The name of the attachment. | `string` | no |
| <a name="input_iam_policy_name_prefix"></a> [iam\_policy\_name\_prefix](#input\_iam\_policy\_name\_prefix) | Creates a unique name beginning with the specified prefix. | `string` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | Use IAM role of specified ARN for s3 replication instead of creating it. | `string` | no |
| <a name="input_iam_role_name_prefix"></a> [iam\_role\_name\_prefix](#input\_iam\_role\_name\_prefix) | Creates a unique name beginning with the specified prefix. | `string` | no |
| <a name="input_kms_key_deletion_window_in_days"></a> [kms\_key\_deletion\_window\_in\_days](#input\_kms\_key\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. | `number` | no |
| <a name="input_kms_key_description"></a> [kms\_key\_description](#input\_kms\_key\_description) | The description of the key as viewed in AWS console. | `string` | no |
| <a name="input_kms_key_enable_key_rotation"></a> [kms\_key\_enable\_key\_rotation](#input\_kms\_key\_enable\_key\_rotation) | Specifies whether key rotation is enabled. | `bool` | no |
| <a name="input_noncurrent_version_expiration"></a> [noncurrent\_version\_expiration](#input\_noncurrent\_version\_expiration) | Specifies when noncurrent object versions expire. See the aws\_s3\_bucket document for detail. | <pre>object({<br>    days = number<br>  })</pre> | no |
| <a name="input_noncurrent_version_transitions"></a> [noncurrent\_version\_transitions](#input\_noncurrent\_version\_transitions) | Specifies when noncurrent object versions transitions. See the aws\_s3\_bucket document for detail. | <pre>list(object({<br>    days          = number<br>    storage_class = string<br>  }))</pre> | no |
| <a name="input_override_s3_bucket_name"></a> [override\_s3\_bucket\_name](#input\_override\_s3\_bucket\_name) | override s3 bucket name to disable bucket\_prefix and create bucket with static name | `bool` | no |
| <a name="input_replica_bucket_prefix"></a> [replica\_bucket\_prefix](#input\_replica\_bucket\_prefix) | Creates a unique replica bucket name beginning with the specified prefix. | `string` | no |
| <a name="input_s3_bucket_force_destroy"></a> [s3\_bucket\_force\_destroy](#input\_s3\_bucket\_force\_destroy) | A boolean that indicates all objects should be deleted from S3 buckets so that the buckets can be destroyed without error. These objects are not recoverable. | `bool` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | If override\_s3\_bucket\_name is true, use this bucket name for replica instead of dynamic name with bucket\_prefix | `string` | no |
| <a name="input_s3_bucket_name_replica"></a> [s3\_bucket\_name\_replica](#input\_s3\_bucket\_name\_replica) | If override\_s3\_bucket\_name is true, use this bucket name instead of dynamic name with bucket\_prefix | `string` | no |
| <a name="input_s3_logging_target_bucket"></a> [s3\_logging\_target\_bucket](#input\_s3\_logging\_target\_bucket) | The name of the bucket for log storage. The "S3 log delivery group" should have Objects-write und ACL-read permissions on the bucket. | `string` | no |
| <a name="input_s3_logging_target_prefix"></a> [s3\_logging\_target\_prefix](#input\_s3\_logging\_target\_prefix) | The prefix to apply on bucket logs, e.g "logs/". | `string` | no |
| <a name="input_state_bucket_prefix"></a> [state\_bucket\_prefix](#input\_state\_bucket\_prefix) | Creates a unique state bucket name beginning with the specified prefix. | `string` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to resources. | `map(string)` | no |
| <a name="input_terraform_iam_policy_create"></a> [terraform\_iam\_policy\_create](#input\_terraform\_iam\_policy\_create) | Specifies whether to terraform IAM policy is created. | `bool` | no |
| <a name="input_terraform_iam_policy_name_prefix"></a> [terraform\_iam\_policy\_name\_prefix](#input\_terraform\_iam\_policy\_name\_prefix) | Creates a unique name beginning with the specified prefix. | `string` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dynamodb_table"></a> [dynamodb\_table](#output\_dynamodb\_table) | The DynamoDB table to manage lock states. |
| <a name="output_kms_key"></a> [kms\_key](#output\_kms\_key) | The KMS customer master key to encrypt state buckets. |
| <a name="output_replica_bucket"></a> [replica\_bucket](#output\_replica\_bucket) | The S3 bucket to replicate the state S3 bucket. |
| <a name="output_state_bucket"></a> [state\_bucket](#output\_state\_bucket) | The S3 bucket to store the remote state file. |
| <a name="output_terraform_iam_policy"></a> [terraform\_iam\_policy](#output\_terraform\_iam\_policy) | The IAM Policy to access remote state environment. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
