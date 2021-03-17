# Group Creation 
resource "aws_iam_group" "aws-group" {
  for_each = toset(var.aws_groups)
  name     = "${each.value}"
}

# Group Membership Management for Admin, Devops and Developer groups
resource "aws_iam_group_membership" "devops-group-membership" {
  name = "devops-group-membership"
  users = "${var.devops_group_users}"
  group = "devops"
}
resource "aws_iam_group_membership" "developer-group-membership" {
  name = "developer-group-membership"
  users = "${var.developer_group_users}"
  group = "developer"
}
resource "aws_iam_group_membership" "admin-group-membership" {
  name = "admin-group-membership"
  users = "${var.admin_group_users}"
  group = "admin"
}

# Group Policy Attachments
resource "aws_iam_group_policy" "group-policy" {
  for_each = toset(var.aws_groups)
  name   = "${each.key}-policy"
  group  = "${each.key}"
  policy = "${file("${path.module}/policies/${each.key}-policy.json")}"
}