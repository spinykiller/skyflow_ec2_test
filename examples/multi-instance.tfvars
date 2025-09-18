# Example: Multiple EC2 Instances with Different Architectures
aws_region = "us-east-1"

default_tags = {
  env         = "multi-demo"
  managed_by  = "terraform"
  project     = "multi-instance-demo"
  cost_center = "demo"
}

# VPC Configuration
vpc_id             = "vpc-12345678" # Replace with your VPC ID
public_subnet_ids  = ["subnet-12345678", "subnet-87654321"] # Replace with your public subnet IDs
private_subnet_ids = ["subnet-11111111", "subnet-22222222"] # Replace with your private subnet IDs
key_pair_name      = "demo-key" # Replace with your key pair name

# Multiple EC2 instances with different configurations
ec2_data = [
  {
    name          = "x86-web-server"
    vpc_id        = "vpc-12345678" # Replace with your VPC ID
    ami_id        = ""             # Auto-select AMI
    ec2_metrics   = true
    instance_type = ""         # Auto-select based on architecture
    key_name      = "demo-key" # Replace with your key pair name
    architecture  = "x86_64"
    subnet_id     = "subnet-12345678" # Replace with your subnet ID
    az            = ""                # Auto-select AZ
    eni = [
      {
        name            = "x86-web-eni"
        subnet_id       = "subnet-87654321" # Replace with your subnet ID
        security_groups = []
      }
    ]
    ebs_volumes = [
      {
        name        = "x86-web-data"
        size        = "50"
        type        = "gp3"
        device_name = "/dev/sdf"
        mount_point = "/data"
      }
    ]
  },
  {
    name          = "arm-app-server"
    vpc_id        = "vpc-12345678" # Replace with your VPC ID
    ami_id        = ""             # Auto-select AMI
    ec2_metrics   = true
    instance_type = ""         # Auto-select based on architecture
    key_name      = "demo-key" # Replace with your key pair name
    architecture  = "arm64"
    subnet_id     = "subnet-87654321" # Replace with your subnet ID
    az            = ""                # Auto-select AZ
    eni = [
      {
        name            = "arm-app-eni"
        subnet_id       = "subnet-11111111" # Replace with your subnet ID
        security_groups = []
      }
    ]
    ebs_volumes = [
      {
        name        = "arm-app-data"
        size        = "30"
        type        = "gp3"
        device_name = "/dev/sdf"
        mount_point = "/app/data"
      },
      {
        name        = "arm-app-logs"
        size        = "20"
        type        = "gp3"
        device_name = "/dev/sdg"
        mount_point = "/app/logs"
      }
    ]
  }
]

# Security groups for different tiers
sg_data = [
  {
    name        = "web-tier-sg"
    description = "Security group for web tier"
    vpc_id      = "vpc-12345678" # Replace with your VPC ID
    ingress = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    tags = {
      Name = "web-tier-sg"
      Type = "web"
    }
  },
  {
    name        = "app-tier-sg"
    description = "Security group for application tier"
    vpc_id      = "vpc-12345678" # Replace with your VPC ID
    ingress = [
      {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/8"] # Internal only
      }
    ]
    egress = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    tags = {
      Name = "app-tier-sg"
      Type = "app"
    }
  }
]

sg_names = ["web-tier-sg", "app-tier-sg"]

# Use default KMS key
kms_key_id = null
