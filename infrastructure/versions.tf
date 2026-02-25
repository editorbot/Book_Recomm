terraform {
  required_version = ">= 1.0.0" # Ensure that the Terraform version is 1.0.0 or higher

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Specify the source of the AWS provider
      version = "~> 4.0"        # Use a version of the AWS provider that is compatible with version
    }
  }
}

provider "aws" {
  region = "us-east-1" # Set the AWS region to US East (N. Virginia)

  # This skips the IMDS/EC2 metadata lookup that is hanging/failing on Windows local
  skip_credentials_validation = false
  skip_requesting_account_id  = false
  skip_metadata_api_check     = true   # ← Key line! This stops the 169.254 attempt
}