variable "keypair_public_key" {}
variable "vpc-id" {}
variable "region" {}
variable "aws_key_name" {}
variable "environment" {}
variable "environment_shortened" {}
variable "nginx_instance_type" {}
variable "bastion_sg_id" {}
variable "vpc_cidr" {}
variable "domain_certificate_arn" {}


variable "private_subnet_ids" {
  default = []
}

variable "public_subnet_ids" {
  default = []
}

variable "private_sub_cidr" {
  default = []
}

variable "prod_proxy" {}
variable "test_proxy" {}
variable "sigfox_data_source_port" {}
variable "gwt_data_source_port" {}
variable "loxone_data_source_port" {}
variable "generic_data_source_port" {}

variable "sigfox_target_group_arn" {}
variable "gwt_target_group_arn" {}
variable "loxone_target_group_arn" {}
variable "generic_target_group_arn" {}

variable "site_external_elb_id" {}

