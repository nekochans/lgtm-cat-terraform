resource "aws_iam_user" "serverless_deploy_user" {
  name          = var.serverless_deploy_user_name
  force_destroy = true
}

resource "aws_iam_policy" "serverless_deploy_policy" {
  name        = "${var.serverless_deploy_user_name}-policy"
  description = "${var.serverless_deploy_user_name}-policy"
  policy      = file("${path.module}/files/policy/serverless-deploy-policy.json")
}

resource "aws_iam_user_policy_attachment" "serverless_deploy_policy_attach" {
  user       = aws_iam_user.serverless_deploy_user.name
  policy_arn = aws_iam_policy.serverless_deploy_policy.arn
}
