resource "aws_s3_bucket" "mybucket" {
  
  for_each = toset(var.bucket_name) 
  bucket = each.key
  acl    = var.acl
  force_destroy = true

  tags = {
    Name        = "${var.environment_name}-bucket"
    Environment = var.environment_name
  }

}

resource "aws_s3_bucket_policy" "bucket_policy" {

  for_each = toset(var.bucket_name)
  bucket = aws_s3_bucket.mybucket[each.key].id

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
                         aws_s3_bucket.mybucket.arn,
                        "${aws_s3_bucket.mybucket.arn}/*",
                   ]
              },
            ]
         })
}



/*resource "aws_iam_group_policy" "bucket_policy" {

  name  = "developer_bucket_policy_${aws_s3_bucket.}"
  group = aws_iam_group.my_developers.name

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
             "aws_s3_bucket.mybucket.arn",
             "${aws_s3_bucket.mybucket.arn}/*"

        ]
      },
    ]
  })
  
}*/
