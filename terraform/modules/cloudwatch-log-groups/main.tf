/* Create a log group and pass it to Ansible for cloudwatch logs */

resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.log_group_name}"
  retention_in_days = "${var.cloudwatch_retention_in_days}"

  tags {
    Environment = "${var.environment}"
  }
}
