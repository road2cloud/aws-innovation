
output "instance_private_ips" {
  value = "Instances: ${element(aws_instance.ec2.*.private_ip, 0)}"
}
