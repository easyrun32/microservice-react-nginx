#ecs cluster creation
module "ecs_cluster" {
  source  = "infrablocks/ecs-cluster/aws"
  version = "3.4.0"

  region     = "us-east-1"
  vpc_id     = aws_default_vpc.default.id
  subnet_ids = [aws_default_subnet.default_us-east-1a.id, aws_default_subnet.default_us-east-1b.id]

  component             = "micro"
  deployment_identifier = "react-nginx"

  cluster_name                         = "cluster"
  cluster_instance_ssh_public_key_path = "./terraform.pub"
  cluster_instance_type                = "t2.micro"

  cluster_minimum_size     = 0
  cluster_maximum_size     = 2
  cluster_desired_capacity = 2
  security_groups          = [aws_security_group.sg.id]
}




#TASK DEFINITION FOR USERS FOR DEFINING THE SPECS OF AN EC2 INSTANCE 
resource "aws_ecs_task_definition" "users-td" {
  family = "${var.my-project-name}-users-td"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 0,
   


    "portMappings": [
        {
          "hostPort": 0,
          "protocol": "tcp",
          "containerPort": 5000
        }
      ],




    "essential": true,
    "image": "${var.docker-username}/${var.my-project-name}-users:prod",
    "memory": null,
    "memoryReservation": 128,
    "name": "users"
  }
]
DEFINITION
}



#TASK DEFINITION FOR CLIENT FOR DEFINING THE SPECS OF AN EC2 INSTANCE
resource "aws_ecs_task_definition" "client-td" {
  family = "${var.my-project-name}-client-td"

  container_definitions = <<DEFINITION
[
  {
    "cpu": 0,
    "environment": [{
      "name": "REACT_APP_SECRETME",
      "value": "EXAMPLE"
    }
    ],


    "portMappings": [
        {
          "hostPort": 0,
          "protocol": "tcp",
          "containerPort": 80
        }
      ],




    "essential": true,
    "image": "${var.docker-username}/${var.my-project-name}-client:prod",
    "memory": null,
    "memoryReservation": 128,
    "name": "client"
  }
]
DEFINITION
}



# FOR USERS SERVICE
resource "aws_ecs_service" "users-service" {
  name            = "${var.my-project-name}-users-service"
  cluster         = "${var.my-project-name}-cluster"
  task_definition = aws_ecs_task_definition.users-td.arn
  desired_count   = 1



  load_balancer {
    target_group_arn = aws_lb_target_group.users.arn
    container_name   = "users"
    container_port   = 5000
  }


}


# FOR CLIENT SERVICE
resource "aws_ecs_service" "client-service" {
  name            = "${var.my-project-name}-client-service"
  cluster         = "${var.my-project-name}-cluster"
  task_definition = aws_ecs_task_definition.client-td.arn
  desired_count   = 1


  load_balancer {
    target_group_arn = aws_lb_target_group.client.arn
    container_name   = "client"
    container_port   = 80
  }


}