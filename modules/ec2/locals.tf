locals {
  # Supported instance types by architecture
  supported_instance_types = {
    x86_64 = [
      "t3.nano", "t3.micro", "t3.small", "t3.medium", "t3.large", "t3.xlarge", "t3.2xlarge",
      "t3a.nano", "t3a.micro", "t3a.small", "t3a.medium", "t3a.large", "t3a.xlarge", "t3a.2xlarge",
      "m5.large", "m5.xlarge", "m5.2xlarge", "m5.4xlarge", "m5.8xlarge", "m5.12xlarge", "m5.16xlarge", "m5.24xlarge",
      "m5a.large", "m5a.xlarge", "m5a.2xlarge", "m5a.4xlarge", "m5a.8xlarge", "m5a.12xlarge", "m5a.16xlarge", "m5a.24xlarge",
      "c5.large", "c5.xlarge", "c5.2xlarge", "c5.4xlarge", "c5.9xlarge", "c5.12xlarge", "c5.18xlarge", "c5.24xlarge",
      "r5.large", "r5.xlarge", "r5.2xlarge", "r5.4xlarge", "r5.8xlarge", "r5.12xlarge", "r5.16xlarge", "r5.24xlarge"
    ]
    arm64 = [
      "t4g.nano", "t4g.micro", "t4g.small", "t4g.medium", "t4g.large", "t4g.xlarge", "t4g.2xlarge",
      "m6g.medium", "m6g.large", "m6g.xlarge", "m6g.2xlarge", "m6g.4xlarge", "m6g.8xlarge", "m6g.12xlarge", "m6g.16xlarge",
      "c6g.medium", "c6g.large", "c6g.xlarge", "c6g.2xlarge", "c6g.4xlarge", "c6g.8xlarge", "c6g.12xlarge", "c6g.16xlarge",
      "r6g.medium", "r6g.large", "r6g.xlarge", "r6g.2xlarge", "r6g.4xlarge", "r6g.8xlarge", "r6g.12xlarge", "r6g.16xlarge"
    ]
  }

  # Default instance types by architecture
  default_instance_types = {
    x86_64 = "t3.medium"
    arm64  = "t4g.medium"
  }

  # Select AMI with fallback logic
  selected_ami_id = (
    var.ec2_data.ami_id != "" ? var.ec2_data.ami_id :
    (length(data.aws_ami_ids.amazon_linux_2.ids) > 0 ? data.aws_ami_ids.amazon_linux_2.ids[0] : "ami-0c02fb55956c7d316")
  )

  # Select instance type with availability check
  selected_instance_type = var.ec2_data.instance_type != "" ? var.ec2_data.instance_type : (
    contains(data.aws_ec2_instance_type_offerings.available_types.instance_types, local.default_instance_types[var.ec2_data.architecture]) ?
    local.default_instance_types[var.ec2_data.architecture] :
    data.aws_ec2_instance_type_offerings.available_types.instance_types[0]
  )

  # Select availability zone
  selected_az = var.ec2_data.az != "" ? var.ec2_data.az : data.aws_availability_zones.available.names[0]

  # Environment-specific naming
  environment  = lookup(var.tags, "env", "dev")
  project_name = lookup(var.tags, "project", "ec2")
}