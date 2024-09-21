variable "env" {
  type = string
}
variable "service_name" {
  type = string
}
variable "lambda_function_name" {
  type = string
}
variable "log_retention_in_days" {
  type = number
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
