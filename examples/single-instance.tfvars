# Example: Single EC2 Instance Configuration
aws_region = "us-west-2"

default_tags = {
  env         = "example"
  managed_by  = "terraform"
  project     = "single-instance-demo"
  cost_center = "demo"
}

# VPC Configuration
vpc_id             = "vpc-12345678" # Replace with your VPC ID
public_subnet_ids  = ["subnet-12345678"] # Replace with your public subnet IDs
private_subnet_ids = ["subnet-87654321"] # Replace with your private subnet IDs
key_pair_name      = "demo-key" # Replace with your key pair name

# Single EC2 instance with custom AMI
ec2_data = [
  {
    name          = "demo-instance"
    vpc_id        = "vpc-12345678"          # Replace with your VPC ID
    ami_id        = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
    ec2_metrics   = true
    instance_type = "t3.micro" # Specific instance type
    key_name      = "demo-key" # Replace with your key pair name
    architecture  = "x86_64"
    subnet_id     = "subnet-12345678" # Replace with your subnet ID
    az            = "us-west-2a"      # Specific availability zone
    eni           = []                # No additional ENIs
    ebs_volumes = [
      {
        name        = "demo-data"
        size        = "10"
        type        = "gp3"
        device_name = "/dev/sdf"
        mount_point = "/opt/data"
      }
    ]
  }
]

# No additional security groups
sg_data  = []
sg_names = []

# Use default KMS key
kms_key_id = null
