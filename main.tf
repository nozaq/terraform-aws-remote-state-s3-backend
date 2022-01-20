terraform {
  required_version = ">= 1.1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.39.0"

      configuration_aliases = [aws.replica]
    }
  }
}
