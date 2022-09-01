data "aws_ami" "kafka" {
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



resource "aws_instance" "kafka-1" {
  ami                         = "${data.aws_ami.kafka.id}"
  instance_type               = "${var.kafka_instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.kafka-cluster-sg.id}"]
  subnet_id                   = "${var.private_subnet_ids[0]}"
  associate_public_ip_address = false
  source_dest_check           = false
  // Implicit dependency
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-kafka.name}"
  user_data                   = "${data.template_file.userdata-kafka-cluster-1.rendered}"

  root_block_device {
    volume_size           = "200"
    volume_type           = "gp2"
  }

  tags {
    Name                = "${upper(var.environment)}-KAFKA-1"
    Environment         = "${var.environment}"
    Role1               = "kafka_instances"
    Role2               = "zookeeper_instances"
    cloudwatch          = "true"
  }

  lifecycle = {
    ignore_changes = ["ami"]
  }
}

resource "aws_elb_attachment" "kafka1" {
  elb      = "${aws_elb.kafka.id}"
  instance = "${aws_instance.kafka-1.id}"
}

resource "aws_elb_attachment" "zookeeper1" {
  elb      = "${aws_elb.zookeeper.id}"
  instance = "${aws_instance.kafka-1.id}"
}

resource "aws_instance" "kafka-2" {
  ami                         = "${data.aws_ami.kafka.id}"
  instance_type               = "${var.kafka_instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.kafka-cluster-sg.id}"]
  subnet_id                   = "${var.private_subnet_ids[1]}"
  associate_public_ip_address = false
  source_dest_check           = false
  // Implicit dependency
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-kafka.name}"
  user_data                   = "${data.template_file.userdata-kafka-cluster-2.rendered}"

  root_block_device {
    volume_size           = "200"
    volume_type           = "gp2"
  }

  tags {
    Name                = "${upper(var.environment)}-KAFKA-2"
    Environment         = "${var.environment}"
    Role1               = "kafka_instances"
    Role2               = "zookeeper_instances"
    cloudwatch          = "true"
  }

  lifecycle = {
    ignore_changes = ["ami"]
  }
}

resource "aws_elb_attachment" "kafka2" {
  elb      = "${aws_elb.kafka.id}"
  instance = "${aws_instance.kafka-2.id}"
}

resource "aws_elb_attachment" "zookeeper2" {
  elb      = "${aws_elb.zookeeper.id}"
  instance = "${aws_instance.kafka-2.id}"
}

resource "aws_instance" "kafka-3" {
  ami                         = "${data.aws_ami.kafka.id}"
  instance_type               = "${var.kafka_instance_type}"
  key_name                    = "${var.aws_key_name}"
  vpc_security_group_ids      = ["${aws_security_group.kafka-cluster-sg.id}"]
  subnet_id                   = "${var.private_subnet_ids[2]}"
  associate_public_ip_address = false
  source_dest_check           = false
  // Implicit dependency
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-kafka.name}"
  user_data                   = "${data.template_file.userdata-kafka-cluster-3.rendered}"

  root_block_device {
    volume_size           = "200"
    volume_type           = "gp2"
  }

  tags {
    Name                = "${upper(var.environment)}-KAFKA-3"
    Environment         = "${var.environment}"
    Role1               = "kafka_instances"
    Role2               = "zookeeper_instances"
    cloudwatch          = "true"
  }

  lifecycle = {
    ignore_changes = ["ami"]
  }
}

resource "aws_elb_attachment" "kafka3" {
  elb      = "${aws_elb.kafka.id}"
  instance = "${aws_instance.kafka-3.id}"
}

resource "aws_elb_attachment" "zookeeper3" {
  elb      = "${aws_elb.zookeeper.id}"
  instance = "${aws_instance.kafka-3.id}"
}

/*resource "aws_launch_configuration" "kafka-cluster-lc" {
  image_id                    = "${data.aws_ami.kafka.id}"
  name_prefix                 = "kafka-cluster-${var.environment}-"
  instance_type               = "${var.kafka_instance_type}"
  associate_public_ip_address = true
  key_name                    = "${var.aws_key_name}"
  security_groups             = ["${aws_security_group.kafka-cluster-sg.id}"]
  user_data                   = "${data.template_file.userdata-kafka-cluster.rendered}"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-profile-kafka.name}"
  placement_tenancy           = "default"

  root_block_device {
    volume_type           = "standard"
    volume_size           = 30
    delete_on_termination = true
  }

  connection {
    user  = "ec2-user"
    agent = true
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = ["image_id"]
  }

}


resource "aws_autoscaling_group" "kafka-cluster-asg" {
  vpc_zone_identifier       = ["${var.private_subnet_ids}"]
  name                      = "ECS-KAFKA-CLUSTER-${var.environment}"
  max_size                  = "${var.kafka_asg_max_size}"
  min_size                  = "${var.kafka_asg_min_size}"
  health_check_grace_period = 100
  health_check_type         = "EC2"
  desired_capacity          = "${var.kafka_asg_desired_size}"
  force_delete              = false
  launch_configuration      = "${aws_launch_configuration.kafka-cluster-lc.name}"

 // Setting this to true would not allow us to delete the ECS clusters
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "ECS-KAFKA-INSTANCES-${upper(var.environment)}"
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
    value               = "kafka_instances"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role2"
    value               = "zookeeper_instances"
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

  depends_on = ["aws_launch_configuration.kafka-cluster-lc"]
}

resource "aws_ecs_cluster" "kafka-cluster" {
  name = "Kafka-cluster-${var.environment}"

}*/

/*resource "aws_alb" "kafka-internal" {
  name            = "KAFKA-INTERNAL-${var.environment}"
  subnets         = ["${var.private_subnet_ids}"]
  internal        = true
  security_groups = ["${aws_security_group.kafka-alb-internal-sg.id}"]
}*/

resource "aws_elb" "kafka" {
  name               = "KAFKA-INTERNAL-${var.environment}"
  subnets         = ["${var.private_subnet_ids}"]
  internal        = true
  security_groups = ["${aws_security_group.kafka-alb-internal-sg.id}"]

  listener {
    instance_port     = 29092
    instance_protocol = "tcp"
    lb_port           = 29092
    lb_protocol       = "tcp"
  }

  listener {
    instance_port      = 9020
    instance_protocol  = "tcp"
    lb_port            = 9020
    lb_protocol        = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300

  tags {
    Name = "KAFKA-${var.environment}"
  }
}

resource "aws_elb" "zookeeper" {
  name               = "ZOOKEEPER-INTERNAL-${var.environment}"
  subnets         = ["${var.private_subnet_ids}"]
  internal        = true
  security_groups = ["${aws_security_group.kafka-alb-internal-sg.id}"]

  listener {
    instance_port     = 2181
    instance_protocol = "tcp"
    lb_port           = 2181
    lb_protocol       = "tcp"
  }

  listener {
    instance_port      = 2888
    instance_protocol  = "tcp"
    lb_port            = 2888
    lb_protocol        = "tcp"
  }

  listener {
    instance_port     = 3181
    instance_protocol = "tcp"
    lb_port           = 3181
    lb_protocol       = "tcp"
  }

  listener {
    instance_port      = 3888
    instance_protocol  = "tcp"
    lb_port            = 3888
    lb_protocol        = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:2181"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300

  tags {
    Name = "ZOOKEEPER-${var.environment}"
  }
}


resource "aws_alb_target_group" "kafka" {
  name     = "${var.environment_shortened}-kafka"
  port     = "${var.kafka_port}"
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

resource "aws_alb_target_group" "kafka_1" {
  name     = "${var.environment_shortened}-kafka-1"
  port     = "${var.kafka_port_1}"
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

resource "aws_alb_target_group" "zookeeper" {
  name     = "${var.environment_shortened}-zookeeper"
  port     = "${var.zookeeper_port}"
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

resource "aws_alb_target_group" "zookeeper_1" {
  name     = "${var.environment_shortened}-zookeeper-1"
  port     = "${var.zookeeper_port_1}"
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

resource "aws_alb_target_group" "zookeeper_2" {
  name     = "${var.environment_shortened}-zookeeper-2"
  port     = "${var.zookeeper_port_2}"
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

resource "aws_alb_target_group" "zookeeper_3" {
  name     = "${var.environment_shortened}-zookeeper-3"
  port     = "${var.zookeeper_port_3}"
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


/*resource "aws_alb_listener" "kafka" {
  load_balancer_arn = "${aws_alb.kafka-internal.id}"
  port              = "${var.kafka_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.kafka.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "kafka_1" {
  load_balancer_arn = "${aws_alb.kafka-internal.id}"
  port              = "${var.kafka_port_1}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.kafka_1.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "zookeeper" {
  load_balancer_arn = "${aws_alb.kafka-internal.id}"
  port              = "${var.zookeeper_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.zookeeper.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "zookeeper_1" {
  load_balancer_arn = "${aws_alb.kafka-internal.id}"
  port              = "${var.zookeeper_port_1}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.zookeeper_1.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "zookeeper_2" {
  load_balancer_arn = "${aws_alb.kafka-internal.id}"
  port              = "${var.zookeeper_port_2}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.zookeeper_2.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "zookeeper_3" {
  load_balancer_arn = "${aws_alb.kafka-internal.id}"
  port              = "${var.zookeeper_port_3}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.zookeeper_3.id}"
    type             = "forward"
  }
}*/


/* We use this to create this as a dependency for other modules */
resource "null_resource" "module_dependency" {
  depends_on = ["aws_elb.kafka"]
}
