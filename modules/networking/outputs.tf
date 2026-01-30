output "vpc_id" {
  description = "Identifier of the created VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "Identifier of the public subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Identifier of the default security group"
  value       = aws_security_group.default.id
}
