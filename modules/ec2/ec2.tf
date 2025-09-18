resource "aws_instance" "ec2_instance" {
  ami                  = local.selected_ami_id
  instance_type        = local.selected_instance_type
  key_name             = var.ec2_data.key_name
  monitoring           = var.ec2_data.ec2_metrics
  availability_zone    = local.selected_az
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  # Primary network interface
  network_interface {
    network_interface_id = aws_network_interface.primary.id
    device_index         = 0
  }

  user_data = templatefile("${path.module}/userdata/userdata.sh.tpl", {
    volumes = var.ec2_data.ebs_volumes
  })

  tags = merge(var.tags, {
    "Name"             = "${local.environment}-${local.project_name}-${var.ec2_data.name}"
    "Environment"      = local.environment
    "Project"          = local.project_name
    "InstanceType"     = local.selected_instance_type
    "Architecture"     = var.ec2_data.architecture
    "AvailabilityZone" = local.selected_az
  })

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_network_interface" "primary" {
  subnet_id       = var.ec2_data.subnet_id
  security_groups = [aws_security_group.default_sg.id]

  tags = merge(var.tags, {
    "Name"       = "${local.environment}-${local.project_name}-${var.ec2_data.name}-primary"
    Environment  = local.environment
    Project      = local.project_name
    InstanceName = var.ec2_data.name
    Type         = "primary"
  })
}