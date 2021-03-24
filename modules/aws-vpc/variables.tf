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

/*variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  default     = []
}*/



variable "private_subnets" {
  description = "A map of availability zones to private cidrs"
  type        = "map"
  default     = {

    us-east-1a = "192.168.4.0/24",
    us-east-1b = "192.168.5.0/24",
    us-east-1c = "192.168.6.0/24"

  }
}


variable "private_subnets_db" {
  description = "A map of availability zones to private cidrs"
  type        = "map"
  default     = {

    us-east-1a = "192.168.7.0/24",
    us-east-1b = "192.168.8.0/24",
    us-east-1c = "192.168.9.0/24"

  }
}




