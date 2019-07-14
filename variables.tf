#---------------------------------------------------------------------------------------------------
# IAM Policy for Executing Terraform with Remote States
#---------------------------------------------------------------------------------------------------
variable "terraform_iam_policy_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  default     = "terraform"
}

#---------------------------------------------------------------------------------------------------
# KMS Key for Encrypting S3 Buckets
#---------------------------------------------------------------------------------------------------
variable "kms_key_description" {
  description = "The description of the key as viewed in AWS console."
  default     = "The key used to encrypt the remote state bucket."
}

variable "kms_key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days."
  default     = 30
}

variable "kms_key_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled."
  default     = true
}

#---------------------------------------------------------------------------------------------------
# S3 Buckets
#---------------------------------------------------------------------------------------------------
variable "state_bucket_prefix" {
  description = "Creates a unique state bucket name beginning with the specified prefix."
  default     = "tf-remote-state"
}

variable "replica_bucket_prefix" {
  description = "Creates a unique replica bucket name beginning with the specified prefix."
  default     = "tf-remote-state-replica"
}

variable "iam_role_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  default     = "remote-state-replication-role"
}

variable "iam_policy_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  default     = "remote-state-replication-policy"
}

variable "iam_policy_attachment_name" {
  description = "The name of the attachment."
  default     = "tf-iam-role-attachment-replication-configuration"
}

#---------------------------------------------------------------------------------------------------
# DynamoDB Table for State Locking
#---------------------------------------------------------------------------------------------------
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to use for state locking."
  default     = "remote-state-lock"
}

variable "dynamodb_table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  default     = "PAY_PER_REQUEST"
}
