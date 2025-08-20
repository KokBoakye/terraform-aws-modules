
resource "aws_instance" "web_server" {
    ami = var.instance_ami
    count = 1
    instance_type = var.instance_type[0]
    subnet_id = var.public_subnet_ids
    key_name = var.key_name
    tags = {
        Name = "${var.environment}_${var.user}_Web_Server"
    } 
    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt-get install -y nginx
        sudo systemctl start nginx
        sudo systemctl enable nginx
        sudo echo "<h1>Hello from $(var.environment[count.index]) Web Server</h1>" > /var/www/html/index.html
    EOF
      
}

resource "aws_instance" "Private_Server" {
    ami = var.instance_ami
    instance_type = var.instance_type[count.index]
    count = 1
    subnet_id = var.private_subnet_ids[count.index]
    key_name = var.key_name
    tags = {
        Name = "${var.environment}_${var.user}_Private_Server"
    } 
    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update -y
        sudo apt-get install -y apache
        sudo systemctl start apache2
        sudo systemctl enable apache2
        sudo echo "<h1>Hello from $(var.environment[count.index]) Private Web Server</h1>" > /var/www/html/index.html
    EOF
        
}
