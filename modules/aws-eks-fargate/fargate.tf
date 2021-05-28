data "aws_iam_policy_document" "assume-role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "pod-execustion-role" {
  for_each           = toset(var.namespaces)
  name               = format("tw-%s-fargate-%s", var.cluster_name, each.value)
  #assume_role_policy = data.aws_iam_policy_document.assume-role.json
  assume_role_policy    = <<POLICY
 {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "eks-fargate-pods.amazonaws.com",
            ]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
POLICY
  tags = merge(var.tags,
    { Namespace = each.value },
    { "kubernetes.io/cluster/${var.cluster_name}" = "owned" },
  { "k8s.io/cluster/${var.cluster_name}" = "owned" })
}

resource "aws_iam_role_policy_attachment" "attachment_main" {
  for_each   = toset(var.namespaces)
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.pod-execustion-role[each.value].name
}

resource "aws_eks_fargate_profile" "fargate-profile" {
  for_each               = toset(var.namespaces)
  cluster_name           = var.cluster_name
  fargate_profile_name   = format("tw-%s-fargate-%s", var.cluster_name, each.value)
  pod_execution_role_arn = aws_iam_role.pod-execustion-role[each.value].arn
  subnet_ids             = var.private_subnet_ids

  tags = merge(var.tags,
    { Namespace = each.value },
    { "kubernetes.io/cluster/${var.cluster_name}" = "owned" },
  { "k8s.io/cluster/${var.cluster_name}" = "owned" })

  selector {
    namespace = each.value
  }
}