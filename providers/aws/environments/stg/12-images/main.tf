module "images" {
  source                          = "../../../../../modules/aws/images"
  lgtm_images_bucket_name         = local.lgtm_images_bucket_name
  lgtm_images_cdn_sub_domain      = local.lgtm_images_cdn_sub_domain
  lgtm_images_cdn_domain          = local.lgtm_images_cdn_domain
  lgtm_images_cdn_acm_arn         = local.lgtm_images_cdn_acm_arn
  main_host_zone                  = data.aws_route53_zone.main_host_zone.zone_id
  upload_images_bucket_name       = local.upload_images_bucket_name
  cat_images_bucket_name          = local.cat_images_bucket_name
  created_lgtm_images_bucket_name = local.created_lgtm_images_bucket_name
}
