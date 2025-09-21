
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "AWS region must be a valid region identifier."
  }
}

variable "default_tags" {
  description = "Default tags to be applied to resources"
  type        = map(string)
  default = {
    env        = "dev"
    managed_by = "terraform"
  }
}


variable "sg_names" {
  description = "Default sg_names to be applied to enis"
  type        = list(string)
  default     = []
}



variable "ec2_data" {
  description = "Configuration for EC2 instances"
  type = list(object({
    name          = string
    vpc_id        = string
    ami_id        = string
    ec2_metrics   = bool
    instance_type = string
    architecture  = string
    key_name      = string
    az            = string
    subnet_id     = string
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
  }))
  default = [
    {
      name          = "example-instance"
      vpc_id        = ""
      ami_id        = ""
      ec2_metrics   = true
      instance_type = "t3.medium"
      key_name      = ""
      architecture  = "x86_64"
      subnet_id     = ""
      az            = ""
      eni = [
        {
          name            = ""
          subnet_id       = ""
          security_groups = []
        }
      ]
      ebs_volumes = [
        {
          name        = ""
          size        = ""
          type        = "gp3"
          device_name = ""
          mount_point = ""
        }
      ]
    }
  ]

  validation {
    condition = alltrue([
      for instance in var.ec2_data :
      contains(["x86_64", "arm64"], instance.architecture)
    ])
    error_message = "Architecture must be either 'x86_64' or 'arm64'."
  }

  validation {
    condition = alltrue([
      for instance in var.ec2_data :
      instance.name != ""
    ])
    error_message = "Instance name cannot be empty."
  }
}


variable "sg_data" {
  description = "A list of security groups to create"
  type = list(object({
    name        = string
    description = string
    vpc_id      = string
    ingress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags = map(string)
  }))
  default = []
}

variable "kms_key_id" {
  description = "KMS key ID for EBS volume encryption"
  type        = string
  default     = null
}
