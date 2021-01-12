# Provider Configuration

provider "aws" {
  region  = "us-east-1"
  Access_key = AKIA223JF52AXIODC24Q
  secret_key = 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
  }

}
#1. Create VPC

  resource "aws_vpc" "keet-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "keet"
  }
}
#2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.keet-vpc.id}

  }
#3. Create a Custom Route Table and Assign Route
resource "aws_route_table" "keet" {
  vpc_id = aws_vpc.keet-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
# 4. Create a subnet  
resource "aws_subnet" "keet_subnet" {
  vpc_id     = aws_vpc.keet-vpc.id
  cidr_block = "10.0.1.0/24" 
  availability_zone       = "us-east-1b"
  
  tags = {
    Name = "Dev"
  }
}
# 6. AWS Route Table Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.keet_subnet.id
  route_table_id = aws_route_table.keet.id
}
7. Create  Security Group
resource "aws_security_group" "allow_web" {
  name  = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id   =  "aws_vpc.keet-vpc.id"

  ingress {
    description = "Http web traffic from anywhere"
    from_port   =  80
    to_port     =  80
    protocol    =  "tcp"
    cidr_block  =  "0.0.0.0"
  }
  ingress {
    description = "Https web traffic from anywhere"
    from_port   =  443
    to_port     =  443
    protocol    =  "tcp"
    cidr_block  =  "0.0.0.0/0"
  }
  ingress {
    description = "ssh web traffic from anywhere"
    from_port   =  22
    to_port     =  22
    protocol    =  "tcp"
    cidr_block  =  "0.0.0.0/0"
  }
  Egress {
    from_port   =  0
    to_port     =  0
    protocol    =  "-1"
    cidr_block  =  "0.0.0.0/0"  
  tags  +{
    Name = "allow web traffic"
  } 
#. 8. Create a Network Interface
resource "aws_network_interface" "web-server-nic"
  subnet_id      = aws_subnet.keet_subnet.id
  private_ip     = ["10.0.1.45"]
  security_groups = ["aws_security_group" "allow_web"]

#9. Assign an elastic IP to the Network Interface
resource "aws_eip" "eip" {
  aws_network_interface_id = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.45"
  vpc      = true
  depends_on = aws_internet_gateway.gw
}
#10. Create Ubuntu server
 resource "aws_instance" "Keet" {
  ami          = "ami-00ddb0e5626798373"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  key_name = "devops"
  
  network_interface {
    device_index = 0
    aws_network_interface_id = aws_network_interface.web-server-nic.id

  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              curl -sSL https://get.docker.com/ | sh
              sudo usermod -aG docker ubuntu
              echo added user to docker group
              EOF
  tags = {
    Name = "docker-server"
  }
resource "docker_container" "nginx-server" {
  name = "nginx-server-1"
  image = docker_image.nginx.latest
  ports {
    internal = 80
    external = 8081
  }
  volumes {
    container_path  = "/usr/share/nginx/html"
    host_path = "/tmp/tutorial/www"
    read_only = true
  }
  output "instance_ips" {
  value = aws_instance.web.*.public_ip
  

output "instance_ip_addr" {
  value = aws_instance.server.private_ip
  } 
}
