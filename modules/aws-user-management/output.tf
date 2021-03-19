/*output "group_ids" {

    value = aws_iam_group.aws-group
  
}*/

output "password" {


     value = tomap({
    for name , user in aws_iam_user.aws-user : name => user.encrypted_password
  })
}