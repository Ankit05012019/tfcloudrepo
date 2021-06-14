module "prod-vpc" {


  source               = "../modules/aws-vpc"
  cidr                 = var.cidr
  name                 = var.name
  environment          = var.environment
  public_subnets       = var.public_subnets
  private_subnets_db   = var.private_subnets_db
  private_subnets_app  = var.private_subnets_app
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  cluster_name         = "test_cluster_prod"

}


data "terraform_remote_state" "test" {
    backend = "remote"
    config = {
      organization = "scaleworx"
      workspaces {
      name = "test-eks-spot"
    }

    }
}

resource "aws_vpc_peering_connection" "test-peering" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = terraform_remote_state.test.module.staging-vpc.vpc-id
  vpc_id        = module.prod-vpc.vpc-id
  peer_region   = "us-east-1"

  depends_on  = []
}
