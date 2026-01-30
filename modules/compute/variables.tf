variable "name_prefix" {
  description = "Prefix applied to compute resources"
  type        = string
}

variable "ami_id" {
  description = "AMI identifier for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair used for SSH"
  type        = string
}

variable "subnet_id" {
  description = "Subnet identifier for the instance"
  type        = string
}

variable "security_group_ids" {
  description = "Security groups to associate with the instance"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = true
}

variable "allocate_eip" {
  description = "Whether to allocate and attach an Elastic IP"
  type        = bool
  default     = false
}

variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "root_volume_size" {
  description = "Size of the root volume in GiB"
  type        = number
  default     = 160
}

variable "root_volume_type" {
  description = "EBS volume type for the root volume"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Encrypt the root volume"
  type        = bool
  default     = true
}

variable "swap_size_gib" {
  description = "Size of the swap file in GiB"
  type        = number
  default     = 2
}

variable "docker_compose_version" {
  description = "Docker Compose release version to install"
  type        = string
  default     = "1.29.2"
}

variable "perform_system_upgrade" {
  description = "Whether to run a full apt upgrade during bootstrap"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the instances and related resources"
  type        = map(string)
  default     = {}
}
