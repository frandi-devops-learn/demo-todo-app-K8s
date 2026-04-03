# IAM Role for EC2 (SSM + ALB Controller)

resource "aws_iam_role" "ec2_role" {
  name = "microk8s-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "microk8s-ec2-role"
  }
}


# Attach SSM Managed Policy

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# Custom Policy for AWS Load Balancer Controller

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerPolicy"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticloadbalancing:*",
          "ec2:Describe*",
          "ec2:CreateSecurityGroup",
          "ec2:CreateTags",
          "ec2:DeleteTags",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:CreateVolume",
          "ec2:DeleteVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DescribeSubnets",
          "ec2:DescribeVolumes",
          "ec2:DescribeAvailabilityZones",
          "iam:CreateServiceLinkedRole"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name = "alb-controller-policy"
  }
}


# Attach ALB Policy to EC2 Role

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}


# Instance Profile (USED BY EC2)

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "microk8s-ec2-profile"
  role = aws_iam_role.ec2_role.name
}