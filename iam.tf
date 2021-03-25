module "aws-user-management" {

    source = "../modules/aws-user-management"
    aws_users = var.aws_users
    devops_group_users = var.devops_group_users
  
}

/*output "user-details" {

    value = "${module.aws-user-management.password}"
  
}*/