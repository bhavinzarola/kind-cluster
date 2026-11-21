provider "aws" {
  region = var.aws_region

  # Same files the AWS CLI uses. Do not set profile = "default": that lookup
  # fails when Terraform is started from make, then the provider falls through
  # to the EC2 metadata service.
  shared_credentials_files = ["${replace(pathexpand("~"), "\\", "/")}/.aws/credentials"]
  shared_config_files      = ["${replace(pathexpand("~"), "\\", "/")}/.aws/config"]
  skip_metadata_api_check  = true
}
