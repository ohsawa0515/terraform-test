provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.1.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    tags {
        Name = "terraform_vpc"
    }
}

resource "aws_internet_gateway" "my_gw" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    depends_on = ["aws_vpc.my_vpc"]
}

resource "aws_subnet" "public-a" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    cidr_block = "10.1.1.0/24"
    availability_zone = "ap-northeast-1a"
    tags {
        Name = "public-a"
    }
}
 
resource "aws_route_table" "public-route" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.my_gw.id}"
    }
    tags {
        Name = "public-route"
    }
}

resource "aws_route_table_association" "puclic-a" {
    subnet_id = "${aws_subnet.public-a.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}
 
resource "aws_security_group" "admin" {
    name = "admin"
    description = "Allow SSH inbound traffic"
    vpc_id = "${aws_vpc.my_vpc.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "admin"
    }
}
 
resource "aws_instance" "ec2_test" {
    # ami = "${var.images.amazon_linux}"
    ami = "${lookup(var.images, "amazon_linux")}"
    instance_type = "t2.small"
    key_name = "aws_ohsawa"
    vpc_security_group_ids = [
        "${aws_security_group.admin.id}"
    ]
    subnet_id = "${aws_subnet.public-a.id}"
    associate_public_ip_address = "true"
    root_block_device = {
        volume_type = "gp2"
        volume_size = "20"
    }
    ebs_block_device = {
        device_name = "/dev/sdf"
        volume_type = "gp2"
        volume_size = "10"
    }
    tags {
        Name = "terraform_test"
    }
}
 
