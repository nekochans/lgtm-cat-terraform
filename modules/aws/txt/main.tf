resource "aws_route53_record" "txt_records" {
  name    = var.main_domain_name
  type    = "TXT"
  zone_id = var.main_host_zone
  records = var.txt_records
  ttl     = "300"
}
