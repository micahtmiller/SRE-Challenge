resource "aws_alb" "load_balancer" {
  name            = "DynamicEnablement-lb"
  subnets         = aws_subnet.public_subnet.*.id
  security_groups = [aws_security_group.sg_for_lb.id]
}

resource "aws_alb_target_group" "target_group" {
  name        = "DynamicEnablement-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "lb_listener" {
  load_balancer_arn = aws_alb.load_balancer.id
  port              = var.port_number_to_run_the_container
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group.id
    type             = "forward"
  }
}

