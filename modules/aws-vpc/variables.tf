variable "name" {

    type = string 
    default = "staging-vpc"
}

variable "environment" {}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type = string
  default = "192.168.0.0/16"
}

variable "public_subnets" {
  description = "A map of availability zones to public cidrs"
  type        = "map"
  default     = {
    
    us-east-1a = "192.168.1.0/24",
    us-east-1b = "192.168.2.0/24",
    us-east-1c = "192.168.3.0/24"

  }
}


variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = false
}

variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  default     = []
}



/*variable "private_subnets" {
  description = "A map of availability zones to private cidrs"
  type        = "map"
  default     = {}
}




variable "private_propagating_vgws" {
  description = "A list of VGWs the private route table should propagate."
  default     = []
}

variable "bastion_ami" {
  description = "AMI to create bastion server with"

  default = {
    us-east-1 = "ami-6869aa05"
  }
}

variable "bastion_instance_type" {
  description = "Availability zone to put the NAT in"
  default     = "t2.micro"
}

variable "internal_fqdn" {
  description = "Domain to be used for internal DNS"
}

variable "legacy_cidr" {
  description = "The legacy cidr block"
}

variable "legacy_account_id" {
  description = "AWS account id of the legacy AWS"
}

variable "legacy_vpc_id" {
  description = "VPC ID of the legacy VPC"
}

variable "datadog_api_key" {
  description = "Datadog API key"
}*/
