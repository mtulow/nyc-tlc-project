# alb.tf | Load Balancer Configuration

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# ========= #
# Resources #
# ========= #

# Load Balancer
resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-${var.app_env}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${var.app_name}-${var.app_env}-alb"
    Environment = var.app_environment
  }
}
# Security Group
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.mage_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32",
                   "192.92.207.50/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32",
                   "192.92.207.50/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.app_name}-${var.app_env}-sg"
    Environment = var.app_environment
  }
}
# Target Group
resource "aws_lb_target_group" "target_group" {
  name        = "${var.app_name}-${var.app_env}-tg"
  port        = 6789
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.mage_vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "5"
    path                = "/api/status"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.app_name}-lb-tg"
    Environment = var.app_environment
  }
}
# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}
