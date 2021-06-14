
variable "name" {

    type = string 
    default = "staging-vpc"
}

variable "environment" {

    type = string 
    default = "eks-test"
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
    
    us-east-1a = "192.168.16.0/20",
    us-east-1b = "192.168.32.0/20",
    us-east-1c = "192.168.48.0/20"  

  }
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}


variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "private_subnets_app" {
  description = "A map of availability zones to private cidrs"
  type        = "map"
  default     = {

    us-east-1a = "192.168.128.0/20",
    us-east-1b = "192.168.64.0/20",
    us-east-1c = "192.168.96.0/20"

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
/*variable "public_propagating_vgws" {
  description = "A list of VGWs the public route table should propagate."
  default     = []
}*/


/*EKS variables */

/*
variable "cluster_name" {
  type    = string
  default = "tf-test-cluster"
}

variable "cluster_version" {
  type    = number
  default = 1.18
}

variable "cluster_service_ipv4_cidr" {
  type    = string
  default = "172.20.0.0/16"
}

variable "cluster_endpoint_private_access_cidrs" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "eks_node_group_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = false 
}


variable "namespaces" {
  type    = set(string)
  default = ["fargate"]
}
variable "private_subnet_ids" {
  type    = set(string)
  default = []
}

variable "tags" {
  type = map(string)
  default = {
    name = "tf-test-cluster"
  }

}

variable "vpc_id" {
  type    = string
  default = ""
} 

variable "enable_spot_instances" {

  type = bool
  default = true

}

variable "eks_spot_node_group_instance_types" {
  type    = list(string)
  default = ["t3.medium","t2.medium"]
}

variable "spot_node_group_desired" {

  type = number
  default = 1

}

variable "spot_node_group_max_size" {

  type = number
  default = 2
  
}
 variable "spot_node_group_min_size" {

  type = number
  default = 1
  
}


variable "node_group_desired" {

  type = number
  default = 1

}

variable "node_group_max_size" {

  type = number
  default = 2
  
}
 variable "node_group_min_size" {

  type = number
  default = 1
  
}
*/