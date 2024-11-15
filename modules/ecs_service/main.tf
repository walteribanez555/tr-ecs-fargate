resource "aws_ecs_service" "service" {
    name = "${var.app_name}-api-service"
    cluster = var.ecs_cluster.id
    task_definition = var.ecs_task_definition_arn
    desired_count = 1
    launch_type = "FARGATE"
    deployment_maximum_percent = 200
    deployment_minimum_healthy_percent = 100

    network_configuration {
      subnets = var.subnets
      security_groups =  [var.security_groups]
      assign_public_ip = true
    }

    load_balancer {
        target_group_arn = var.alb_target_group.arn
        container_name = "${var.app_name}-api-container"
        container_port = 80
    }

    tags = var.tags
    
  
}