output "public_ips_of_demo_servers" {
  value = aws_instance.demo_server[*].public_ip
}

output "private_ips_of_demo_servers" {
  value = aws_instance.demo_server[*].private_ip
}
