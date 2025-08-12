resource "aws_security_group" "web_sg" {
    description = "web security group"
    vpc_id = var.vpc_id
    
    ingress {
        description = "ssh"
        protocol    = "tcp"
        from_port   = 22
        to_port     = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "http from Load Balancer"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        security_groups = [aws_security_group.alb_sg.id]
    }

    ingress {
        description = "https from Load Balancer"
        protocol = "tcp"
        from_port = 443
        to_port = 443
        security_groups = [aws_security_group.alb_sg.id]  
    }
    egress {
        description = "all"
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web-sg"
    }

}

resource "aws_security_group" "app_sg" {
    description = "app security group"
    vpc_id = var.vpc_id
    
    ingress {
        description = "app port from web SG"
        protocol = "tcp"
        from_port = var.app_port
        to_port = var.app_port
        security_groups = [aws_security_group.web_sg.id]
    }

    egress {
        description = "all"
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "app-sg"
    }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS inbound traffic from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}


resource "aws_lb_target_group" "project_x_target_group" {
    port     = var.app_port
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold  = 2
        unhealthy_threshold = 2
    }

    tags = {
        Name = "project_x_target_group"
    }
}