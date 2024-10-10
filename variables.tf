variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "kafka_private" {
  description = "kfaka-instance"
  type        = string
  default     = "t2.medium"
}

variable "kafka_public" {
  description = "kafka-ansible"
  type        = string
  default     = "t2.small"
}
