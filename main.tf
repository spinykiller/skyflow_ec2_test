
module "ec2" {
  source     = "./modules/ec2"
  count      = length(var.ec2_data)
  ec2_data   = var.ec2_data[count.index]
  tags       = var.default_tags
  sg_names   = var.sg_names
  kms_key_id = var.kms_key_id
}

module "security_groups" {
  source          = "./modules/security_groups"
  default_tags    = var.default_tags
  security_groups = var.sg_data
}

output "security_group_ids" {
  description = "IDs of the created security groups"
  value       = module.security_groups.security_group_ids
}

output "ec2_instances" {
  description = "Information about the created EC2 instances"
  value = {
    for idx, instance in module.ec2 : idx => {
      instance_id                     = instance.instance_id
      instance_arn                    = instance.instance_arn
      instance_public_ip              = instance.instance_public_ip
      instance_private_ip             = instance.instance_private_ip
      instance_public_dns             = instance.instance_public_dns
      instance_private_dns            = instance.instance_private_dns
      instance_type                   = instance.instance_type
      instance_architecture           = instance.instance_architecture
      instance_availability_zone      = instance.instance_availability_zone
      instance_ami                    = instance.instance_ami
      security_group_ids              = instance.security_group_ids
      primary_network_interface_id    = instance.primary_network_interface_id
      secondary_network_interface_ids = instance.secondary_network_interface_ids
      ebs_volume_ids                  = instance.ebs_volume_ids
      iam_instance_profile_name       = instance.iam_instance_profile_name
      iam_role_name                   = instance.iam_role_name
      iam_role_arn                    = instance.iam_role_arn
    }
  }
}