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

resource "aws_security_group" "nodes_sg" {
  name        = "microk8s-nodes-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Security group for all microk8s nodes"

  # SSH only from bastion
  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # Kubernetes API
  ingress {
    description = "Allow Kubernetes API access from master and workers"
    from_port   = 16443
    to_port     = 16443
    protocol    = "tcp"
    self        = true
  }

  # Allow Kubernetes API from bastion
  ingress {
    description     = "Allow Kubernetes API from bastion"
    from_port       = 16443
    to_port         = 16443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # Cluster join
  ingress {
    description = "Allow cluster join from master and workers"
    from_port   = 25000
    to_port     = 25000
    protocol    = "tcp"
    self        = true
  }

  # VXLAN (pod networking)
  ingress {
    description = "Allow VXLAN traffic for pod networking"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  # kubelet
  ingress {
    description = "Allow kubelet access from master and workers"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    self        = true
  }

  # dqlite (cluster DB)
  ingress {
    description = "Allow dqlite traffic for cluster database"
    from_port   = 19001
    to_port     = 19001
    protocol    = "tcp"
    self        = true
  }

  # Allow all internal communication
  ingress {
    description = "Allow all internal communication between nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Outbound internet (needed for pulling images)
  egress {
    description = "Allow outbound internet access for nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "demo_nodes_sg"
  })
}