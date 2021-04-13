# output "db_hostname" {
#   value         = "${element(concat(aws_route53_record.db.*.fqdn, list("")), 0)}"
# }

output "db_name" {
  description   = "Address of RDS instance"
  value         = aws_db_instance.db-instance.name
}

output "db_port" {
  description   = "Port of the RDS instance"
  value         = aws_db_instance.db-instance.port
}
