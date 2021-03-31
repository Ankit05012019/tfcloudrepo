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

     type = string 
     default = "0.0.0.0"

}