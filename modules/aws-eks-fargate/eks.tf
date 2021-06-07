
resource "aws_eks_cluster" "eks-cluster" {

  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version
  tags     = var.tags

  vpc_config {
    security_group_ids      = ["${aws_security_group.cluster.id}"]
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    subnet_ids              = var.private_subnet_ids #module.aws-vpc.private-subnet-ids

  }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_service_ipv4_cidr
  }

  /*worker_groups = [
    {
      name                = "on-demand-1"
      instance_type       = "t2.medium"
      asg_max_size        = 1
      kubelet_extra_args  = "--node-labels=node.kubernetes.io/lifecycle=normal"
      suspended_processes = ["AZRebalance"]
    },
    {
      name                = "spot-1"
      spot_price          = "0.042"
      instance_type       = "t3.medium"
      asg_max_size        = 3
      kubelet_extra_args  = "--node-labels=node.kubernetes.io/lifecycle=spot"
      suspended_processes = ["AZRebalance"]
    }
  ]*/

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
  vpc_id      = var.vpc_id #module.aws-vpc.vpc-id
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
  name                  = "${var.cluster_name}-cluster-role"
  description           = "Allow cluster to manage node groups, fargate nodes and cloudwatch logs"
  force_detach_policies = true
  assume_role_policy    = <<POLICY
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

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy1" {
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
  node_group_name = "${var.cluster_name}-${var.environment}-ondemand_node_group"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = var.eks_node_group_instance_types
}



resource "aws_eks_node_group" "eks-node-group-spot" {

  count           = var.enable_spot_instances == true ? 1 : 0
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "${var.cluster_name}-${var.environment}-spot_node_group"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  capacity_type   = "SPOT"
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.spot_node_group_desired
    max_size     = var.spot_node_group_max_size
    min_size     = var.spot_node_group_min_soze
  }

  instance_types = var.eks_spot_node_group_instance_types
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