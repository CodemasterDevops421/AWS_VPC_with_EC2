output "instance_ids" {
  description = "List of instance IDs"
  value       = aws_instance.this[*].id
}

output "private_ips" {
  description = "Private IP addresses"
  value       = aws_instance.this[*].private_ip
}

output "public_ips" {
  description = "Public IP addresses"
  value       = aws_instance.this[*].public_ip
}

output "eip_allocation_ids" {
  description = "Allocation IDs for Elastic IPs when created"
  value       = aws_eip.this[*].allocation_id
}
