# User Creation
resource "aws_iam_user" "knotch-aws-user" {
  for_each      = toset(var.aws_users)
  name          = "${each.key}"
  force_destroy = "false"
}
