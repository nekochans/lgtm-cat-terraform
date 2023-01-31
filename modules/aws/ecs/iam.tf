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
