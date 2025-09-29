# Architecture Overview

This project mirrors the "Ultimate Beginner Cloud Project" blueprint using AWS managed services and defense-in-depth defaults.

## Network & Infrastructure
- Dedicated VPC with public and private subnets across multiple AZs.
- Internet Gateway plus per-AZ NAT Gateways; private routing for workloads, public routing for ingress.
- Security groups scoped for ALB ingress, ECS service east-west traffic, database isolation, and bastion access.
- Terraform modules provision VPC, ECS Fargate, Application Load Balancer, RDS Postgres, CloudWatch dashboards, and IAM roles.

## Application Deployment
- Containerized Flask API providing `/health`, `/ready`, and `/api/v1/echo` endpoints.
- Deploys to ECS Fargate with encrypted environment secrets from SSM Parameter Store and CloudWatch logging enabled.
- ALB enforces HTTPS (when ACM cert supplied) and redirects HTTP → HTTPS; blue/green ready via `force-new-deployment`.

## Data & Observability
- RDS Postgres with multi-AZ toggle, managed backups, and IAM-auth friendly configuration.
- CloudTrail/GuardDuty ready through AWS account-level services; CloudWatch alarms for ALB 5xx and ECS CPU.
- Dashboard surfaces ALB request counts, ECS utilization, and log ingestion trends.

## Security & Compliance Alignment
- **Prevent:** Least-privilege IAM roles, security group micro-segmentation, encrypted secrets, Terraform tagging.
- **Detect:** CloudWatch alarms, SNS alert fan-out, container scanning (Trivy), IaC scanning (tfsec/checkov).
- **Respond:** Runbooks in `docs/operations.md` guide alert triage, escalation, and rollback.

See `docs/security-controls.md` and `docs/operations.md` for deeper process guidance.
