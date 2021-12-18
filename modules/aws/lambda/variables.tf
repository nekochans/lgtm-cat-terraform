variable "lambda_function_name" {
  type = string
}

variable "lambda_api_iam_role_name" {
  type = string
}

variable "lambda_api_iam_policy_name" {
  type = string
}

variable "log_retention_in_days" {
  type = number
}

variable "s3_bucket_name" {
  type = string
}

variable "lgtm_images_cdn_domain" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
