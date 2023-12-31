# --------------------------------------------------------------------------------------------------
# Migrations to 0.7.0
# --------------------------------------------------------------------------------------------------
locals {
  kms_key_replica       = var.enable_replication ? length(data.aws_kms_key.existing_kms_key_replica) == 1 ? data.aws_kms_key.existing_kms_key_replica : aws_kms_key.replica : null
  kms_key_replica_array = var.enable_replication ? length(data.aws_kms_key.existing_kms_key_replica) == 1 ? data.aws_kms_key.existing_kms_key_replica[0] : aws_kms_key.replica[0] : null
}

moved {
  from = local.kms_key_replica
  to   = local.kms_key_replica_array
}

moved {
  from = aws_s3_bucket.replica
  to   = aws_s3_bucket.replica[0]
}

moved {
  from = aws_s3_bucket_public_access_block.replica
  to   = aws_s3_bucket_public_access_block.replica[0]
}

moved {
  from = aws_s3_bucket_policy.replica_force_ssl
  to   = aws_s3_bucket_policy.replica_force_ssl[0]
}

