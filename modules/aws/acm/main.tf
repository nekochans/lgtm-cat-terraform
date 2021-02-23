data "aws_acm_certificate" "main" {
  domain = var.main_domain_name
}

data "aws_acm_certificate" "sub" {
  domain = "*.${var.main_domain_name}"
}
