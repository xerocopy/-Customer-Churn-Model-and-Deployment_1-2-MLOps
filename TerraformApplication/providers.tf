terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
# provider "aws" {
#   region     = "us-east-1"
#   shared_credentials_file = ".aws/creds/creds"
#   profile    = "default"
# }

provider "aws" {
    profile = "ML_DevOps_User"
    region = "us-east-1"
}


# terraform {
#   backend "s3" {
#     bucket = "terraform-backends-churn"
#     key    = "churn-application/backend/terraform.tfstate"
#     region = "us-east-1"
#     shared_credentials_file = ".aws/creds/creds"
#   }
#}

terraform {
  backend "s3" {
    bucket = "terraform-backends-churn-123"
    key    = "churn-application/backend/terraform.tfstate"
    region = "us-east-1"
    profile = "ML_DevOps_User"
  }
}


# edit
resource "aws_s3_bucket" "b" {
  bucket = "terraform-backends-churn-123"
  
  tags = {
    Name = "My bucket"
    Environment = "Dev"
  }
  
}