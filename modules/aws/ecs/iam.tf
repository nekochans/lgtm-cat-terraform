data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ssm_for_ecs_task_execution_role" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ssm_for_ecs_task_execution_role" {
  name   = "${var.env}-ssm-for-ecs-task-execution-role"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.ssm_for_ecs_task_execution_role.json
}

data "aws_iam_policy_document" "ecs_task_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "${var.name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role.json
}

data "aws_iam_policy_document" "task_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["s3:*", ]
    resources = [
      "arn:aws:s3:::${var.upload_images_bucket_name}",
      "arn:aws:s3:::${var.upload_images_bucket_name}/*"
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task" {
  name   = "${var.name}-ecs-task-role-policy"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.task_role_policy.json
}

data "aws_iam_policy_document" "bedrock_task_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["bedrock:InvokeModel"]
    resources = [
      "arn:aws:bedrock:${var.bedrock_region}::foundation-model/cohere.embed-v4:0"
    ]
  }
}

resource "aws_iam_role_policy" "bedrock_ecs_task" {
  name   = "${var.name}-bedrock-ecs-task-role-policy"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.bedrock_task_role_policy.json
}

data "aws_iam_policy_document" "s3vectors_task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3vectors:GetVectors",
      "s3vectors:QueryVectors"
    ]
    resources = [
      "arn:aws:s3vectors:${var.s3vectors_region}:${data.aws_caller_identity.current.account_id}:bucket/${var.vector_index_bucket}/index/${var.vector_index_name}"
    ]
  }
}

resource "aws_iam_role_policy" "s3vectors_ecs_task" {
  name   = "${var.name}-s3vectors-ecs-task-role-policy"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.s3vectors_task_role_policy.json
}

data "aws_iam_policy_document" "rekognition_task_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "rekognition:DetectFaces",
      "rekognition:DetectLabels",
      "rekognition:DetectModerationLabels"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "rekognition_ecs_task" {
  name   = "${var.name}-rekognition-ecs-task-role-policy"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.rekognition_task_role_policy.json
}
