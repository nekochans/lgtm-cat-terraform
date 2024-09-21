data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.env}-${var.service_name}-deploy-service-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/codebuild/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:GetFunctionConfiguration"
    ]
    resources = ["arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}"]
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name   = "deploy-policy"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild.json
}
