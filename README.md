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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.15   |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.39.0 |

## Providers

| Name                                                                     | Version   |
| ------------------------------------------------------------------------ | --------- |
| <a name="provider_aws"></a> [aws](#provider_aws)                         | >= 3.39.0 |
| <a name="provider_aws.replica"></a> [aws.replica](#provider_aws.replica) | >= 3.39.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                   | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_dynamodb_table.lock](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table)                                  | resource    |
| [aws_iam_policy.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                   | resource    |
| [aws_iam_policy.terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                     | resource    |
| [aws_iam_policy_attachment.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment)             | resource    |
| [aws_iam_role.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                       | resource    |
| [aws_kms_key.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                             | resource    |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                                | resource    |
| [aws_s3_bucket.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                         | resource    |
| [aws_s3_bucket.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                           | resource    |
| [aws_s3_bucket_policy.replica_force_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)                 | resource    |
| [aws_s3_bucket_policy.state_force_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)                   | resource    |
| [aws_s3_bucket_public_access_block.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource    |
| [aws_s3_bucket_public_access_block.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)   | resource    |
| [aws_iam_policy_document.replica_force_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)        | data source |
| [aws_iam_policy_document.state_force_ssl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)          | data source |
| [aws_region.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                            | data source |
| [aws_region.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                              | data source |

## Inputs

| Name                                                                                                                              | Description                                                                                                                                                   | Type                                                                          | Default                                                                     | Required |
| --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------- | :------: |
| <a name="input_dynamodb_table_billing_mode"></a> [dynamodb_table_billing_mode](#input_dynamodb_table_billing_mode)                | Controls how you are charged for read and write throughput and how you manage capacity.                                                                       | `string`                                                                      | `"PAY_PER_REQUEST"`                                                         |    no    |
| <a name="input_dynamodb_table_name"></a> [dynamodb_table_name](#input_dynamodb_table_name)                                        | The name of the DynamoDB table to use for state locking.                                                                                                      | `string`                                                                      | `"tf-remote-state-lock"`                                                    |    no    |
| <a name="input_iam_policy_attachment_name"></a> [iam_policy_attachment_name](#input_iam_policy_attachment_name)                   | The name of the attachment.                                                                                                                                   | `string`                                                                      | `"tf-iam-role-attachment-replication-configuration"`                        |    no    |
| <a name="input_iam_policy_name_prefix"></a> [iam_policy_name_prefix](#input_iam_policy_name_prefix)                               | Creates a unique name beginning with the specified prefix.                                                                                                    | `string`                                                                      | `"tf-remote-state-replication-policy"`                                      |    no    |
| <a name="input_iam_role_arn"></a> [iam_role_arn](#input_iam_role_arn)                                                             | Use IAM role of specified ARN for s3 replication instead of creating it.                                                                                      | `any`                                                                         | `null`                                                                      |    no    |
| <a name="input_iam_role_name_prefix"></a> [iam_role_name_prefix](#input_iam_role_name_prefix)                                     | Creates a unique name beginning with the specified prefix.                                                                                                    | `string`                                                                      | `"tf-remote-state-replication-role"`                                        |    no    |
| <a name="input_kms_key_deletion_window_in_days"></a> [kms_key_deletion_window_in_days](#input_kms_key_deletion_window_in_days)    | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days.                                             | `number`                                                                      | `30`                                                                        |    no    |
| <a name="input_kms_key_description"></a> [kms_key_description](#input_kms_key_description)                                        | The description of the key as viewed in AWS console.                                                                                                          | `string`                                                                      | `"The key used to encrypt the remote state bucket."`                        |    no    |
| <a name="input_kms_key_enable_key_rotation"></a> [kms_key_enable_key_rotation](#input_kms_key_enable_key_rotation)                | Specifies whether key rotation is enabled.                                                                                                                    | `bool`                                                                        | `true`                                                                      |    no    |
| <a name="input_noncurrent_version_expiration"></a> [noncurrent_version_expiration](#input_noncurrent_version_expiration)          | Specifies when noncurrent object versions expire. See the aws_s3_bucket document for detail.                                                                  | <pre>object({<br> days = number<br> })</pre>                                  | `null`                                                                      |    no    |
| <a name="input_noncurrent_version_transitions"></a> [noncurrent_version_transitions](#input_noncurrent_version_transitions)       | Specifies when noncurrent object versions transitions. See the aws_s3_bucket document for detail.                                                             | <pre>list(object({<br> days = number<br> storage_class = string<br> }))</pre> | <pre>[<br> {<br> "days": 7,<br> "storage_class": "GLACIER"<br> }<br>]</pre> |    no    |
| <a name="input_replica_bucket_prefix"></a> [replica_bucket_prefix](#input_replica_bucket_prefix)                                  | Creates a unique replica bucket name beginning with the specified prefix.                                                                                     | `string`                                                                      | `"tf-remote-state-replica"`                                                 |    no    |
| <a name="input_s3_bucket_force_destroy"></a> [s3_bucket_force_destroy](#input_s3_bucket_force_destroy)                            | A boolean that indicates all objects should be deleted from S3 buckets so that the buckets can be destroyed without error. These objects are not recoverable. | `bool`                                                                        | `false`                                                                     |    no    |
| <a name="input_s3_logging_target_bucket"></a> [s3_logging_target_bucket](#input_s3_logging_target_bucket)                         | The name of the bucket for log storage. The "S3 log delivery group" should have Objects-write und ACL-read permissions on the bucket.                         | `string`                                                                      | `null`                                                                      |    no    |
| <a name="input_s3_logging_target_prefix"></a> [s3_logging_target_prefix](#input_s3_logging_target_prefix)                         | The prefix to apply on bucket logs, e.g "logs/".                                                                                                              | `string`                                                                      | `""`                                                                        |    no    |
| <a name="input_state_bucket_prefix"></a> [state_bucket_prefix](#input_state_bucket_prefix)                                        | Creates a unique state bucket name beginning with the specified prefix.                                                                                       | `string`                                                                      | `"tf-remote-state"`                                                         |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                                     | A mapping of tags to assign to resources.                                                                                                                     | `map`                                                                         | <pre>{<br> "Terraform": "true"<br>}</pre>                                   |    no    |
| <a name="input_terraform_iam_policy_create"></a> [terraform_iam_policy_create](#input_terraform_iam_policy_create)                | Specifies whether to terraform IAM policy is created.                                                                                                         | `bool`                                                                        | `true`                                                                      |    no    |
| <a name="input_terraform_iam_policy_name_prefix"></a> [terraform_iam_policy_name_prefix](#input_terraform_iam_policy_name_prefix) | Creates a unique name beginning with the specified prefix.                                                                                                    | `string`                                                                      | `"terraform"`                                                               |    no    |

## Outputs

| Name                                                                                            | Description                                           |
| ----------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| <a name="output_dynamodb_table"></a> [dynamodb_table](#output_dynamodb_table)                   | The DynamoDB table to manage lock states.             |
| <a name="output_kms_key"></a> [kms_key](#output_kms_key)                                        | The KMS customer master key to encrypt state buckets. |
| <a name="output_replica_bucket"></a> [replica_bucket](#output_replica_bucket)                   | The S3 bucket to replicate the state S3 bucket.       |
| <a name="output_state_bucket"></a> [state_bucket](#output_state_bucket)                         | The S3 bucket to store the remote state file.         |
| <a name="output_terraform_iam_policy"></a> [terraform_iam_policy](#output_terraform_iam_policy) | The IAM Policy to access remote state environment.    |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
