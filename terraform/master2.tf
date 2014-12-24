resource "aws_instance" "master2" {
	instance_type     = "${var.instance_type.master}"
	ami               = "${lookup(var.ami, var.region)}"
	key_name          = "${var.key_name}"
	subnet_id         = "${aws_subnet.public.id}"
	security_groups   = ["${aws_security_group.private.id}", "${aws_security_group.master.id}"]
	depends_on        = ["aws_instance.admin", "aws_internet_gateway.public"]

	private_ip        = "${var.master2_ip}"

	connection {
		user        = "ubuntu"
		key_file    = "${var.key_path}"
		host        = "${aws_instance.admin.public_ip}"
		script_path = "/tmp/${aws_instance.master2.id}.sh"
	}

	provisioner "file" {
		source      = "${path.module}/scripts/header.sh"
		destination = "/tmp/${aws_instance.master2.id}-00header.sh"
	}

	provisioner "file" {
		source      = "${path.module}/scripts/init_master.sh"
		destination = "/tmp/${aws_instance.master2.id}-01init_master.sh"
	}

	provisioner "remote-exec" {
		inline = [
			"echo main ${var.master2_ip} ${aws_instance.master2.public_dns} | cat /tmp/${aws_instance.master2.id}-*.sh - | bash"
		]
	}
}
