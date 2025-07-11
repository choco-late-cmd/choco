provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket         = "tf-state-choco381"
    key            = "dev/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock" 
    encrypt        = true
  }
}

# VPC
module "vpc" {
  source               = "../../modules/vpc"
  name                 = "dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  azs                  = ["eu-north-1a", "eu-north-1b"]
}

# Security Groups
module "security_groups" {
  source    = "../../modules/security_groups"
  name      = "dev"
  vpc_id    = module.vpc.vpc_id
  admin_ip  = "79.175.83.8/32"
}

# IAM Role and Instance Profile for NGINX EC2
resource "aws_iam_role" "nginx_instance" {
  name = "nginx-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.nginx_instance.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "nginx_instance" {
  name = "nginx-instance-profile"
  role = aws_iam_role.nginx_instance.name
}

# NGINX Instance
module "nginx_instance" {
  source           = "../../modules/nginx_instance"
  name             = "dev"
  ami_id           = "ami-0989fb15ce71ba39e"
  instance_type    = "t3.micro"              
  public_subnet_id = module.vpc.public_subnet_ids[0]
  nginx_sg_id      = module.security_groups.nginx_sg_id
  key_name         = "chocolate"
  iam_instance_profile = aws_iam_instance_profile.nginx_instance.name
  user_data = file("${path.module}/config-script.sh")
}

# RDS PostgreSQL
module "rds_postgresql" {
  source            = "../../modules/rds_postgresql"
  name              = "dev"
  private_subnet_ids = module.vpc.private_subnet_ids
  internal_sg_id    = module.security_groups.internal_sg_id
  db_username       = "chocolate"
  db_password       = var.db_password
  instance_class    = "db.t3.micro"         
  allocated_storage = 20                     
  engine_version    = "17.2"
}