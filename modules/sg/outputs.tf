output "ecs_sg" {
    value = aws_security_group.ecs_sg
}

output "ecs_alb_sg" {
    value = aws_security_group.alb_sg
}