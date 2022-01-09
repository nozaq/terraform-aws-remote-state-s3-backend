#---------------------------------------------------------------------------------------------------
# General
#---------------------------------------------------------------------------------------------------

variable "tags" {
  description = "A mapping of tags to assign to resources."
  type        = map(string)
  default = {
    Terraform = "true"
  }
}

#---------------------------------------------------------------------------------------------------
# IAM Policy for Executing Terraform with Remote States
#---------------------------------------------------------------------------------------------------

variable "terraform_iam_policy_create" {
  description = "Specifies whether to terraform IAM policy is created."
  type        = bool
  default     = true
}

variable "terraform_iam_policy_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  type        = string
  default     = "terraform"
}

#---------------------------------------------------------------------------------------------------
# KMS Key for Encrypting S3 Buckets
#---------------------------------------------------------------------------------------------------

variable "kms_key_description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
  default     = "The key used to encrypt the remote state bucket."
}

variable "kms_key_deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days."
  type        = number
  default     = 30
}

variable "kms_key_enable_key_rotation" {
  description = "Specifies whether key rotation is enabled."
  type        = bool
  default     = true
}

#---------------------------------------------------------------------------------------------------
# S3 Buckets
#---------------------------------------------------------------------------------------------------

variable "state_bucket_prefix" {
  description = "Creates a unique state bucket name beginning with the specified prefix."
  type        = string
  default     = "tf-remote-state"
}

variable "replica_bucket_prefix" {
  description = "Creates a unique replica bucket name beginning with the specified prefix."
  type        = string
  default     = "tf-remote-state-replica"
}

variable "iam_role_arn" {
  description = "Use IAM role of specified ARN for s3 replication instead of creating it."
  type        = string
  default     = null
}

variable "iam_role_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  type        = string
  default     = "tf-remote-state-replication-role"
}

variable "iam_policy_name_prefix" {
  description = "Creates a unique name beginning with the specified prefix."
  type        = string
  default     = "tf-remote-state-replication-policy"
}

variable "iam_policy_attachment_name" {
  description = "The name of the attachment."
  type        = string
  default     = "tf-iam-role-attachment-replication-configuration"
}

variable "noncurrent_version_transitions" {
  description = "Specifies when noncurrent object versions transitions. See the aws_s3_bucket document for detail."

  type = list(object({
    days          = number
    storage_class = string
  }))

  default = [
    {
      days          = 7
      storage_class = "GLACIER"
    }
  ]
}

variable "noncurrent_version_expiration" {
  description = "Specifies when noncurrent object versions expire. See the aws_s3_bucket document for detail."

  type = object({
    days = number
  })

  default = null
}

variable "s3_bucket_force_destroy" {
  description = "A boolean that indicates all objects should be deleted from S3 buckets so that the buckets can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "s3_logging_target_bucket" {
  description = "The name of the bucket for log storage. The \"S3 log delivery group\" should have Objects-write und ACL-read permissions on the bucket."
  type        = string
  default     = null
}

variable "s3_logging_target_prefix" {
  description = "The prefix to apply on bucket logs, e.g \"logs/\"."
  type        = string
  default     = ""
}

#---------------------------------------------------------------------------------------------------
# DynamoDB Table for State Locking
#---------------------------------------------------------------------------------------------------

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to use for state locking."
  type        = string
  default     = "tf-remote-state-lock"
}

variable "dynamodb_table_billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "enable_replication" {
  description = "Set this to true to enable S3 bucket replication in another region"
  type        = bool
  default     = true
}

#---------------------------------------------------------------------------------------------------
# Optionally specifying a fixed bucket name
#---------------------------------------------------------------------------------------------------

variable "override_s3_bucket_name" {
  description = "override s3 bucket name to disable bucket_prefix and create bucket with static name"
  type        = bool
  default     = false
}

variable "s3_bucket_name" {
  description = "If override_s3_bucket_name is true, use this bucket name for replica instead of dynamic name with bucket_prefix"
  type        = string
  default     = ""
}
variable "s3_bucket_name_replica" {
  description = "If override_s3_bucket_name is true, use this bucket name instead of dynamic name with bucket_prefix"
  type        = string
  default     = ""
}

