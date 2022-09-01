data "template_file" "kafka_ecs_deploy" {
  template   = "${file("${path.module}/templates/kafka_ecs_deploy.sh")}"

  vars {
    env                          = "${lower(var.env)}"
    region                       = "${var.region}"
    log_group_name               = "${var.log_group_name}"
    repository_credentials_arn   = "${var.repository_credentials_arn}"
    ecs_role_arn                 = "${var.ecs_role_arn}"
    kafka_sg_id                  = "${var.kafka_sg_id}"
    private_subnet_0             = "${var.private_subnet_ids[0]}"
    private_subnet_1             = "${var.private_subnet_ids[1]}"
    private_subnet_2             = "${var.private_subnet_ids[2]}"
    kafka_internal_elb_dns       = "${var.kafka_internal_elb_dns}"
    CHANGELOG_REPLICATION_FACTOR = "${var.CHANGELOG_REPLICATION_FACTOR}"

    kafka_port                            = "${var.kafka_port}"
    kafka_port_1                          = "${var.kafka_port_1}"
    zookeeper_port                        = "${var.zookeeper_port}"
    zookeeper_port_1                      = "${var.zookeeper_port_1}"
    zookeeper_port_2                      = "${var.zookeeper_port_2}"
    zookeeper_port_3                      = "${var.zookeeper_port_3}"

    kafka_target_group_arn                            = "${var.kafka_target_group_arn}"
    kafka_target_group_arn_1                          = "${var.kafka_target_group_arn_1}"
    zookeeper_target_group_arn                        = "${var.zookeeper_target_group_arn}"
    zookeeper_target_group_arn_1                      = "${var.zookeeper_target_group_arn_1}"
    zookeeper_target_group_arn_2                      = "${var.zookeeper_target_group_arn_2}"
    zookeeper_target_group_arn_3                      = "${var.zookeeper_target_group_arn_3}"
  }

}

data "template_file" "kafka_ecs_destroy" {
  template   = "${file("${path.module}/templates/kafka_ecs_destroy.sh")}"

  vars {
    env                          = "${lower(var.env)}"
    region                       = "${var.region}"
    log_group_name               = "${var.log_group_name}"
    repository_credentials_arn   = "${var.repository_credentials_arn}"
    ecs_role_arn                 = "${var.ecs_role_arn}"
    kafka_sg_id                  = "${var.kafka_sg_id}"
    private_subnet_0             = "${var.private_subnet_ids[0]}"
    private_subnet_1             = "${var.private_subnet_ids[1]}"
    private_subnet_2             = "${var.private_subnet_ids[2]}"
    kafka_internal_elb_dns       = "${var.kafka_internal_elb_dns}"
    CHANGELOG_REPLICATION_FACTOR = "${var.CHANGELOG_REPLICATION_FACTOR}"

    kafka_port                            = "${var.kafka_port}"
    kafka_port_1                          = "${var.kafka_port_1}"
    zookeeper_port                        = "${var.zookeeper_port}"
    zookeeper_port_1                      = "${var.zookeeper_port_1}"
    zookeeper_port_2                      = "${var.zookeeper_port_2}"
    zookeeper_port_3                      = "${var.zookeeper_port_3}"

    kafka_target_group_arn                            = "${var.kafka_target_group_arn}"
    kafka_target_group_arn_1                          = "${var.kafka_target_group_arn_1}"
    zookeeper_target_group_arn                        = "${var.zookeeper_target_group_arn}"
    zookeeper_target_group_arn_1                      = "${var.zookeeper_target_group_arn_1}"
    zookeeper_target_group_arn_2                      = "${var.zookeeper_target_group_arn_2}"
    zookeeper_target_group_arn_3                      = "${var.zookeeper_target_group_arn_3}"
  }

}

resource "null_resource" "kafka_ecs_generate" {

  triggers {
    # This will trigger create on every run
    filename = "test-${uuid()}"
  }


  provisioner "local-exec" {
    command = "echo '${ data.template_file.kafka_ecs_deploy.rendered }' > ../../../ansible/kafka_call_deploy.sh"
  }

  provisioner "local-exec" {
    command = "chmod 755 ../../../ansible/kafka_call_deploy.sh"
  }

  provisioner "local-exec" {
    command = "../../../ansible/kafka_call_deploy.sh"
  }

}


/*
resource "null_resource" "kafka_ecs_destroy" {

  triggers {
    template_rendered = "${data.template_file.kafka_ecs_destroy.rendered}"
  }


  provisioner "local-exec" {
    command = "echo '${ data.template_file.kafka_ecs_destroy.rendered }' > ../../../ansible/kafka_call_destroy.sh"
  }

  provisioner "local-exec" {
    command = "chmod 755 ../../../ansible/kafka_call_destroy.sh"
  }

  provisioner "local-exec" {
    command = "../../../ansible/kafka_call_destroy.sh"
  }

}
*/

resource "aws_security_group" "dependency-sg" {
  name = "${var.env}-dependency-sg"
  vpc_id = "${var.vpc-id}"

  // allows traffic from the SG itself for tcp
  ingress {
    from_port = 1
    to_port = 1
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/32"]
  }
}
