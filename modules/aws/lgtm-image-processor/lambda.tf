resource "aws_lambda_function" "lgtm_image_processor" {
  function_name = var.lambda_function_name
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lgtm_image_processor.repository_url}:latest"
  role          = aws_iam_role.lambda.arn

  architectures = ["arm64"]
  memory_size   = 128
  timeout       = 30

  lifecycle {
    ignore_changes = [
      last_modified,
      image_uri,
      version,
    ]
  }
}
