variable "env" {
  type = string
}

variable "ecr_name" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "lambda_iam_role_name" {
  type = string
}

variable "log_retention_in_days" {
  type = number
}

variable "stepfunctions_name" {
  type = string
}

variable "stepfunctions_iam_role_name" {
  type = string
}

variable "stepfunctions_iam_policy_name" {
  type = string
}

variable "eventbridge_rule_name" {
  type = string
}

variable "eventbridge_rule_target_id" {
  type = string
}

variable "upload_images_bucket" {
  type = string
}

variable "eventbridge_iam_role_name" {
  type = string
}

variable "eventbridge_iam_policy_name" {
  type = string
}

variable "judge_image_upload_bucket" {
  type = string
}

variable "generate_lgtm_image_upload_bucket" {
  type = string
}

variable "convert_to_webp_upload_bucket" {
  type = string
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret" "secret" {
  name = "/${var.env}/lgtm-cat"
}

data "aws_secretsmanager_secret_version" "secret" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}
