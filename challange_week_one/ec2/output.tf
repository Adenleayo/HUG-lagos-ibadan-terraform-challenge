output "ec2_name" {
  description = "The name of the EC2 instance"
  value       = aws_instance.web.tags["Name"]
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}