locals {
  env = "stg"
  ecs_targets = [
    { cluster = "${local.env}-lgtm-cat-api", service = "${local.env}-lgtm-cat-api" },
  ]
}
