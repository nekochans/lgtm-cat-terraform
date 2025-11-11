locals {
  env          = "stg"
  service_name = "lgtm-image-processor"

  log_retention_in_days             = 3
  upload_images_bucket              = "${local.env}-lgtmeow-cat-images"
  judge_image_upload_bucket         = "${local.env}-lgtmeow-cat-images"
  generate_lgtm_image_upload_bucket = "${local.env}-lgtmeow-images"
  vector_index_bucket               = "${local.env}-lgtm-cat-vectors"
  vector_index_name                 = "${local.env}-multimodal-search-index"
  lambda_function_name              = "${local.env}-${local.service_name}"
  s3vectors_region                  = "us-east-1"
  bedrock_region                    = "us-east-1"
  codebuild_log_retention_in_days   = 3
}
