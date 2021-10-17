#provider "aws" {
#  region              = "eu-central-1"
#  version             = "2.38.0"
#  allowed_account_ids = [var.aws_accountid]
#}

terraform {
  backend "remote" {
    organization = "vesta-corp"

    workspaces {
      name = "github-actions"
    }
  }
}