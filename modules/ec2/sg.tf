# Default security group for EC2 instances
resource "aws_security_group" "default_sg" {
  name_prefix = "${local.environment}-${local.project_name}-${var.ec2_data.name}-"
  vpc_id      = var.ec2_data.vpc_id
  description = "Default security group for ${var.ec2_data.name}"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.tags, {
    Name         = "${local.environment}-${local.project_name}-${var.ec2_data.name}-default"
    Environment  = local.environment
    Project      = local.project_name
    InstanceName = var.ec2_data.name
    Type         = "default"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Additional security groups based on sg_names
resource "aws_security_group" "sg" {
  for_each = { for idx, name in var.sg_names : idx => name if name != "" }

  name_prefix = "${local.environment}-${local.project_name}-${var.ec2_data.name}-${each.value}-"
  vpc_id      = var.ec2_data.vpc_id
  description = "Security group ${each.value} for ${var.ec2_data.name}"

  # Basic ingress rules
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All inbound traffic"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(var.tags, {
    Name         = "${local.environment}-${local.project_name}-${var.ec2_data.name}-${each.value}"
    Environment  = local.environment
    Project      = local.project_name
    InstanceName = var.ec2_data.name
    Type         = "additional"
  })

  lifecycle {
    create_before_destroy = true
  }
}
