
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
    #!/bin/bash
    # Update packages
    apt update -y && apt upgrade -y

    # -----------------------------
    # Install Docker
    # -----------------------------
    # Install dependencies
    apt install -y apt-transport-https ca-certificates curl software-properties-common unzip

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update packages again and install Docker
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io

    # Start Docker service
    systemctl start docker

    # Enable Docker to start on boot
    systemctl enable docker

    # Add ubuntu user to docker group (optional)
    usermod -aG docker ubuntu

    # -----------------------------
    # Install AWS CLI v2
    # -----------------------------
    # Download AWS CLI v2
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"

    # Unzip the installer
    unzip /tmp/awscliv2.zip -d /tmp

    # Install AWS CLI
    /tmp/aws/install

    # Verify installation
    aws --version

    # -----------------------------
    # Install Python3 and Flask
    # -----------------------------
    apt install -y python3 python3-pip

    # Upgrade pip
    pip3 install --upgrade pip

    # Install Flask
    pip3 install flask

    # Verify installation
    python3 -m flask --version

    # -----------------------------
    # Cleanup
    # -----------------------------
    rm -rf /tmp/aws /tmp/awscliv2.zip

    echo "Docker, AWS CLI, and Flask installation complete."


        EOF
      
}

# resource "aws_instance" "Private_Server" {
#     ami = var.instance_ami["ubuntu"]
#     instance_type = var.instance_type[1]
#     count = length(var.environment)
#     subnet_id = var.private_subnet_ids[count.index]
#     key_name = var.key_name
#     vpc_security_group_ids = var.private_security_group
#     tags = {
#         Name = "${var.environment[count.index]}_${var.user}_Private_Server"
#     } 
#     user_data = <<-EOF
#         #!/bin/bash
#         sudo apt-get update -y
#         sudo apt-get install -y apache2
#         sudo systemctl start apache2
#         sudo systemctl enable apache2
#         sudo echo "<h1>Hello from $(var.environment[count.index]) Private Web Server</h1>" > /var/www/html/index.html
#     EOF
        
# }

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