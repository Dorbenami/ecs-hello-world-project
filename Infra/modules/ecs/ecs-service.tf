# modules/ecs/ecs-service.tf

resource "aws_ecs_task_definition" "hello_world" {
  family                   = "${var.app_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = var.app_name
      image = var.container_image

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ],

      healthCheck = {
        command     = ["CMD-SHELL", "wget -q -O /dev/null http://localhost:80/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = {
    Name = "${var.app_name}-task"
  }
}

resource "aws_ecs_service" "hello_world" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hello_world.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.app_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  tags = {
    Name = "${var.app_name}-service"
  }
}
