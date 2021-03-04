module "txt" {
  source           = "../../../../../modules/aws/txt"
  main_host_zone   = data.aws_route53_zone.main_host_zone.zone_id
  main_domain_name = var.main_domain_name
  txt_records      = var.txt_records
}
