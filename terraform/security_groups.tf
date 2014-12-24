resource "aws_security_group" "private" {
	name        = "private"
	description = "private"
	vpc_id      = "${var.vpc_id}"

	ingress {
		from_port = 0
		to_port   = 65535
		protocol  = "tcp"
		self      = true
	}

	ingress {
		from_port = 0
		to_port   = 65535
		protocol  = "udp"
		self      = true
	}

	ingress {
		from_port = -1
		to_port   = -1
		protocol  = "icmp"
		self      = true
	}
}

resource "aws_security_group" "maintenance" {
	name        = "maintenance"
	description = "maintenance"
	vpc_id      = "${var.vpc_id}"

	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "master" {
	name        = "master"
	description = "master"
	vpc_id      = "${var.vpc_id}"

	ingress {
		from_port   = 5050
		to_port     = 5050
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port   = 8080
		to_port     = 8080
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

resource "aws_security_group" "slave" {
	name        = "slave"
	description = "slave"
	vpc_id      = "${var.vpc_id}"

	ingress {
		from_port   = 5051
		to_port     = 5051
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}
