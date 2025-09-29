variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "app_security_group_id" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "container_image" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "health_check_path" {
  type = string
}

variable "database_config" {
  type = object({
    engine                = string
    engine_version        = string
    instance_class        = string
    allocated_storage     = number
    username              = string
    password_ssm_param    = string
    port                  = number
    multi_az              = bool
    backup_retention_days = number
    endpoint              = string
  })
}

variable "alb_certificate_arn" {
  type    = string
  default = ""
}

variable "aws_region" {
  type = string
}

variable "log_group_name" {
  type = string
}
