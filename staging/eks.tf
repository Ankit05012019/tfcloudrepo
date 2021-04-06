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

   source                                 = "../modules/aws-eks-fargate"
   cluster_name                           = var.cluster_name
   cluster_version                        = var.cluster_version 
   tags                                   = var.tags 
   cluster_service_ipv4_cidr              = var.cluster_service_ipv4_cidr
   cluster_endpoint_private_access_cidrs  = var.cluster_endpoint_private_access_cidrs
   vpc-id                                 =  module.staging-vpc.vpc-id
   private-subnet-ids                     =  module.staging-vpc.private-subnet-ids
   eks_node_group_instance_types          = var.eks_node_group_instance_types
   cluster_endpoint_private_access        = var.cluster_endpoint_private_access
   cluster_endpoint_public_access         = var.cluster_endpoint_public_access
}


module "eks2" {

   source                                 = "../modules/aws-eks-fargate"
   cluster_name                           = var.cluster_name2
   cluster_version                        = var.cluster_version 
   tags                                   = var.tags2
   cluster_service_ipv4_cidr              = var.cluster_service_ipv4_cidr
   cluster_endpoint_private_access_cidrs  = var.cluster_endpoint_private_access_cidrs
   vpc-id                                 =  module.staging-vpc.vpc-id
   private-subnet-ids                     =  module.staging-vpc.private-subnet-ids
   eks_node_group_instance_types          = var.eks_node_group_instance_types
   cluster_endpoint_private_access        = var.cluster_endpoint_private_access
   cluster_endpoint_public_access         = var.cluster_endpoint_public_access
}
