module "staging-vpc" {


    source               = "../modules/aws-vpc"
    cidr          = var.cidr
    name                 = var.name
    environment          = var.environment
    public_subnets        = var.public_subnets

}