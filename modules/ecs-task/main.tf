resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.app_name}-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn
  container_definitions    = jsonencode([
    {
      name      = "${var.app_name}-api-container"  # Ensure this matches the container name in the ECS service
      image     = "${var.repository_url}:latest"
      essential = true
      cpu       = 1024
      memory    = 2048
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "${var.cloudwatch.name}"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "${var.app_name}-log-stream"
        }
      }
    }
  ])
  tags = var.tags
}