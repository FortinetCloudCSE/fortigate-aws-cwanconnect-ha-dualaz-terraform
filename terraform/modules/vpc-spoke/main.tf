data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-vpc"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-subnet2"
  }
}

resource "aws_route" "route_to_cwan" {
  count = var.cwan_creation
  depends_on = [aws_networkmanager_vpc_attachment.cwan_attachment]
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  core_network_arn = "arn:aws:networkmanager::${local.account_id}:core-network/${var.cwan_id}"
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-rt"
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.private_rt.id]
}

resource "aws_route_table_association" "private_rt_association1" {
  subnet_id = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association2" {
  subnet_id = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_networkmanager_vpc_attachment" "cwan_attachment" {
  count = var.cwan_creation
  depends_on = [var.cwan_policy_state]
  core_network_id = var.cwan_id
  subnet_arns = [aws_subnet.private_subnet1.arn, aws_subnet.private_subnet2.arn]
  vpc_arn = aws_vpc.vpc.arn
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-vpc-attachment"
    segment = "${var.cwan_segment}"
  }
}