# ── AWS outputs ──────────────────────────────────────────────────────────────

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.aws_alb.dns_name
}

output "ec2_private_ip" {
  description = "EC2 instance private IP"
  value       = aws_instance.app-server.private_ip
}

output "vpc_id" {
  description = "AWS VPC ID"
  value       = aws_vpc.aws_my_vpc.id
}

# ── Azure outputs ────────────────────────────────────────────────────────────

output "az_resource_group_name" {
  description = "Azure Resource Group name"
  value       = azurerm_resource_group.az_rg.name
}

output "az_vm_public_ip" {
  description = "Azure VM public IP address"
  value       = azurerm_public_ip.az_pb_ip.ip_address
}

output "az_vm_private_ip" {
  description = "Azure VM private IP address"
  value       = azurerm_network_interface.az_intf.private_ip_address
}
