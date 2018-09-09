resource "aws_efs_file_system" "main" {
  tags {
    Name = "LAB ARC"
  }
}

resource "aws_efs_mount_target" "main_subnet1" {
  file_system_id = "${aws_efs_file_system.main.id}"
  subnet_id      = "${var.subnet1_id}"

  security_groups = [
    "${aws_security_group.efs.id}",
  ]
}

resource "aws_efs_mount_target" "main_subnet2" {
  file_system_id = "${aws_efs_file_system.main.id}"
  subnet_id      = "${var.subnet2_id}"

  security_groups = [
    "${aws_security_group.efs.id}",
  ]
}

resource "aws_security_group" "efs" {
  name        = "efs-mnt"
  description = "Allows NFS traffic from instances within the VPC."
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      "${var.vpc_cidr_block}",
    ]
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      "${var.vpc_cidr_block}",
    ]
  }

  tags {
    Name = "allow_nfs-ec2"
  }
}
