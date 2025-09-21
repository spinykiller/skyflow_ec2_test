variable "tags" {
  description = "Default tags to be applied to resources"
  type        = map(string)
  default = {
    env        = "uat"
    managed_by = "terraform"
  }
}

variable "sg_names" {
  type = list(string)
}

variable "ec2_data" {
  description = "Configuration for EC2 instances"
  type = object({
    name          = string
    vpc_id        = string
    ami_id        = string
    ec2_metrics   = bool
    instance_type = string
    key_name      = string
    subnet_id     = string
    architecture  = string
    az            = string
    eni = list(object({
      name            = string
      subnet_id       = string
      security_groups = list(string)
    }))
    ebs_volumes = list(object({
      name        = string
      size        = string
      type        = string
      device_name = string
      mount_point = string
    }))
  })
}

variable "kms_key_id" {
  description = "KMS key ID for EBS volume encryption"
  type        = string
  default     = null
}
