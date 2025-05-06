# modules/ecs/monitoring.tf

# SNS Topic for alarm notifications
resource "aws_sns_topic" "ecs_alarms" {
  name = "${var.app_name}-alarms"
}

# Email subscription for the SNS topic
resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.ecs_alarms.arn
  protocol  = "email"
  endpoint  = var.alert_email # Add this variable to your variables.tf
}

# Task errors alarm
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
  alarm_actions       = [aws_sns_topic.ecs_alarms.arn]
  ok_actions          = [aws_sns_topic.ecs_alarms.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.hello_world.name
  }

  tags = {
    Name = "${var.app_name}-task-errors"
  }
}

# High CPU alarm
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
  alarm_actions       = [aws_sns_topic.ecs_alarms.arn]
  ok_actions          = [aws_sns_topic.ecs_alarms.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.hello_world.name
  }

  tags = {
    Name = "${var.app_name}-high-cpu"
  }
}

# High memory alarm
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
  alarm_actions       = [aws_sns_topic.ecs_alarms.arn]
  ok_actions          = [aws_sns_topic.ecs_alarms.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.main.name
    ServiceName = aws_ecs_service.hello_world.name
  }

  tags = {
    Name = "${var.app_name}-high-memory"
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "${var.app_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.main.name, "ServiceName", aws_ecs_service.hello_world.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region # Make sure this variable is defined in your module
          title  = "CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.main.name, "ServiceName", aws_ecs_service.hello_world.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "Errors", "ClusterName", aws_ecs_cluster.main.name, "ServiceName", aws_ecs_service.hello_world.name]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "Task Errors"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "RunningTaskCount", "ClusterName", aws_ecs_cluster.main.name, "ServiceName", aws_ecs_service.hello_world.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Running Tasks"
        }
      }
    ]
  })
}