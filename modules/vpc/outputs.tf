output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.kafka_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}