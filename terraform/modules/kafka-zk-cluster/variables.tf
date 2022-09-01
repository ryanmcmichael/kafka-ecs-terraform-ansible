/*
   Variables for ECS_CLUSTER
*/


variable "keypair_public_key" {}
variable "vpc-id" {}
variable "region" {}
variable "aws_key_name" {}
variable "environment" {}
variable "environment_shortened" {}
variable "kafka_instance_type" {}
variable "control_cidr" {}
variable "efs_data_dir" {}
variable "efs_fs_id" {}
variable "bastion_sg_id" {}
#variable "vpc_sg_id" {}
variable "ami_owner_name" {}
variable "ami_name_regex" {}
variable "kafka_ami_id" {}
variable "vpc_cidr" {}
variable "CHANGELOG_REPLICATION_FACTOR" {}
variable "domain_certificate_arn" {}
variable "azs" {
  default = []
}

// ASG
variable "kafka_asg_max_size" {}
variable "kafka_asg_min_size" {}
variable "kafka_asg_desired_size" {}

variable "private_subnet_ids" {
   default = []
}

variable "public_subnet_ids" {
  default = []
}

variable "dependency_id" {
  default = ""
}

variable "public_sub_cidr" {
     default = []
}

variable "private_sub_cidr" {
     default = []
}

variable "kafka_port" {}
variable "kafka_port_1" {}
variable "zookeeper_port" {}
variable "zookeeper_port_1" {}
variable "zookeeper_port_2" {}
variable "zookeeper_port_3" {}
