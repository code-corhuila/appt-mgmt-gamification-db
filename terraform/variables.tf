variable "aws_region" {
  description = "AWS region for the database."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "environment must be dev, qa, or prod."
  }
}

variable "name" {
  description = "Prefix used for database resources."
  type        = string
  default     = "salud-activa-gamification"
}

variable "vpc_id" {
  description = "ID of the VPC hosting the application."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs in at least two availability zones."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnet IDs are required."
  }
}

variable "application_security_group_ids" {
  description = "Security groups allowed to connect to PostgreSQL."
  type        = set(string)

  validation {
    condition     = length(var.application_security_group_ids) > 0
    error_message = "At least one application security group is required."
  }
}

variable "engine_version" {
  description = "PostgreSQL version available in the selected AWS region."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20
    error_message = "allocated_storage must be at least 20 GiB."
  }
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "gamification"
}

variable "db_username" {
  description = "Initial PostgreSQL administrator username."
  type        = string
  default     = "gamification_admin"
}

variable "db_password" {
  description = "Initial PostgreSQL administrator password."
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Whether to deploy a standby in another availability zone."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Protect the database from accidental deletion."
  type        = bool
  default     = true
}
