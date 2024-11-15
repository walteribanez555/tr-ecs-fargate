resource "aws_alb" "alb" {
    name = "${var.app_name}-api-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.ecs_alb_sg.id]
    subnets = var.subnets
    tags = var.tags
    enable_deletion_protection = false
    idle_timeout = 60
    enable_http2 = true
    
    

}


resource "aws_alb_target_group" "service_target_group" {
    name = "${var.app_name}-api-tg"
    vpc_id = var.vpc_id
    port = 80
    protocol = "HTTP"
    deregistration_delay = 30
    
    target_type = "ip"

    health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 60
    matcher             =  "200"
    path                =  "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 30

  }

    tags = var.tags

}  

resource "aws_alb_listener" "alb_listener" {
    load_balancer_arn = aws_alb.alb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_alb_target_group.service_target_group.arn
    }
}