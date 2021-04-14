locals {
  env                             = "prod"
  name                            = "lgtmeow"
  lgtm_images_bucket_name         = "${local.env}-${local.name}-images"
  lgtm_images_cdn_sub_domain      = "lgtm-images"
  lgtm_images_cdn_domain          = "${local.lgtm_images_cdn_sub_domain}.${var.main_domain_name}"
  lgtm_images_cdn_acm_arn         = data.terraform_remote_state.acm.outputs.us_east_1_sub_domain_acm_arn
  main_host_zone                  = data.aws_route53_zone.main_host_zone
  upload_images_bucket_name       = "${local.env}-${local.name}-upload-images"
  cat_images_bucket_name          = "${local.env}-${local.name}-cat-images"
  created_lgtm_images_bucket_name = "${local.env}-${local.name}-created-lgtm-images"
}

variable "main_domain_name" {
  type    = string
  default = "lgtmeow.com"
}

data "aws_route53_zone" "main_host_zone" {
  name = var.main_domain_name
}
