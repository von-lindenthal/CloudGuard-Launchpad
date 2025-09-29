terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  tags = {
    Project     = var.project_name
    Environment = "prod"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/${var.project_name}"
  retention_in_days = var.log_retention_in_days

  tags = merge(local.tags, {
    Service = "ecs"
  })
}

module "network" {
  source               = "./modules/network"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source                        = "./modules/security"
  project_name                  = var.project_name
  vpc_id                        = module.network.vpc_id
  alb_access_cidrs              = var.alb_access_cidrs
  app_port                      = var.app_port
  database_port                 = var.database_config.port
  ecs_task_role_policies        = var.ecs_task_role_policies
  ecs_task_execution_role_policies = var.ecs_task_execution_role_policies
}

module "data" {
  source             = "./modules/data"
  project_name       = var.project_name
  database_config    = var.database_config
  vpc_id             = module.network.vpc_id
  private_subnets    = module.network.private_subnet_ids
  security_group_ids = [module.security.data_security_group_id]
}

module "app" {
  source                = "./modules/app"
  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  private_subnets       = module.network.private_subnet_ids
  public_subnets        = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  app_security_group_id = module.security.app_security_group_id
  task_role_arn         = module.security.task_role_arn
  execution_role_arn    = module.security.execution_role_arn
  container_image       = var.container_image
  desired_count         = var.desired_count
  cpu                   = var.cpu
  memory                = var.memory
  health_check_path     = var.health_check_path
  database_config       = merge(var.database_config, {
    endpoint = module.data.rds_endpoint
  })
  alb_certificate_arn   = var.alb_certificate_arn
  aws_region            = var.aws_region
  log_group_name        = aws_cloudwatch_log_group.app.name
  app_port              = var.app_port
}

module "observability" {
  source                  = "./modules/observability"
  project_name            = var.project_name
  aws_region              = var.aws_region
  alert_email             = var.alert_email
  log_group_name          = aws_cloudwatch_log_group.app.name
  alb_arn_suffix          = module.app.alb_arn_suffix
  target_group_arn_suffix = module.app.target_group_arn_suffix
  ecs_cluster_name        = module.app.ecs_cluster_name
}

output "alb_dns_name" {
  value       = module.app.alb_dns_name
  description = "DNS address for the application load balancer."
}

output "cloudwatch_dashboard_name" {
  value       = module.observability.dashboard_name
  description = "Name of the CloudWatch dashboard for this stack."
}

output "rds_endpoint" {
  value       = module.data.rds_endpoint
  description = "Database endpoint for application connectivity."
}
