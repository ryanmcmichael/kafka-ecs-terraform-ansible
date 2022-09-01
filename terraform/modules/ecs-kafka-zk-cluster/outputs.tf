/* We use this to track dependecies between each modules */
output "dependency_id" {
  value = "${null_resource.module_dependency.id}"
}

output "kafka-cluster-sg-id" {
   value = "${aws_security_group.kafka-cluster-sg.id}"
}

output "ecs_role_arn" {
  value = "${aws_iam_role.ecs-role-kafka.arn}"
}

output "kafka_target_group_arn" {
  value = "${aws_alb_target_group.kafka.arn}"
}

output "kafka_target_group_arn_1" {
  value = "${aws_alb_target_group.kafka_1.arn}"
}

output "zookeeper_target_group_arn" {
  value = "${aws_alb_target_group.zookeeper.arn}"
}

output "zookeeper_target_group_arn_1" {
  value = "${aws_alb_target_group.zookeeper_1.arn}"
}

output "zookeeper_target_group_arn_2" {
  value = "${aws_alb_target_group.zookeeper_2.arn}"
}

output "zookeeper_target_group_arn_3" {
  value = "${aws_alb_target_group.zookeeper_3.arn}"
}

output "kafka_internal_elb_dns" {
  value = "${aws_elb.kafka.dns_name}"
}

/*output "kafka_internal_alb_dns" {
  value = "${aws_alb.kafka-internal.dns_name}"
}*/

output "kafka_internal_elb_zone_id" {
  value = "${aws_elb.kafka.zone_id}"
}

output "kafka_internal_ip_1" {
  value = "${aws_instance.kafka-1.private_ip}"
}

output "kafka_internal_ip_2" {
  value = "${aws_instance.kafka-2.private_ip}"
}

output "kafka_internal_ip_3" {
  value = "${aws_instance.kafka-3.private_ip}"
}