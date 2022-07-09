output "kms_key" {
  description = "The KMS customer master key to encrypt state buckets."
  value       = aws_kms_key.this
}

output "kms_key_alias" {
  description = "The alias of the KMS customer master key used to encrypt state bucket and dynamodb."
  value       = aws_kms_key.this
}

output "state_bucket" {
  description = "The S3 bucket to store the remote state file."
  value       = aws_s3_bucket.state
}

output "replica_bucket" {
  description = "The S3 bucket to replicate the state S3 bucket."
  value       = try(aws_s3_bucket.replica[0], null)
}

output "dynamodb_table" {
  description = "The DynamoDB table to manage lock states."
  value       = aws_dynamodb_table.lock
}

output "kms_key_replica" {
  description = "The KMS customer master key to encrypt replica bucket and dynamodb."
  value       = try(aws_kms_key.replica[0], null)
}

output "terraform_iam_policy" {
  description = "The IAM Policy to access remote state environment."
  value       = var.terraform_iam_policy_create ? aws_iam_policy.terraform[0] : null
}
