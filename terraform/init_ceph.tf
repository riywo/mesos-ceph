resource "null_resource" "init_ceph" {
	depends_on = [
		"aws_instance.admin",
		"aws_instance.master1",
		"aws_instance.master2",
		"aws_instance.master3",
		"aws_instance.slaves",
	]

	connection {
		user        = "ubuntu"
		key_file    = "${var.key_path}"
		host        = "${aws_instance.admin.public_ip}"
		script_path = "/tmp/${null_resource.init_ceph.id}.sh"
	}

	provisioner "file" {
		source      = "${path.module}/scripts/header.sh"
		destination = "/tmp/${null_resource.init_ceph.id}-00header.sh"
	}

	provisioner "file" {
		source      = "${path.module}/scripts/init_ceph.sh"
		destination = "/tmp/${null_resource.init_ceph.id}-01init_ceph.sh"
	}

	provisioner "remote-exec" {
		inline = [
			"echo main ${aws_instance.admin.private_ip} ${var.master1_ip} ${var.master2_ip} ${var.master3_ip} ${join(\" \", aws_instance.slaves.*.private_ip)} | cat /tmp/${null_resource.init_ceph.id}-*.sh - | bash"
		]
	}
}
