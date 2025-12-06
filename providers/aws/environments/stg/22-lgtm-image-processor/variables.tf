locals {
  env          = "stg"
  service_name = "lgtm-image-processor"

  log_retention_in_days             = 3
  upload_images_bucket              = "${local.env}-lgtmeow-upload-images"
  judge_image_upload_bucket         = "${local.env}-lgtmeow-cat-images"
  generate_lgtm_image_upload_bucket = "${local.env}-lgtmeow-images"
  lambda_function_name              = "${local.env}-${local.service_name}"
  s3vectors_region                  = "ap-northeast-1"
  bedrock_region                    = "ap-northeast-1"
  codebuild_log_retention_in_days   = 3

  judge_image_api_url    = "https://stg-api.lgtmeow.com"
  cognito_client_id      = data.terraform_remote_state.cognito.outputs.cognito_app_client_id
  cognito_client_secret  = data.terraform_remote_state.cognito.outputs.cognito_client_secret
  cognito_token_endpoint = data.terraform_remote_state.cognito.outputs.cognito_token_endpoint
}
