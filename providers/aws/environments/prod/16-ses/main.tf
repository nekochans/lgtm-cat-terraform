module "ses" {
  source           = "../../../../../modules/aws/ses"
  main_domain_name = var.main_domain_name
  from_email       = var.from_email
}
