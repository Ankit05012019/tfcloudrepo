# User Creation
resource "aws_iam_user" "aws-user" {
  for_each      = toset(var.aws_users)
  name          = "${each.key}"
  force_destroy = "false"
}
