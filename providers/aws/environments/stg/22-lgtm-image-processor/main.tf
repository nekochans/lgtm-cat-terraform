module "lgtm_image_processor" {
  source = "../../../../../modules/aws/lgtm-image-processor"

  env                               = local.env
  service_name                      = local.service_name
  log_retention_in_days             = local.log_retention_in_days
  upload_images_bucket              = local.upload_images_bucket
  judge_image_upload_bucket         = local.judge_image_upload_bucket
  generate_lgtm_image_upload_bucket = local.generate_lgtm_image_upload_bucket
  vector_index_bucket               = local.vector_index_bucket
  vector_index_name                 = local.vector_index_name
  s3vectors_region                  = local.s3vectors_region
  bedrock_region                    = local.bedrock_region
  lambda_function_name              = local.lambda_function_name
  judge_image_api_url               = local.judge_image_api_url
  cognito_client_id                 = local.cognito_client_id
  cognito_client_secret             = local.cognito_client_secret
  cognito_token_endpoint            = local.cognito_token_endpoint
}

module "codebuild" {
  source = "../../../../../modules/aws/lgtm-image-processor/codebuild"

  env                   = local.env
  service_name          = local.service_name
  lambda_function_name  = local.lambda_function_name
  log_retention_in_days = local.codebuild_log_retention_in_days
}
