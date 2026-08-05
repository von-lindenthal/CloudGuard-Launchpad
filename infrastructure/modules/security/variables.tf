variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_access_cidrs" {
  type = list(string)
}

variable "bastion_access_cidrs" {
  type    = list(string)
  default = []
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "database_port" {
  type    = number
  default = 5432
}

variable "ecs_task_role_policies" {
  type    = list(string)
  default = []
}

variable "ecs_task_execution_role_policies" {
  type    = list(string)
  default = []
}
