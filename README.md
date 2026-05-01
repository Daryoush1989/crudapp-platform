# crudapp-platform

Production-ready FastAPI platform on AWS using:

- FastAPI
- PostgreSQL
- S3
- ECS Fargate
- RDS Proxy
- Terraform
- GitHub Actions

## Environments

- staging
- prod

## Region

- eu-west-2

This is just a starter. We will expand it later.
## Step 4 - AWS bootstrap and ECR

Step 4 adds the first AWS infrastructure foundation for the project:

- Terraform bootstrap layer
- S3 bucket for future Terraform remote state
- S3 native Terraform lockfile configuration for staging and prod
- Private ECR repository for the FastAPI API image
- Immutable image tags
- ECR lifecycle policy
- Docker image pushed and verified from ECR

No ECS, RDS, ALB, NAT Gateway, Route 53 records, or public application deployment is created in Step 4.
