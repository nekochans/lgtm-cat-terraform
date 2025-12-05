variable "vector_bucket_name" {
  type = string
}

variable "vector_index_name" {
  type = string
}

variable "data_type" {
  type    = string
  default = "float32"
}

variable "dimension" {
  type    = number
  default = 1536
}

variable "distance_metric" {
  type    = string
  default = "cosine"
}

variable "force_destroy" {
  type    = bool
  default = false
}
