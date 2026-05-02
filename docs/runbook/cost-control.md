# crudapp-platform Cost Control Notes

This staging environment is production-style and includes billable AWS resources.

## Main Cost Drivers

- Amazon RDS PostgreSQL
- Amazon ECS Fargate
- Application Load Balancer
- VPC Interface Endpoints
- AWS WAF
- AWS Backup
- CloudWatch Logs, dashboards, and alarms
- Route 53 hosted zone and DNS queries
- Amazon ECR image storage
- S3 storage for Terraform state and ALB logs

## Lowest-Risk Pause Option

To reduce ECS compute cost, scale the ECS service to 0 only when the app does not need to run:

aws ecs update-service `
  --cluster cloud-dash-crudapp-platform-staging-ecs-cluster `
  --service cloud-dash-crudapp-platform-staging-api-service `
  --desired-count 0 `
  --region eu-west-2

Important: this stops the running ECS task, so the public application will stop responding successfully.

This does not stop all costs. RDS, ALB, VPC endpoints, WAF, AWS Backup, Route 53, ECR, S3, and CloudWatch can still generate charges.

## Full Cost Stop

To stop nearly all project costs, destroy the environment carefully in reverse order:

1. Destroy staging infrastructure.
2. Confirm RDS, ECS, ALB, WAF, VPC endpoints, Route 53 records, CloudWatch alarms, and AWS Backup resources are gone.
3. Destroy bootstrap resources only after staging is destroyed.
4. Remove remaining ECR images and S3 objects only when intentionally cleaning up.

Do not destroy the bootstrap stack first because staging Terraform state depends on the S3 state bucket.
