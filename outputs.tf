output "public ip of ec2_test" {
  value = "${aws_instance.ec2_test.public_ip}"
}

