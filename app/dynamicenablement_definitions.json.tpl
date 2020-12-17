[
  {
    "name": "DynamicEnablement",
    "image": "${url_to_container_image}",
    "cpu": ${allocated_cpu_to_fargate},
    "memory": ${allocated_memory_to_fargate},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/DynamicEnablement",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${port_number_to_run_the_container},
        "hostPort": ${port_number_to_run_the_container}
      }
    ]
  }
]