/* Specify all templates to be used here */

data "template_file" "userdata-kafka-cluster-1" {
   template = "${file("${path.module}/templates/userdata-kafka-cluster")}"

   vars {
     brokerID = "1"
     environment = "${var.environment}"
   }
}

data "template_file" "userdata-kafka-cluster-2" {
  template = "${file("${path.module}/templates/userdata-kafka-cluster")}"

  vars {
    brokerID = "2"
    environment = "${var.environment}"
  }
}

data "template_file" "userdata-kafka-cluster-3" {
  template = "${file("${path.module}/templates/userdata-kafka-cluster")}"

  vars {
    brokerID = "3"
    environment = "${var.environment}"
  }
}
