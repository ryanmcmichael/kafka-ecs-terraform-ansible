
resource "aws_alb" "nginx-sigfox" {
  name            = "NGINX-SIGFOX-${var.environment}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.nginx-alb.id}"]
  internal        = false
}

resource "aws_alb_target_group" "nginx-sigfox" {
  name     = "${var.environment_shortened}-nginx-sigfox"
  port     = "${var.sigfox_data_source_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_listener" "nginx-sigfox-https" {
  load_balancer_arn = "${aws_alb.nginx-sigfox.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.nginx-sigfox.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "nginx-sigfox-http-redirect" {
  load_balancer_arn = "${aws_alb.nginx-sigfox.id}"
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



resource "aws_alb" "nginx-gwt" {
  name            = "NGINX-GWT-${var.environment}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.nginx-alb.id}"]
  internal        = false
}

resource "aws_alb_target_group" "nginx-gwt" {
  name     = "${var.environment_shortened}-nginx-gwt"
  port     = "${var.gwt_data_source_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_listener" "nginx-gwt-https" {
  load_balancer_arn = "${aws_alb.nginx-gwt.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.nginx-gwt.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "nginx-gwt-http-redirect" {
  load_balancer_arn = "${aws_alb.nginx-gwt.id}"
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



resource "aws_alb" "nginx-loxone" {
  name            = "NGINX-LOXONE-${var.environment}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.nginx-alb.id}"]
  internal        = false
}

resource "aws_alb_target_group" "nginx-loxone" {
  name     = "${var.environment_shortened}-nginx-loxone"
  port     = "${var.loxone_data_source_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_listener" "nginx-loxone-https" {
  load_balancer_arn = "${aws_alb.nginx-loxone.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.nginx-loxone.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "nginx-loxone-http-redirect" {
  load_balancer_arn = "${aws_alb.nginx-loxone.id}"
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



resource "aws_alb" "nginx-generic" {
  name            = "NGINX-GENERIC-${var.environment}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.nginx-alb.id}"]
  internal        = false
}

resource "aws_alb_target_group" "nginx-generic" {
  name     = "${var.environment_shortened}-nginx-generic"
  port     = "${var.generic_data_source_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    path                = "/ping"
  }
}

resource "aws_alb_listener" "nginx-generic-https" {
  load_balancer_arn = "${aws_alb.nginx-generic.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.domain_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.nginx-generic.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "nginx-generic-http-redirect" {
  load_balancer_arn = "${aws_alb.nginx-generic.id}"
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

