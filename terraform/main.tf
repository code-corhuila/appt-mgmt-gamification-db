terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  identifier = "${var.name}-${var.environment}"
}

resource "aws_db_subnet_group" "gamification" {
  name       = local.identifier
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = local.identifier
    Environment = var.environment
  }
}

resource "aws_security_group" "gamification" {
  name_prefix = "${local.identifier}-"
  description = "Private PostgreSQL access for Salud Activa gamification"
  vpc_id      = var.vpc_id
  ingress     = []
  egress      = []

  tags = {
    Name        = local.identifier
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "application" {
  for_each = var.application_security_group_ids

  security_group_id            = aws_security_group.gamification.id
  referenced_security_group_id = each.value
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "PostgreSQL from application security group"
}

resource "aws_db_instance" "gamification" {
  identifier                  = local.identifier
  engine                      = "postgres"
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.allocated_storage
  storage_type                = "gp3"
  storage_encrypted           = true
  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  port                        = 5432
  db_subnet_group_name        = aws_db_subnet_group.gamification.name
  vpc_security_group_ids      = [aws_security_group.gamification.id]
  publicly_accessible         = false
  multi_az                    = var.multi_az
  backup_retention_period     = 7
  auto_minor_version_upgrade = true
  deletion_protection         = var.deletion_protection
  skip_final_snapshot         = false
  final_snapshot_identifier   = "${local.identifier}-final"

  tags = {
    Name        = local.identifier
    Environment = var.environment
  }
}
