#!/bin/bash

## Pre-reqs
# - Ansible > 2.0
# - Botocore
# - Boto3
# - python 2. 7

ansible_code_dir="../../../ansible/"

# For Dynamic inventory
export AWS_REGION=${region}
echo $AWS_REGION
# **** Only for localhost***
# **** ALL VM level configuration is done via ansible pull *****#

ansible-playbook -i $ansible_code_dir/hosts/ec2.py $ansible_code_dir/site-ecs-delete.yml --extra-vars \
"env=${env}
region=${region}
log_group_name=${log_group_name}
repository_credentials_arn=${repository_credentials_arn}
ecs_role_arn=${ecs_role_arn}
site_sg_id=${kafka_sg_id}
private_subnet_0=${private_subnet_0}
private_subnet_1=${private_subnet_1}
private_subnet_2=${private_subnet_2}
kafka_internal_elb_dns=${kafka_internal_elb_dns}
site_external_elb_dns=${site_external_elb_dns}
anomaly_info_url=${anomaly_info_url}
api_username=${api_username}
api_password=${api_password}
mongo_db_name=${mongo_db_name}
mongo_fqdn=${mongo_fqdn}
ehs_mongo_alerts_mongo_username=${ehs_mongo_alerts_mongo_username}
event_history_service_mongo_username=${event_history_service_mongo_username}
ehs_mongo_events_mongo_username=${ehs_mongo_events_mongo_username}
ehs_mongo_alerts_mongo_pw=${ehs_mongo_alerts_mongo_pw}
event_history_service_mongo_pw=${event_history_service_mongo_pw}
ehs_mongo_events_mongo_pw=${ehs_mongo_events_mongo_pw}
asset_manager_mongo_pw=${asset_manager_mongo_pw}
escalation_manager_mongo_pw=${escalation_manager_mongo_pw}
notification_permissions_manager_mongo_pw=${notification_permissions_manager_mongo_pw}
offline_sensor_manager_mongo_pw=${offline_sensor_manager_mongo_pw}
permissions_manager_mongo_pw=${permissions_manager_mongo_pw}
sensor_manager_mongo_pw=${sensor_manager_mongo_pw}
site_manager_mongo_pw=${site_manager_mongo_pw}
system_manager_mongo_pw=${system_manager_mongo_pw}
threshold_model_manager_mongo_pw=${threshold_model_manager_mongo_pw}
roc_model_manager_mongo_pw=${roc_model_manager_mongo_pw}
spike_model_manager_mongo_pw=${spike_model_manager_mongo_pw}
user_manager_mongo_pw=${user_manager_mongo_pw}
CHANGELOG_REPLICATION_FACTOR=${CHANGELOG_REPLICATION_FACTOR}
jwt_key=${jwt_key}
external_app_url=${external_app_url}
new_user_email=${new_user_email}
notify_requests_email=${notify_requests_email}
default_to=${default_to}
twilio_call_back_url=${twilio_call_back_url}
twilio_status_call_back_url=${twilio_status_call_back_url}
ehs_port=${ehs_port}
port_8080=${port_8080}
anomaly_processor_port=${anomaly_processor_port}
asset_enricher_port=${asset_enricher_port}
asset_manager_port=${asset_manager_port}
control_center_port=${control_center_port}
email_notification_service_port=${email_notification_service_port}
escalation_manager_port=${escalation_manager_port}
escalation_service_port=${escalation_service_port}
kafka_port=${kafka_port}
mute_manager_port=${mute_manager_port}
notification_permissions_manager_port=${notification_permissions_manager_port}
notifications_enricher_port=${notifications_enricher_port}
offline_sensor_manager_port=${offline_sensor_manager_port}
offline_sensor_monitor_port=${offline_sensor_monitor_port}
permissions_manager_port=${permissions_manager_port}
response_manager_port=${response_manager_port}
sensor_manager_port=${sensor_manager_port}
site_enricher_port=${site_enricher_port}
site_manager_port=${site_manager_port}
system_manager_port=${system_manager_port}
telegram_inbound_service_port=${telegram_inbound_service_port}
telegram_notification_service_port=${telegram_notification_service_port}
threshold_anomaly_detector_port=${threshold_anomaly_detector_port}
threshold_model_manager_port=${threshold_model_manager_port}
rateofchange_model_manager_port=${rateofchange_model_manager_port}
rateofchange_anomaly_detector_port=${rateofchange_anomaly_detector_port}
spike_model_manager_port=${spike_model_manager_port}
api_gateway_port=${api_gateway_port}
ttn_dc2_raw_port=${ttn_dc2_raw_port}
ttn_transformer_port=${ttn_transformer_port}
user_enricher_port=${user_enricher_port}
user_manager_port=${user_manager_port}
zookeeper_port=${zookeeper_port}
mute_service_port=${mute_service_port}
north_data_source_port=${north_data_source_port}
loxone_data_source_port=${loxone_data_source_port}
generic_data_source_port=${generic_data_source_port}
sigfox_data_source_port=${sigfox_data_source_port}
texecom_data_source_port=${texecom_data_source_port}
webway_data_source_port=${webway_data_source_port}
api_gateway_target_group_arn=${api_gateway_target_group_arn}
anomaly_processor_target_group_arn=${anomaly_processor_target_group_arn}
asset_enricher_target_group_arn=${asset_enricher_target_group_arn}
asset_manager_target_group_arn=${asset_manager_target_group_arn}
control_center_target_group_arn=${control_center_target_group_arn}
email_notification_service_target_group_arn=${email_notification_service_target_group_arn}
escalation_manager_target_group_arn=${escalation_manager_target_group_arn}
escalation_service_target_group_arn=${escalation_service_target_group_arn}
mute_manager_target_group_arn=${mute_manager_target_group_arn}
notification_permissions_manager_target_group_arn=${notification_permissions_manager_target_group_arn}
notifications_enricher_target_group_arn=${notifications_enricher_target_group_arn}
offline_sensor_manager_target_group_arn=${offline_sensor_manager_target_group_arn}
offline_sensor_monitor_target_group_arn=${offline_sensor_monitor_target_group_arn}
permissions_manager_target_group_arn=${permissions_manager_target_group_arn}
response_manager_target_group_arn=${response_manager_target_group_arn}
sensor_manager_target_group_arn=${sensor_manager_target_group_arn}
site_enricher_target_group_arn=${site_enricher_target_group_arn}
site_manager_target_group_arn=${site_manager_target_group_arn}
system_manager_target_group_arn=${system_manager_target_group_arn}
telegram_inbound_service_target_group_arn=${telegram_inbound_service_target_group_arn}
telegram_notification_service_target_group_arn=${telegram_notification_service_target_group_arn}
threshold_anomaly_detector_target_group_arn=${threshold_anomaly_detector_target_group_arn}
threshold_model_manager_target_group_arn=${threshold_model_manager_target_group_arn}
rateofchange_anomaly_detector_target_group_arn=${rateofchange_anomaly_detector_target_group_arn}
rateofchange_model_manager_target_group_arn=${rateofchange_model_manager_target_group_arn}
spike_model_manager_target_group_arn=${spike_model_manager_target_group_arn}
ttn_dc2_raw_target_group_arn=${ttn_dc2_raw_target_group_arn}
ttn_transformer_target_group_arn=${ttn_transformer_target_group_arn}
user_enricher_target_group_arn=${user_enricher_target_group_arn}
user_manager_target_group_arn=${user_manager_target_group_arn}
mute_service_target_group_arn=${mute_service_target_group_arn}
loxone_data_source_target_group_arn=${loxone_data_source_target_group_arn}
generic_data_source_target_group_arn=${generic_data_source_target_group_arn}
sigfox_data_source_target_group_arn=${sigfox_data_source_target_group_arn}
webway_data_source_target_group_arn=${webway_data_source_target_group_arn}
gwt_data_source_target_group_arn=${gwt_data_source_target_group_arn}
ehs_target_group_arn=${ehs_target_group_arn}
"
