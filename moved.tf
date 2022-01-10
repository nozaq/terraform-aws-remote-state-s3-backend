moved {
  from = aws_kms_key.replica
  to   = aws_kms_key.replica[0]
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

