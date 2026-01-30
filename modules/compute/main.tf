locals {
  user_data = templatefile("${path.module}/templates/user_data.sh.tpl", {
    docker_compose_version = var.docker_compose_version
    swap_size_gib          = var.swap_size_gib
    perform_system_upgrade = var.perform_system_upgrade
  })
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  user_data                   = local.user_data
  user_data_replace_on_change = true

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    encrypted   = var.root_volume_encrypted
  }

  tags = merge(var.tags, {
    Name = format("%s-%02d", var.name_prefix, count.index + 1)
  })

  volume_tags = merge(var.tags, {
    Name = format("%s-root-%02d", var.name_prefix, count.index + 1)
  })
}

resource "aws_eip" "this" {
  count    = var.allocate_eip ? var.instance_count : 0
  domain   = "vpc"
  instance = aws_instance.this[count.index].id

  tags = merge(var.tags, {
    Name = format("%s-eip-%02d", var.name_prefix, count.index + 1)
  })
}
