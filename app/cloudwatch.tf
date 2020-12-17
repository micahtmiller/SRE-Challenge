resource "aws_cloudwatch_log_group" "cw_log_group" {
  name              = "/ecs/DynamicEnablement"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "cw_log_stream" {
  name           = "DynamicEnablement-log-stream"
  log_group_name = aws_cloudwatch_log_group.cw_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "alarm_for_high_cpu" {
  alarm_name          = "cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "90"

  dimensions = {
    ClusterName = aws_ecs_cluster.service_cluster.name
    ServiceName = aws_ecs_service.service_ecs.name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "alarm_for_low_cpu" {
  alarm_name          = "cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = aws_ecs_cluster.service_cluster.name
    ServiceName = aws_ecs_service.service_ecs.name
  }

  alarm_actions = [aws_appautoscaling_policy.scale_down.arn]
}