provider "aws" {
  region = var.location
}

data "aws_ami" "ubuntu_2204" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  ami_id = length(var.ami_id) > 0 ? var.ami_id : data.aws_ami.ubuntu_2204.id
}

resource "aws_eip" "demo_eip" {
  count    = 1
  domain   = "vpc"
  instance = aws_instance.demo_server[count.index].id
}

resource "aws_instance" "demo_server" {
  count                       = 1
  ami                         = local.ami_id
  key_name                    = var.key
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.demo_subnet.id
  vpc_security_group_ids      = [aws_security_group.demo_vpc_sg.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e
              export DEBIAN_FRONTEND=noninteractive
              apt-get update -y
              apt-get upgrade -y
              apt-get install -y unzip openjdk-11-jdk docker.io curl
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              usermod -aG docker ubuntu
              systemctl enable docker
              systemctl start docker
              EOF

  tags = {
    Name = "demo-server-${count.index}"
  }
}

// Create VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = var.vpc_cidr
}

// Create Subnet
resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.subnet_az

  tags = {
    Name = "demo_subnet"
  }
}

// Create Internet Gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "demo-rt"
  }
}

// associate subnet with route table
resource "aws_route_table_association" "demo_rt_association" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo_rt.id
}

// create a security group
resource "aws_security_group" "demo_vpc_sg" {
  name   = "demo-vpc-sg"
  vpc_id = aws_vpc.demo_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "main"
  }
}
