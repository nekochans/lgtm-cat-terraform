variable "lambda_function_name" {
  type = string
}

variable "lambda_invoke_arn" {
  type = string
}

variable "lambda_arn" {
  type = string
}

variable "api_gateway_name" {
  type = string
}

variable "auto_deploy" {
  type = bool
}

variable "api_gateway_domain_name" {
  type = string
}
variable "certificate_arn" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "bff_authorizer_name" {
  type = string
}

variable "bff_authorizer_issuer_url" {
  type = string
}

variable "bff_authorizer_audience" {
  type = string
}
