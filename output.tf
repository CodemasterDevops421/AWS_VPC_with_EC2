output "public_ips_of_demo_servers" {
  description = "Public IPs assigned to the demo servers"
  value       = module.compute.public_ips
}

output "private_ips_of_demo_servers" {
  description = "Private IPs assigned to the demo servers"
  value       = module.compute.private_ips
}

output "security_group_id" {
  description = "Security group protecting the demo instances"
  value       = module.networking.security_group_id
}
