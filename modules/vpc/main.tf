resource "aws_vpc" "master_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        name = "${var.environment[0]}_${var.user}_vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.master_vpc.id
    cidr_block = var.public_subnet_cidr_block[count.index]
    map_public_ip_on_launch = true
    availability_zone = var.availability_zones[count.index]
    count = length(var.environment)
    tags = {
        name = "${var.environment[count.index]}_${var.user}_public_subnet"
    }

}

resource "aws_subnet" "private_subnet" {
  count             = length(var.environment) * length(var.availability_zones)  # 2 subnets per environment
  vpc_id            = aws_vpc.master_vpc.id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]

  tags = {
    name = "${var.environment[count.index % length(var.environment)]}_${var.user}_private_subnet_${count.index}"
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