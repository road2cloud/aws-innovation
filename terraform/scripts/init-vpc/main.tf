variable "region" {
  default = "us-east-1"
}
variable "access_key" {}
variable "secret_key" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "lab_vpc" {
  source = "../../modules/vpc"
}

output "private-subnet1_id" {
  value = "${module.lab_vpc.private-subnet1_id}"
}

output "private-subnet2_id" {
  value = "${module.lab_vpc.private-subnet2_id}"
}

output "public-subnet1_id" {
  value = "${module.lab_vpc.public-subnet1_id}"
}

output "public-subnet2_id" {
  value = "${module.lab_vpc.public-subnet2_id}"
}

output "vpc_id" {
  value = "${module.lab_vpc.vpc_id}"
}
