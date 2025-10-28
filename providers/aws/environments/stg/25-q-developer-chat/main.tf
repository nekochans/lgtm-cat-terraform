module "ecs_scale" {
  source = "../../../../../modules/aws/q-developver-chat"

  env  = local.env
  name = local.name
}
