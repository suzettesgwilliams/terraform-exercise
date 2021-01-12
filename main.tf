# Provider Configuration
#

provider "aws" {
  region  = "us-east-1"
}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_instance" "Keet" {
  instance_id = "i-instanceid"

  filter {
    name   = "image-id"
    values = ["ami-00ddb0e5626798373"]
  }

  resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"
  
  }
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id}

resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.first-vpc.id
  cidr_block = "10.0.1.0/24"

  }
}
   
   # Variables Configuration
#



#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "keet" {
  cidr_block = "10.0.0.0/16"

  }

resource "aws_subnet" "keet" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.keet.id

  }

resource "aws_internet_gateway" "keet" {
  vpc_id = aws_vpc.demo.id

 
resource "aws_route_table" "keet" {
  vpc_id = aws_vpc.keet.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.keet.id
  }


resource "aws_route_table_association" "demo" {
  count = 2

  subnet_id      = aws_subnet.keet.*.id[count.index]
  route_table_id = aws_route_table.keet.id
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
}

output "instance_ip_addr" {
  value = aws_instance.server.private_ip
} 
}
