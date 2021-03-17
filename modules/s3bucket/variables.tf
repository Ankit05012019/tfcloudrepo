variable "bucket_name" {
    type = string
    default = ["firstdemobucket",]
   
}

variable "environment_name" {

    type = string
    default  = "dev"
}


variable "acl" {

    type = string 
    default = "private"
}
