variable "caas_sg" {}
variable "caas_subnet_id" {}
variable "project" {}

resource "tls_private_key" "default" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated" {
  depends_on = ["tls_private_key.default"]
  key_name   = "${var.project}-keypair"
  public_key = "${tls_private_key.default.public_key_openssh}"
}

resource "local_file" "private_key_pem" {
  depends_on = ["tls_private_key.default"]
  content    = "${tls_private_key.default.private_key_pem}"
  filename   = "./ansible/${var.project}-keypair.pem"
}

resource "aws_instance" "ec2" {
    ami = "ami-1853ac65"
    availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "${var.project}-keypair"
    vpc_security_group_ids = ["${var.caas_sg}"]
    subnet_id = "${var.caas_subnet_id}"
    associate_public_ip_address = false
    source_dest_check = false

    depends_on = ["aws_key_pair.generated"]

    tags {
        Name = "CAAS_${var.project}"
    }
}

resource "aws_ebs_volume" "ebs_ssd" {
  availability_zone = "us-east-1a"
  size = 10
  type = "gp2"
}

resource "aws_volume_attachment" "ebs_ssd_att" {
  device_name = "/dev/sdh"
  volume_id = "${aws_ebs_volume.ebs_ssd.id}"
  instance_id = "${aws_instance.ec2.id}"
}
