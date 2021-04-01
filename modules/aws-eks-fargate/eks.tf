
module "aws-vpc" {


    source               =  "../modules/aws-vpc"
    cidr                 =  var.cidr
    name                 =  var.name
    environment          =  var.environment
    public_subnets       =  var.public_subnets
    /*private_subnets_db   =  var.private_subnets_db
    private_subnets_app  =  var.private_subnets_app*/
    enable_dns_hostnames =  var.enable_dns_hostnames
    enable_dns_support   =  var.enable_dns_support


}




resource "aws_eks_cluster" "eks-cluster" {
  
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  version                   = var.cluster_version
  tags                      = var.tags

  vpc_config {
    security_group_id       = aws_security_group.cluster.id
    subnet_ids              = module.aws-vpc.private-subnet-ids

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
  vpc_id      = var.vpc_idmodule.aws-vpc.vpc-id
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