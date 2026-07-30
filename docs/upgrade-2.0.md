# Version 2.0 Upgrade Guide

This document outlines a way to upgrade this module from v1.x to v2.0 or later.

Starting from v2.0, this module relies on [S3 native state locking] instead of a DynamoDB table.
The lock file is stored in the state bucket next to the state file as `<key>.tflock`, so the DynamoDB table is no longer needed.

## Requirements

- Terraform v1.11 or later, which is the first version supporting `use_lockfile`.

## Removed variables

The following variables were removed. All of them had default values, so you may not have set any of them.
If your module block does set one, remove it before upgrading, otherwise `terraform plan` fails with an unsupported argument error.

- `dynamodb_table_name`
- `dynamodb_table_billing_mode`
- `dynamodb_enable_server_side_encryption`
- `dynamodb_deletion_protection_enabled`

## Removed outputs

The following output was removed. Remove any reference to it from your configuration.

- `dynamodb_table`

## Update the backend configuration

Replace `dynamodb_table` with `use_lockfile = true` in every backend configuration pointing to the state bucket.

```diff
 terraform {
   backend "s3" {
-    bucket         = "THE_NAME_OF_THE_STATE_BUCKET"
-    key            = "some_environment/terraform.tfstate"
-    region         = "us-east-1"
-    encrypt        = true
-    kms_key_id     = "THE_ID_OF_THE_KMS_KEY"
-    dynamodb_table = "THE_ID_OF_THE_DYNAMODB_TABLE"
+    bucket       = "THE_NAME_OF_THE_STATE_BUCKET"
+    key          = "some_environment/terraform.tfstate"
+    region       = "us-east-1"
+    encrypt      = true
+    kms_key_id   = "THE_ID_OF_THE_KMS_KEY"
+    use_lockfile = true
   }
 }
```

Run `terraform init -reconfigure` afterwards so that the backend picks up the new locking method.

Make sure no operation is holding a DynamoDB lock while you migrate. Terraform does not transfer an existing DynamoDB lock to the new lock file, so a stale lock left in the table is simply ignored after the upgrade.

## Removing the DynamoDB table

`aws_dynamodb_table.lock` is no longer managed by this module, so `terraform plan` shows it as a resource to destroy.

Note that the table was created with `deletion_protection_enabled` set to `var.dynamodb_deletion_protection_enabled`, which defaults to `true`. If deletion protection is still enabled, the destroy fails. Either disable deletion protection first, or drop the table from the state and delete it manually.

To let Terraform destroy the table, disable deletion protection while still on v1.x:

```hcl
module "remote_state" {
  source  = "nozaq/remote-state-s3-backend/aws"
  version = "~> 1.6"

  dynamodb_deletion_protection_enabled = false

  # ...
}
```

Apply that change, then upgrade to v2.0 and apply again to destroy the table.

Alternatively, to keep the table in AWS and only drop it from the Terraform state, remove it before upgrading:

```sh
$ terraform state rm "$MODULE_PATH.aws_dynamodb_table.lock"
```

### Notes

- `$MODULE_PATH` should be replaced with the actual path of this module in your project, e.g. `module.remote_state`.

## IAM policy changes

The `terraform_iam_policy` output no longer grants `dynamodb:*` permissions. Instead it allows `s3:GetObject`, `s3:PutObject` and `s3:DeleteObject` on `arn:aws:s3:::<state bucket>/*.tflock` so that Terraform can acquire and release the lock file.

If you manage your own IAM policy instead of using `terraform_iam_policy_create`, update it accordingly.

[s3 native state locking]: https://developer.hashicorp.com/terraform/language/backend/s3#state-locking
