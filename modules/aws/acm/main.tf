data "aws_acm_certificate" "sub" {
  domain = "*.${var.main_domain_name}"
}
