# EC2 Instance Terraform Module

A Terraform module for creating EC2 instances with EBS volumes, network interfaces, and security groups.

## Features

- **Multi-Instance Support**: Deploy multiple EC2 instances with different configurations
- **Dynamic AMI Selection**: Auto-selects Amazon Linux 2 AMI or uses custom AMI
- **EBS Volume Management**: Create multiple encrypted EBS volumes with auto-mounting
- **Network Interfaces**: Support for primary and secondary ENIs
- **Security Groups**: Configurable security groups with default SSH/HTTP/HTTPS access
- **IAM Integration**: SSM, CloudWatch, and EC2 read-only policies
- **Architecture Support**: Both x86_64 and ARM64 instances

## Quick Start

### 1. Configure Backend

Update `backend.tf` with your S3 bucket:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "ec2-instances/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

### 2. Deploy

```bash
terraform init
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

## Configuration Example

```hcl
ec2_data = [
  {
    name          = "web-server"
    vpc_id        = "vpc-12345678"
    ami_id        = ""                    # Auto-select AMI
    instance_type = "t3.micro"
    key_name      = "my-key-pair"
    architecture  = "x86_64"
    subnet_id     = "subnet-12345678"
    az            = "us-east-1a"
    eni = []
    ebs_volumes = [
      {
        name        = "data-volume"
        size        = "20"
        type        = "gp3"
        device_name = "/dev/sdf"
        mount_point = "/data"
      }
    ]
  }
]
```

## Architecture

```
├── main.tf                 # Root configuration
├── vars.tf                 # Variables
├── backend.tf             # State management
├── modules/
│   ├── ec2/              # EC2 instance module
│   └── security_groups/  # Security group module
├── environments/          # Environment configs
└── examples/            # Usage examples
```

## Outputs

The module outputs instance details including:
- Instance ID, public/private IPs
- Security group IDs
- EBS volume IDs
- IAM role information

The user data script will automatically:
1. Wait for `/dev/sdf` and `/dev/sdg` to be available
2. Format them with XFS if needed
3. Create `/app/data` and `/var/log` directories
4. Mount the volumes
5. Add entries to `/etc/fstab` for persistence

## License

MIT License
