data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web_server" {
    ami = data.aws_ami.ubuntu.id
    count = 1
    instance_type = var.instance_type[0]
    subnet_id = var.public_subnet_ids[0]
    key_name = var.key_name
    vpc_security_group_ids = [var.web_sg]
    tags = {
        Name = "${var.environment}_${var.user}_Web_Server"
    } 
    user_data = <<-EOF
        #!/bin/bash

        # Install, start and enable nginx
        sudo apt-get update -y
        sudo apt-get install -y nginx
        sudo systemctl start nginx
        sudo systemctl enable nginx

  
        # Install, start and enable docker
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

        # Add Docker repository
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker

        # Install aws cli
        sudo apt-get install -y awscli

       
        
    EOF
      
}

resource "aws_instance" "private_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type[0]
    subnet_id = var.private_subnet_ids[0]
    key_name = var.key_name
    vpc_security_group_ids = [var.app_sg]
    tags = {
        Name = "${var.environment}_${var.user}_Private_Server"
    } 
    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt-get install -y apache
        sudo systemctl start apache2
        sudo systemctl enable apache2
        sudo echo "<h1>Hello from ${var.environment} Private Web Server</h1>" > /var/www/html/index.html
    EOF
        
}
