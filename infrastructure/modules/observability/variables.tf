variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "alert_email" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}
