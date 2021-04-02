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

variable "environment" {

    type = string 
    default = "staging"
}

variable "eks_node_group_instance_types" {

    type = list(string)
    default = ["t3.medium"]

}

variable "cluster_endpoint_private_access" {

    type = bool
    default = true

}

variable "cluster_endpoint_public_access"  {

   type = bool
   default = false

}