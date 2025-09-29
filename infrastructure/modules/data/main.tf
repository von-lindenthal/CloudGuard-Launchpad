resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet"
  subnet_ids = var.private_subnets

  tags = {
    Name    = "${var.project_name}-db-subnet"
    Project = var.project_name
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.project_name}-db"
  engine                  = var.database_config.engine
  engine_version          = var.database_config.engine_version
  instance_class          = var.database_config.instance_class
  allocated_storage       = var.database_config.allocated_storage
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = var.security_group_ids
  username                = var.database_config.username
  password                = data.aws_ssm_parameter.db_password.value
  multi_az                = var.database_config.multi_az
  backup_retention_period = var.database_config.backup_retention_days
  skip_final_snapshot     = false
  deletion_protection     = true
  publicly_accessible     = false

  tags = {
    Name    = "${var.project_name}-db"
    Project = var.project_name
  }
}

data "aws_ssm_parameter" "db_password" {
  name = var.database_config.password_ssm_param
}

output "rds_endpoint" {
  value = aws_db_instance.this.endpoint
}
