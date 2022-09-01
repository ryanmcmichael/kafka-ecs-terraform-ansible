/*
   Variables for ECS_CLUSTER
*/


variable "keypair_public_key" {}
variable "vpc-id" {}
variable "region" {}
variable "aws_key_name" {}
variable "environment" {}
variable "environment_shortened" {}
variable "site_instance_type" {}
variable "control_cidr" {}
variable "bastion_sg_id" {}
#variable "vpc_sg_id" {}
variable "ami_owner_name" {}
variable "ami_name_regex" {}
variable "site_ami_id" {}
variable "vpc_cidr" {}
variable "CHANGELOG_REPLICATION_FACTOR" {}
variable "domain_certificate_arn" {}
variable "azs" {
  default = []
}

variable "site_asg_max_size" {}
variable "site_asg_min_size" {}
variable "site_asg_desired_size" {}


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

variable "port_8080" {}
variable "anomaly_processor_port" {}
variable "asset_enricher_port" {}
variable "asset_manager_port" {}
variable "control_center_port" {}
variable "ehs_port" {}
variable "email_notification_service_port" {}
variable "escalation_manager_port" {}
variable "escalation_service_port" {}
variable "generic_data_source_port" {}
variable "loxone_data_source_port" {}
variable "mute_manager_port" {}
variable "mute_service_port" {}
variable "north_data_source_port" {}
variable "notification_permissions_manager_port" {}
variable "notifications_enricher_port" {}
variable "offline_sensor_manager_port" {}
variable "offline_sensor_monitor_port" {}
variable "permissions_manager_port" {}
variable "response_manager_port" {}
variable "sensor_manager_port" {}
variable "sigfox_data_source_port" {}
variable "site_enricher_port" {}
variable "site_manager_port" {}
variable "system_manager_port" {}
variable "telegram_inbound_service_port" {}
variable "telegram_notification_service_port" {}
variable "texecom_data_source_port" {}
variable "threshold_anomaly_detector_port" {}
variable "threshold_model_manager_port" {}
variable "rateofchange_model_manager_port" {}
variable "rateofchange_anomaly_detector_port" {}
variable "spike_model_manager_port" {}
variable "api_gateway_port" {}
variable "ttn_dc2_raw_port" {}
variable "ttn_transformer_port" {}
variable "user_enricher_port" {}
variable "user_manager_port" {}
variable "webway_data_source_port" {}
variable "gwt_data_source_port" {}
