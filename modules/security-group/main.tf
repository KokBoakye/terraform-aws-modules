resource "aws_security_group" "app_sg" {
    description = "web security group"
    vpc_id = var.vpc_id
    
    ingress {
        description = "ssh"
        protocol    = "tcp"
        from_port   = 22
        to_port     = 22
        security_groups = [aws_security_group.bastion_sg]
    }

    ingress {
        description = "http"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        security_groups = [aws_security_group.alb_sg.id]
    }

    ingress {
        description = "https"
        protocol = "tcp"
        from_port = 443
        to_port = 443
        security_groups = [aws_security_group.alb_sg.id] 
    } 

    ingress {
        description = "https"
        protocol = "tcp"
        from_port = 8080
        to_port = 8080
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
        Name = "app-sg"
    }

}

# resource "aws_security_group" "app_sg" {
#     description = "app security group"
#     vpc_id = var.vpc_id
    
#     ingress {
#         description = "app port from web SG"
#         protocol = "tcp"
#         from_port = var.app_port
#         to_port = var.app_port
#         security_groups = [aws_security_group.bastion_sg.id]
#     }

#     egress {
#         description = "all"
#         protocol = "-1"
#         from_port = 0
#         to_port = 0
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     tags = {
#         Name = "app-sg"
#     }
# }

resource "aws_security_group" "alb_sg" {
    description = "Allow HTTP and HTTPS traffic"
    vpc_id = var.vpc_id

    ingress {
        description = "HTTP"
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTPS"
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "all"
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "bastion_sg" {
    description = "bastion security group"
    vpc_id = var.vpc_id

    ingress {
        description = "ssh"
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "all"
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}