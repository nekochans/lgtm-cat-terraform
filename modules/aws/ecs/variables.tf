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
variable "ecs_task_cpu" {
  type = number
}
variable "ecs_task_memory" {
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
variable "lgtm_images_cdn_domain" {
  type = string
}

data "aws_region" "current" {}
