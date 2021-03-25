variable "budget_name" {

    type = string 
    default = ""
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
     default = "DAILY"

}

variable "email_addresses" {

     type = list
     default = []

}