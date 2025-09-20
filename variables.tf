variable "location" {
  description = "AWS region for all resources"
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Override to pin a specific AMI ID (leave empty for latest Ubuntu 22.04 LTS)"
  type        = string
  default     = ""
}

variable "key" {
  description = "Name of an existing EC2 key pair"
  default     = "rasberrypi5"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
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
