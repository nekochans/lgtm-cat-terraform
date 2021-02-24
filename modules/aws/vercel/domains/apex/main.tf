resource "aws_route53_record" "apex_domain_record" {
  name    = var.main_domain_name
  type    = "A"
  zone_id = var.main_host_zone
  records = [var.a_record_value]
  ttl     = "5"
}
