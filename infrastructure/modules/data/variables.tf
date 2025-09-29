variable "project_name" {
  type = string
}

variable "database_config" {
  type = object({
    engine               = string
    engine_version       = string
    instance_class       = string
    allocated_storage    = number
    username             = string
    password_ssm_param   = string
    multi_az             = bool
    backup_retention_days = number
  })
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}
