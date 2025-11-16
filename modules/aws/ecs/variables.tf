variable "env" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_public_ids" {
  type = list(string)
}
variable "certificate_arn" {
  type = string
}
variable "ecs_domain_name" {
  type = string
}
variable "zone_id" {
  type = string
}
variable "name" {
  type = string
}
variable "enable_container_insights" {
  type = bool
}
variable "log_retention_in_days" {
  type = number
}
variable "ecs_service_desired_count" {
  type = number
}
variable "upload_images_bucket_name" {
  type = string
}
variable "db_hostname" {
  type = string
}
variable "db_password" {
  type = string
}
variable "db_username" {
  type = string
}
variable "db_name" {
  type = string
}
variable "sentry_dsn" {
  type = string
}
variable "cognito_user_pool_id" {
  type = string
}
variable "cognito_app_client_id" {
  type = string
}
variable "image_allowed_domain" {
  type = string
}
variable "bedrock_region" {
  type = string
}
variable "s3vectors_region" {
  type = string
}
variable "vector_index_bucket" {
  type = string
}
variable "vector_index_name" {
  type = string
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
