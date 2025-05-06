# modules/ecs/variables.tf

variable "app_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "cluster_name" {
  type = string
}


variable "vpc_id" {
  description = "The VPC ID to deploy ECS resources into"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "app_security_group_id" {
  type        = string
  description = "Security group ID for ECS tasks"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group ID for the ALB"
}

variable "container_image" {
  type        = string
  description = "Full container image URI in ECR"
}

variable "alert_email" {
  description = "Email address to receive CloudWatch alarm notifications"
  type        = string
  default     = "benami.dordor@gmail.com"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
}