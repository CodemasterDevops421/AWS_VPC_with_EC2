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

module "networking" {
  source = "./modules/networking"

  name_prefix          = "${var.project_name}-${var.environment}"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.subnet1_cidr
  availability_zone    = var.subnet_az
  security_group_rules = local.security_group_rules
  tags                 = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  name_prefix        = "${var.project_name}-${var.environment}-app"
  ami_id             = local.ami_id
  instance_type      = var.instance_type
  key_name           = var.key
  subnet_id          = module.networking.public_subnet_id
  security_group_ids = [module.networking.security_group_id]

  associate_public_ip = true
  allocate_eip        = true
  swap_size_gib       = 2

  tags = local.common_tags
}
