locals {
  env          = "stg"
  service_name = "lgtm-image-processor"

  log_retention_in_days             = 3
  upload_images_bucket              = "${local.env}-lgtmeow-cat-images"
  judge_image_upload_bucket         = "${local.env}-lgtmeow-cat-images"
  generate_lgtm_image_upload_bucket = "${local.env}-lgtmeow-created-lgtm-images"
  convert_to_webp_upload_bucket     = "${local.env}-lgtmeow-images"
}
