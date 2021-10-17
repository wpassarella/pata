output "instance_public_ip" {
  value = aws_eip.k8s.public_ip
}

output "security_group_id" {
  value = aws_security_group.k8s.id
}

output "security_group_name" {
  value = aws_security_group.k8s.name
}

output "security_group_desc" {
  value = aws_security_group.k8s.description
}
