variable "env" {
  type = string
}

variable "ecs_targets" {
  type = list(object({ cluster : string, service : string }))
}
