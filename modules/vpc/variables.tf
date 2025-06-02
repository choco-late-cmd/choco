variable "name" {
    description = "Name prefix for all resources"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string  
}

variable "public_subnet_cidrs" {
    description = "List of public subnet CIDR blocks"
    type        = list(string)
}

variable "private_subnet_cidrs" {
    description = "list of private subnet CIDR blocks"
    type        = list(string) 
}

variable "azs" {
    description = "List of availability zones"
    type        = list(string)
}