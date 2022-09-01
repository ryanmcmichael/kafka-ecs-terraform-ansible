data "aws_ami" "nginx" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}


resource "aws_instance" "nginx-sigfox" {
  ami                         = "${data.aws_ami.nginx.id}"
  instance_type               = "${var.nginx_instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nginx.id}"]
  subnet_id                   = "${element(var.private_subnet_ids,0)}"
  associate_public_ip_address = false
  source_dest_check           = false
  // Implicit dependency
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-nginx.name}"
  user_data                   = "${data.template_file.userdata-nginx-sigfox.rendered}"

  tags {
    Name                = "${upper(var.environment)}-NGINX-SIGFOX"
    Environment         = "${var.environment}"
    cloudwatch          = "true"
  }

  lifecycle = {
    ignore_changes = ["ami"]
  }
}

resource "aws_lb_target_group_attachment" "nginx-sigfox" {
  target_group_arn = "${aws_alb_target_group.nginx-sigfox.arn}"
  target_id        = "${aws_instance.nginx-sigfox.id}"
  port             = "${var.sigfox_data_source_port}"
}



resource "aws_instance" "nginx-gwt" {
  ami                         = "${data.aws_ami.nginx.id}"
  instance_type               = "${var.nginx_instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nginx.id}"]
  subnet_id                   = "${element(var.private_subnet_ids,1)}"
  associate_public_ip_address = false
  source_dest_check           = false
  // Implicit dependency
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-nginx.name}"
  user_data                   = "${data.template_file.userdata-nginx-gwt.rendered}"

  tags {
    Name                = "${upper(var.environment)}-NGINX-GWT"
    Environment         = "${var.environment}"
    cloudwatch          = "true"
  }

  lifecycle = {
    ignore_changes = ["ami"]
  }
}

resource "aws_lb_target_group_attachment" "nginx-gwt" {
  target_group_arn = "${aws_alb_target_group.nginx-gwt.arn}"
  target_id        = "${aws_instance.nginx-gwt.id}"
  port             = "${var.gwt_data_source_port}"
}



resource "aws_instance" "nginx-loxone" {
  ami                         = "${data.aws_ami.nginx.id}"
  instance_type               = "${var.nginx_instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nginx.id}"]
  subnet_id                   = "${element(var.private_subnet_ids,2)}"
  associate_public_ip_address = false
  source_dest_check           = false
  // Implicit dependency
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-nginx.name}"
  user_data                   = "${data.template_file.userdata-nginx-loxone.rendered}"

  tags {
    Name                = "${upper(var.environment)}-NGINX-LOXONE"
    Environment         = "${var.environment}"
    cloudwatch          = "true"
  }

  lifecycle = {
    ignore_changes = ["ami"]
  }
}

resource "aws_lb_target_group_attachment" "nginx-loxone" {
  target_group_arn = "${aws_alb_target_group.nginx-loxone.arn}"
  target_id        = "${aws_instance.nginx-loxone.id}"
  port             = "${var.loxone_data_source_port}"
}



resource "aws_instance" "nginx-generic" {
  ami                         = "${data.aws_ami.nginx.id}"
  instance_type               = "${var.nginx_instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.nginx.id}"]
  subnet_id                   = "${element(var.private_subnet_ids,0)}"
  associate_public_ip_address = false
  source_dest_check           = false
  // Implicit dependency
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-nginx.name}"
  user_data                   = "${data.template_file.userdata-nginx-generic.rendered}"

  tags {
    Name                = "${upper(var.environment)}-NGINX-GENERIC"
    Environment         = "${var.environment}"
    cloudwatch          = "true"
  }

  lifecycle = {
    ignore_changes = ["ami"]
  }
}

resource "aws_lb_target_group_attachment" "nginx-generic" {
  target_group_arn = "${aws_alb_target_group.nginx-generic.arn}"
  target_id        = "${aws_instance.nginx-generic.id}"
  port             = "${var.generic_data_source_port}"
}

