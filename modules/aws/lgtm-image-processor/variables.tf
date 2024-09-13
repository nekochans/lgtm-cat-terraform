variable "env" {
  type = string
}

variable "service_name" {
  type = string
}

variable "log_retention_in_days" {
  type = number
}

variable "upload_images_bucket" {
  type = string
}

variable "judge_image_upload_bucket" {
  type = string
}

variable "generate_lgtm_image_upload_bucket" {
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

locals {
  lambda_function_name = "${var.env}-${var.service_name}"
}
