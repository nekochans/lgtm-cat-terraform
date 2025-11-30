variable "user_pool_name" {
  type = string
}

variable "user_pool_domain_name" {
  type = string
}

variable "email_identity_arn" {
  type = string
}

variable "lgtm_cat_api_resource_server_name" {
  type = string
}

variable "lgtm_cat_api_resource_server_identifier" {
  type = string
}

variable "lgtm_cat_image_recognition_api_resource_server_name" {
  type = string
}

variable "lgtm_cat_image_recognition_api_resource_server_identifier" {
  type = string
}

variable "lgtm_cat_bff_client_name" {
  type = string
}

data "aws_region" "current" {}
