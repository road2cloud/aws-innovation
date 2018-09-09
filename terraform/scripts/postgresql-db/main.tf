variable "private-subnet1_id" {}
variable "private-subnet2_id" {}
variable "vpc_id" {}
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

module "lab_rds" {
  source = "../../modules/rds"
  private_subnet1_id = "${var.private-subnet1_id}"
  private_subnet2_id = "${var.private-subnet2_id}"
  #public_sg = "${module.lab_autoscaling.public_sg}"
  vpc_id = "${var.vpc_id}"
}

output "endpoint" {
  value = "${module.lab_rds.endpoint}"
}
