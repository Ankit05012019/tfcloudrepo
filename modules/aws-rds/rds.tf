resource "aws_security_group" "db-security-group" {
  name                            = "${var.instance_name}-DB-SG"
  description                     = "Security Group for ${var.instance_name} DB"
  vpc_id                          = var.vpc_id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.instance_name}-DB-SG"
  }
}

resource "aws_db_instance" "db-instance" {
  identifier                      = var.instance_name
  allocated_storage               = var.allocated_storage
  iops                            = var.iops
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  name                            = var.db_name
  username                        = var.username
  password                        = var.password
  port                            = var.port
  final_snapshot_identifier       = "${var.instance_name}-final"
  allow_major_version_upgrade     = true
  skip_final_snapshot             = var.skip_final_snapshot
  maintenance_window              = var.maintenance_window
  apply_immediately               = var.apply_immediately
  vpc_security_group_ids          = [aws_security_group.db-security-group.id]
  db_subnet_group_name            = var.subnet_group_name
  multi_az                        = var.is_multi_az
  storage_type                    = var.storage_type
  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  parameter_group_name            = var.parameter_group_name
  deletion_protection             = true
  monitoring_interval             = var.monitor_interval
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_log_exports

  tags {
    Name        = var.instance_name
    Environment = var.environment
  }
}

# resource "aws_route53_record" "db-record" {
#   zone_id = var.route53_zone_id
#   name    = var.subdomain
#   type    = "CNAME"
#   ttl     = "5"
#   records = [aws_db_instance.main.address]
# }