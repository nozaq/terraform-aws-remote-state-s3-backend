provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

provider "aws" {
  alias  = "replica"
  region = var.replica_region
}

module "remote_state" {
  source                  = "../../"
  override_s3_bucket_name = true
  s3_bucket_name          = "my-fixed-bucket-name-remote-state"
  s3_bucket_name_replica  = "my-fixed-bucket-replica-name-remote-state"

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}

resource "aws_iam_user" "terraform" {
  name = "TerraformUser"
}

resource "aws_iam_user_policy_attachment" "remote_state_access" {
  user       = aws_iam_user.terraform.name
  policy_arn = module.remote_state.terraform_iam_policy.arn
}
