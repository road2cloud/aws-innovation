variable "region" {
  default = "us-east-1"
}
variable "access_key" {}
variable "secret_key" {}
variable "vpc_id" {}
variable "cluster-name" {
  default = "arclab"
}
variable "public_subnet1_id" {}
variable "public_subnet2_id" {}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "lab_eks" {
  source = "../../modules/eks"
  public_subnet1_id = "${var.public_subnet1_id}"
  public_subnet2_id = "${var.public_subnet2_id}"
  vpc_id = "${var.vpc_id}"
  region = "${var.region}"
}

output "kubeconfig" {
  value = "${module.lab_eks.kubeconfig}"
}

output "config-map-aws-auth" {
  value = "${module.lab_eks.config-map-aws-auth}"
}
