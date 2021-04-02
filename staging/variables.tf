
variable "name" {

    type = string 
    default = "staging-vpc"
}

variable "environment" {

    type = string 
    default = "staging"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type = string
  default = "192.168.0.0/16"
}

variable "public_subnets" {

  description = "A map of availability zones to public cidrs"
  type        = "map"
  default     = {
    
    us-east-2a = "192.168.1.0/24",
    us-east-2b = "192.168.2.0/24",
    us-east-2c = "192.168.3.0/24"

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

variable "private_subnets_app" {
  description = "A map of availability zones to private cidrs"
  type        = "map"
  default     = {

    us-east-2a = "192.168.4.0/24",
    us-east-2b = "192.168.5.0/24",
    us-east-2c = "192.168.6.0/24"

  }
}


variable "private_subnets_db" {
  description = "A map of availability zones to private cidrs"
  type        = "map"
  default     = {

    us-east-2a = "192.168.7.0/24",
    us-east-2b = "192.168.8.0/24",
    us-east-2c = "192.168.9.0/24"

  }
}
/*variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  default     = []
}*/



### EKS module 

variable "cluster_name" {
  
     type = string 
     default = "my-cluster-eks"

}

variable "cluster_version" {

      type = number 
      default = 1.18

}

variable "tags" {

     type = "map"
     default = {

         name = "my-cluster-eks"
     }

}

variable "cluster_service_ipv4_cidr" {

     type = string
     default = "172.20.0.0/16"

}


variable "cluster_endpoint_private_access_cidrs" {

     type = list 
     default = ["0.0.0.0/0"]

}

variable "eks_node_group_instance_types" {

    type = string
    default = "t3.medium"

}