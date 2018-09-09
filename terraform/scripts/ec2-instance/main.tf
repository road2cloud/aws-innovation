variable "alb-securitygroup" {}
variable "public_subnet1_id" {}
variable "public_subnet2_id" {}
variable "target_group_arn" {}
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

module "lab_autoscaling" {
  source = "../../modules/autoscaling"
  public_subnet1_id = "${var.public_subnet1_id}"
  public_subnet2_id = "${var.public_subnet2_id}"
  target_group_arn = "${var.target_group_arn}"
  alb-securitygroup = "${var.alb-securitygroup}"
  vpc_id = "${var.vpc_id}"
  AMI_ID = "${var.AMI_ID}"
}
