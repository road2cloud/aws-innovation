provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

module "lab_vpc" {
  source = "./modules/vpc"
}

module "lab_autoscaling" {
  source = "./modules/autoscaling"
  vpc_id = "${module.lab_vpc.vpc_id}"
  public_subnet1_id = "${module.lab_vpc.public-subnet1_id}"
  public_subnet2_id = "${module.lab_vpc.public-subnet2_id}"
}

module "lab_rds" {
  source = "./modules/rds"
  private_subnet1_id = "${module.lab_vpc.private-subnet1_id}"
  private_subnet2_id = "${module.lab_vpc.private-subnet2_id}"
}

/*module "myec2" {
  source = "./modules/ec2"
  caas_sg = "${module.caas_vpc.caas-sg_id}"
  caas_subnet_id = "${module.caas_vpc.us-east-1a-private_id}"
  project = "${var.project}"
}*/
