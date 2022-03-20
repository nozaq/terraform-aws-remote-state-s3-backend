# Version 1.0 Upgrade Guide

This document outlines a way to upgrade this module from v0.x to v1.0 or later.

Following the changes introduced in AWS provider v4.0, several configurations for S3 buckets were extracted from `aws_s3_bucket` resource to newly added resources.
It is recommended to import these resources before running `terraform apply` to prevent data loss.

See [the upgrade guide for AWS provider] for more detail.

## State bucket migrations

Following configurations from `aws_s3_bucket.state` were extracted to separated resources.

- `aws_s3_bucket_acl.state`
- `aws_s3_bucket_versioning.state`
- `aws_s3_bucket_server_side_encryption_configuration.state`
- `aws_s3_bucket_lifecycle_configuration.state`
- `aws_s3_bucket_logging.state[0]` (Only exists when `var.s3_logging_target_bucket` is specified)

To import the current configuration into these resources, use `terraform import` command as follows.

```sh
$ terraform import "$MODULE_PATH.aws_s3_bucket_acl.state" "$STATE_BUCKET"

$ terraform import "$MODULE_PATH.aws_s3_bucket_versioning.state" "$STATE_BUCKET"

$ terraform import "$MODULE_PATH.aws_s3_bucket_server_side_encryption_configuration.state" "$STATE_BUCKET"

$ terraform import "$MODULE_PATH.aws_s3_bucket_lifecycle_configuration.state" "$STATE_BUCKET"

$ terraform import "$MODULE_PATH.aws_s3_bucket_logging.state[0]" "$STATE_BUCKET"
```

### Notes

- `$MODULE_PATH` should be replaced the actual path of this module in your project, e.g. `module.remote_state`.
- `$STATE_BUCKET` should be replaced with the state bucket name. The actual value in your state file as `aws_s3_bucket.state.id`.

## Replica bucket migrations

If the replication is enabled for the state bucket, i.e. `var.enable_replication` set to true, then the following resources should also be manually imported.

- `aws_s3_bucket_replication_configuration.state[0]`
- `aws_s3_bucket_acl.replica[0]`
- `aws_s3_bucket_versioning.replica[0]`
- `aws_s3_bucket_server_side_encryption_configuration.replica[0]`
- `aws_s3_bucket_lifecycle_configuration.replica[0]`

These resources can be imported by `terraform import` command as well.

```sh
$ terraform import "$MODULE_PATH.aws_s3_bucket_replication_configuration.state[0]" "$STATE_BUCKET"

$ terraform import "$MODULE_PATH.aws_s3_bucket_acl.replica[0]" "$REPLICA_BUCKET"

$ terraform import "$MODULE_PATH.aws_s3_bucket_versioning.replica[0]" "$REPLICA_BUCKET"

$ terraform import "$MODULE_PATH.aws_s3_bucket_server_side_encryption_configuration.replica[0]" "$REPLICA_BUCKET"

$ terraform import "$MODULE_PATH.aws_s3_bucket_lifecycle_configuration.replica[0]" "$REPLICA_BUCKET"
```

### Notes

- `$MODULE_PATH` should be replaced the actual path of this module in your project, e.g. `module.remote_state`.
- `$STATE_BUCKET` should be replaced with the state bucket name. The actual value in your state file as `aws_s3_bucket.state.id`.
- `$REPLICA_BUCKET` should be replaced with the replica bucket name. The actual value in your state file as `aws_s3_bucket.replica.id`.

[aws provider]: https://github.com/hashicorp/terraform-provider-aws
[the upgrade guide for aws provider]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/guides/version-4-upgrade
