#ecs cluster
resource "aws_ecs_cluster" "churn_cluster" {
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT",
  ]
  name = "churn-application-cluster"
  tags = local.tags


  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  depends_on = [
    aws_lb_listener.churn_connection,
  ]
}  
  

# ecs services
resource "aws_ecs_service" "churn_service" {
  cluster                            = aws_ecs_cluster.churn_cluster.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  desired_count                      = 2
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  health_check_grace_period_seconds  = 0
  #iam_role                           = local.ecs_service_role
  launch_type                        = "FARGATE"
  name                               = "churn-service"
  platform_version                   = "LATEST"
  scheduling_strategy                = "REPLICA"
  tags                               = {}
  tags_all                           = {}
  task_definition                    = format("%s:%s", aws_ecs_task_definition.churn_definition.family, aws_ecs_task_definition.churn_definition.revision)

# network_configuration must be configured in FarGate Mode!!!!!
  network_configuration {
    security_groups    = [aws_security_group.allow_ecs.id]
    subnets            = aws_subnet.public_subnet.*.id       # edited private to public to avoid fargate-resourceinitializationerror-unable-to-pull-secrets-or-registry
    assign_public_ip = true
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "churn-application-container"
    container_port   = 5000
    target_group_arn = aws_lb_target_group.churn_target_group.arn
  }
}



# aws_ecs_task_definition.
resource "aws_ecs_task_definition" "churn_definition" {
  container_definitions = jsonencode(
    [
      {
        cpu         = 0
        environment = []
        essential   = true
        image       = format("%s%s", aws_ecr_repository.churn_repo.repository_url, ":latest")
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-create-group  = "true"     # create logs group 
            awslogs-group         = "/churn_cluster/churn_service"
            awslogs-region        = "us-east-1"
            awslogs-stream-prefix = "churn_cluster"
          }
        }
        memoryReservation = 128
        mountPoints       = []
        name              = "churn-application-container"
        portMappings = [
          {
            containerPort = 5000
            hostPort      = 5000
            protocol      = "tcp"
          },
        ]
        volumesFrom = []
      },
    ]
  )
  
  cpu                = 1024
  execution_role_arn = local.ecs_task_role
  family             = "churn-application"
  memory             = 4096
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags          = local.tags
  task_role_arn = local.ecs_task_role
  depends_on = [
    aws_ecs_cluster.churn_cluster,
  ]
}


resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = var.ecs_image_ami
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.allow_ecs.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.churn_cluster.name} >> /etc/ecs/ecs.config"
  instance_type        = "t2.medium"
  #auto assign public IP 
}
