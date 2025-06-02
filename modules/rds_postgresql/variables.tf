variable "name" {
  description = "Name prefix"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "internal_sg_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.5"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage in GB"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "DB admin username"
  type        = string
}

variable "db_password" {
  description = "DB admin password"
  type        = string
  sensitive   = true
}