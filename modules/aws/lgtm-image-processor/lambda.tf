resource "aws_lambda_function" "lgtm_image_processor" {
  function_name = var.lambda_function_name
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lgtm_image_processor.repository_url}:latest"
  role          = aws_iam_role.lambda.arn

  architectures = ["arm64"]
  memory_size   = 128
  timeout       = 30

  environment {
    variables = {
      JUDGE_IMAGE_UPLOAD_BUCKET         = var.judge_image_upload_bucket
      GENERATE_LGTM_IMAGE_UPLOAD_BUCKET = var.generate_lgtm_image_upload_bucket
      CONVERT_TO_WEBP_UPLOAD_BUCKET     = var.convert_to_webp_upload_bucket
    }
  }

  lifecycle {
    ignore_changes = [
      last_modified,
      image_uri,
      version,
    ]
  }
}
