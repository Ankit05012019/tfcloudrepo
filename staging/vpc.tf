module "staging-vpc" {


    source               =  "../modules/aws-vpc"
    cidr                 =  var.cidr
    name                 =  var.name
    environment          =  var.environment
    public_subnets       =  var.public_subnets
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support   = var.enable_dns_support


}