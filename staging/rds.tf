resource "aws_db_parameter_group" "db-parameter-group" {
  name                          = var.db_parameter_group
  family                        = var.db_family
  description                   = "RDS PG params"

  parameter {
    name  = "rds.log_retention_period"
    value = "10080"
  }

  parameter {
    name         = "max_connections"
    value        = "750"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "work_mem"
    value = "15990"    # in kB
  }

  parameter {
    name  = "maintenance_work_mem"
    value = "4684800"
  }

  parameter {
    name  = "min_wal_size"
    value = "1000"         # 1GB
  }

  parameter {
    name  = "max_wal_size"
    value = "3000"         # 3GB
  }

  parameter {
    name         = "wal_buffers"
    value        = "16000"          # 16MB
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "default_statistics_target"
    value = "500"
  }

  parameter {
    name  = "autovacuum_vacuum_scale_factor"
    value = "0.001"
  }

  parameter {
    name  = "autovacuum_analyze_scale_factor"
    value = "0.002"
  }

  parameter {
    name  = "autovacuum_naptime"
    value = "5"
  }

  parameter {
    name         = "autovacuum_max_workers"
    value        = "5"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "autovacuum_vacuum_cost_limit"
    value = "200"
  }

  parameter {
    name  = "max_standby_streaming_delay"
    value = "2400000"
  }

  parameter {
    name  = "max_standby_archive_delay"
    value = "2400000"
  }
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name                          = var.db_subnet_group_name
  subnet_ids                    = module.staging-vpc.db-subnet-ids

  tags = {
    Name = "${var.db_subnet_group_name}-db-subnet-group"
  }
}

module "db" {

  source                         = "../modules/aws-rds"
  instance_name                  = "tw-${var.environment}"
  environment                    = var.environment
  allocated_storage              = var.rds_allocated_storage
  engine                         = "postgres"
  engine_version                 = var.rds_engine_version
  instance_class                 = var.rds_instance_class
  db_name                        = var.rds_db_name
  username                       = var.rds_user
  password                       = var.rds_password
  is_multi_az                    = var.rds_is_multi_az
  storage_type                   = "gp2"
  apply_immediately              = false
  backup_retention_period        = 30
  iops                           = 0
  backup_window                  = "10:00-10:30"
  maintenance_window             = "sun:11:30-sun:12:30"
  monitor_interval               = "60"
  skip_final_snapshot            = false
  enabled_cloudwatch_log_exports = ["postgresql", "upgrade"]
  parameter_group_name           = aws_db_parameter_group.db-parameter-group.name
  subnet_group_name              = aws_db_subnet_group.db-subnet-group.name
#   route53_zone_id                = "${module.vpc.internal_route53_zone_id}"
#   subdomain                      = "db"
  vpc_id                         = module.staging-vpc.vpc-id
  cidr                           = module.staging-vpc.vpc-cidr
}