output "public-subnet1_id" {
  value = "${aws_subnet.public-subnet1.id}"
}

output "public-subnet2_id" {
  value = "${aws_subnet.public-subnet2.id}"
}

output "private-subnet1_id" {
  value = "${aws_subnet.private-subnet1.id}"
}

output "private-subnet2_id" {
  value = "${aws_subnet.private-subnet2.id}"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.default.cidr_block}"
}
