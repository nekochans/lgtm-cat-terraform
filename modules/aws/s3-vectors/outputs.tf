output "vector_bucket_name" {
  value = aws_s3vectors_vector_bucket.main.vector_bucket_name
}

output "vector_index_name" {
  value = aws_s3vectors_index.main.index_name
}
