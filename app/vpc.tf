data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = "172.17.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "route_to_internet" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private_route" {
  count  = var.number_of_az_to_deploy
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gw.*.id, count.index)
  }
}

resource "aws_route_table_association" "private_route_association" {
  count          = var.number_of_az_to_deploy
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route.*.id, count.index)
}

resource "aws_eip" "eip" {
  count      = var.number_of_az_to_deploy
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.number_of_az_to_deploy
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
}

resource "aws_subnet" "private_subnet" {
  count             = var.number_of_az_to_deploy
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "public_subnet" {
  count                   = var.number_of_az_to_deploy
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, var.number_of_az_to_deploy + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

resource "aws_security_group" "sg_for_lb" {
  name        = "DynamicEnablement-lb"
  description = "For restricting traffic to the load balancers only"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.port_number_to_run_the_container
    to_port     = var.port_number_to_run_the_container
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_for_ecs_tasks" {
  name        = "DynamicEnablement-ecs"
  description = "For allowing traffic from the load balancers only"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol        = "tcp"
    from_port       = var.port_number_to_run_the_container
    to_port         = var.port_number_to_run_the_container
    security_groups = [aws_security_group.sg_for_lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

