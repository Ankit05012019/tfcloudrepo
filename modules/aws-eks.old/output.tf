output "aws_auth_roles" {
  description = "Roles for use in aws-auth ConfigMap"
  value = [
    for k, v in local.node_groups_expanded : {
      worker_role_arn = lookup(v, "iam_role_arn", var.default_iam_role_arn)
      platform        = "linux"
    }
  ]
}