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

## Step 5 - Staging VPC network foundation

Step 5 adds the first deployable AWS network foundation for the staging environment:

- Dedicated staging VPC
- Two public subnets across two Availability Zones
- Two private app subnets across two Availability Zones
- Two private data subnets across two Availability Zones
- Internet Gateway for the public subnet tier
- Separate route tables for public, private app, and private data tiers
- S3 Gateway VPC Endpoint for private S3 access
- Security groups for future ALB, ECS app, RDS database, and interface VPC endpoints

This step intentionally avoids ECS, RDS, ALB, NAT Gateway, Route 53, and ACM to keep cost low while building the production-style foundation.
