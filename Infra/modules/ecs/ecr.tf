# modules/ecs/ecr.tf

resource "aws_ecr_repository" "hello_world" {
  name = var.app_name
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.app_name}-ecr"
  }
}
