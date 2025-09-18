resource "aws_iam_role" "ssm_role" {
  name = "${local.environment}-${local.project_name}-ssm-role-${var.ec2_data.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name         = "${local.environment}-${local.project_name}-ssm-role-${var.ec2_data.name}"
    InstanceName = var.ec2_data.name
  })
}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ec2_read_only_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${local.environment}-${local.project_name}-ssm-profile-${var.ec2_data.name}"
  role = aws_iam_role.ssm_role.name

  tags = merge(var.tags, {
    Name         = "${local.environment}-${local.project_name}-ssm-profile-${var.ec2_data.name}"
    InstanceName = var.ec2_data.name
  })
}