variable "access_key" {
  default = "AKIAJZKDAIFPVGBKOL4Q"
}

variable "secret_key" {
  default = "vn6K6fHto5YqzOIjzOjhTMat8qiDFLbQ0RrbM0d/"
}

variable "region" {
  default = "us-east-1"
}

variable "aws_key_name" {
  default = "MyNVirginiaKey"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}
