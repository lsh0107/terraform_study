resource "aws_vpc" "kafka_vpc" {
  cidr_block = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "vpc_igw" {  # vpc_igw로 이름 수정
  vpc_id = aws_vpc.kafka_vpc.id  # VPC 이름에 맞게 참조 수정
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.kafka_vpc.id  # VPC 이름에 맞게 참조 수정
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.vpc_name}-subnet-public1"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.kafka_vpc.id  # VPC 이름에 맞게 참조 수정
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "${var.vpc_name}-subnet-private1"
  }
}

resource "aws_nat_gateway" "vpc_nat" {
  allocation_id = var.eip_allocation_id
  subnet_id     = aws_subnet.public_subnet.id  # 서브넷 이름에 맞게 참조 수정
  tags = {
    Name = "${var.vpc_name}-nat-public1"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.kafka_vpc.id  # VPC 이름에 맞게 참조 수정
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id  # 인터넷 게이트웨이 이름에 맞게 참조 수정
  }
  tags = {
    Name = "${var.vpc_name}-rtb-public"
  }
}

resource "aws_route_table_association" "public_table_association" {
  subnet_id      = aws_subnet.public_subnet.id  # 서브넷 이름에 맞게 참조 수정
  route_table_id = aws_route_table.public_route_table.id  # 라우팅 테이블 이름에 맞게 참조 수정
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.kafka_vpc.id  # VPC 이름에 맞게 참조 수정
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.vpc_nat.id  # NAT 게이트웨이 이름에 맞게 참조 수정
  }
  tags = {
    Name = "${var.vpc_name}-rtb-private1"
  }
}

resource "aws_route_table_association" "private_table_association" {
  subnet_id      = aws_subnet.private_subnet.id  # 서브넷 이름에 맞게 참조 수정
  route_table_id = aws_route_table.private_route_table.id  # 라우팅 테이블 이름에 맞게 참조 수정
}
