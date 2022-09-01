output "sigfox_nginx_target_group_arn" {
  value = "${aws_alb_target_group.nginx-sigfox.id}"
}
output "gwt_nginx_target_group_arn" {
  value = "${aws_alb_target_group.nginx-gwt.id}"
}
output "loxone_nginx_target_group_arn" {
  value = "${aws_alb_target_group.nginx-loxone.id}"
}
output "generic_nginx_target_group_arn" {
  value = "${aws_alb_target_group.nginx-generic.id}"
}