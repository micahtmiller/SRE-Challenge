resource "aws_appautoscaling_target" "container_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.service_cluster.name}/${aws_ecs_service.service_ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 2
  max_capacity       = 4
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "DynamicEnablement_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.service_cluster.name}/${aws_ecs_service.service_ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.container_target]
}

resource "aws_appautoscaling_policy" "scale_down" {
  name               = "DynamicEnablement_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.service_cluster.name}/${aws_ecs_service.service_ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.container_target]
}