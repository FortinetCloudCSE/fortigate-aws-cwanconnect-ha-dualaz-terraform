data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-igw"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-subnet2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-subnet2"
  }
}

resource "aws_subnet" "hamgmt_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.hamgmt_subnet_cidr1
  availability_zone = var.availability_zone1
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-hamgmt-subnet1"
  }
}

resource "aws_subnet" "hamgmt_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.hamgmt_subnet_cidr2
  availability_zone = var.availability_zone2
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-hamgmt-subnet2"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-private-rt"
  }
}

resource "aws_route" "private_rtb_route_to_cwan" {
  depends_on = [
    aws_networkmanager_vpc_attachment.cwan_vpc_attachment,
    aws_networkmanager_connect_attachment.cwan_connect_attachment
  ]
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = var.cwan_connect_cidr
  core_network_arn       = "arn:aws:networkmanager::${local.account_id}:core-network/${var.cwan_id}"
}

resource "aws_route_table_association" "public_rt_association1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association3" {
  subnet_id      = aws_subnet.hamgmt_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_association4" {
  subnet_id      = aws_subnet.hamgmt_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_association1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_networkmanager_vpc_attachment" "cwan_vpc_attachment" {
  depends_on      = [var.cwan_policy_state]
  core_network_id = var.cwan_id
  subnet_arns     = [aws_subnet.private_subnet1.arn, aws_subnet.private_subnet2.arn]
  vpc_arn         = aws_vpc.vpc.arn
  options {
    appliance_mode_support = true
  }
  tags = merge(
    {
      Name = "${var.tag_name_prefix}-${var.tag_name_unique}-vpc-attachment"
    },
    var.cwan_creation == "yes" ? {
      segment = var.cwan_segment_value
      } : {
      (var.cwan_segment_key) = var.cwan_segment_value
    }
  )
}

resource "aws_networkmanager_connect_attachment" "cwan_connect_attachment" {
  core_network_id         = var.cwan_id
  transport_attachment_id = aws_networkmanager_vpc_attachment.cwan_vpc_attachment.id
  edge_location           = var.region
  options {
    protocol = "NO_ENCAP"
  }
  tags = merge(
    {
      Name = "${var.tag_name_prefix}-${var.tag_name_unique}-connect-attachment"
    },
    var.cwan_creation == "yes" ? {
      segment = var.cwan_segment_value
      } : {
      (var.cwan_segment_key) = var.cwan_segment_value
    }
  )
}

resource "aws_networkmanager_connect_peer" "cwan_connect_peer1" {
  connect_attachment_id = aws_networkmanager_connect_attachment.cwan_connect_attachment.id
  peer_address          = split("/", var.fgt1_private_ip)[0]
  bgp_options {
    peer_asn = var.fgt_bgp_asn
  }
  subnet_arn = aws_subnet.private_subnet1.arn
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-connect-peer1"
  }
}

resource "aws_networkmanager_connect_peer" "cwan_connect_peer2" {
  connect_attachment_id = aws_networkmanager_connect_attachment.cwan_connect_attachment.id
  peer_address          = split("/", var.fgt2_private_ip)[0]
  bgp_options {
    peer_asn = var.fgt_bgp_asn
  }
  subnet_arn = aws_subnet.private_subnet2.arn
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-connect-peer2"
  }
}