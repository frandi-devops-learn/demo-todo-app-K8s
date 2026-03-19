resource "aws_eip" "ec2_eip" {
  instance = aws_instance.master_node_ec2.id
  domain   = "vpc"

  tags = merge(local.common_tags, {
    Name = "master_node-ec2-eip"
  })
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-nat-eip"
  })
}