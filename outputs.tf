output "bastion" {
  value = "${module.caas_vpc.bastion_ip}"
}

output "ec2-private-ip" {
  value = "${module.caas_ec2.instance_private_ips}"
}
