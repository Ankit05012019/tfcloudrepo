variable "aws_users" {

  type = list
  default = []
}

variable "aws_groups" {

  type =  list
  default = ["admin",
    "developer",
    "devops"
  ]
}

variable "devops_group_users" {
  type = list
  default = []
}

variable "developer_group_users" {
  type = list
  default = []
}

variable "admin_group_users" {

  type = list
  default = []
}
