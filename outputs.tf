output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.kind.id
}

output "public_ip" {
  description = "Public IPv4 address used by the remote-exec provisioner."
  value       = aws_instance.kind.public_ip
}

output "spot_instance_request_id" {
  description = "Spot request ID. max_price is omitted, so the cap is the On-Demand price."
  value       = aws_instance.kind.instance_market_options[0].spot_instance_request_id
}

output "ssh_command" {
  description = "SSH command for the Kind host. Password is the ssh_password variable (default DevOps321)."
  value       = "ssh ${var.ssh_user}@${aws_instance.kind.public_ip}"
}

output "kind_cluster_name" {
  description = "Kind cluster created on the instance."
  value       = var.kind_cluster_name
}
