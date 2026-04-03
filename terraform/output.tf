output "bastion_host_public_ip" {
  description = "Public IP of bastion host"
  value       = aws_instance.bastion_host.public_ip
}

output "master_private_ip" {
  description = "Private IP of master node"
  value       = aws_instance.master_node_ec2.private_ip
}

output "worker_private_ips" {
  description = "Private IPs of worker nodes"
  value = [
    aws_instance.workers[0].private_ip,
    aws_instance.workers[1].private_ip
  ]
}

output "rds_endpoint" {
  description = "Endpoint of RDS instance"
  value       = aws_db_instance.rds.endpoint
}