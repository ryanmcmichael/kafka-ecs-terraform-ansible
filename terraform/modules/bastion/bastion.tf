data "aws_ami" "bastion" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

}


resource "aws_instance" "jump_node" {
    ami                         = "ami-0150b2ec056e3c3c1"
    instance_type               = "${var.bastion_instance_type}"
    key_name                    = "${var.aws_key_name}"
    vpc_security_group_ids      = ["${aws_security_group.jump-sg.id}"]
    #count                      = "${length(var.public_sub_cidr)}"
    user_data                   = "${data.template_file.userdata-bastion.rendered}"
    subnet_id                   = "${var.pub_sub_id}"
    associate_public_ip_address = true
    source_dest_check           = false
    // Implicit dependency
    iam_instance_profile        = "${aws_iam_instance_profile.bastion_profile.name}"

    tags = {
      Name        = "ECS-BASTION-NODE-${var.environment}"
      Role        = "bastion"
      Environment = "${var.environment}"
      cloudwatch  = "true"
    }

}


//assgin eip to jump-node
resource "aws_eip" "jump-node" {
    instance = "${aws_instance.jump_node.id}"
    vpc      = true
}
