variable "rds_name" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "cluster_availability_zones" {
  type = list(string)
}

variable "instance_availability_zones" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "parameter_group_family" {
  type = string
}

variable "app_username" {
  type = string
}
variable "app_password" {
  type = string
}
variable "proxy_engine" {
  type = string
}

variable "stg_lambda_securitygroup_id" {
  type = string
}