data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

locals {
  cluster_name        = "${var.name_prefix}-${var.environment}-ecs-cluster"
  service_name        = "${var.name_prefix}-${var.environment}-api-service"
  task_family         = "${var.name_prefix}-${var.environment}-api"
  log_group_name      = "/ecs/${var.name_prefix}/${var.environment}/api"
  api_container_name  = "api"
  api_container_image = "${var.ecr_repository_url}:${var.api_image_tag}"
}

resource "aws_cloudwatch_log_group" "api" {
  name              = local.log_group_name
  retention_in_days = var.api_log_retention_days

  tags = merge(var.tags, {
    Name = local.log_group_name
    Tier = "private-app"
  })
}

resource "aws_ecs_cluster" "this" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = merge(var.tags, {
    Name = local.cluster_name
    Tier = "private-app"
  })
}

resource "aws_iam_role" "task_execution" {
  name               = "${var.name_prefix}-${var.environment}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-ecs-execution-role"
  })
}

resource "aws_iam_role_policy_attachment" "task_execution_managed" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "task_execution_secrets" {
  statement {
    sid    = "AllowReadDatabaseSecret"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      var.db_master_user_secret_arn
    ]
  }
}

resource "aws_iam_policy" "task_execution_secrets" {
  name        = "${var.name_prefix}-${var.environment}-ecs-execution-secrets-policy"
  description = "Allow ECS task execution role to read the RDS managed secret."
  policy      = data.aws_iam_policy_document.task_execution_secrets.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-ecs-execution-secrets-policy"
  })
}

resource "aws_iam_role_policy_attachment" "task_execution_secrets" {
  role       = aws_iam_role.task_execution.name
  policy_arn = aws_iam_policy.task_execution_secrets.arn
}

resource "aws_iam_role" "task" {
  name               = "${var.name_prefix}-${var.environment}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-ecs-task-role"
  })
}

resource "aws_ecs_task_definition" "api" {
  family                   = local.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = tostring(var.api_cpu)
  memory                   = tostring(var.api_memory)
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = local.api_container_name
      image     = local.api_container_image
      essential = true

      portMappings = [
        {
          containerPort = var.api_container_port
          hostPort      = var.api_container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "APP_ENV"
          value = var.environment
        },
        {
          name  = "AWS_REGION"
          value = var.aws_region
        },
        {
          name  = "LOG_LEVEL"
          value = "INFO"
        },
        {
          name  = "DB_HOST"
          value = var.db_host
        },
        {
          name  = "DB_PORT"
          value = tostring(var.db_port)
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_SSLMODE"
          value = "require"
        }
      ]

      secrets = [
        {
          name      = "DB_USER"
          valueFrom = "${var.db_master_user_secret_arn}:username::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.db_master_user_secret_arn}:password::"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.api.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "api"
        }
      }

      healthCheck = {
        command = [
          "CMD-SHELL",
          "python -c \"import urllib.request; urllib.request.urlopen('http://127.0.0.1:${var.api_container_port}/health/live', timeout=3)\""
        ]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = merge(var.tags, {
    Name = local.task_family
    Tier = "private-app"
  })
}

resource "aws_ecs_service" "api" {
  name            = local.service_name
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = var.api_desired_count

  launch_type      = "FARGATE"
  platform_version = var.fargate_platform_version

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"
  enable_execute_command  = false

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.private_app_subnet_ids
    security_groups  = [var.app_security_group_id]
    assign_public_ip = false
  }

  tags = merge(var.tags, {
    Name = local.service_name
    Tier = "private-app"
  })

  depends_on = [
    aws_iam_role_policy_attachment.task_execution_managed,
    aws_iam_role_policy_attachment.task_execution_secrets,
    aws_cloudwatch_log_group.api
  ]
}