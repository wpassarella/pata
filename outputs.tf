output "instance_public_ip" {
  value = "${aws_eip.test_eip.public_ip}"
}

output "security_group_id" {
  value = "${aws_security_group.allow_ssh.id}"
}

output "security_group_name" {
  value = "${aws_security_group.allow_ssh.name}"
}

output "security_group_desc" {
  value = "${aws_security_group.allow_ssh.description}"
}
