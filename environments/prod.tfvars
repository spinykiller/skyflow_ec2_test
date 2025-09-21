# Production Environment Configuration
aws_region = "us-east-1"

default_tags = {
  env         = "prod"
  managed_by  = "terraform"
  project     = "ec2-deployment"
  cost_center = "production"
}


# Production EC2 instances
ec2_data = [
  {
    name          = "prod-web-server-1"
    vpc_id        = "vpc-87654321" # Replace with your VPC ID
    ami_id        = ""             # Will use default AMI
    ec2_metrics   = true
    instance_type = ""              # Will auto-select based on architecture
    key_name      = "prod-key-pair" # Replace with your key pair name
    architecture  = "x86_64"
    subnet_id     = "subnet-87654321" # Replace with your subnet ID
    az            = ""                # Will auto-select
    eni = [
      {
        name            = "prod-web-eni-1"
        subnet_id       = "subnet-11111111" # Replace with your subnet ID
        security_groups = []
      }
    ]
    ebs_volumes = [
      {
        name        = "prod-web-data-1"
        size        = "100"
        type        = "gp3"
        device_name = "/dev/sdf"
        mount_point = "/data"
      },
      {
        name        = "prod-web-logs"
        size        = "50"
        type        = "gp3"
        device_name = "/dev/sdg"
        mount_point = "/var/log"
      }
    ]
  },
  {
    name          = "prod-web-server-2"
    vpc_id        = "vpc-87654321" # Replace with your VPC ID
    ami_id        = ""             # Will use default AMI
    ec2_metrics   = true
    instance_type = ""              # Will auto-select based on architecture
    key_name      = "prod-key-pair" # Replace with your key pair name
    architecture  = "arm64"
    subnet_id     = "subnet-22222222" # Replace with your subnet ID
    az            = ""                # Will auto-select
    eni = [
      {
        name            = "prod-web-eni-2"
        subnet_id       = "subnet-33333333" # Replace with your subnet ID
        security_groups = []
      }
    ]
    ebs_volumes = [
      {
        name        = "prod-web-data-2"
        size        = "100"
        type        = "gp3"
        device_name = "/dev/sdf"
        mount_point = "/data"
      }
    ]
  }
]

# Production security groups
sg_data = [
  {
    name        = "prod-web-sg"
    description = "Security group for production web servers"
    vpc_id      = "vpc-87654321" # Replace with your VPC ID
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
      },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/8"] # Restrict SSH to internal networks
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
      Name = "prod-web-sg"
      Type = "web"
    }
  }
]

sg_names = ["prod-web-sg"]

# KMS key for encryption (recommended for production)
kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012" # Replace with your KMS key ARN
