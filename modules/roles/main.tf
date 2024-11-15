
resource "aws_iam_role" "ecr_execution_role" {
  name = "${var.app_name}-ecr-execution-role"
  //add  polices AmazonECSTaskExecutionRolePolicy and  CloudWatchLogsFullAccess
  assume_role_policy = <<EOF
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                "Effect": "Allow",
                "Principal": {
                    "Service": "ecs-tasks.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
                }
            ]

                }
        EOF

    
}


resource "aws_iam_policy_attachment" "ecs_task_execution_policy_attachment" {
  name       = "${var.app_name}-ecs-task-execution-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecr_execution_role.name]

}

resource "aws_iam_policy_attachment" "cloudwatch_logs_policy_attachment" {
  name       = "${var.app_name}-cloudwatch-logs-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  roles      = [aws_iam_role.ecr_execution_role.name]

}



