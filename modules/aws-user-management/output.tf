output "group_ids" {

    value = aws_iam_group.aws-group[*]
  
}

output "password" {


     value = aws_iam_user.aws-user[*]
}