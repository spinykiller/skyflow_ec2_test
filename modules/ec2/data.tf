# Data source for Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  count = var.ec2_data.ami_id == "" ? 1 : 0

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = [var.ec2_data.architecture]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-${var.ec2_data.architecture}-gp2"]
  }
}

# Ubuntu AMI data source removed to avoid query issues
# Amazon Linux 2 will be used as the primary choice

# Data source for available instance types
data "aws_ec2_instance_type_offerings" "available_types" {
  location_type = "availability-zone"
  
  filter {
    name   = "instance-type"
    values = local.supported_instance_types[var.ec2_data.architecture]
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}