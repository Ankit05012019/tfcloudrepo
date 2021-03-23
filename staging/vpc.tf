module "staging-vpc" {


    source               = "../modules/aws-vpc"
    cidr_block           = var.cidr
    Name                 = var.name
    environment          = var.environment
    public-subnet        = var.public_subnets

}