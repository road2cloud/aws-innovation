variable "access_key" {}
variable "secret_key" {}
variable "aws_key_name" {}
variable "project" {}
variable "numOfInstances" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "caas_vpc" {
  source = "./modules/vpc"
  aws_key_name = "${var.aws_key_name}"
}

module "caas_ec2" {
  source = "./modules/ec2"
  caas_sg = "${module.caas_vpc.caas-sg_id}"
  caas_subnet_id = "${module.caas_vpc.us-east-1a-private_id}"
  project = "${var.project}"
  numOfInstances = "${var.numOfInstances}"
}
