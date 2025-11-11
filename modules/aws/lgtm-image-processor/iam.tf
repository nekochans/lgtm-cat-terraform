data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${var.env}-${var.service_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


data "aws_iam_policy_document" "lambda_s3" {
  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${var.upload_images_bucket}",
      "arn:aws:s3:::${var.upload_images_bucket}/*",
      "arn:aws:s3:::${var.judge_image_upload_bucket}",
      "arn:aws:s3:::${var.judge_image_upload_bucket}/*",
      "arn:aws:s3:::${var.generate_lgtm_image_upload_bucket}",
      "arn:aws:s3:::${var.generate_lgtm_image_upload_bucket}/*",
    ]
  }
}

resource "aws_iam_role_policy" "lambda_s3" {
  name   = "${var.env}-${var.service_name}-lambda-s3-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_s3.json
}

data "aws_iam_policy_document" "lambda_rekognition" {
  statement {
    effect    = "Allow"
    actions   = ["rekognition:DetectLabels"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "lambda_rekognition" {
  name   = "${var.env}-${var.service_name}-lambda-rekognition-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_rekognition.json
}

data "aws_iam_policy_document" "lambda_bedrock" {
  statement {
    effect  = "Allow"
    actions = ["bedrock:InvokeModel"]
    resources = [
      "arn:aws:bedrock:${var.bedrock_region}::foundation-model/cohere.embed-v4:0"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_bedrock" {
  name   = "${var.env}-${var.service_name}-lambda-bedrock-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_bedrock.json
}

data "aws_iam_policy_document" "lambda_s3vectors" {
  statement {
    effect  = "Allow"
    actions = ["s3vectors:PutVectors"]
    resources = [
      "arn:aws:s3vectors:${var.s3vectors_region}:${data.aws_caller_identity.current.account_id}:bucket/${var.vector_index_bucket}/index/${var.vector_index_name}"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_s3vectors" {
  name   = "${var.env}-${var.service_name}-lambda-s3vectors-policy"
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_s3vectors.json
}

#StepFunctions
data "aws_iam_policy_document" "step_functions_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "step_functions" {
  name               = "${var.env}-stepfunctions-${var.service_name}-lambda-invoke-role"
  assume_role_policy = data.aws_iam_policy_document.step_functions_assume_role.json
}

resource "aws_iam_policy" "step_functions" {
  name = "${var.env}-stepfunctions-${var.service_name}-lambda-invoke-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
        ],
        "Resource" : "arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction",
        ],
        "Resource" : "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function_name}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "step_functions_policy_attachment" {
  role       = aws_iam_role.step_functions.id
  policy_arn = aws_iam_policy.step_functions.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# EventBridge
resource "aws_iam_role" "eventbridge" {
  name               = "${var.env}-eventbridge-${var.service_name}-invoke-stepfunctions-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "eventbridge" {
  statement {
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = [aws_sfn_state_machine.lgtm_image_processor.arn]
  }
}

resource "aws_iam_policy" "eventbridge" {
  name   = "${var.env}-eventbridge-${var.service_name}-invoke-stepfunctions-policy"
  policy = data.aws_iam_policy_document.eventbridge.json
}

resource "aws_iam_role_policy_attachment" "eventbridge" {
  role       = aws_iam_role.eventbridge.name
  policy_arn = aws_iam_policy.eventbridge.arn
}
