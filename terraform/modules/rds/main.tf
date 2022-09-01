resource "aws_security_group" "database" {
  name_prefix = "${var.environment}-database-"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    self            = true
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["10.0.0.0/8"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment}-database"
    Environment = "${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_instance" "db" {
  identifier                    = "postgres-${var.environment}"
  allocated_storage             = "200"
  engine                        = "postgres"
  instance_class                = "db.t2.medium"
  name                          = "client"
  username                      = "client"
  password                      = "${var.db_password}"
  vpc_security_group_ids        = ["${aws_security_group.database.id}"]
  db_subnet_group_name          = "${var.database_subnet_group_name}"
  publicly_accessible           = false
  skip_final_snapshot           = true
  multi_az                      = "${var.environment == "production" ? true : false}"

  lifecycle {
    ignore_changes = ["snapshot_identifier"]
  }
}

resource "aws_route53_record" "database" {
  zone_id = "${var.internal_zone_id}"
  name = "database"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_db_instance.db.address}"]
}