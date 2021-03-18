output "group_ids" {

    value = aws_iam_group.aws-group[*]
  
}