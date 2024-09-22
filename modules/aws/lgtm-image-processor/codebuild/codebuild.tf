resource "aws_codebuild_project" "codebuild" {
  name          = "${var.env}-${var.service_name}-deploy"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild.arn

  environment {
    compute_type                = "BUILD_LAMBDA_1GB"
    type                        = "ARM_LAMBDA_CONTAINER"
    image                       = "aws/codebuild/amazonlinux-aarch64-lambda-standard:python3.12"
    image_pull_credentials_type = "CODEBUILD"
  }

  # リポジトリで設定するので何もしない
  source {
    type      = "NO_SOURCE"
    buildspec = <<BUILDSPEC
version: 0.2
BUILDSPEC
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = "/aws/codebuild/${var.env}-${var.service_name}-deploy"
    }
  }
}

resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "${var.env}-${var.service_name}-deploy"
  retention_in_days = var.log_retention_in_days
}
