variable "bucket_name" {
    type = list
    default = ["demobacket-tw-1","demobucket-tw-2"]
   
}

variable "aws_users" {

  type = list
  default = ["ankit.tripathi@scaleworx.io","tfcloud","random","rohan"]

}

variable "devops_group_users" {

  type = list
  default = ["ankit.tripathi@scaleworx.io"]
}

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