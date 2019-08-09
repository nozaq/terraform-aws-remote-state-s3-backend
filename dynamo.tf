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

  tags = var.tags
}
