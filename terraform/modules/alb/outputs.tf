output "alb-securitygroup" {
	value = "${aws_security_group.alb-securitygroup.id}"
}

output "target_group_arn" {
	value = "${aws_lb_target_group.alb_target_group.arn}"
}

output "dns_name" {
	value = "${aws_lb.alb.dns_name}"
}
