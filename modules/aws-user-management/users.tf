# User Creation
resource "aws_iam_user" "knotch-aws-user" {
  for_each      = toset(var.aws_users)
  name          = "${each.value}"
  force_destroy = "false"
}
