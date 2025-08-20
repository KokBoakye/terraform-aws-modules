resource "aws_vpc" "master_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.environment}_${var.user}_vpc"
  }
}

# One public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.master_vpc.id
  cidr_block = var.public_subnet_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}_${var.user}_public_subnet"
  }
}

# Two private subnets
resource "aws_subnet" "private_subnet" {
  count      = 2
  vpc_id     = aws_vpc.master_vpc.id
  cidr_block = var.private_subnet_cidr_block[count.index]

  tags = {
    Name = "${var.environment}_${var.user}_private_subnet_${count.index}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.master_vpc.id

  tags = {
    Name = "${var.environment}_${var.user}_igw"
  }
}

# Single NAT Gateway
resource "aws_eip" "nat_eip" {
  

  tags = {
    Name = "${var.environment}_${var.user}_nat_eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.internet_gateway]

  tags = {
    Name = "${var.environment}_${var.user}_nat_gateway"
  }
}

# Public route table (all public subnets here)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.master_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.environment}_${var.user}_public_rt"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private route table (all private subnets use same NAT)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.master_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.environment}_${var.user}_private_rt"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

