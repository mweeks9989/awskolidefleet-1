data "aws_availability_zones" "available" {}

resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr_block}" 
  enable_dns_hostnames = true
  
  tags = {
    Name   = "template-vpc"
	Deploy = "Terraform"
  }
}

resource "aws_subnet" "public" {
  count                   = "${var.az_count}"
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.vpc_cidr_net}.${10+count.index}.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  
  tags = {
    Name = "subnet-public-${count.index}-${var.namespace}"
	Deploy = "Terraform"
  }
}

resource "aws_subnet" "private" {
  count                   = "${var.az_count}"
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.vpc_cidr_net}.${20+count.index}.0/24"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  
  tags = {
    Name = "subnet-private-${count.index}-${var.namespace}"
	Deploy = "Terraform"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "default" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_eip" "nat" {
  count      = "${var.az_count}"
  vpc        = true
  depends_on = ["aws_internet_gateway.default"]
}

resource "aws_nat_gateway" "nat" {
	count         = "${var.az_count}"
	allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
	subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  
  	tags = {
        name = "nat-private-${count.index}-${var.namespace}"
		deploy = "Terraform" 
    }
}

resource "aws_route_table" "private" {
  count  = "${var.az_count}"
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }
}

resource "aws_route_table_association" "private" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

	#default private vpc dns zone

resource "aws_route53_zone" "default" {
	name = "${var.namespace}.priv"

	vpc {
		vpc_id = "${aws_vpc.default.id}"
	}
}


