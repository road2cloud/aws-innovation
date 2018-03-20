output "us-east-1a-private_id" {
  value = "${aws_subnet.us-east-1a-private.id}"
}

output "caas-sg_id" {
  value = "${aws_security_group.caas-sg.id}"
}

output "bastion_ip" {
  value = "${aws_eip.bastion-ip.public_ip}"
}
