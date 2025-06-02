output "nginx_public_ip" {
  value = module.nginx_instance.nginx_public_ip
}

output "db_instance_endpoint" {
  value = module.rds_postgresql.db_instance_endpoint
}