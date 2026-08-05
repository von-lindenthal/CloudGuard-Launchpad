variable "project_name" {
  description = "Prefix used for resource naming."
  type        = string
}

variable "aws_region" {
  description = "AWS region for deployment."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional AWS CLI profile to use. Leave blank to use default credentials chain."
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default     = [
    "10.0.0.0/24",
    "10.0.1.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default     = [
    "10.0.10.0/24",
    "10.0.11.0/24"
  ]
}

variable "alb_access_cidrs" {
  description = "CIDR blocks allowed to access the Application Load Balancer."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "bastion_access_cidrs" {
  description = "CIDR blocks allowed SSH access to the bastion host. Empty by default to avoid exposing SSH publicly."
  type        = list(string)
  default     = []
}

variable "alb_certificate_arn" {
  description = "ACM certificate ARN for enabling HTTPS on the load balancer. Leave blank to disable HTTPS."
  type        = string
  default     = ""
}

variable "container_image" {
  description = "Container image to deploy for the application."
  type        = string
  default     = "public.ecr.aws/docker/library/nginx:latest"
}

variable "desired_count" {
  description = "Number of desired ECS tasks."
  type        = number
  default     = 1
}

variable "cpu" {
  description = "CPU units for the ECS task definition."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (MiB) for the ECS task definition."
  type        = number
  default     = 512
}

variable "app_port" {
  description = "Container port exposed by the application."
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Health check path for the load balancer target group."
  type        = string
  default     = "/health"
}

variable "database_config" {
  description = "Map of database configuration values."
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
  })
  default = {
    engine                = "postgres"
    engine_version        = "15"
    instance_class        = "db.t3.micro"
    allocated_storage     = 20
    username              = "appuser"
    password_ssm_param    = "/cyber-sec-project/db/password"
    port                  = 5432
    multi_az              = false
    backup_retention_days = 7
  }
}

variable "ecs_task_role_policies" {
  description = "Additional IAM policy ARNs to attach to the ECS task role."
  type        = list(string)
  default     = []
}

variable "ecs_task_execution_role_policies" {
  description = "Additional IAM policy ARNs to attach to the ECS execution role."
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention period for the application log group."
  type        = number
  default     = 30
}

variable "alert_email" {
  description = "Email address for CloudWatch alarms."
  type        = string
  default     = "alerts@example.com"
}
