variable "public_subnet1_id" {}
variable "public_subnet2_id" {}
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

module "lab_alb" {
  source = "../../modules/alb"
  public_subnet1_id = "${var.public_subnet1_id}"
  public_subnet2_id = "${var.public_subnet2_id}"
  vpc_id = "${var.vpc_id}"
}

output "dns_name" {
  value = "${module.lab_alb.dns_name}"
}

output "alb-securitygroup" {
	value = "${module.lab_alb.alb-securitygroup}"
}

output "target_group_arn" {
	value = "${module.lab_alb.target_group_arn}"
}
