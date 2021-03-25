resource "aws_s3_bucket" "s3-bucket" {
  
  for_each = toset(var.bucket_name) 
  bucket = each.key
  acl    = var.acl
  force_destroy = true

  tags = {
    Name        = "${var.environment_name}-bucket"
    Environment = var.environment_name
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}

resource "aws_s3_bucket_policy" "bucket-policy" {

  for_each = toset(var.bucket_name)
  bucket = aws_s3_bucket.s3-bucket[each.key].id

  policy = jsonencode({
             Version = "2012-10-17"
             Id      = "MyBucketPolicy"
             Statement = [
               {
                  Sid       = "AllowPublicRead",
                  Effect    = "Allow",
                  Principal = {"AWS":"*"},
                  Action    = ["s3:GetObject"],
                  Resource = [
                         aws_s3_bucket.s3-bucket[each.key].arn,
                        "${aws_s3_bucket.s3-bucket[each.key].arn}/*",
                   ]
              },
            ]
         })
}



resource "aws_iam_group_policy" "bucket_policy" {
  
  for_each = toset(var.bucket_name)
  name  = "developer_bucket_policy_${aws_s3_bucket.s3-bucket[each.key].id}"
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
              aws_s3_bucket.s3-bucket[each.key].arn,
             "${aws_s3_bucket.s3-bucket[each.key].arn}/*"

        ]
      },
    ]
  })
  
}


resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}


