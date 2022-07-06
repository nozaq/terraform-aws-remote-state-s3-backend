#---------------------------------------------------------------------------------------------------
# DynamoDB Table for State Locking
#---------------------------------------------------------------------------------------------------

locals {
  # The table must have a primary key named LockID.
  # See below for more detail.
  # https://www.terraform.io/docs/backends/types/s3.html#dynamodb_table
  lock_key_id = "LockID"
}

resource "aws_dynamodb_table" "lock" {
  name         = var.dynamodb_table_name
  billing_mode = var.dynamodb_table_billing_mode
  hash_key     = local.lock_key_id

  attribute {
    name = local.lock_key_id
    type = "S"
  }

  server_side_encryption {
    enabled     = var.dynamodb_enable_server_side_encryption
    kms_key_arn = aws_kms_key.this.arn
  }

  point_in_time_recovery {
    enabled = true
  }

  dynamic "replica" {
    for_each = var.enable_replication == true ? [1] : []
    content {
      region_name = data.aws_region.replica[0].name
      kms_key_arn = var.dynamodb_enable_server_side_encryption ? aws_kms_key.replica[0].arn : null
    }
  }
  stream_enabled = var.dynamodb_enable_server_side_encryption ? true : null

  tags = var.tags
}
