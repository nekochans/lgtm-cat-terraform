variable "main_host_zone" {
  type = string
}

variable "main_domain_name" {
  type = string
}

variable "txt_records" {
  type = list(string)

  default = []
}
