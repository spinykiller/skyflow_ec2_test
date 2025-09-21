variable "security_groups" {
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

variable "default_tags" {
  description = "Default tags to be applied to resources"
  type        = map(string)
  default = {
    env        = "uat"
    managed_by = "terraform"
  }
}