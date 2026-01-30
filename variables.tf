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
  default     = "c6i.2xlarge"
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

variable "allowed_ssh_cidrs" {
  description = "IPv4 CIDRs allowed to access SSH (22/tcp)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_http_cidrs" {
  description = "IPv4 CIDRs allowed to access HTTP (80/tcp)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_https_cidrs" {
  description = "IPv4 CIDRs allowed to access HTTPS (443/tcp)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "additional_security_group_rules" {
  description = "Additional ingress rules for the security group"
  type = list(object({
    description      = optional(string, "")
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = optional(list(string), [])
  }))
  default = []
}

variable "project_name" {
  description = "Project tag applied to all resources"
  type        = string
  default     = "demo"
}

variable "environment" {
  description = "Environment tag applied to all resources"
  type        = string
  default     = "dev"
}

variable "resource_tags" {
  description = "Additional tags to merge onto all resources"
  type        = map(string)
  default     = {}
}
