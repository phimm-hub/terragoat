provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.16.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = "172.16.0.0/16"
  tags = {
    git_commit           = "f1a3726cb53d99856f4e4a77388f3756ba9969ce"
    git_file             = "terraform-aws-ec2-bastion-server-master/examples/complete/main.tf"
    git_last_modified_at = "2020-11-09 16:45:37"
    git_last_modified_by = "68634672+guyeisenkot@users.noreply.github.com"
    git_modifiers        = "68634672+guyeisenkot"
    git_org              = "phimm-hub"
    git_repo             = "terragoat"
    yor_trace            = "c2656435-f988-49b8-8176-6406bb993580"
  }
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.26.0"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  tags = {
    git_commit           = "f1a3726cb53d99856f4e4a77388f3756ba9969ce"
    git_file             = "terraform-aws-ec2-bastion-server-master/examples/complete/main.tf"
    git_last_modified_at = "2020-11-09 16:45:37"
    git_last_modified_by = "68634672+guyeisenkot@users.noreply.github.com"
    git_modifiers        = "68634672+guyeisenkot"
    git_org              = "phimm-hub"
    git_repo             = "terragoat"
    yor_trace            = "e6094d2b-be55-4517-9ae4-af4d527ec31d"
  }
}

module "aws_key_pair" {
  source              = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=tags/0.13.1"
  namespace           = var.namespace
  stage               = var.stage
  name                = var.name
  attributes          = ["ssh", "key"]
  ssh_public_key_path = var.ssh_key_path
  generate_ssh_key    = var.generate_ssh_key
  tags = {
    git_commit           = "f1a3726cb53d99856f4e4a77388f3756ba9969ce"
    git_file             = "terraform-aws-ec2-bastion-server-master/examples/complete/main.tf"
    git_last_modified_at = "2020-11-09 16:45:37"
    git_last_modified_by = "68634672+guyeisenkot@users.noreply.github.com"
    git_modifiers        = "68634672+guyeisenkot"
    git_org              = "phimm-hub"
    git_repo             = "terragoat"
    yor_trace            = "29babf3b-4316-433f-8af5-6024ebf38500"
  }
}

module "ec2_bastion" {
  source = "../../"

  enabled = var.enabled

  ami           = var.ami
  instance_type = var.instance_type

  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
  attributes = var.attributes

  security_groups         = compact(concat([module.vpc.vpc_default_security_group_id], var.security_groups))
  ingress_security_groups = var.ingress_security_groups
  subnets                 = module.subnets.public_subnet_ids
  ssh_user                = var.ssh_user
  key_name                = module.aws_key_pair.key_name

  user_data = var.user_data

  vpc_id = module.vpc.vpc_id
}