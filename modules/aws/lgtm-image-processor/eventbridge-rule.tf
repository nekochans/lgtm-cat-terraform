resource "aws_cloudwatch_event_rule" "lgtm_image_processor" {
  name = var.eventbridge_rule_name
  event_pattern = jsonencode({
    "source" : [
      "aws.s3"
    ],
    "detail-type" : [
      "Object Created"
    ],
    "detail" : {
      "bucket" : {
        "name" : [
          var.upload_images_bucket
        ]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "step_functions" {
  rule      = aws_cloudwatch_event_rule.lgtm_image_processor.name
  target_id = var.eventbridge_rule_target_id
  arn       = aws_sfn_state_machine.lgtm_image_processor.arn
  role_arn  = aws_iam_role.eventbridge.arn
}
