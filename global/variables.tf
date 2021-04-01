variable "bucket_name" {
    type = list
    default = ["demobacket-tw-1","demobucket-tw-2"]
   
}

# logging Bucket Name
variable "log_bucket_name" {
  type    = string
  default = "demobacket-tw-logs"
}

variable "aws_users" {

  type = list
  default = ["ankit.tripathi@scaleworx.io","tfcloud","random","rohan"]

}

variable "devops_group_users" {

  type = list
  default = ["ankit.tripathi@scaleworx.io"]
}


variable "budget_name" {

    type = string 
    default = "tf-test-budget"
}


variable "budget_type" {

    type = string 
    default = "COST"
}

variable "limit_amount" {

    type = number
    default = 10

}

variable "time_unit" {

     type = string
     default = "MONTHLY"

}

variable "email_addresses" {

     type = list
     default = ["tripathi.ankitjnj@gmail.com"]

}
