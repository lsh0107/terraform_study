resource "aws_instance" "kafka_public" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = public_subnet_id  # 퍼블릭 서브넷
  associate_public_ip_address = true  # 퍼블릭 IP 할당
  vpc_security_group_ids = ["sg-0dc679a83c482ac84"]  # 보안 그룹 설정
  tags = {
    Name = "public-instance"
  }
}

resource "aws_instance" "kafka_private" {
  count                  = 4  # 프라이빗 인스턴스 4개 생성
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = modules.vpc.aws_subnet.private.id  # 프라이빗 서브넷
  associate_public_ip_address = false  # 퍼블릭 IP 할당 안함
  vpc_security_group_ids = ["sg-0dc679a83c482ac84"]
  tags = {
    Name = "private-instance-${count.index}"
  }
}


module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  vpc_name = "kafka-sg-vpc"
  public_subnet_cidr = "10.0.0.0/20"
  private_subnet_cidr = "10.0.128.0/20"
  availability_zone = "ap-northeast-2a"
  eip_allocation_id = "eipalloc-0537e81e745b88e47"
}

