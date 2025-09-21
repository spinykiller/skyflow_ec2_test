resource "aws_network_interface" "eni" {
  for_each = { for idx, eni in var.ec2_data.eni : idx => eni if eni.name != "" && eni.subnet_id != "" }

  subnet_id       = each.value.subnet_id
  security_groups = length(each.value.security_groups) > 0 ? each.value.security_groups : [aws_security_group.default_sg.id]

  tags = merge(var.tags, {
    Name         = "${local.environment}-${local.project_name}-${var.ec2_data.name}-${each.value.name}"
    Environment  = local.environment
    Project      = local.project_name
    InstanceName = var.ec2_data.name
    Type         = "secondary"
  })
}

resource "aws_network_interface_attachment" "eni_attach" {
  for_each = { for idx, eni in var.ec2_data.eni : idx => eni if eni.name != "" && eni.subnet_id != "" }

  instance_id          = aws_instance.ec2_instance.id
  network_interface_id = aws_network_interface.eni[each.key].id
  device_index         = each.key + 1 # Start from 1 since 0 is primary

  lifecycle {
    create_before_destroy = true
  }
}
