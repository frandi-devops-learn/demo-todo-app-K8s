resource "aws_security_group" "bastion_sg" {
  name        = "demo-bastion-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Security group for bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allow_ssh
    description = "Allow SSH Connection from Trusted IPs"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "demo-bastion-sg"
  })

}

resource "aws_security_group" "alb_sg" {
  name   = "demo-alb-sg"
  vpc_id = aws_vpc.vpc.id

  # Internet → ALB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from internet"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from internet"
  }

  # ALB → VPC (Worker Nodes)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound to VPC"
  }

  tags = merge(local.common_tags, {
    Name = "demo-alb-sg"
  })
}

resource "aws_security_group" "master_sg" {
  name   = "demo-master-sg"
  vpc_id = aws_vpc.vpc.id

  # SSH from bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "SSH from bastion"
  }

  # Kubernetes API from bastion
  ingress {
    from_port       = 16443
    to_port         = 16443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "K8s API from bastion"
  }

  # ALL MicroK8s internal communication via VPC CIDR
  ingress {
    description = "MicroK8s internal cluster traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = merge(local.common_tags, {
    Name = "demo-master-sg"
  })
}

resource "aws_security_group" "worker_sg" {
  name   = "demo-worker-sg"
  vpc_id = aws_vpc.vpc.id

  # SSH from bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
    description     = "AllowSSH from bastion"
  }

  # ALB → NodePort
  ingress {
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "Allow ALB to NodePort"
  }

  # Internal cluster communication
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
    description = "Allow internal cluster communication"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound to internet"
  }

  tags = merge(local.common_tags, {
    Name = "demo-worker-sg"
  })
}

resource "aws_security_group" "rds_sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "demo-todo-rds-sg"
  description = "Allow RDS Connection from Backend MicroK8s"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.worker_sg.id]
    description     = "Allow RDS Connection from Backend MicroK8s"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.rds_sg}"
  })
}