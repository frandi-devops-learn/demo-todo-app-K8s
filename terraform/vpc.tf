resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-igw"
  })
}

resource "aws_subnet" "priv_subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.vpc_priv_subnets)
  cidr_block        = var.vpc_priv_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(local.common_tags, {
    Name = "${var.priv_name}-${count.index + 1}"
  })
}

resource "aws_subnet" "pub_subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.vpc_pub_subnets)
  cidr_block        = var.vpc_pub_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(local.common_tags, {
    Name = "${var.pub_name}-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet[0].id

  tags = merge(local.common_tags, {
    Name = "${var.vpc_name}-nat-gw"
  })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "priv_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.rtb_name}-private-rtb"
  })
}

resource "aws_route_table_association" "priv_rtb_assoc" {
  count          = length(var.vpc_priv_subnets)
  subnet_id      = aws_subnet.priv_subnet[count.index].id
  route_table_id = aws_route_table.priv_rtb.id
}

resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.rtb_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.rtb_name}-public-rtb"
  })
}

resource "aws_route_table_association" "pub_rtb_assoc" {
  count          = length(var.vpc_pub_subnets)
  subnet_id      = aws_subnet.pub_subnet[count.index].id
  route_table_id = aws_route_table.pub_rtb.id
}