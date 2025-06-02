output "nginx_instance_id" {
  value = aws_instance.nginx.id
}

output "nginx_public_ip" {
  value = aws_instance.nginx.public_ip
}