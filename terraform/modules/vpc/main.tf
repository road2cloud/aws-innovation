/*********************
  AWS VPC
*********************/

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    tags {
        Name = "main"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

/*********************
  Public Subnet and IG
*********************/
resource "aws_subnet" "public-subnet1" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_cidr1}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"

    tags {
        Name = "Public Subnet 1"
    }
}

resource "aws_subnet" "public-subnet2" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_cidr2}"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = "true"

    tags {
        Name = "Public Subnet 2"
    }
}

resource "aws_route_table" "public-route-table" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Public Route Table"
    }
}

resource "aws_route_table_association" "public-route-table-assoc1" {
    subnet_id = "${aws_subnet.public-subnet1.id}"
    route_table_id = "${aws_route_table.public-route-table.id}"
}

resource "aws_route_table_association" "public-route-table-assoc2" {
    subnet_id = "${aws_subnet.public-subnet2.id}"
    route_table_id = "${aws_route_table.public-route-table.id}"
}

/*********************
  Private Subnet
*********************/
resource "aws_subnet" "private-subnet1" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_cidr1}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "false"

    tags {
        Name = "Private Subnet 1"
    }
}

resource "aws_subnet" "private-subnet2" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_cidr2}"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = "false"

    tags {
        Name = "Private Subnet 2"
    }
}

/**********************************************
  NAT GAteway association with private subnets
*********************************************/
resource "aws_eip" "nat1" {
    vpc = true
}

resource "aws_eip" "nat2" {
    vpc = true
}

resource "aws_nat_gateway" "nat-gateway1" {
  allocation_id = "${aws_eip.nat1.id}"
  subnet_id = "${aws_subnet.public-subnet1.id}"

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "nat-gateway2" {
  allocation_id = "${aws_eip.nat2.id}"
  subnet_id = "${aws_subnet.public-subnet2.id}"

  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_route_table" "private-subnet1" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gateway1.id}"
    }

    tags {
        Name = "NAT Gateway 1"
    }
}

resource "aws_route_table" "private-subnet2" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gateway2.id}"
    }

    tags {
        Name = "NAT Gateway 2"
    }
}

resource "aws_route_table_association" "private-subnet1" {
    subnet_id = "${aws_subnet.private-subnet1.id}"
    route_table_id = "${aws_route_table.private-subnet1.id}"
}

resource "aws_route_table_association" "private-subnet2" {
    subnet_id = "${aws_subnet.private-subnet2.id}"
    route_table_id = "${aws_route_table.private-subnet2.id}"
}
