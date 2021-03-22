# User Creation
resource "aws_iam_user" "aws-user" {
  for_each      = toset(var.aws_users)
  name          = "${each.key}"
  force_destroy = "false"
}

/*resource "aws_iam_user_login_profile" "profile" {
  
  for_each      = toset(var.aws_users)
  user    = aws_iam_user.aws-user[each.key].name
  pgp_key = base64encode(file(var.key_path))

}*/