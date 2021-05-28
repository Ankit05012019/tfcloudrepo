variable "region" {
  description = "Region to deploy server"
  type        = string
  default     = "us-east-1"
}

variable "openvpn_username" {
  description = "Admin Username to access server"
  type        = string
  default     = "openvpn"
}

variable "openvpn_password" {
  description = "Admin Password to access server"
  type        = string
  default     = "password"
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address to the OpenVPN instance."
  default     = true
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the security group(s)."
  type        = string
  default     = "vpc-0797952431ebe1228"
}

variable "subnet_id" {
  description = "List of Subnet IDs to launch the instance in (e.g.: ['subnet-0zfg04s2','subnet-6jm2z54q'])."
  type        = string
  default     =  "subnet-0c9a91e67540719a1"
}


