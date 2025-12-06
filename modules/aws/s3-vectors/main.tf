resource "aws_s3vectors_vector_bucket" "main" {
  vector_bucket_name = var.vector_bucket_name
  force_destroy      = var.force_destroy
}

resource "aws_s3vectors_index" "main" {
  index_name         = var.vector_index_name
  vector_bucket_name = aws_s3vectors_vector_bucket.main.vector_bucket_name

  data_type       = var.data_type
  dimension       = var.dimension
  distance_metric = var.distance_metric
}
