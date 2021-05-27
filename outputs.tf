output "kms_key" {
  description = "The KMS customer master key to encrypt state buckets."
  value       = aws_kms_key.this
}

output "state_bucket" {
  description = "The S3 bucket to store the remote state file."
  value       = aws_s3_bucket.state
}

output "replica_bucket" {
  description = "The S3 bucket to replicate the state S3 bucket."
  value       = aws_s3_bucket.replica
}

output "log_bucket" {
  description = "The S3 log bucket used for state S3 bucket logs storage."
  value = try((!var.s3_bucket_activate_logging ? "" : var.s3_bucket_activate_logging.undefined),
          can(aws_s3_bucket.log[0]) ? aws_s3_bucket.log[0] : data.aws_s3_bucket.log[0])
}

output "dynamodb_table" {
  description = "The DynamoDB table to manage lock states."
  value       = aws_dynamodb_table.lock
}

output "terraform_iam_policy" {
  description = "The IAM Policy to access remote state environment."
  value       = var.terraform_iam_policy_create ? aws_iam_policy.terraform[0] : null
}
