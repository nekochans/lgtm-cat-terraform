module "ecs_stop_scheduler" {
  source = "../../../../../modules/aws/ecs-stop-scheduler"

  env         = local.env
  ecs_targets = local.ecs_targets
}
