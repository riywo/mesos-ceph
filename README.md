mesos-ceph
==========

Terraform module for Mesos + Ceph cluster in AWS VPC and Packer template for the AMI.

## Summary

This Terraform module will spin up instances like below by default:

- admin
    - t2.micro
    - ssh gateway
    - run ceph-deploy
- master1, master2, master3
    - t2.micro
    - mesos master
    - marathon
    - ceph mon
    - ceph mds
    - mount cephfs
- slaves (default 3)
    - t2.micro
    - mesos slave
    - ceph osd
        - 1 EBS attached (default 30GB)
    - mount cephfs

## Usage

Just add the `module` into your Terraform config like below:

````
provider "aws" {}

resource "aws_vpc" "default" {
        cidr_block           = "10.0.0.0/16"
        enable_dns_support   = true
        enable_dns_hostnames = true
}

module "mesos_ceph" {
        source                   = "github.com/riywo/mesos-ceph/terraform"
        vpc_id                   = "${aws_vpc.default.id}"
        key_name                 = "${var.key_name}"
        key_path                 = "${var.key_path}"
        subnet_availability_zone = "us-east-1e"
        subnet_cidr_block        = "10.0.1.0/24"
        master1_ip               = "10.0.1.11"
        master2_ip               = "10.0.1.12"
        master3_ip               = "10.0.1.13"
}
````

Note: You can use environment variables for AWS configuration and `terraform.tfvars` file for variables.

````
export AWS_REGION=us-east-1
export AWS_ACCESS_KEY=AAAAAAAAAA
export AWS_SECRET_KEY=000000000000000000
````

````
$ cat terraform.tfvars
key_name = "your key name"
key_path = "/path/to/private_pem_file"
````

Then, check plan.

````
$ terraform plan -module-depth -1
Refreshing Terraform state prior to plan...


The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ aws_vpc.default
    cidr_block:           "" => "10.0.0.0/16"
    enable_dns_hostnames: "" => "1"
    enable_dns_support:   "" => "1"
    main_route_table_id:  "" => "<computed>"

+ module.mesos.aws_instance.admin
    ami:               "" => "ami-06ef816e"
    availability_zone: "" => "<computed>"
    instance_type:     "" => "t2.micro"
    key_name:          "" => "your key name"
    private_dns:       "" => "<computed>"
    private_ip:        "" => "<computed>"
    public_dns:        "" => "<computed>"
    public_ip:         "" => "<computed>"
    security_groups.#: "" => "<computed>"
    subnet_id:         "" => "${aws_subnet.public.id}"
    tenancy:           "" => "<computed>"

+ module.mesos.aws_instance.master1
    ami:               "" => "ami-06ef816e"
    availability_zone: "" => "<computed>"
    instance_type:     "" => "t2.micro"
    key_name:          "" => "your key name"
    private_dns:       "" => "<computed>"
    private_ip:        "" => "10.0.1.11"
    public_dns:        "" => "<computed>"
    public_ip:         "" => "<computed>"
    security_groups.#: "" => "<computed>"
    subnet_id:         "" => "${aws_subnet.public.id}"
    tenancy:           "" => "<computed>"

+ module.mesos.aws_instance.master2
    ami:               "" => "ami-06ef816e"
    availability_zone: "" => "<computed>"
    instance_type:     "" => "t2.micro"
    key_name:          "" => "your key name"
    private_dns:       "" => "<computed>"
    private_ip:        "" => "10.0.1.12"
    public_dns:        "" => "<computed>"
    public_ip:         "" => "<computed>"
    security_groups.#: "" => "<computed>"
    subnet_id:         "" => "${aws_subnet.public.id}"
    tenancy:           "" => "<computed>"

+ module.mesos.aws_instance.master3
    ami:               "" => "ami-06ef816e"
    availability_zone: "" => "<computed>"
    instance_type:     "" => "t2.micro"
    key_name:          "" => "your key name"
    private_dns:       "" => "<computed>"
    private_ip:        "" => "10.0.1.13"
    public_dns:        "" => "<computed>"
    public_ip:         "" => "<computed>"
    security_groups.#: "" => "<computed>"
    subnet_id:         "" => "${aws_subnet.public.id}"
    tenancy:           "" => "<computed>"

+ module.mesos.aws_instance.slaves.0
    ami:                                  "" => "ami-06ef816e"
    availability_zone:                    "" => "<computed>"
    block_device.#:                       "" => "1"
    block_device.0.delete_on_termination: "" => "1"
    block_device.0.device_name:           "" => "/dev/sdb"
    block_device.0.encrypted:             "" => ""
    block_device.0.snapshot_id:           "" => ""
    block_device.0.virtual_name:          "" => ""
    block_device.0.volume_size:           "" => "30"
    block_device.0.volume_type:           "" => ""
    instance_type:                        "" => "t2.micro"
    key_name:                             "" => "your key name"
    private_dns:                          "" => "<computed>"
    private_ip:                           "" => "<computed>"
    public_dns:                           "" => "<computed>"
    public_ip:                            "" => "<computed>"
    security_groups.#:                    "" => "<computed>"
    subnet_id:                            "" => "${aws_subnet.public.id}"
    tenancy:                              "" => "<computed>"

+ module.mesos.aws_instance.slaves.1
    ami:                                  "" => "ami-06ef816e"
    availability_zone:                    "" => "<computed>"
    block_device.#:                       "" => "1"
    block_device.0.delete_on_termination: "" => "1"
    block_device.0.device_name:           "" => "/dev/sdb"
    block_device.0.encrypted:             "" => ""
    block_device.0.snapshot_id:           "" => ""
    block_device.0.virtual_name:          "" => ""
    block_device.0.volume_size:           "" => "30"
    block_device.0.volume_type:           "" => ""
    instance_type:                        "" => "t2.micro"
    key_name:                             "" => "your key name"
    private_dns:                          "" => "<computed>"
    private_ip:                           "" => "<computed>"
    public_dns:                           "" => "<computed>"
    public_ip:                            "" => "<computed>"
    security_groups.#:                    "" => "<computed>"
    subnet_id:                            "" => "${aws_subnet.public.id}"
    tenancy:                              "" => "<computed>"

+ module.mesos.aws_instance.slaves.2
    ami:                                  "" => "ami-06ef816e"
    availability_zone:                    "" => "<computed>"
    block_device.#:                       "" => "1"
    block_device.0.delete_on_termination: "" => "1"
    block_device.0.device_name:           "" => "/dev/sdb"
    block_device.0.encrypted:             "" => ""
    block_device.0.snapshot_id:           "" => ""
    block_device.0.virtual_name:          "" => ""
    block_device.0.volume_size:           "" => "30"
    block_device.0.volume_type:           "" => ""
    instance_type:                        "" => "t2.micro"
    key_name:                             "" => "your key name"
    private_dns:                          "" => "<computed>"
    private_ip:                           "" => "<computed>"
    public_dns:                           "" => "<computed>"
    public_ip:                            "" => "<computed>"
    security_groups.#:                    "" => "<computed>"
    subnet_id:                            "" => "${aws_subnet.public.id}"
    tenancy:                              "" => "<computed>"

+ module.mesos.aws_internet_gateway.public
    vpc_id: "" => "${var.vpc_id}"

+ module.mesos.aws_route_table.public
    route.#:             "" => "1"
    route.0.cidr_block:  "" => "0.0.0.0/0"
    route.0.gateway_id:  "" => "${aws_internet_gateway.public.id}"
    route.0.instance_id: "" => ""
    vpc_id:              "" => "${var.vpc_id}"

+ module.mesos.aws_route_table_association.public
    route_table_id: "" => "${aws_route_table.public.id}"
    subnet_id:      "" => "${aws_subnet.public.id}"

+ module.mesos.aws_security_group.maintenance
    description:                 "" => "maintenance"
    ingress.#:                   "" => "1"
    ingress.0.cidr_blocks.#:     "" => "1"
    ingress.0.cidr_blocks.0:     "" => "0.0.0.0/0"
    ingress.0.from_port:         "" => "22"
    ingress.0.protocol:          "" => "tcp"
    ingress.0.security_groups.#: "" => "0"
    ingress.0.self:              "" => "0"
    ingress.0.to_port:           "" => "22"
    name:                        "" => "maintenance"
    owner_id:                    "" => "<computed>"
    vpc_id:                      "" => "${var.vpc_id}"

+ module.mesos.aws_security_group.master
    description:                 "" => "master"
    ingress.#:                   "" => "2"
    ingress.0.cidr_blocks.#:     "" => "1"
    ingress.0.cidr_blocks.0:     "" => "0.0.0.0/0"
    ingress.0.from_port:         "" => "8080"
    ingress.0.protocol:          "" => "tcp"
    ingress.0.security_groups.#: "" => "0"
    ingress.0.self:              "" => "0"
    ingress.0.to_port:           "" => "8080"
    ingress.1.cidr_blocks.#:     "" => "1"
    ingress.1.cidr_blocks.0:     "" => "0.0.0.0/0"
    ingress.1.from_port:         "" => "5050"
    ingress.1.protocol:          "" => "tcp"
    ingress.1.security_groups.#: "" => "0"
    ingress.1.self:              "" => "0"
    ingress.1.to_port:           "" => "5050"
    name:                        "" => "master"
    owner_id:                    "" => "<computed>"
    vpc_id:                      "" => "${var.vpc_id}"

+ module.mesos.aws_security_group.private
    description:                 "" => "private"
    ingress.#:                   "" => "3"
    ingress.0.cidr_blocks.#:     "" => "0"
    ingress.0.from_port:         "" => "0"
    ingress.0.protocol:          "" => "udp"
    ingress.0.security_groups.#: "" => "0"
    ingress.0.self:              "" => "1"
    ingress.0.to_port:           "" => "65535"
    ingress.1.cidr_blocks.#:     "" => "0"
    ingress.1.from_port:         "" => "-1"
    ingress.1.protocol:          "" => "icmp"
    ingress.1.security_groups.#: "" => "0"
    ingress.1.self:              "" => "1"
    ingress.1.to_port:           "" => "-1"
    ingress.2.cidr_blocks.#:     "" => "0"
    ingress.2.from_port:         "" => "0"
    ingress.2.protocol:          "" => "tcp"
    ingress.2.security_groups.#: "" => "0"
    ingress.2.self:              "" => "1"
    ingress.2.to_port:           "" => "65535"
    name:                        "" => "private"
    owner_id:                    "" => "<computed>"
    vpc_id:                      "" => "${var.vpc_id}"

+ module.mesos.aws_security_group.slave
    description:                 "" => "slave"
    ingress.#:                   "" => "1"
    ingress.0.cidr_blocks.#:     "" => "1"
    ingress.0.cidr_blocks.0:     "" => "0.0.0.0/0"
    ingress.0.from_port:         "" => "5051"
    ingress.0.protocol:          "" => "tcp"
    ingress.0.security_groups.#: "" => "0"
    ingress.0.self:              "" => "0"
    ingress.0.to_port:           "" => "5051"
    name:                        "" => "slave"
    owner_id:                    "" => "<computed>"
    vpc_id:                      "" => "${var.vpc_id}"

+ module.mesos.aws_subnet.public
    availability_zone:       "" => "us-east-1e"
    cidr_block:              "" => "10.0.1.0/24"
    map_public_ip_on_launch: "" => "1"
    vpc_id:                  "" => "${var.vpc_id}"

+ module.mesos.null_resource.init_ceph

````
