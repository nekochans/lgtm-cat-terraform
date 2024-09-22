locals {
  env          = "stg"
  service_name = "lgtm-image-processor"

  log_retention_in_days             = 3
  upload_images_bucket              = "${local.env}-lgtmeow-cat-images"
  judge_image_upload_bucket         = "${local.env}-lgtmeow-cat-images"
  generate_lgtm_image_upload_bucket = "${local.env}-lgtmeow-images"
  lambda_function_name              = "${local.env}-${local.service_name}"
  codebuild_log_retention_in_days   = 3
}
