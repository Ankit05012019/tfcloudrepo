module "staging-vpc" {


    source               =  "../modules/aws-vpc"
    cidr                 =  var.cidr
    name                 =  var.name
    environment          =  var.environment
    public_subnets_app   =  var.public_subnets_app
    public_subnets_db    = var.public_subnet_db
    private_subnets      =  var.private_subnets
    enable_dns_hostnames =  var.enable_dns_hostnames
    enable_dns_support   =  var.enable_dns_support


}