variable "bucket_name" {
    type = String
    default = "my-tf-test-bucket"
   
}

variable "environment_name" {

    type = string
    default  = "dev"
}


variable "acl" {

    type = string 
    default = "private"
}
