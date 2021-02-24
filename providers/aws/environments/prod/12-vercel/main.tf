module "vercel_domains_apex" {
  source           = "../../../../../modules/aws/vercel/domains/apex"
  main_host_zone   = data.aws_route53_zone.main_host_zone.zone_id
  main_domain_name = var.main_domain_name
  a_record_value   = local.a_record_value
}
