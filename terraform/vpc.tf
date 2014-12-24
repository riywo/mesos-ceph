resource "aws_internet_gateway" "public" {
	vpc_id = "${var.vpc_id}"
}

resource "aws_route_table" "public" {
	vpc_id = "${var.vpc_id}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.public.id}"
	}
}

resource "aws_subnet" "public" {
	vpc_id                  = "${var.vpc_id}"
	availability_zone       = "${var.subnet_availability_zone}"
	cidr_block              = "${var.subnet_cidr_block}"
	map_public_ip_on_launch = true
	depends_on              = ["aws_internet_gateway.public"]
}

resource "aws_route_table_association" "public" {
	subnet_id      = "${aws_subnet.public.id}"
	route_table_id = "${aws_route_table.public.id}"
}
