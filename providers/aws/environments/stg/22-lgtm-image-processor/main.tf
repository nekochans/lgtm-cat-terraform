module "lgtm_image_processor" {
  source = "../../../../../modules/aws/lgtm-image-processor"

  env                               = local.env
  service_name                      = local.service_name
  log_retention_in_days             = local.log_retention_in_days
  upload_images_bucket              = local.upload_images_bucket
  judge_image_upload_bucket         = local.judge_image_upload_bucket
  generate_lgtm_image_upload_bucket = local.generate_lgtm_image_upload_bucket
  convert_to_webp_upload_bucket     = local.convert_to_webp_upload_bucket
}
