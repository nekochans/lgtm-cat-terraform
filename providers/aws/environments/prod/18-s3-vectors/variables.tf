locals {
  env                = "prod"
  vector_bucket_name = "${local.env}-lgtm-cat-vectors"
  vector_index_name  = "${local.env}-multimodal-search-index"
  data_type          = "float32"
  dimension          = 1536
  distance_metric    = "cosine"
}
