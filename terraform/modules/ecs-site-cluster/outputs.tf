/* We use this to track dependecies between each modules */
output "dependency_id" {
  value = "${null_resource.module_dependency.id}"
}

output "site-cluster-sg-id" {
   value = "${aws_security_group.site-cluster-sg.id}"
}

output "ecs_role_arn" {
  value = "${aws_iam_role.ecs-role-site.arn}"
}

output "api_gateway_target_group_arn" {
  value = "${aws_alb_target_group.api_gateway.arn}"
}

output "anomaly_processor_target_group_arn" {
  value = "${aws_alb_target_group.anomaly_processor.arn}"
}

output "asset_enricher_target_group_arn" {
  value = "${aws_alb_target_group.asset_enricher.arn}"
}

output "asset_manager_target_group_arn" {
  value = "${aws_alb_target_group.asset_manager.arn}"
}

output "control_center_target_group_arn" {
  value = "${aws_alb_target_group.control_center.arn}"
}

output "ehs_target_group_arn" {
  value = "${aws_alb_target_group.ehs.arn}"
}

output "email_notification_service_target_group_arn" {
  value = "${aws_alb_target_group.email_notification_service.arn}"
}

output "escalation_manager_target_group_arn" {
  value = "${aws_alb_target_group.escalation_manager.arn}"
}

output "escalation_service_target_group_arn" {
  value = "${aws_alb_target_group.escalation_service.arn}"
}

output "generic_data_source_target_group_arn" {
  value = "${aws_alb_target_group.generic_data_source.arn}"
}

output "loxone_data_source_target_group_arn" {
  value = "${aws_alb_target_group.loxone_data_source.arn}"
}

output "mute_manager_target_group_arn" {
  value = "${aws_alb_target_group.mute_manager.arn}"
}

output "mute_service_target_group_arn" {
  value = "${aws_alb_target_group.mute_service.arn}"
}

output "notification_permissions_manager_target_group_arn" {
  value = "${aws_alb_target_group.notification_permissions_manager.arn}"
}

output "notifications_enricher_target_group_arn" {
  value = "${aws_alb_target_group.notifications_enricher.arn}"
}

output "offline_sensor_manager_target_group_arn" {
  value = "${aws_alb_target_group.offline_sensor_manager.arn}"
}

output "offline_sensor_monitor_target_group_arn" {
  value = "${aws_alb_target_group.offline_sensor_monitor.arn}"
}

output "permissions_manager_target_group_arn" {
  value = "${aws_alb_target_group.permissions_manager.arn}"
}

output "response_manager_target_group_arn" {
  value = "${aws_alb_target_group.response_manager.arn}"
}

output "sensor_manager_target_group_arn" {
  value = "${aws_alb_target_group.sensor_manager.arn}"
}

output "sigfox_data_source_target_group_arn" {
  value = "${aws_alb_target_group.sigfox_data_source.arn}"
}

output "site_enricher_target_group_arn" {
  value = "${aws_alb_target_group.site_enricher.arn}"
}

output "site_manager_target_group_arn" {
  value = "${aws_alb_target_group.site_manager.arn}"
}

output "system_manager_target_group_arn" {
  value = "${aws_alb_target_group.system_manager.arn}"
}

output "telegram_inbound_service_target_group_arn" {
  value = "${aws_alb_target_group.telegram_inbound_service.arn}"
}

output "telegram_notification_service_target_group_arn" {
  value = "${aws_alb_target_group.telegram_notification_service.arn}"
}

output "threshold_anomaly_detector_target_group_arn" {
  value = "${aws_alb_target_group.threshold_anomaly_detector.arn}"
}

output "threshold_model_manager_target_group_arn" {
  value = "${aws_alb_target_group.threshold_model_manager.arn}"
}

output "rateofchange_model_manager_target_group_arn" {
  value = "${aws_alb_target_group.rateofchange_model_manager.arn}"
}

output "rateofchange_anomaly_detector_target_group_arn" {
  value = "${aws_alb_target_group.rateofchange_anomaly_detector.arn}"
}

output "spike_model_manager_target_group_arn" {
  value = "${aws_alb_target_group.spike_model_manager.arn}"
}

output "ttn_dc2_raw_target_group_arn" {
  value = "${aws_alb_target_group.ttn_dc2_raw.arn}"
}

output "ttn_transformer_target_group_arn" {
  value = "${aws_alb_target_group.ttn_transformer.arn}"
}

output "user_enricher_target_group_arn" {
  value = "${aws_alb_target_group.user_enricher.arn}"
}

output "user_manager_target_group_arn" {
  value = "${aws_alb_target_group.user_manager.arn}"
}

output "webway_data_source_target_group_arn" {
  value = "${aws_alb_target_group.webway_data_source.arn}"
}

output "gwt_data_source_target_group_arn" {
  value = "${aws_alb_target_group.gwt_data_source.arn}"
}

output "site_internal_elb_dns" {
  value = "${aws_alb.site-internal.dns_name}"
}

output "site_external_elb_dns" {
  value = "${aws_alb.site.dns_name}"
}

output "site_external_elb_id" {
  value = "${aws_alb.site.id}"
}