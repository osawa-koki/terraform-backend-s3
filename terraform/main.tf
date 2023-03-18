
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.59.0"
    }
  }

  backend "s3" {
    region  = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
