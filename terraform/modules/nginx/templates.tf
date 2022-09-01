/* Specify all templates to be used here */

data "template_file" "userdata-nginx-sigfox" {
   template = "${file("${path.module}/templates/userdata-nginx")}"

   vars {
     server_name = "sigfox"
     azure_port = "9060"
     azure_protocol = "http"
     prod_proxy = "${var.prod_proxy}"
     test_proxy = "${var.test_proxy}"
     service_port = "${var.sigfox_data_source_port}"
   }
}

data "template_file" "userdata-nginx-gwt" {
  template = "${file("${path.module}/templates/userdata-nginx")}"

  vars {
    server_name = "gwt"
    azure_port = "7090"
    azure_protocol = "https"
    prod_proxy = "${var.prod_proxy}"
    test_proxy = "${var.test_proxy}"
    service_port = "${var.gwt_data_source_port}"
  }
}

data "template_file" "userdata-nginx-loxone" {
  template = "${file("${path.module}/templates/userdata-nginx")}"

  vars {
    server_name = "loxone"
    azure_port = "8443"
    azure_protocol = "https"
    prod_proxy = "${var.prod_proxy}"
    test_proxy = "${var.test_proxy}"
    service_port = "${var.loxone_data_source_port}"
  }
}

data "template_file" "userdata-nginx-generic" {
  template = "${file("${path.module}/templates/userdata-nginx")}"

  vars {
    server_name = "generic"
    azure_port = "9055"
    azure_protocol = "http"
    prod_proxy = "${var.prod_proxy}"
    test_proxy = "${var.test_proxy}"
    service_port = "${var.generic_data_source_port}"
  }
}
