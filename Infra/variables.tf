variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
  default     = "ecs-hello-world"
}

variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner name for resource tagging"
  type        = string
  default     = "Dor Ben Ami"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "azs" {
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "cluster_name" {
  type        = string
  description = "ECS cluster name"
  default     = "hello-world-cluster" # Optional default
}

variable "app_name" {
  type        = string
  description = "App name"
  default     = "hello-world"
}

variable "container_port" {
  type    = number
  default = 80
}

variable "alert_email" {
  default = "benami.dordor@gmail.com"
}