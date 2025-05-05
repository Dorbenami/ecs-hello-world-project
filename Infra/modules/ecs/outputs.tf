# modules/ecs/outputs.tf

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.hello_world.name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.hello_world.arn
} 

output "repository_url" {
  value = aws_ecr_repository.hello_world.repository_url
}

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "app_sg_id" {
  value = aws_security_group.ecs_service.id
}
