data "archive_file" "lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/function/lambda.zip"
}

data "aws_region" "current" {}

resource "aws_lambda_function" "api" {
  filename         = data.archive_file.lambda_function.output_path
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_api.arn
  handler          = "lambda"
  runtime          = "go1.x"

  memory_size = 128
  timeout     = 900

  environment {
    variables = {
      REGION                 = data.aws_region.current.name
      UPLOAD_S3_BUCKET_NAME  = var.s3_bucket_name
      LGTM_IMAGES_CDN_DOMAIN = var.lgtm_images_cdn_domain
    }
  }

  lifecycle {
    ignore_changes = [
      last_modified,
      source_code_hash,
      version,
    ]
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.log_retention_in_days
}
