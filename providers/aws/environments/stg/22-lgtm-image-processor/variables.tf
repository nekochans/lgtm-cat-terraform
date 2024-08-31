locals {
  env          = "stg"
  service_name = "lgtm-image-processor"

  ecr_name              = "${local.env}-${local.service_name}"
  lambda_function_name  = "${local.env}-${local.service_name}"
  lambda_iam_role_name  = "${local.env}-${local.service_name}-lambda-role"
  log_retention_in_days = 3

  stepfunctions_name            = "${local.env}-${local.service_name}-invoke"
  stepfunctions_iam_role_name   = "${local.env}-stepfunctions-${local.service_name}-lambda-invoke-role"
  stepfunctions_iam_policy_name = "${local.env}-stepfunctions-${local.service_name}-lambda-invoke-policy"

  eventbridge_rule_name       = "${local.env}-${local.service_name}-rule"
  eventbridge_rule_target_id  = "${local.env}-${local.service_name}-stepfunctions-invoke"
  eventbridge_iam_role_name   = "${local.env}-eventbridge-${local.service_name}-invoke-stepfunctions-role"
  eventbridge_iam_policy_name = "${local.env}-eventbridge-${local.service_name}-invoke-stepfunctions-policy"
  upload_images_bucket        = "${local.env}-lgtmeow-cat-images"

  judge_image_upload_bucket         = "${local.env}-lgtmeow-cat-images"
  generate_lgtm_image_upload_bucket = "${local.env}-lgtmeow-created-lgtm-images"
  convert_to_webp_upload_bucket     = "${local.env}-lgtmeow-images"
}
