data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_stop_scheduler" {
  count = var.env != "prod" ? 1 : 0

  name               = "${var.env}-ecs-stop-scheduler-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


data "aws_iam_policy_document" "ecs_stop_scheduler" {
  statement {
    effect    = "Allow"
    actions   = ["ecs:UpdateService"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecs_stop_scheduler" {
  count = var.env != "prod" ? 1 : 0

  name   = "${var.env}-ecs-stop-scheduler-role-policy"
  role   = aws_iam_role.ecs_stop_scheduler[count.index].id
  policy = data.aws_iam_policy_document.ecs_stop_scheduler.json
}
