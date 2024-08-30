resource "aws_sfn_state_machine" "lgtm_image_processor" {
  name     = var.stepfunctions_name
  role_arn = aws_iam_role.step_functions.arn

  definition = templatefile("${path.module}/files/step-function.json", {
    lambda_arn = aws_lambda_function.lgtm_image_processor.arn
  })
}
