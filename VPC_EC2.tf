provider "aws" {
  region = var.location
}


resource "aws_eip" "demo-eip" {
  count    = 1
  domain   = "vpc"
  instance = aws_instance.demo-server[count.index].id
}




resource "aws_instance" "demo-server" {
  count                       = 1
  ami                         = var.os_name
  key_name                    = var.key
  instance_type               = var.instance-type
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.demo_subnet.id
  vpc_security_group_ids      = [aws_security_group.demo-vpc-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum upgrade -y
              sudo yum install unzip java-11-openjdk-devel docker -y
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              # Modify PATH to include /usr/local/bin
              echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
              source ~/.bashrc
              sudo systemctl start docker
              sudo systemctl enable docker
              EOF

  tags = {
    Name = "demo-server-${count.index}"
  }
}



// Create VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc-cidr
}

// Create Subnet
resource "aws_subnet" "demo_subnet" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.subnet1-cidr
  availability_zone = var.subent_az

  tags = {
    Name = "demo_subnet"
  }
}

// Create Internet Gateway

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
  tags = {
    Name = "demo-rt"
  }
}

// associate subnet with route table 
resource "aws_route_table_association" "demo-rt_association" {
  subnet_id = aws_subnet.demo_subnet.id

  route_table_id = aws_route_table.demo-rt.id
}
// create a security group 

resource "aws_security_group" "demo-vpc-sg" {
  name = "demo-vpc-sg"

  vpc_id = aws_vpc.demo-vpc.id

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


