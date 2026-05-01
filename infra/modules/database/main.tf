locals {
  db_identifier = "${var.name_prefix}-${var.environment}-postgres"
  log_group     = "/aws/rds/instance/${local.db_identifier}/postgresql"
}

resource "aws_db_subnet_group" "this" {
  name        = "${local.db_identifier}-subnet-group"
  description = "Private data subnet group for ${local.db_identifier}"
  subnet_ids  = var.private_data_subnet_ids

  tags = merge(var.tags, {
    Name = "${local.db_identifier}-subnet-group"
    Tier = "private-data"
  })
}

resource "aws_db_parameter_group" "this" {
  name        = "${local.db_identifier}-pg"
  description = "Parameter group for ${local.db_identifier}"
  family      = var.parameter_group_family

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  tags = merge(var.tags, {
    Name = "${local.db_identifier}-pg"
  })
}

resource "aws_cloudwatch_log_group" "postgresql" {
  name              = local.log_group
  retention_in_days = var.cloudwatch_log_retention_days

  tags = merge(var.tags, {
    Name = local.log_group
  })
}

resource "aws_db_instance" "this" {
  identifier = local.db_identifier

  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name  = var.db_name
  username = var.master_username
  port     = 5432

  manage_master_user_password = true

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true
  kms_key_id            = var.kms_key_id

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.db_security_group_id]
  publicly_accessible    = false
  multi_az               = var.multi_az

  parameter_group_name = aws_db_parameter_group.this.name

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  auto_minor_version_upgrade = true
  copy_tags_to_snapshot      = true
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  apply_immediately          = var.apply_immediately

  depends_on = [
    aws_cloudwatch_log_group.postgresql
  ]

  tags = merge(var.tags, {
    Name = local.db_identifier
    Tier = "private-data"
  })
}