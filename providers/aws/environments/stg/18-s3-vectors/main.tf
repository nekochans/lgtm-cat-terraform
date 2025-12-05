module "s3_vectors" {
  source = "../../../../../modules/aws/s3-vectors"

  vector_bucket_name = local.vector_bucket_name
  vector_index_name  = local.vector_index_name
  data_type          = local.data_type
  dimension          = local.dimension
  distance_metric    = local.distance_metric
  force_destroy      = false
}
