output "resource_id" {
  description = "Application Auto Scaling ECS service resource ID."
  value       = aws_appautoscaling_target.ecs_service.resource_id
}

output "min_capacity" {
  description = "Minimum ECS task count."
  value       = aws_appautoscaling_target.ecs_service.min_capacity
}

output "max_capacity" {
  description = "Maximum ECS task count."
  value       = aws_appautoscaling_target.ecs_service.max_capacity
}

output "cpu_policy_arn" {
  description = "CPU target tracking policy ARN."
  value       = aws_appautoscaling_policy.cpu.arn
}

output "memory_policy_arn" {
  description = "Memory target tracking policy ARN."
  value       = aws_appautoscaling_policy.memory.arn
}