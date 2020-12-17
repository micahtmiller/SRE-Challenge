resource "aws_ecs_cluster" "service_cluster" {
  name = "DynamicEnablement"
}

data "template_file" "template_for_container" {
  template = file("dynamicenablement_definitions.json.tpl")

  vars = {
    url_to_container_image           = var.url_to_container_image
    port_number_to_run_the_container = var.port_number_to_run_the_container
    allocated_cpu_to_fargate         = var.allocated_cpu_to_fargate
    allocated_memory_to_fargate      = var.allocated_memory_to_fargate
    aws_region                       = var.aws_region
  }
}

resource "aws_ecs_task_definition" "service_task_definition" {
  family                   = "DynamicEnablement-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.allocated_cpu_to_fargate
  memory                   = var.allocated_memory_to_fargate
  container_definitions    = data.template_file.template_for_container.rendered
}

resource "aws_ecs_service" "service_ecs" {
  name            = "DynamicEnablement-service"
  cluster         = aws_ecs_cluster.service_cluster.id
  task_definition = aws_ecs_task_definition.service_task_definition.arn
  desired_count   = var.number_of_containers_to_deploy
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.sg_for_ecs_tasks.id]
    subnets          = aws_subnet.private_subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.id
    container_name   = "DynamicEnablement"
    container_port   = var.port_number_to_run_the_container
  }

  depends_on = [aws_alb_listener.lb_listener, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
