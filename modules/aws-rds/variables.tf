variable "allocated_storage" {
  description           = "Integer with the number of GB to allocate"
}

variable "apply_immediately" {
  default               = true
  description           = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
}

variable "backup_retention_period" {
  description           = "Number of days to keep backups"
}

variable "backup_window" {
  description           = "Backup window timeframe"
}

variable "cidr" {
  description           = "cidr block which has access to RDS"
}

variable "instance_name" {
  description           = "Name of the RDS instance"
}

variable "db_name" {
  description           = "Name of the database"
  default                 = ""
}

variable "enabled_cloudwatch_log_exports" {
  description           = "enabled cloudwatch log exports"
  default               = []
}

variable "enabled_replica" {
  description           = "Enable replica"
  default               = false
}

variable "engine" {
  description           = "RDS DB engine"
  default               = "postgres"
}

variable "engine_version" {
  default               = ""
  description           = "DB engine version"
}

variable "environment" {}

variable "iops" {
  default               = 0
  description           = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
}

variable "instance_class" {
  description           = "Instance class to launch the database on"
  default               =   ""
}

variable "is_multi_az" {
  default               = true
}

variable "maintenance_window" {
  default               = ""
  description           = "Maintenance window time"
}

variable "monitor_interval" {
  description           = "Monito Interval Count"
  default               = "0"
}

variable "parameter_group_name" {
  description           = "parameter group name"
}

variable "password" {
  description           = "Database password"
  default               = "admin"
}

variable "port" {
  default               = "5432"
}

# variable "route53_zone_id" {
#   description           = "Route53 zone ID to set up the DNS entry"
# }

variable "security_group_ids" {
  type                  = "list"
  default               = []
  description           = "List of VPC security group IDs"
}

variable "skip_final_snapshot" {
  default               = false
  description           = "Skip the creation of the final database snapshot on destroy"
}

variable "storage_type" {
  description           = "'gp2' for general purpose SSD or 'io1' for provisined IOPS SSD. Automatically defaults to io1 if `iops` variable is specified"
}

variable "subnet_group_name" {
  description           = "Subnet Group name"
}

# variable "subdomain" {
#   description           = "Subdomain name to setup a DNS record for"
# }

variable "username" {
  description           = "Database username"
  default               = "admin"
}

variable "vpc_id" {}