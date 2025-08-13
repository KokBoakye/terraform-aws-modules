
resource "aws_instance" "web_server" {
    ami = var.instance_ami["ubuntu"]
    count = length(var.environment)
    instance_type = var.instance_type[0]
    subnet_id = var.public_subnet_ids[count.index]
    key_name = var.key_name
    associate_public_ip_address = true
    vpc_security_group_ids = [var.web_security_group]
    tags = {
        Name = "${var.environment[count.index]}_${var.user}_Web_Server"
    } 
    user_data = <<-EOF
    user_data = <<-EOF
    #!/bin/bash

    # -----------------------
    # Redirect all output to a log file
    # -----------------------
    exec > /var/log/user-data.log 2>&1
    set -e

    # -----------------------
    # Update system and install dependencies
    # -----------------------
    apt update -y
    apt install -y unzip curl python3 python3-pip ca-certificates lsb-release gnupg docker.io

    # -----------------------
    # Install AWS CLI v2
    # -----------------------
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install
    aws --version

    # -----------------------
    # Enable and start Docker
    # -----------------------
    systemctl enable docker
    systemctl start docker

    # -----------------------
    # Install Flask
    # -----------------------
    pip3 install --upgrade pip
    pip3 install flask

    # -----------------------
    # Confirm installations
    # -----------------------
    docker --version
    python3 --version
    pip3 show flask

    EOF


      
}

resource "aws_instance" "Private_Server" {
    ami = var.instance_ami["ubuntu"]
    instance_type = var.instance_type[1]
    count = length(var.environment)
    subnet_id = var.private_subnet_ids[count.index]
    key_name = var.key_name
    vpc_security_group_ids = var.private_security_group
    tags = {
        Name = "${var.environment[count.index]}_${var.user}_Private_Server"
    } 
    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt-get install -y apache2
        sudo systemctl start apache2
        sudo systemctl enable apache2
        sudo echo "<h1>Hello from $(var.environment[count.index]) Private Web Server</h1>" > /var/www/html/index.html
    EOF
        
}

resource "aws_instance" "bastion_host" {
    ami = var.instance_ami["ubuntu"]
    instance_type = var.instance_type[0]
    subnet_id = var.public_subnet_ids[count.index]
    associate_public_ip_address = true
    count = length(var.environment)
    key_name = var.key_name
    vpc_security_group_ids = [var.bastion_security_group]
    tags = {
        Name = "${var.environment[count.index]}_${var.user}_Bastion_Host"
    } 
    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt-get install -y nginx
        sudo systemctl start nginx
        sudo systemctl enable nginx
        sudo echo "<h1>Hello from Bastion Host</h1>" > /var/www/html/index.html
    EOF
}

resource "aws_db_instance" "db_instance" {
    count = length(var.environment)
    identifier = "${var.environment[count.index]}-db-instance"
    instance_class = "db.t3.micro"
    engine = "mysql"
    engine_version = "8.0"
    allocated_storage = 20
    storage_type = "gp2"
    username = var.db_username
    password = var.db_password 
    db_subnet_group_name = var.private_db_subnet_group
    vpc_security_group_ids = var.db_private_security_group
    skip_final_snapshot = true
    tags = {
        Name = "${var.environment[count.index]}_${var.user}_DB_Instance"
    }
}