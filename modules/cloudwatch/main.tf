resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "/ecs/${var.app_name}"
  retention_in_days = 30
  tags = var.tags
  
}