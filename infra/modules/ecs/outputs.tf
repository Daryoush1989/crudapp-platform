output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.this.name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN."
  value       = aws_ecs_cluster.this.arn
}

output "api_service_name" {
  description = "ECS API service name."
  value       = aws_ecs_service.api.name
}

output "api_service_arn" {
  description = "ECS API service ARN."
  value       = aws_ecs_service.api.id
}

output "api_task_definition_arn" {
  description = "API task definition ARN."
  value       = aws_ecs_task_definition.api.arn
}

output "api_log_group_name" {
  description = "CloudWatch log group name for the API container."
  value       = aws_cloudwatch_log_group.api.name
}

output "api_container_name" {
  description = "API container name."
  value       = local.api_container_name
}

output "api_container_image" {
  description = "Full API container image."
  value       = local.api_container_image
}

output "task_execution_role_arn" {
  description = "ECS task execution role ARN."
  value       = aws_iam_role.task_execution.arn
}

output "task_role_arn" {
  description = "ECS task role ARN."
  value       = aws_iam_role.task.arn
}