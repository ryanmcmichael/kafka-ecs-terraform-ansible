resource "aws_security_group" "nginx" {
  name = "${var.environment}-nginx"
  vpc_id = "${var.vpc-id}"

  // allows traffic from the SG itself for tcp
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  // allows traffic from the SG itself for udp
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    self = true
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = ["${var.bastion_sg_id}"]
  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "nginx-alb" {
  name = "${var.environment}-nginx-alb"
  vpc_id = "${var.vpc-id}"

  // allows traffic from the SG itself for tcp
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
  }

  // allows traffic from the SG itself for udp
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "udp"
    self = true
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}