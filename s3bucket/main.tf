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


resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name
  acl    = var.acl

  tags = {
    Name        = "Tf-test-bucket"
    Environment = var.environment_name
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.mybucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MyBucketPolicy"
    Statement = [
      {
        Sid       = "AllowPublicRead",
        Effect    = "Allow",
        Principal = {"AWS","*"},
        Action    = ["s3:GetObject"],
        Resource = [
          aws_s3_bucket.b.arn,
          "${aws_s3_bucket.mybucket.arn}/*",
        ]
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "*"
          }
        }
      },
    ]
  })
}


