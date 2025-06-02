resource "aws_security_group" "nginx" {
    name                = "${var.name}-nginx-sg"
    description         = "Allow HTTP/HTTPS from the internet, SSH for admin"
    vpc_id              = var.vpc_id

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.admin_ip]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-nginx-sg"
    }
}

resource "aws_security_group" "internal" {
    name            = "${var.name}-internal-sg"
    description     = "Allow internal communication"
    vpc_id          = var.vpc_id 
    
    ingress {
        description     = "Allow from NGINX SG"
        from_port       = 5432
        to_port         = 5432
        protocol        = "tcp"
        security_groups = [aws_security_group.nginx.id]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.name}-internal-sg"
    }
}



