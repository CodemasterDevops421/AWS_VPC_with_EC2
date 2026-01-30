variable "name_prefix" {
  description = "Prefix applied to resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to networking resources"
  type        = map(string)
  default     = {}
}

variable "security_group_rules" {
  description = "Ingress rules for the default security group"
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
