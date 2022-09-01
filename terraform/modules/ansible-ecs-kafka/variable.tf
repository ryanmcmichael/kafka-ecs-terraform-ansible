variable "env" {}
variable "vpc-id" {}
variable "region" {}
variable "log_group_name" {}
variable "repository_credentials_arn" {}
variable "ecs_role_arn" {}
variable "kafka_sg_id" {}
variable "kafka_internal_elb_dns" {}
variable "CHANGELOG_REPLICATION_FACTOR" {}
variable "private_subnet_ids" {
    default = []
}
variable "dependency_id" {
    default = []
}


variable "kafka_port" {}
variable "kafka_port_1" {}
variable "zookeeper_port" {}
variable "zookeeper_port_1" {}
variable "zookeeper_port_2" {}
variable "zookeeper_port_3" {}


variable "kafka_target_group_arn" {}
variable "kafka_target_group_arn_1" {}
variable "zookeeper_target_group_arn" {}
variable "zookeeper_target_group_arn_1" {}
variable "zookeeper_target_group_arn_2" {}
variable "zookeeper_target_group_arn_3" {}
