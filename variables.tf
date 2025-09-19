variable "location" {
  description = "AWS region for all resources"
  default     = "ap-south-1"
}

variable "os_name" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-006935d9a6773e4ec"
}

variable "key" {
  description = "Name of an existing EC2 key pair"
  default     = "demo-03"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet1_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "subnet_az" {
  description = "Availability Zone for the subnet"
  default     = "ap-south-1a"
}
