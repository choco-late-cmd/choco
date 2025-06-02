variable "name" {
  description = "Name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "admin_ip" {
  description = "Admin IP for SSH access (e.g., your public IP with /32)"
  type        = string
}