resource "aws_instance" "slaves" {
	count = "${var.slaves}"

	instance_type     = "${var.instance_type.slave}"
	ami               = "${lookup(var.ami, var.region)}"
	key_name          = "${var.key_name}"
	subnet_id         = "${aws_subnet.public.id}"
	security_groups   = ["${aws_security_group.private.id}", "${aws_security_group.slave.id}"]
	depends_on        = ["aws_instance.admin", "aws_internet_gateway.public"]

	block_device {
		device_name           = "/dev/sdb"
		volume_size           = "${var.slave_block_device.volume_size}"
		delete_on_termination = true
	}

	connection {
		user        = "ubuntu"
		key_file    = "${var.key_path}"
		host        = "${aws_instance.admin.public_ip}"
		script_path = "/tmp/${element(aws_instance.slaves.*.id, count.index)}.sh"
	}

	provisioner "file" {
		source      = "${path.module}/scripts/header.sh"
		destination = "/tmp/${element(aws_instance.slaves.*.id, count.index)}-00header.sh"
	}

	provisioner "file" {
		source      = "${path.module}/scripts/init_slave.sh"
		destination = "/tmp/${element(aws_instance.slaves.*.id, count.index)}-01init_slave.sh"
	}

	provisioner "remote-exec" {
		inline = [
			"echo main ${element(aws_instance.slaves.*.private_ip, count.index)} ${element(aws_instance.slaves.*.public_dns, count.index)} | cat /tmp/${element(aws_instance.slaves.*.id, count.index)}-*.sh - | bash"
		]
	}
}
