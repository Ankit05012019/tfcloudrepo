variable "bucket_name" {
    type = list
    default = []
   
}

variable "environment_name" {

    type = string
    default  = "dev"
}


variable "acl" {

    type = string 
    default = "private"
}
