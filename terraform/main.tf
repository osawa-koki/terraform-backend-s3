
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  backend "s3" {
    region  = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
