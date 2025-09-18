# Development Environment Configuration
aws_region = "us-east-1"

default_tags = {
  env         = "dev"
  managed_by  = "terraform"
  project     = "ec2-deployment"
  cost_center = "development"
}


# Development EC2 instances
ec2_data = [
  {
    name          = "dev-web-server"
    vpc_id        = "vpc-12345678" # Replace with your VPC ID
    ami_id        = ""             # Will use default AMI
    ec2_metrics   = true
    instance_type = ""             # Will auto-select based on architecture
    key_name      = "dev-key-pair" # Replace with your key pair name
    architecture  = "x86_64"
    subnet_id     = "subnet-12345678" # Replace with your subnet ID
    az            = ""                # Will auto-select
    eni = [
      {
        name            = "dev-web-eni"
        subnet_id       = "subnet-87654321" # Replace with your subnet ID
        security_groups = []
      }
    ]
    ebs_volumes = [
      {
        name        = "dev-web-data"
        size        = "20"
        type        = "gp3"
        device_name = "/dev/sdf"
        mount_point = "/data"
      }
    ]
  }
]

# Development security groups
sg_data = [
  {
    name        = "dev-web-sg"
    description = "Security group for development web servers"
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
      Name = "dev-web-sg"
      Type = "web"
    }
  }
]

sg_names = ["dev-web-sg"]

# KMS key for encryption (optional)
kms_key_id = null # Will use default AWS managed key
