/*data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}*/

module "eks" {

   source                         = ../modules/aws-eks-fargate
   cluster_name                   = var.cluster_name
   cluster_vaerison               = var.cluster_version 
   tags                           = var.tags 
   cluster_service_ipv4_cidr      = var.cluster_service_ipv4_cidr
   cluster_endpoint_private_access_cidrs  = var.cluster_endpoint_private_access_cidrs


}

