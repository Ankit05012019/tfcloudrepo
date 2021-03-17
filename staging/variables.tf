variable "bucket_name" {
    type = list
    default = ["demobacket-tw-1","demobucket-tw-2"]
   
}

variable "aws_users" {
  type = list
  default = ["ankit.tripathi@scaleworx.io"]
}

variable "devops_group_users" 
{
  type = list
  default = ["ankit.tripathi@scaleworx.io"]
}