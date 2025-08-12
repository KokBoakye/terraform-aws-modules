resource "aws_vpc" "master_vpc" {
    cidr_block = var.vpc_cidr_block
    
    tags = {
        name = "${var.user}_vpc"
    }
}

# One public subnet per environment
resource "aws_subnet" "public_subnet" {
  count = length(var.environment)

  vpc_id            = aws_vpc.master_vpc.id
  cidr_block        = var.public_subnet_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.environment[count.index]}_${var.user}_public_subnet"
  }
}

# Two private subnets per environment
resource "aws_subnet" "private_subnet" {
  count = length(var.environment) * 2  # 2 private subnets per env

  vpc_id     = aws_vpc.master_vpc.id
  cidr_block = var.private_subnet_cidr_block[count.index]

  # Assign AZ based on environment index (integer division)
  availability_zone = var.availability_zones[floor(count.index / 2)]

  tags = {
    Name = "${var.environment[floor(count.index / 2)]}_${var.user}_private_subnet_${count.index % 2 + 1}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.master_vpc.id
    
    
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat_eip[count.index].id
    count = length(var.environment)
    subnet_id = aws_subnet.public_subnet[count.index].id
    depends_on = [aws_eip.nat_eip]


    tags = {
        name = "${var.environment[count.index]}_${var.user}_nat_gateway"
    }
}

resource "aws_eip" "nat_eip" {
    
    count = length(var.environment)

    tags = {
        name = "${var.environment[count.index]}_${var.user}_nat_eip"
    
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.master_vpc.id
    count = length(var.environment)
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }
}

resource "aws_route_table_association" "public_route_table_association" {
    subnet_id = aws_subnet.public_subnet[count.index].id
    count = length(var.environment)
    route_table_id = aws_route_table.public_route_table[count.index].id
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.master_vpc.id
    count = length(var.environment)
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
    }
}

resource "aws_route_table_association" "private_route_table_association" {
    count = length(var.environment)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_lb" "project_x_lb" {
    internal = false
    load_balancer_type = "application"
    subnets = aws_subnet.public_subnet[*].id
    security_groups = [var.alb_sg_id]
    name = "project-x-lb"
}

resource "aws_lb_listener" "project_x_listener" {
    load_balancer_arn = aws_lb.project_x_lb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.project_x_target_group.arn
    }
}

resource "aws_lb_target_group_attachment" "project_x_target_attachment" {
    count = length(var.environment)
    target_group_arn = aws_lb_target_group.project_x_target_group.arn
    target_id = var.web_server_instance_ids[count.index]
    port = 80
}

resource "aws_lb_target_group" "project_x_target_group" {
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.master_vpc.id

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