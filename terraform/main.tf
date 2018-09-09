provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "lab_vpc" {
  source = "./modules/vpc"
}

module "lab_efs" {
  source = "./modules/efs"
  subnet1_id = "${module.lab_vpc.public-subnet1_id}"
  subnet2_id = "${module.lab_vpc.public-subnet2_id}"
  vpc_id = "${module.lab_vpc.vpc_id}"
  vpc_cidr_block = "${module.lab_vpc.vpc_cidr_block}"
}

/*module "lab_rds" {
  source = "./modules/rds"
  private_subnet1_id = "${module.lab_vpc.private-subnet1_id}"
  private_subnet2_id = "${module.lab_vpc.private-subnet2_id}"
  #public_sg = "${module.lab_autoscaling.public_sg}"
  vpc_id = "${module.lab_vpc.vpc_id}"
}*/

module "lab_autoscaling" {
  source = "./modules/autoscaling"
  vpc_id = "${module.lab_vpc.vpc_id}"
  public_subnet1_id = "${module.lab_vpc.public-subnet1_id}"
  public_subnet2_id = "${module.lab_vpc.public-subnet2_id}"
}
