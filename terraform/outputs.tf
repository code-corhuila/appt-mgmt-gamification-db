output "database_endpoint" {
  description = "Private PostgreSQL endpoint."
  value       = aws_db_instance.gamification.address
}

output "database_port" {
  description = "PostgreSQL port."
  value       = aws_db_instance.gamification.port
}

output "database_security_group_id" {
  description = "Security group attached to the database."
  value       = aws_security_group.gamification.id
}
