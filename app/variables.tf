variable "aws_region" {
  description = "AWS Region to deploy the container"
  default     = "us-east-1"
}

variable "allocated_cpu_to_fargate" {
  description = "compute power units to allocate to fargate"
  default     = "1024"
}

variable "allocated_memory_to_fargate" {
  description = "memory units to allocate to fargate"
  default     = "2048"
}

variable "number_of_az_to_deploy" {
  description = "Multi AZ count to make it highly available"
  default     = "3"
}

variable "url_to_container_image" {
  description = "Container image to run on the ECS"
  default     = ""
}

variable "port_number_to_run_the_container" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "number_of_containers_to_deploy" {
  description = "Number of ECS to deploy the image to achieve the redundancy"
  default     = 3
}

variable "task_execution_role" {
  description = "ECS task execution role name"
  default = "myEcsTaskExecutionRole"
}

variable "health_check_path" {
  default = "/"
}