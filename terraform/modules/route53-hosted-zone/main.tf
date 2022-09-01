/* private hosted zone */

resource "aws_route53_zone" "private-zone" {
  name   = "${var.hosted_zone_name}"
  vpc {
    vpc_id = "${var.vpc_id}"
  }
}


resource "null_resource" "module_dependency" {
   depends_on = [
        "aws_route53_zone.private-zone",
   ]
}


resource "aws_route53_record" "kafka1" {
  zone_id = "${aws_route53_zone.private-zone.zone_id}"
  name    =  "kafka1"
  type    = "A"
  ttl     = "300"

  records = ["${var.kafka_internal_ip_1}"]
}

resource "aws_route53_record" "kafka2" {
  zone_id = "${aws_route53_zone.private-zone.zone_id}"
  name    =  "kafka2"
  type    = "A"
  ttl     = "300"

  records = ["${var.kafka_internal_ip_2}"]
}

resource "aws_route53_record" "kafka3" {
  zone_id = "${aws_route53_zone.private-zone.zone_id}"
  name    =  "kafka3"
  type    = "A"
  ttl     = "300"

  records = ["${var.kafka_internal_ip_3}"]
}

resource "aws_route53_record" "zookeeper" {
  zone_id = "${aws_route53_zone.private-zone.zone_id}"
  name    =  "zookeeper"
  type    = "A"
  ttl     = "300"

  records = ["${var.kafka_internal_ip_1}","${var.kafka_internal_ip_2}","${var.kafka_internal_ip_3}"]
}

resource "aws_route53_record" "kafka" {
  zone_id = "${aws_route53_zone.private-zone.zone_id}"
  name    =  "kafka"
  type    = "A"
  ttl     = "300"

  records = ["${var.kafka_internal_ip_1}","${var.kafka_internal_ip_2}","${var.kafka_internal_ip_3}"]
}
