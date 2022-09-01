/*
   Variables for all modules
*/

// Kafka
variable "kafka_instance_type" {}
variable "site_instance_type" {}
variable "efs_kafka_data_dir" {}

variable "kafka_asg_max_size" {}
variable "kafka_asg_min_size" {}
variable "kafka_asg_desired_size" {}

variable "site_asg_max_size" {}
variable "site_asg_min_size" {}
variable "site_asg_desired_size" {}

// VPC
variable "region" {}
variable "vpc_cidr" {}
variable "aws_key_path" {}
variable "aws_key_name" {}
variable "keypair_public_key" {}
variable "vpc_name" {}
variable "environment" {}
variable "environment_shortened" {}
variable "log_group_name" {}
variable "private_sub_control_cidr" {}
variable "ansible_ssh_user" {}
variable "control_cidr" {}
variable "proxy_cidr" {}
variable "ami_owner_name" {}
variable "ami_name_regex" {}
variable "kafka_ami_id" {}
variable "site_ami_id" {}
variable "cloudwatch_retention_in_days" {}

variable "bastion_instance_type" {}

variable "anomaly_info_url" {}

variable "external_app_url" {}
variable "new_user_email" {}
variable "notify_requests_email" {}
variable "default_to" {}
variable "twilio_call_back_url" {}
variable "twilio_status_call_back_url" {}
variable "external_dns" {}
variable "api_username" {}
variable "api_password" {}
variable "mongo_db_name" {}
variable "mongo_fqdn" {}
variable "ehs_mongo_alerts_mongo_username" {}
variable "event_history_service_mongo_username" {}
variable "ehs_mongo_events_mongo_username" {}
variable "ehs_mongo_alerts_mongo_pw" {}
variable "event_history_service_mongo_pw" {}
variable "ehs_mongo_events_mongo_pw" {}
variable "asset_manager_mongo_pw" {}
variable "escalation_manager_mongo_pw" {}
variable "notification_permissions_manager_mongo_pw" {}
variable "offline_sensor_manager_mongo_pw" {}
variable "permissions_manager_mongo_pw" {}
variable "sensor_manager_mongo_pw" {}
variable "site_manager_mongo_pw" {}
variable "system_manager_mongo_pw" {}
variable "threshold_model_manager_mongo_pw" {}
variable "roc_model_manager_mongo_pw" {}
variable "spike_model_manager_mongo_pw" {}
variable "user_manager_mongo_pw" {}

// Generic
variable "azs" {
    default = []
}


variable "public_sub_cidr" {
     default = []
}


variable "private_sub_cidr" {
     default = []
}

variable "db_password" {}
variable "internal_domain" {}
variable "repository_credentials_arn" {}
variable "ecs_execution_role_arn" {}
variable "CHANGELOG_REPLICATION_FACTOR" {}
variable "mongo_peering_connection_id" {}
variable "mongo_cidr_block" {}

variable "port_8080" {}
variable "anomaly_processor_port" {}
variable "api_gateway_port" {}
variable "asset_enricher_port" {}
variable "asset_manager_port" {}
variable "control_center_port" {}
variable "ehs_port" {}
variable "email_notification_service_port" {}
variable "escalation_manager_port" {}
variable "escalation_service_port" {}
variable "generic_data_source_port" {}
variable "kafka_port" {}
variable "kafka_port_1" {}
variable "loxone_data_source_port" {}
variable "mute_manager_port" {}
variable "mute_service_port" {}
variable "notification_permissions_manager_port" {}
variable "north_data_source_port" {}
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
variable "ttn_dc2_raw_port" {}
variable "ttn_transformer_port" {}
variable "user_enricher_port" {}
variable "user_manager_port" {}
variable "webway_data_source_port" {}
variable "gwt_data_source_port" {}
variable "zookeeper_port" {}
variable "zookeeper_port_1" {}
variable "zookeeper_port_2" {}
variable "zookeeper_port_3" {}
variable "domain_certificate_arn" {}
variable "jwt_key" {}

#TODO: REMOVE THESE ENV-SPECIFIC VARIABLES WHEN PHASING OUT V1
variable "nginx_instance_type" {}
variable "test_proxy" {}

