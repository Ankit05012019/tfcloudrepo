terraform {
  backend "remote" {
    organization = "scaleworx"

    workspaces {
      name = "s3bucket"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}


resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  acl    = var.acl

  tags = {
    Name        = "Tf test bucket"
    Environment = var.environment_name
  }

  versioning {
    enabled = true
  }
}


