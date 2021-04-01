/* 
Resource Creation for Logging.
- S3 Bucket, Bucket Policy and IAM Access to the Bucket
*/

# s3 Bucket
resource "aws_s3_bucket" "s3-log-bucket" {
  bucket        = var.log_bucket_name
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "${var.environment_name}-log-bucket"
    Environment = var.environment_name
  }
}

# TODO: To be updated once we get Configuration from WordPress VIP

# Logging Bucket Policy
# resource "aws_s3_bucket_policy" "s3-log-bucket-policy" {
#   bucket = aws_s3_bucket.s3-log-bucket.id
#   policy = jsonencode({
#              Version = "2012-10-17"
#              Id      = "MyBucketPolicy"
#              Statement = [
#                {
#                   Sid       = "AllowPublicRead",
#                   Effect    = "Allow",
#                   Principal = {"AWS":"*"},
#                   Action    = ["s3:GetObject"],
#                   Resource = [
#                          aws_s3_bucket.s3-log-bucket.arn,
#                         "${aws_s3_bucket.s3-log-bucket.arn}/*",
#                    ]
#               },
#             ]
#          })
# }

# Logging Bucket IAM Group Policy
resource "aws_iam_group_policy" "s3-log-bucket-iam-policy" {
  
  name  = "developer_bucket_policy_${aws_s3_bucket.s3-log-bucket.id}"
  group = "developer"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = [
              aws_s3_bucket.s3-log-bucket.arn,
             "${aws_s3_bucket.s3-log-bucket.arn}/*"

        ]
      },
    ]
  })
  
}
