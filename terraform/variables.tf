variable "key_name" {
	description = "SSH key name in your AWS account for AWS instances."
}

variable "key_path" {
	description = "Path to the private key specified by key_name."
}

variable "vpc_id" {
	description = "VPC id for mesos-ceph. (must be enabled dns_support and dns_hostnames)"
}

variable "subnet_availability_zone" {
	description = "Availability zone for mesos-ceph subnet."
}

variable "subnet_cidr_block" {
	description = "Cidr block for mesos-ceph subnet."
}

variable "master1_ip" {
	description = "Private IP address for master1. (must be under the subnet_cidr_block)"
}

variable "master2_ip" {
	description = "Private IP address for master2. (must be under the subnet_cidr_block)"
}

variable "master3_ip" {
	description = "Private IP address for master3. (must be under the subnet_cidr_block)"
}

variable "slaves" {
	description = "The number of slaves."
	default = "3"
}

variable "slave_block_device" {
	description = "Block device for OSD."
	default = {
		volume_size = 30
	}
}

variable "region" {
	description = "AWS region for mesos-ceph."
	default = "us-east-1"
}

variable "instance_type" {
	default = {
		master = "t2.micro"
		slave  = "t2.micro"
		admin  = "t2.micro"
	}
}
