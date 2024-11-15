

resource "aws_security_group" "ecs_sg" {
    vpc_id = var.vpc_id
    name = "${var.app_name}-ecs-security-group"
    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = var.tags
  
}

resource "aws_security_group" "alb_sg" {
    vpc_id = var.vpc_id
    name = "${var.app_name}-alb-security-group"
    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }
  
}