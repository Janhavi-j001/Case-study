output "instance_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}