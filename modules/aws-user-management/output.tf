output "group_ids" {

    for_each = toset(var.aws_groups)
    value = aws_iam_group.aws-group[each.key].name
  
}