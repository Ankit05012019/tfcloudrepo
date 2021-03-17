module "aws-user-management" {

    source = "../modules/aws-user-management"
    aws_user = var.aws_user
    devops_group_users = var.devops_group_users
  
}