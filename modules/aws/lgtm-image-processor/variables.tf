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

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
