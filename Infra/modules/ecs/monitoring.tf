# modules/ecs/monitoring.tf

resource "aws_cloudwatch_metric_alarm" "ecs_task_errors" {
  alarm_name          = "${var.app_name}-task-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "ECS/ContainerInsights"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Alert on ECS task errors"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.hello_world.name
  }

  tags = {
    Name = "${var.app_name}-task-errors"
  }
}


resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.app_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "High CPU utilization in ECS service"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.hello_world.name
  }

  tags = {
    Name = "${var.app_name}-high-cpu"
  }
}


resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name          = "${var.app_name}-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "High memory utilization in ECS service"

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.hello_world.name
  }

  tags = {
    Name = "${var.app_name}-high-memory"
  }
}
