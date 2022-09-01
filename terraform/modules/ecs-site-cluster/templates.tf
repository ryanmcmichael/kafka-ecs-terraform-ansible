data "template_file" "userdata-site-cluster" {
   template = "${file("${path.module}/templates/userdata-site-cluster")}"

   vars {
     ecs_cluster_name    = "${aws_ecs_cluster.site-cluster.name}"
     region              = "${var.region}"
     environment         = "${var.environment}"
   }
}
