/*
-----------------------------------------------------------------
- Setup creds and region via env variables
- For more details: https://www.terraform.io/docs/providers/aws
-----------------------------------------------------------------
Notes:
 - control_cidr changes for different modules
 - Instance class also changes for different modules
 - Default security group is added where traffic is supposed to flow between VPC
 */

/********************************************************************************/


provider "aws" {
  region = "${var.region}"
}



terraform {
  backend "s3" {
  bucket     = "client-terraform-remote-state"
  key        = "development/terraform.tfstate"
  region     = "eu-west-2"
  encrypt    = "true"
  }
}



module "vpc" {
   source                   = "../../modules/vpc"
   azs                      = "${var.azs}"
   vpc_cidr                 = "${var.vpc_cidr}"
   public_sub_cidr          = "${var.public_sub_cidr}"
   private_sub_cidr         = "${var.private_sub_cidr}"
   enable_dns_hostnames     = true
   vpc_name                 = "${var.vpc_name}"
   //-- In case we need to change Domain servers
   //dhcp_domain_name_servers = ["${var.domain_servers}"]
   environment              = "${var.environment}"
   mongo_peering_connection_id = "${var.mongo_peering_connection_id}"
   mongo_cidr_block         = "${var.mongo_cidr_block}"
}

module "glp-private-zone" {
   source                       = "../../modules/route53-hosted-zone"
   environment                   = "${var.environment}"
   hosted_zone_name             = "${var.environment}-internal.com"
   vpc_id                       = "${module.vpc.vpc_id}"
   kafka_internal_elb_dns_name  = "${module.ecs-kafka-cluster.kafka_internal_elb_dns}"
   kafka_internal_elb_zone_id   = "${module.ecs-kafka-cluster.kafka_internal_elb_zone_id}"
   kafka_internal_ip_1          = "${module.ecs-kafka-cluster.kafka_internal_ip_1}"
   kafka_internal_ip_2          = "${module.ecs-kafka-cluster.kafka_internal_ip_2}"
   kafka_internal_ip_3          = "${module.ecs-kafka-cluster.kafka_internal_ip_3}"
}

module "bastion" {
   source                = "../../modules/bastion"
   public_sub_cidr       = "${var.public_sub_cidr}"
   vpc-id                = "${module.vpc.vpc_id}"
   pub_sub_id            = "${module.vpc.aws_pub_subnet_id[0]}"
   region                = "${var.region}"
   bastion_instance_type = "${var.bastion_instance_type}"
   keypair_public_key    = "${var.keypair_public_key}"
   aws_key_name          = "${var.aws_key_name}"
   control_cidr          = "${var.control_cidr}"
   ansible_ssh_user      = "${var.ansible_ssh_user}"
   proxy_cidr            = "${var.proxy_cidr}"
   environment           = "${var.environment}"
}

module "ecs-kafka-cluster" {
   source                      = "../../modules/ecs-kafka-zk-cluster"
   private_subnet_ids          = "${module.vpc.aws_pri_subnet_id}"
   public_subnet_ids           = "${module.vpc.aws_pub_subnet_id}"
   vpc-id                      = "${module.vpc.vpc_id}"
   region                      = "${var.region}"
   keypair_public_key          = "${var.keypair_public_key}"
   aws_key_name                = "${var.aws_key_name}"
   control_cidr                = "${var.private_sub_control_cidr}"
   kafka_instance_type         = "${var.kafka_instance_type}"
   efs_data_dir                = "${var.efs_kafka_data_dir}"
   efs_fs_id                   = "${module.efs-private-subnet.efs_fs_id}"
   environment                 = "${var.environment}"
   environment_shortened       = "${var.environment_shortened}"
   bastion_sg_id               = "${module.bastion.bastion-sg-id}"
   dependency_id               = "${module.efs-private-subnet.dependency_id}"
   kafka_asg_max_size          = "${var.kafka_asg_max_size}"
   kafka_asg_min_size          = "${var.kafka_asg_min_size}"
   kafka_asg_desired_size      = "${var.kafka_asg_desired_size}"
   kafka_ami_id                = "${var.kafka_ami_id}"
   ami_owner_name              = "${var.ami_owner_name}"
   ami_name_regex              = "${var.ami_name_regex}"
   vpc_cidr                    = "${var.vpc_cidr}"
   azs                         = "${var.azs}"
   domain_certificate_arn      = "${var.domain_certificate_arn}"

   CHANGELOG_REPLICATION_FACTOR          = "${var.CHANGELOG_REPLICATION_FACTOR}"
   kafka_port                          = "${var.kafka_port}"
   kafka_port_1                          = "${var.kafka_port_1}"
   zookeeper_port                        = "${var.zookeeper_port}"
   zookeeper_port_1                      = "${var.zookeeper_port_1}"
   zookeeper_port_2                      = "${var.zookeeper_port_2}"
   zookeeper_port_3                      = "${var.zookeeper_port_3}"
}


/* Site cluster */
module "ecs-site-cluster" {
   source                      = "../../modules/ecs-site-cluster"
   private_subnet_ids          = "${module.vpc.aws_pri_subnet_id}"
   public_subnet_ids           = "${module.vpc.aws_pub_subnet_id}"
   vpc-id                      = "${module.vpc.vpc_id}"
   region                      = "${var.region}"
   keypair_public_key          = "${var.keypair_public_key}"
   aws_key_name                = "${var.aws_key_name}"
   control_cidr                = "${var.private_sub_control_cidr}"
   site_instance_type          = "${var.site_instance_type}"
   environment                 = "${var.environment}"
   environment_shortened       = "${var.environment_shortened}"
   bastion_sg_id               = "${module.bastion.bastion-sg-id}"
   dependency_id               = "${module.efs-private-subnet.dependency_id}"
   site_asg_max_size           = "${var.site_asg_max_size}"
   site_asg_min_size           = "${var.site_asg_min_size}"
   site_asg_desired_size       = "${var.site_asg_desired_size}"
   site_ami_id                 = "${var.site_ami_id}"
   ami_owner_name              = "${var.ami_owner_name}"
   ami_name_regex              = "${var.ami_name_regex}"
   vpc_cidr                    = "${var.vpc_cidr}"
   azs                         = "${var.azs}"
   domain_certificate_arn      = "${var.domain_certificate_arn}"

   port_8080                             = "${var.port_8080}"
   anomaly_processor_port                = "${var.anomaly_processor_port}"
   asset_enricher_port                   = "${var.asset_enricher_port}"
   asset_manager_port                    = "${var.asset_manager_port}"
   control_center_port                   = "${var.control_center_port}"
   email_notification_service_port       = "${var.email_notification_service_port}"
   escalation_manager_port               = "${var.escalation_manager_port}"
   escalation_service_port               = "${var.escalation_service_port}"
   mute_manager_port                     = "${var.mute_manager_port}"
   notification_permissions_manager_port = "${var.notification_permissions_manager_port}"
   notifications_enricher_port           = "${var.notifications_enricher_port}"
   offline_sensor_manager_port           = "${var.offline_sensor_manager_port}"
   offline_sensor_monitor_port           = "${var.offline_sensor_monitor_port}"
   permissions_manager_port              = "${var.permissions_manager_port}"
   response_manager_port                 = "${var.response_manager_port}"
   sensor_manager_port                   = "${var.sensor_manager_port}"
   site_enricher_port                    = "${var.site_enricher_port}"
   site_manager_port                     = "${var.site_manager_port}"
   system_manager_port                   = "${var.system_manager_port}"
   telegram_inbound_service_port         = "${var.telegram_inbound_service_port}"
   telegram_notification_service_port    = "${var.telegram_notification_service_port}"
   threshold_anomaly_detector_port       = "${var.threshold_anomaly_detector_port}"
   threshold_model_manager_port          = "${var.threshold_model_manager_port}"
   rateofchange_model_manager_port       = "${var.rateofchange_model_manager_port}"
   rateofchange_anomaly_detector_port    = "${var.rateofchange_anomaly_detector_port}"
   spike_model_manager_port              = "${var.spike_model_manager_port}"
   api_gateway_port                      = "${var.api_gateway_port}"
   ttn_dc2_raw_port                      = "${var.ttn_dc2_raw_port}"
   ttn_transformer_port                  = "${var.ttn_transformer_port}"
   user_enricher_port                    = "${var.user_enricher_port}"
   user_manager_port                     = "${var.user_manager_port}"
   mute_service_port                     = "${var.mute_service_port}"
   CHANGELOG_REPLICATION_FACTOR          = "${var.CHANGELOG_REPLICATION_FACTOR}"
   ehs_port                              = "${var.ehs_port}"
   north_data_source_port                = "${var.north_data_source_port}"
   loxone_data_source_port               = "${var.loxone_data_source_port}"
   generic_data_source_port              = "${var.generic_data_source_port}"
   sigfox_data_source_port               = "${var.sigfox_data_source_port}"
   texecom_data_source_port              = "${var.texecom_data_source_port}"
   webway_data_source_port               = "${var.webway_data_source_port}"
   gwt_data_source_port                  = "${var.gwt_data_source_port}"

}

/* EFS for Kafka */
module "efs-private-subnet" {
   source                = "../../modules/efs"
   efs_cluster_name      = "efs_kafka"
   count                 = "${length(var.azs)}"
   subnet_ids            = "${module.vpc.aws_pri_subnet_id_str}"
   environment           = "${var.environment}"
   // We need SGs for all instances where EFS is to be launched
   security_group_id     = [
                             "${module.ecs-kafka-cluster.kafka-cluster-sg-id}"
                           ]
}


module "aws-log-group" {
   source                        = "../../modules/cloudwatch-log-groups"
   log_group_name                = "${var.log_group_name}"
   environment                   = "${var.environment}"
   cloudwatch_retention_in_days  = "${var.cloudwatch_retention_in_days}"
}


/*module "ansible-ecs-kafka" {
   source                        = "../../modules/ansible-ecs-kafka"
   env                           = "${var.environment}"
   region                        = "${var.region}"
   vpc-id                        = "${module.vpc.vpc_id}"
   log_group_name                = "${var.log_group_name}"
   repository_credentials_arn    = "${var.repository_credentials_arn}"
   ecs_role_arn                  = "${var.ecs_execution_role_arn}"
   private_subnet_ids            = "${module.vpc.aws_pri_subnet_id}"
   kafka_sg_id                   = "${module.ecs-kafka-cluster.kafka-cluster-sg-id}"
   kafka_internal_elb_dns        = "${module.ecs-kafka-cluster.kafka_internal_elb_dns}"

   CHANGELOG_REPLICATION_FACTOR          = "${var.CHANGELOG_REPLICATION_FACTOR}"
   kafka_port                            = "${var.kafka_port}"
   kafka_port_1                          = "${var.kafka_port_1}"
   zookeeper_port                        = "${var.zookeeper_port}"
   zookeeper_port_1                      = "${var.zookeeper_port_1}"
   zookeeper_port_2                      = "${var.zookeeper_port_2}"
   zookeeper_port_3                      = "${var.zookeeper_port_3}"

   kafka_target_group_arn                            = "${module.ecs-kafka-cluster.kafka_target_group_arn}"
   kafka_target_group_arn_1                          = "${module.ecs-kafka-cluster.kafka_target_group_arn_1}"
   zookeeper_target_group_arn                        = "${module.ecs-kafka-cluster.zookeeper_target_group_arn}"
   zookeeper_target_group_arn_1                      = "${module.ecs-kafka-cluster.zookeeper_target_group_arn_1}"
   zookeeper_target_group_arn_2                      = "${module.ecs-kafka-cluster.zookeeper_target_group_arn_2}"
   zookeeper_target_group_arn_3                      = "${module.ecs-kafka-cluster.zookeeper_target_group_arn_3}"
}*/

module "ansible-ecs-site" {
   source                        = "../../modules/ansible-ecs-site"
   env                           = "${var.environment}"
   region                        = "${var.region}"
   log_group_name                = "${var.log_group_name}"
   repository_credentials_arn    = "${var.repository_credentials_arn}"
   ecs_role_arn                  = "${var.ecs_execution_role_arn}"
   private_subnet_ids            = "${module.vpc.aws_pri_subnet_id}"
   kafka_sg_id                   = "${module.ecs-site-cluster.site-cluster-sg-id}"
   kafka_internal_elb_dns        = "${module.ecs-site-cluster.site_internal_elb_dns}"
   site_external_elb_dns         = "${var.external_dns}"
   anomaly_info_url              = "${var.anomaly_info_url}"
   api_username                  = "${var.api_username}"
   api_password                  = "${var.api_password}"
   mongo_db_name                 = "${var.mongo_db_name}"
   mongo_fqdn                    = "${var.mongo_fqdn}"
   ehs_mongo_alerts_mongo_username     = "${var.ehs_mongo_alerts_mongo_username}"
   event_history_service_mongo_username = "${var.event_history_service_mongo_username}"
   ehs_mongo_events_mongo_username     = "${var.ehs_mongo_events_mongo_username}"
   ehs_mongo_alerts_mongo_pw     = "${var.ehs_mongo_alerts_mongo_pw}"
   event_history_service_mongo_pw = "${var.event_history_service_mongo_pw}"
   ehs_mongo_events_mongo_pw     = "${var.ehs_mongo_events_mongo_pw}"
   asset_manager_mongo_pw        = "${var.asset_manager_mongo_pw}"
   escalation_manager_mongo_pw   = "${var.escalation_manager_mongo_pw}"
   notification_permissions_manager_mongo_pw = "${var.notification_permissions_manager_mongo_pw}"
   offline_sensor_manager_mongo_pw = "${var.offline_sensor_manager_mongo_pw}"
   permissions_manager_mongo_pw  = "${var.permissions_manager_mongo_pw}"
   sensor_manager_mongo_pw       = "${var.sensor_manager_mongo_pw}"
   site_manager_mongo_pw         = "${var.site_manager_mongo_pw}"
   system_manager_mongo_pw       = "${var.system_manager_mongo_pw}"
   threshold_model_manager_mongo_pw = "${var.threshold_model_manager_mongo_pw}"
   roc_model_manager_mongo_pw    = "${var.roc_model_manager_mongo_pw}"
   spike_model_manager_mongo_pw  = "${var.spike_model_manager_mongo_pw}"
   user_manager_mongo_pw         = "${var.user_manager_mongo_pw}"
   jwt_key                       = "${var.jwt_key}"
   external_app_url              = "${var.external_app_url}"
   new_user_email                = "${var.new_user_email}"
   notify_requests_email         = "${var.notify_requests_email}"
   default_to                    = "${var.default_to}"
   twilio_call_back_url          = "${var.twilio_call_back_url}"
   twilio_status_call_back_url   = "${var.twilio_status_call_back_url}"

   port_8080                             = "${var.port_8080}"
   kafka_port                            = "${var.kafka_port}"
   zookeeper_port                        = "${var.zookeeper_port}"
   anomaly_processor_port                = "${var.anomaly_processor_port}"
   asset_enricher_port                   = "${var.asset_enricher_port}"
   asset_manager_port                    = "${var.asset_manager_port}"
   control_center_port                   = "${var.control_center_port}"
   email_notification_service_port       = "${var.email_notification_service_port}"
   escalation_manager_port               = "${var.escalation_manager_port}"
   escalation_service_port               = "${var.escalation_service_port}"
   mute_manager_port                     = "${var.mute_manager_port}"
   notification_permissions_manager_port = "${var.notification_permissions_manager_port}"
   notifications_enricher_port           = "${var.notifications_enricher_port}"
   offline_sensor_manager_port           = "${var.offline_sensor_manager_port}"
   offline_sensor_monitor_port           = "${var.offline_sensor_monitor_port}"
   permissions_manager_port              = "${var.permissions_manager_port}"
   response_manager_port                 = "${var.response_manager_port}"
   sensor_manager_port                   = "${var.sensor_manager_port}"
   site_enricher_port                    = "${var.site_enricher_port}"
   site_manager_port                     = "${var.site_manager_port}"
   system_manager_port                   = "${var.system_manager_port}"
   telegram_inbound_service_port         = "${var.telegram_inbound_service_port}"
   telegram_notification_service_port    = "${var.telegram_notification_service_port}"
   threshold_anomaly_detector_port       = "${var.threshold_anomaly_detector_port}"
   threshold_model_manager_port          = "${var.threshold_model_manager_port}"
   rateofchange_model_manager_port       = "${var.rateofchange_model_manager_port}"
   rateofchange_anomaly_detector_port    = "${var.rateofchange_anomaly_detector_port}"
   spike_model_manager_port              = "${var.spike_model_manager_port}"
   ttn_dc2_raw_port                      = "${var.ttn_dc2_raw_port}"
   ttn_transformer_port                  = "${var.ttn_transformer_port}"
   user_enricher_port                    = "${var.user_enricher_port}"
   user_manager_port                     = "${var.user_manager_port}"
   mute_service_port                     = "${var.mute_service_port}"
   CHANGELOG_REPLICATION_FACTOR          = "${var.CHANGELOG_REPLICATION_FACTOR}"
   ehs_port                              = "${var.ehs_port}"
   api_gateway_port                      = "${var.api_gateway_port}"
   north_data_source_port                = "${var.north_data_source_port}"
   loxone_data_source_port               = "${var.loxone_data_source_port}"
   generic_data_source_port              = "${var.generic_data_source_port}"
   sigfox_data_source_port               = "${var.sigfox_data_source_port}"
   texecom_data_source_port              = "${var.texecom_data_source_port}"
   webway_data_source_port               = "${var.webway_data_source_port}"

   api_gateway_target_group_arn                      = "${module.ecs-site-cluster.api_gateway_target_group_arn}"
   anomaly_processor_target_group_arn                = "${module.ecs-site-cluster.anomaly_processor_target_group_arn}"
   asset_enricher_target_group_arn                   = "${module.ecs-site-cluster.asset_enricher_target_group_arn}"
   asset_manager_target_group_arn                    = "${module.ecs-site-cluster.asset_manager_target_group_arn}"
   control_center_target_group_arn                   = "${module.ecs-site-cluster.control_center_target_group_arn}"
   email_notification_service_target_group_arn       = "${module.ecs-site-cluster.email_notification_service_target_group_arn}"
   escalation_manager_target_group_arn               = "${module.ecs-site-cluster.escalation_manager_target_group_arn}"
   escalation_service_target_group_arn               = "${module.ecs-site-cluster.escalation_service_target_group_arn}"
   mute_manager_target_group_arn                     = "${module.ecs-site-cluster.mute_manager_target_group_arn}"
   notification_permissions_manager_target_group_arn = "${module.ecs-site-cluster.notification_permissions_manager_target_group_arn}"
   notifications_enricher_target_group_arn           = "${module.ecs-site-cluster.notifications_enricher_target_group_arn}"
   offline_sensor_manager_target_group_arn           = "${module.ecs-site-cluster.offline_sensor_manager_target_group_arn}"
   offline_sensor_monitor_target_group_arn           = "${module.ecs-site-cluster.offline_sensor_monitor_target_group_arn}"
   permissions_manager_target_group_arn              = "${module.ecs-site-cluster.permissions_manager_target_group_arn}"
   response_manager_target_group_arn                 = "${module.ecs-site-cluster.response_manager_target_group_arn}"
   sensor_manager_target_group_arn                   = "${module.ecs-site-cluster.sensor_manager_target_group_arn}"
   site_enricher_target_group_arn                    = "${module.ecs-site-cluster.site_enricher_target_group_arn}"
   system_manager_target_group_arn                   = "${module.ecs-site-cluster.system_manager_target_group_arn}"
   telegram_inbound_service_target_group_arn         = "${module.ecs-site-cluster.telegram_inbound_service_target_group_arn}"
   telegram_notification_service_target_group_arn    = "${module.ecs-site-cluster.telegram_notification_service_target_group_arn}"
   threshold_anomaly_detector_target_group_arn       = "${module.ecs-site-cluster.threshold_anomaly_detector_target_group_arn}"
   threshold_model_manager_target_group_arn          = "${module.ecs-site-cluster.threshold_model_manager_target_group_arn}"
   rateofchange_model_manager_target_group_arn       = "${module.ecs-site-cluster.rateofchange_model_manager_target_group_arn}"
   rateofchange_anomaly_detector_target_group_arn    = "${module.ecs-site-cluster.rateofchange_anomaly_detector_target_group_arn}"
   spike_model_manager_target_group_arn              = "${module.ecs-site-cluster.spike_model_manager_target_group_arn}"
   ttn_dc2_raw_target_group_arn                      = "${module.ecs-site-cluster.ttn_dc2_raw_target_group_arn}"
   ttn_transformer_target_group_arn                  = "${module.ecs-site-cluster.ttn_transformer_target_group_arn}"
   user_enricher_target_group_arn                    = "${module.ecs-site-cluster.user_enricher_target_group_arn}"
   user_manager_target_group_arn                     = "${module.ecs-site-cluster.user_manager_target_group_arn}"
   mute_service_target_group_arn                     = "${module.ecs-site-cluster.mute_service_target_group_arn}"
   site_manager_target_group_arn                     = "${module.ecs-site-cluster.site_manager_target_group_arn}"
   loxone_data_source_target_group_arn               = "${module.ecs-site-cluster.loxone_data_source_target_group_arn}"
   generic_data_source_target_group_arn              = "${module.ecs-site-cluster.generic_data_source_target_group_arn}"
   sigfox_data_source_target_group_arn               = "${module.ecs-site-cluster.sigfox_data_source_target_group_arn}"
   webway_data_source_target_group_arn               = "${module.ecs-site-cluster.webway_data_source_target_group_arn}"
   gwt_data_source_target_group_arn                  = "${module.ecs-site-cluster.gwt_data_source_target_group_arn}"
   ehs_target_group_arn                              = "${module.ecs-site-cluster.ehs_target_group_arn}"
}

module "database" {
   source                     = "../../modules/rds"

   vpc_id                     = "${module.vpc.vpc_id}"
   database_subnet_group_name = "${module.vpc.database_subnet_group_name}"
   db_password                = "${var.db_password}"
   internal_zone_id           = "${module.glp-private-zone.zone-id}"
   environment                = "${var.environment}"
}
