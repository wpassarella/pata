resource "aws_eip" "k8s" {
  instance = "module.k8s_cluster.name"
  tags = {
      Name = "k8s-eip"
  }
}