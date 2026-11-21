provider "aws" {
  region = var.aws_region

  # Use the local AWS CLI profile instead of the EC2 instance metadata service.
  profile                  = "default"
  shared_credentials_files = [pathexpand("~/.aws/credentials")]
  shared_config_files      = [pathexpand("~/.aws/config")]
  skip_metadata_api_check  = true
}
