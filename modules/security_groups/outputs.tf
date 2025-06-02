output "nginx_sg_id" {
  value = aws_security_group.nginx.id
}

output "internal_sg_id" {
  value = aws_security_group.internal.id
}