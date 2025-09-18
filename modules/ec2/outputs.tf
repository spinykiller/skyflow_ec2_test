output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.ec2_instance.arn
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.ec2_instance.public_dns
}

output "instance_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = aws_instance.ec2_instance.private_dns
}

output "instance_type" {
  description = "Instance type of the EC2 instance"
  value       = aws_instance.ec2_instance.instance_type
}

output "instance_architecture" {
  description = "Architecture of the EC2 instance"
  value       = var.ec2_data.architecture
}

output "instance_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.ec2_instance.availability_zone
}

output "instance_ami" {
  description = "AMI ID used for the EC2 instance"
  value       = aws_instance.ec2_instance.ami
}

output "security_group_ids" {
  description = "IDs of the security groups attached to the instance"
  value       = concat([aws_security_group.default_sg.id], [for sg in aws_security_group.sg : sg.id])
}

output "primary_network_interface_id" {
  description = "ID of the primary network interface"
  value       = aws_network_interface.primary.id
}

output "secondary_network_interface_ids" {
  description = "IDs of the secondary network interfaces"
  value       = [for eni in aws_network_interface.eni : eni.id]
}

output "ebs_volume_ids" {
  description = "IDs of the EBS volumes attached to the instance"
  value       = [for vol in aws_ebs_volume.ebs : vol.id]
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.ssm_profile.name
}

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.ssm_role.name
}

output "iam_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.ssm_role.arn
}
