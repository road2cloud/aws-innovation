
output "instance_private_ip" {
  value = "${aws_instance.ec2.private_ip}"
}
