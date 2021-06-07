variable "cluster_name" {
  type    = string
  default = "tf-test-cluster"
}

variable "cluster_version" {
  type    = number
  default = 1.19
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

variable "environment" {
  type    = string
  default = "staging"
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
  default = false
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