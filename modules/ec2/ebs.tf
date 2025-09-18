resource "aws_ebs_volume" "ebs" {
  for_each = { for idx, vol in var.ec2_data.ebs_volumes : idx => vol if vol.size != "" && vol.device_name != "" }

  availability_zone = local.selected_az
  size              = tonumber(each.value.size)
  type              = each.value.type
  encrypted         = true
  kms_key_id        = var.kms_key_id

  # IOPS configuration for gp3 and io1/io2
  iops = each.value.type == "gp3" ? max(3000, tonumber(each.value.size) * 3) : (
    contains(["io1", "io2"], each.value.type) ? max(100, tonumber(each.value.size) * 50) : null
  )

  # Throughput for gp3
  throughput = each.value.type == "gp3" ? 125 : null

  tags = merge(var.tags, {
    Name         = "${local.environment}-${local.project_name}-${var.ec2_data.name}-${each.value.name}"
    Environment  = local.environment
    Project      = local.project_name
    InstanceName = var.ec2_data.name
    MountPoint   = each.value.mount_point
    DeviceName   = each.value.device_name
  })

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_volume_attachment" "ebs_attach" {
  for_each = { for idx, vol in var.ec2_data.ebs_volumes : idx => vol if vol.size != "" && vol.device_name != "" }

  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.ebs[each.key].id
  instance_id = aws_instance.ec2_instance.id

  lifecycle {
    create_before_destroy = true
  }
}