variable "vpc_id" {}
variable "ssh_key_name" {}

variable "name" {
  default = "main"
}

variable "min_size" {
  description = "Minimum number of RabbitMQ nodes"
  default     = 2
}

variable "desired_size" {
  description = "Desired number of RabbitMQ nodes"
  default     = 3
}

variable "max_size" {
  description = "Maximum number of RabbitMQ nodes"
  default     = 4
}

variable "private_subnet_ids" {
  description = "Subnets for RabbitMQ nodes"
  type        = "list"
}

variable "public_subnet_ids" {
  description = "Subnets for RabbitMQ ELB"
  type        = "list"
}

variable "nodes_additional_security_group_ids" {
  type    = "list"
  default = []
}

variable "elb_additional_security_group_ids" {
  type    = "list"
  default = []
}

variable "instance_type" {
  default = "m5.large"
}

variable "instance_volume_type" {
  default = "standard"
}

variable "instance_volume_size" {
  default = "100"
}

variable "instance_volume_iops" {
  default = "0"
}

variable "domain_certificate_arn" {
}