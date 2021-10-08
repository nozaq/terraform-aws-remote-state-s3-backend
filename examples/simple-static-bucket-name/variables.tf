variable "access_key" {
}

variable "secret_key" {
}

variable "region" {
  description = "The AWS region in which resources are set up."
  default     = "us-east-1"
}


variable "replica_region" {
  description = "The AWS region to which the state bucket is replicated."
  default     = "us-west-1"
}

