module "lgtm_image_processor" {
  source = "../../../../../modules/aws/lgtm-image-processor"

  ecr_name                      = local.ecr_name
  lambda_function_name          = local.lambda_function_name
  lambda_iam_role_name          = local.lambda_iam_role_name
  log_retention_in_days         = local.log_retention_in_days
  stepfunctions_name            = local.stepfunctions_name
  stepfunctions_iam_policy_name = local.stepfunctions_iam_policy_name
  stepfunctions_iam_role_name   = local.stepfunctions_iam_role_name
  eventbridge_rule_name         = local.eventbridge_rule_name
  eventbridge_rule_target_id    = local.eventbridge_rule_target_id
  eventbridge_iam_role_name     = local.eventbridge_iam_role_name
  eventbridge_iam_policy_name   = local.eventbridge_iam_policy_name
  upload_images_bucket          = local.upload_images_bucket

  judge_image_upload_bucket         = local.judge_image_upload_bucket
  generate_lgtm_image_upload_bucket = local.generate_lgtm_image_upload_bucket
  convert_to_webp_upload_bucket     = local.convert_to_webp_upload_bucket
}
