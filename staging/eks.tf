module "eks" {

  source                                = "../modules/aws-eks-fargate"
  cluster_name                          = var.cluster_name
  cluster_version                       = var.cluster_version
  tags                                  = var.tags
  cluster_service_ipv4_cidr             = var.cluster_service_ipv4_cidr
  cluster_endpoint_private_access_cidrs = var.cluster_endpoint_private_access_cidrs
  vpc_id                                = module.staging-vpc.vpc-id
  private_subnet_ids                    = module.staging-vpc.private-subnet-ids
  eks_node_group_instance_types         = var.eks_node_group_instance_types
  cluster_endpoint_private_access       = var.cluster_endpoint_private_access
  cluster_endpoint_public_access        = var.cluster_endpoint_public_access
  namespaces                            = var.namespaces
  enable_spot_instances                 = var.enable_spot_instances 
  eks_spot_node_group_instance_types    = var.eks_spot_node_group_instance_types
  spot_node_group_desired               = var.spot_node_group_desired
  spot_node_group_max_size              = var.spot_node_group_max_size
  spot_node_group_min_size              = var.spot_node_group_min_size

}