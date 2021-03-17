variable "aws_users" {
  default = []
}

variable "aws_groups" {
  default = ["admin",
    "developer",
    "devops"
  ]
}

variable "devops_group_users" {
  default = []
}

variable "developer_group_users" {
  default = []
}

variable "admin_group_users" {
  default = []
}
