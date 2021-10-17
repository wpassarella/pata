###############################
### Stack local variables
###############################
locals {
  k8s_cluster_name = "k8s"
  k8s_instance_type = "m5.xlarge"
  k8s_instance_ami = "ami-custom-k8s-ami"
  k8s_enhanced_monitoring = false

  k8s_root_volume_size = 100
  k8s_key_name = aws_key_pair.k8s.key_name
}

###############################
### EC2
###############################
module "k8s_cluster" {
  instance_count       = 1
  source               = "./_modules/ec2_cluster"
  name                 = "k8s"
  ami                  = local.k8s_instance_ami
  monitoring           = local.k8s_enhanced_monitoring
  #subnet_ids           = local.k8s_subnet
  instance_type        = local.k8s_instance_type
  key_name             = local.k8s_key_name
  iam_instance_profile = aws_iam_instance_profile.k8s.id

  root_block_device = [{
    volume_size = local.k8s_root_volume_size
  }]

  vpc_security_group_ids = [
    aws_security_group.k8s-instances.id
  ]
}

###############################
### IAM
###############################
resource "aws_iam_role" "k8s" { // k8s instances IAM role
  name               = "${local.environment_prefix}-role-${local.k8s_cluster_name}"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
      "Action": "sts:AssumeRole",
      "Principal": {
          "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
      }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "k8s" { // Secure Agent IAM instance profile
  name = "${local.environment_prefix}-instanceprofile-${local.k8s_cluster_name}"
  role = aws_iam_role.k8s.name
}
