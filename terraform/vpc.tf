###############################
### VPC Module
###############################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.18.0"

  name = local.environment_prefix
  cidr = var.vpc_cidr_block

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  public_subnets  = [cidrsubnet(var.vpc_cidr_block, 4, 0), cidrsubnet(var.vpc_cidr_block, 4, 1), cidrsubnet(var.vpc_cidr_block, 4, 2)]
  private_subnets = [cidrsubnet(var.vpc_cidr_block, 4, 3), cidrsubnet(var.vpc_cidr_block, 4, 4), cidrsubnet(var.vpc_cidr_block, 4, 5)]
  intra_subnets   = [cidrsubnet(var.vpc_cidr_block, 4, 6), cidrsubnet(var.vpc_cidr_block, 4, 7), cidrsubnet(var.vpc_cidr_block, 4, 8)]

  public_subnet_tags   = { Type = "Red" }
  public_subnet_suffix = "snet-red"

  private_subnet_tags   = { Type = "Amber" }
  private_subnet_suffix = "snet-amber"

  intra_subnet_tags   = { Type = "Green" }
  intra_subnet_suffix = "snet-green"

  enable_nat_gateway     = true
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_dhcp_options  = true

  dhcp_options_domain_name = "${var.r53_private_dns_zone} ib"

  tags = local.global_common_tags
}

data "aws_iam_role" "autoscaling" {
  name = "AWSServiceRoleForAutoScaling"
}

/*resource "aws_kms_grant" "autoscaling" {
  grantee_principal = data.aws_iam_role.autoscaling.arn
  key_id            = var.aws_ami_kms_arn
  operations        = ["Encrypt", "Decrypt", "ReEncryptFrom", "ReEncryptTo", "GenerateDataKey", "GenerateDataKeyWithoutPlaintext", "DescribeKey", "CreateGrant"]
}*/

###############################
### Outputs
###############################
output "vpc_id" {
  value = module.vpc.vpc_id
}