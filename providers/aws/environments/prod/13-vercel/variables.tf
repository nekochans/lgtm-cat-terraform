locals {
  a_record_value = "76.76.21.21"
}

variable "main_domain_name" {
  type    = string
  default = "lgtmeow.com"
}

data "aws_route53_zone" "main_host_zone" {
  name = var.main_domain_name
}
