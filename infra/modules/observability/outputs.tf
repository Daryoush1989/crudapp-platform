
output "dashboard_name" {
  description = "CloudWatch dashboard name."
  value       = aws_cloudwatch_dashboard.ops.dashboard_name
}

output "sns_topic_arn" {
  description = "SNS alert topic ARN. Empty when email alerting is disabled."
  value       = try(aws_sns_topic.alerts[0].arn, "")
}

output "alarm_names" {
  description = "CloudWatch alarm names created by this module."
  value = [
    aws_cloudwatch_metric_alarm.alb_unhealthy_targets.alarm_name,
    aws_cloudwatch_metric_alarm.alb_target_5xx.alarm_name,
    aws_cloudwatch_metric_alarm.alb_response_time.alarm_name,
    aws_cloudwatch_metric_alarm.ecs_cpu_high.alarm_name,
    aws_cloudwatch_metric_alarm.ecs_memory_high.alarm_name,
    aws_cloudwatch_metric_alarm.rds_cpu_high.alarm_name,
    aws_cloudwatch_metric_alarm.rds_free_storage_low.alarm_name,
    aws_cloudwatch_metric_alarm.api_error_logs.alarm_name
  ]
}

output "api_error_metric_name" {
  description = "Custom CloudWatch metric name for API error logs."
  value       = aws_cloudwatch_log_metric_filter.api_errors.metric_transformation[0].name
}
