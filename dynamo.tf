#---------------------------------------------------------------------------------------------------
# DynamoDB Table for State Locking
#---------------------------------------------------------------------------------------------------

locals {
  # The table must have a primary key named LockID.
  # See below for more detail.
  # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table
  lock_key_id             = "LockID"
  aws_kms_key_replica_arn = length(data.aws_kms_key.existing_kms_key_replica) == 1 ? data.aws_kms_key.existing_kms_key_replica[0].arn : aws_kms_key.replica[0].arn
}

resource "aws_dynamodb_table" "lock" {
  name                        = var.dynamodb_table_name
  billing_mode                = var.dynamodb_table_billing_mode
  hash_key                    = local.lock_key_id
  deletion_protection_enabled = var.dynamodb_deletion_protection_enabled

  attribute {
    name = local.lock_key_id
    type = "S"
  }

  server_side_encryption {
    enabled     = var.dynamodb_enable_server_side_encryption
    kms_key_arn = length(data.aws_kms_key.existing_kms_key) == 1 ? data.aws_kms_key.existing_kms_key[0].arn : aws_kms_key.this[0].arn
  }

  point_in_time_recovery {
    enabled = true
  }

  dynamic "replica" {
    for_each = var.enable_replication == true ? [1] : []
    content {
      region_name = data.aws_region.replica[0].name
      kms_key_arn = var.dynamodb_enable_server_side_encryption ? local.aws_kms_key_replica_arn : null
    }
  }
  stream_enabled   = var.enable_replication
  stream_view_type = var.enable_replication ? "NEW_AND_OLD_IMAGES" : null

  tags = var.tags
}
