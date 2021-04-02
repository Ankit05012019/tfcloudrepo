variable "private-subnet-ids" {

type = set(string) 

}

variable "vpc-id"  {

 type = string 

} 

resource "aws_eks_cluster" "eks-cluster" {
  
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  version                   = var.cluster_version
  tags                      = var.tags

  vpc_config {
    #security_group_ids       = aws_security_group.cluster.id
    subnet_ids              = var.private-subnet-ids #module.aws-vpc.private-subnet-ids

  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }


  depends_on = [
    aws_security_group_rule.cluster_egress_internet,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy1,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController1
    
  ]
}

resource "aws_security_group_rule" "cluster_private_access" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = var.cluster_endpoint_private_access_cidrs

  security_group_id = aws_security_group.cluster.id
}



resource "aws_security_group" "cluster" {
  
  name_prefix = var.cluster_name
  description = "EKS cluster security group."
  vpc_id      = var.vpc-id #module.aws-vpc.vpc-id
  tags = merge(
    var.tags,
    {
      "Name" = "${var.cluster_name}-eks_cluster_sg"
    },
  )
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  description       = "Allow cluster egress access to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}


resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  description = "Allow cluster to manage node groups, fargate nodes and cloudwatch logs"
  force_detach_policies = true
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "eks.amazonaws.com",
          "eks-fargate-pods.amazonaws.com"
          ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy1"{
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController1" {
policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
role       = aws_iam_role.eks_cluster_role.name
}


/* Node group */


resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "${var.cluster_name}-${var.environment}-node_group"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  subnet_ids      = var.private-subnet-ids

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 3
  }

  instance_types  = var.eks_node_group_instance_types
}


resource "aws_iam_role" "eks-node-group-role" {
  name = "${var.cluster_name}-node-group_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role.name
}