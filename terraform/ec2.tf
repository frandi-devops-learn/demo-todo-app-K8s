resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "bastion_host" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.pub_subnet[0].id
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  user_data = file("${path.module}/scripts/bastion_user_data.sh")
  user_data_replace_on_change = false

  tags = merge(local.common_tags, {
    Name = "demo_bastion"
  })
}

resource "aws_instance" "master_node_ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.priv_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.master_sg.id]
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = file("${path.module}/scripts/ec2_user_data.sh")
  user_data_replace_on_change = false

  tags = merge(local.common_tags, {
    Name                                     = "demo_master"
    Role                                     = "Master_Node"
    "kubernetes.io/cluster/microk8s-cluster" = "owned"
  })
}

resource "aws_instance" "workers" {
  count = var.instance_count

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.priv_subnet[count.index].id

  vpc_security_group_ids      = [aws_security_group.worker_sg.id]
  key_name                    = aws_key_pair.key.key_name
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data                   = file("${path.module}/scripts/ec2_user_data.sh")
  user_data_replace_on_change = false

  tags = merge(local.common_tags, {
    Name                                     = "demo_worker-${count.index + 1}"
    Role                                     = "Worker_Node"
    "kubernetes.io/cluster/microk8s-cluster" = "owned"
  })
}