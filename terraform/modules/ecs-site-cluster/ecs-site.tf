data "aws_ami" "site" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

}

resource "aws_launch_configuration" "site-cluster-lc" {
  image_id                    = "${data.aws_ami.site.id}"
  name_prefix                 = "site-cluster-${var.environment}-"
  instance_type               = "${var.site_instance_type}"
  associate_public_ip_address = false
  key_name                    = "${var.aws_key_name}"
  security_groups             = ["${aws_security_group.site-cluster-sg.id}"]
  user_data                   = "${data.template_file.userdata-site-cluster.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-site.name}"
  placement_tenancy           = "default"


  connection {
    user  = "ec2-user"
    agent = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = ["image_id"]
  }

}


resource "aws_autoscaling_group" "site-cluster-asg" {
  vpc_zone_identifier       = ["${var.private_subnet_ids}"]
  name                      = "ECS-SITE-CLUSTER-${var.environment}"
  max_size                  = "${var.site_asg_max_size}"
  min_size                  = "${var.site_asg_min_size}"
  health_check_grace_period = 100
  health_check_type         = "EC2"
  desired_capacity          = "${var.site_asg_desired_size}"
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.site-cluster-lc.name}"

 // Setting this to true would not allow us to delete the ECS clusters
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ECS-SITE-INSTANCES-${upper(var.environment)}"
    propagate_at_launch = true
  }

  tag {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
  }

  // This will decide Ansible role to be applied via dynamic inventory
  tag {
    key                 = "Role1"
    value               = "site_instances"
    propagate_at_launch = true
  }

  tag{
    key                 = "Stack"
    value               = "GLP"
    propagate_at_launch = true
  }

  tag{
    key                 = "weave:peerGroupName"
    value               = "GLP-${var.environment}"
    propagate_at_launch = true
  }

  tag{
    key                 = "cloudwatch"
    value               = "true"
    propagate_at_launch = true
  }

  depends_on = ["aws_launch_configuration.site-cluster-lc"]
}

resource "aws_ecs_cluster" "site-cluster" {
  name = "Site-cluster-${var.environment}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "site" {
  name            = "SITE-${var.environment}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.site-alb-sg.id}"]
}

resource "aws_alb" "site-internal" {
  name            = "SITE-INTERNAL-${var.environment}"
  subnets         = ["${var.private_subnet_ids}"]
  internal        = true
  security_groups = ["${aws_security_group.site-alb-internal-sg.id}"]
}


resource "aws_alb_target_group" "api_gateway" {
  name     = "${var.environment_shortened}-api-gateway"
  port     = "${var.api_gateway_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "anomaly_processor" {
  name     = "${var.environment_shortened}-anomaly-processor"
  port     = "${var.anomaly_processor_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "asset_enricher" {
  name     = "${var.environment_shortened}-asset-enricher"
  port     = "${var.asset_enricher_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "asset_manager" {
  name     = "${var.environment_shortened}-asset-mgr"
  port     = "${var.port_8080}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "control_center" {
  name     = "${var.environment_shortened}-control-center"
  port     = "${var.control_center_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "ehs" {
  name     = "${var.environment_shortened}-ehs"
  port     = "${var.ehs_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "email_notification_service" {
  name     = "${var.environment_shortened}-email-notif-svc"
  port     = "${var.email_notification_service_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "escalation_manager" {
  name     = "${var.environment_shortened}-escalation-mgr"
  port     = "${var.escalation_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "escalation_service" {
  name     = "${var.environment_shortened}-escalation-svc"
  port     = "${var.escalation_service_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "generic_data_source" {
  name     = "${var.environment_shortened}-generic-data-source"
  port     = "${var.generic_data_source_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "loxone_data_source" {
  name     = "${var.environment_shortened}-loxone-data-source"
  port     = "${var.loxone_data_source_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "gwt_data_source" {
  name     = "${var.environment_shortened}-gwt-data-source"
  port     = "${var.gwt_data_source_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "mute_manager" {
  name     = "${var.environment_shortened}-mute-manager"
  port     = "${var.mute_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "mute_service" {
  name     = "${var.environment_shortened}-mute-service"
  port     = "${var.mute_service_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "notification_permissions_manager" {
  name     = "${var.environment_shortened}-notification-perm-mgr"
  port     = "${var.notification_permissions_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "notifications_enricher" {
  name     = "${var.environment_shortened}-notifications-enricher"
  port     = "${var.notifications_enricher_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "offline_sensor_manager" {
  name     = "${var.environment_shortened}-offline-sensor-mgr"
  port     = "${var.offline_sensor_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "offline_sensor_monitor" {
  name     = "${var.environment_shortened}-offline-sensor-monitor"
  port     = "${var.offline_sensor_monitor_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}



resource "aws_alb_target_group" "permissions_manager" {
  name     = "${var.environment_shortened}-permissions-manager"
  port     = "${var.permissions_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "response_manager" {
  name     = "${var.environment_shortened}-response-manager"
  port     = "${var.response_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "sensor_manager" {
  name     = "${var.environment_shortened}-sensor-manager"
  port     = "${var.sensor_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "sigfox_data_source" {
  name     = "${var.environment_shortened}-sigfox-data-source"
  port     = "${var.sigfox_data_source_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "site_enricher" {
  name     = "${var.environment_shortened}-site-enricher"
  port     = "${var.site_enricher_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "site_manager" {
  name     = "${var.environment_shortened}-site-manager"
  port     = "${var.site_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "system_manager" {
  name     = "${var.environment_shortened}-system-manager"
  port     = "${var.system_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "telegram_inbound_service" {
  name     = "${var.environment_shortened}-telegram-inbound-svc"
  port     = "${var.telegram_inbound_service_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "telegram_notification_service" {
  name     = "${var.environment_shortened}-telegram-notif-svc"
  port     = "${var.telegram_notification_service_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "threshold_anomaly_detector" {
  name     = "${var.environment_shortened}-threshold-anomaly-detect"
  port     = "${var.threshold_anomaly_detector_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "threshold_model_manager" {
  name     = "${var.environment_shortened}-threshold-model-mgr"
  port     = "${var.threshold_model_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "rateofchange_model_manager" {
  name     = "${var.environment_shortened}-roc-model-mgr"
  port     = "${var.rateofchange_model_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "rateofchange_anomaly_detector" {
  name     = "${var.environment_shortened}-roc-anomaly-detector"
  port     = "${var.rateofchange_anomaly_detector_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}



resource "aws_alb_target_group" "spike_model_manager" {
  name     = "${var.environment_shortened}-spike-model-mgr"
  port     = "${var.spike_model_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "ttn_dc2_raw" {
  name     = "${var.environment_shortened}-ttn-dc2-raw"
  port     = "${var.ttn_dc2_raw_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "ttn_transformer" {
  name     = "${var.environment_shortened}-ttn-transformer"
  port     = "${var.ttn_transformer_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "user_enricher" {
  name     = "${var.environment_shortened}-user-enricher"
  port     = "${var.user_enricher_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}

resource "aws_alb_target_group" "user_manager" {
  name     = "${var.environment_shortened}-user-manager"
  port     = "${var.user_manager_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_target_group" "webway_data_source" {
  name     = "${var.environment_shortened}-webway-data-source"
  port     = "${var.webway_data_source_port}"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/"
  }
}


resource "aws_alb_listener" "api_gateway" {
  load_balancer_arn = "${aws_alb.site.id}"
  port              = "${var.api_gateway_port}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.api_gateway.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = "${aws_alb.site.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "anomaly_processor" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.anomaly_processor_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.anomaly_processor.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "asset_enricher" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.asset_enricher_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.asset_enricher.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "asset_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.asset_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.asset_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "control_center" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.control_center_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.control_center.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "ehs" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.ehs_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ehs.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "email_notification_service" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.email_notification_service_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.email_notification_service.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "escalation_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.escalation_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.escalation_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "escalation_service" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.escalation_service_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.escalation_service.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "generic_data_source" {
  load_balancer_arn = "${aws_alb.site.id}"
  port              = "${var.generic_data_source_port}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.generic_data_source.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "loxone_data_source" {
  load_balancer_arn = "${aws_alb.site.id}"
  port              = "${var.loxone_data_source_port}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.loxone_data_source.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "mute_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.mute_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.mute_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "mute_service" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.mute_service_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.mute_service.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "notification_permissions_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.notification_permissions_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.notification_permissions_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "notifications_enricher" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.notifications_enricher_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.notifications_enricher.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "offline_sensor_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.offline_sensor_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.offline_sensor_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "offline_sensor_monitor" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.offline_sensor_monitor_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.offline_sensor_monitor.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "permissions_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.permissions_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.permissions_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "response_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.response_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.response_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "sensor_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.sensor_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.sensor_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "sigfox_data_source" {
  load_balancer_arn = "${aws_alb.site.id}"
  port              = "${var.sigfox_data_source_port}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.sigfox_data_source.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "gwt_data_source" {
  load_balancer_arn = "${aws_alb.site.id}"
  port              = "${var.gwt_data_source_port}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.gwt_data_source.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "site_enricher" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.site_enricher_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.site_enricher.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "site_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.site_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.site_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "system_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.system_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.system_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "telegram_inbound_service" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.telegram_inbound_service_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.telegram_inbound_service.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "telegram_notification_service" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.telegram_notification_service_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.telegram_notification_service.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "threshold_anomaly_detector" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.threshold_anomaly_detector_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.threshold_anomaly_detector.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "threshold_model_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.threshold_model_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.threshold_model_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "rateofchange_model_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.rateofchange_model_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.rateofchange_model_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "rateofchange_anomaly_detector" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.rateofchange_anomaly_detector_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.rateofchange_anomaly_detector.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "spike_model_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.spike_model_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.spike_model_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "ttn_dc2_raw" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.ttn_dc2_raw_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ttn_dc2_raw.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "ttn_transformer" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.ttn_transformer_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ttn_transformer.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "user_enricher" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.user_enricher_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.user_enricher.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "user_manager" {
  load_balancer_arn = "${aws_alb.site-internal.id}"
  port              = "${var.user_manager_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.user_manager.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "webway_data_source" {
  load_balancer_arn = "${aws_alb.site.id}"
  port              = "${var.webway_data_source_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.webway_data_source.id}"
    type             = "forward"
  }
}


resource "null_resource" "module_dependency" {
  depends_on = ["aws_autoscaling_group.site-cluster-asg"]
}
