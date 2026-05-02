data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  oidc_provider_url = "https://token.actions.githubusercontent.com"
  oidc_subject      = "repo:${var.github_repository}:environment:${var.github_environment}"

  role_name = "${var.name_prefix}-${var.environment}-actions-deploy-role"

  ecr_repository_arn = "arn:${data.aws_partition.current.partition}:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repository_name}"

  ecs_cluster_arn = "arn:${data.aws_partition.current.partition}:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.ecs_cluster_name}"
  ecs_service_arn = "arn:${data.aws_partition.current.partition}:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  ecs_taskdef_arn = "arn:${data.aws_partition.current.partition}:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:task-definition/${var.ecs_task_family}:*"

  ecs_execution_role_arn = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${var.ecs_execution_role_name}"
  ecs_task_role_arn      = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${var.ecs_task_role_name}"

  api_log_group_arn = "arn:${data.aws_partition.current.partition}:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:${var.api_log_group_name}:*"
}

resource "aws_iam_openid_connect_provider" "github" {
  url = local.oidc_provider_url

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-${var.environment}-actions-oidc-provider"
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AllowGitHubActionsOidcAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.oidc_subject]
    }
  }
}

resource "aws_iam_role" "deploy" {
  name                 = local.role_name
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = 3600

  tags = merge(var.tags, {
    Name = local.role_name
    Role = "github-actions-staging-deploy"
  })
}

data "aws_iam_policy_document" "deploy" {
  statement {
    sid    = "AllowEcrAuthorizationToken"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowPushToApiRepository"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = [local.ecr_repository_arn]
  }

  statement {
    sid    = "AllowEcsServiceDeployment"
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]

    resources = [local.ecs_service_arn]
  }

  statement {
    sid    = "AllowEcsTaskDefinitionRegistration"
    effect = "Allow"

    actions = [
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowRunMigrationTask"
    effect = "Allow"

    actions = [
      "ecs:RunTask"
    ]

    resources = [local.ecs_taskdef_arn]

    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"
      values   = [local.ecs_cluster_arn]
    }
  }

  statement {
    sid    = "AllowReadEcsTasks"
    effect = "Allow"

    actions = [
      "ecs:DescribeTasks",
      "ecs:ListTasks"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowPassEcsRolesOnlyToEcsTasks"
    effect = "Allow"

    actions = [
      "iam:PassRole"
    ]

    resources = [
      local.ecs_execution_role_arn,
      local.ecs_task_role_arn
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }

  statement {
    sid    = "AllowReadDeploymentStatus"
    effect = "Allow"

    actions = [
      "ec2:DescribeNetworkInterfaces",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowReadApiLogs"
    effect = "Allow"

    actions = [
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogEvents"
    ]

    resources = [local.api_log_group_arn]
  }
}

resource "aws_iam_policy" "deploy" {
  name        = "${local.role_name}-policy"
  description = "Least-privilege staging deployment policy for crudapp-platform GitHub Actions."
  policy      = data.aws_iam_policy_document.deploy.json

  tags = merge(var.tags, {
    Name = "${local.role_name}-policy"
  })
}

resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.deploy.name
  policy_arn = aws_iam_policy.deploy.arn
}