# crudapp-platform Final Operations Runbook

## Environment

- Project: crudapp-platform
- Environment: staging
- Region: eu-west-2
- Public URL: https://staging.awsclouddash.click

## Daily Health Checks

Run:

Invoke-RestMethod -Uri "https://staging.awsclouddash.click/health/live" -Method Get
Invoke-RestMethod -Uri "https://staging.awsclouddash.click/health/ready" -Method Get

Expected result:

- /health/live returns status ok.
- /health/ready returns status ok and database ok.

## Architecture Summary

Public traffic enters through Route 53, ACM, AWS WAF, and the public Application Load Balancer.

The ALB forwards traffic to private ECS Fargate tasks running in private app subnets.

The ECS tasks connect privately to Amazon RDS PostgreSQL in private data subnets.

The database is not publicly accessible.

## Deployment

Deployments are handled by GitHub Actions using OIDC.

No long-lived AWS access keys are stored in GitHub.

## Monitoring

Monitoring includes CloudWatch dashboards, CloudWatch alarms, SNS email alerts, ECS service metrics, ALB target health, RDS metrics, and API error log metric filters.

## Security

Security controls include private ECS tasks with no public IP, private RDS PostgreSQL, HTTPS-only public access, HTTP to HTTPS redirect, AWS WAF, Secrets Manager, IAM roles, and GitHub Actions OIDC.

## Resilience

Resilience controls include ECS service autoscaling, ALB health checks, AWS Backup for RDS, RDS automated backups, CloudWatch alarms, and SNS alerts.

## Terraform Safety Rule

When running Terraform for staging, preserve the alert email:

terraform -chdir=infra/envs/staging plan `
  -var="api_image_tag=IMAGE_TAG" `
  -var="api_desired_count=1" `
  -var="alert_email=daryoushwaheed@hotmail.com" `
  -out=tfplan

Do not apply any plan that unexpectedly destroys or replaces core infrastructure.
