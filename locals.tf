locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.resource_tags,
  )

  default_security_group_rules = flatten([
    length(var.allowed_ssh_cidrs) > 0 ? [
      {
        description      = "SSH access"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = var.allowed_ssh_cidrs
        ipv6_cidr_blocks = []
      }
    ] : [],
    length(var.allowed_http_cidrs) > 0 ? [
      {
        description      = "HTTP access"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = var.allowed_http_cidrs
        ipv6_cidr_blocks = []
      }
    ] : [],
    length(var.allowed_https_cidrs) > 0 ? [
      {
        description      = "HTTPS access"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = var.allowed_https_cidrs
        ipv6_cidr_blocks = []
      }
    ] : [],
    [
      {
        description      = "Application port"
        from_port        = 8000
        to_port          = 8000
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    ]
  ])

  security_group_rules = concat(
    local.default_security_group_rules,
    var.additional_security_group_rules,
  )
}
