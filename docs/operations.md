# Operations Runbook

## Daily Checks
- Review GitHub Actions runs for latest commits; ensure security scans pass.
- Monitor CloudWatch dashboard (`${project}-dashboard`) for anomalies.
- Confirm SNS alert email inbox is monitored; test subscription monthly.

## Deployment Procedure
1. Create feature branch, implement changes, push PR.
2. GitHub Actions executes lint/tests/scans; remediate any failures.
3. On merge to `main`, CI builds image, scans, applies Terraform, and updates ECS service.
4. Validate deployment via ALB DNS health (`/ready` endpoint) and CloudWatch logs.

## Rollback Procedure
- Trigger `terraform apply` with previous state version if infrastructure change caused regression.
- To roll back app-only change:
  - Retrieve prior image digest from ECR.
  - Run `aws ecs update-service --force-new-deployment --cluster <cluster> --service <service> --deployment-configuration "maximumPercent=200,minimumHealthyPercent=100" --task-definition <previous-task-def>`.

## Access Management
- AWS access provided via SSO/role assumption; developers use `aws-vault` or `aws sso login`.
- ECS task roles limited to required AWS APIs; additional permissions must be approved by security.

## Backup & Recovery
- RDS automated backups enabled, retention default 7 days (configurable).
- To restore, use `aws rds restore-db-instance-to-point-in-time` and update `database_config` endpoint.
- Ensure restored instance security groups match production.

## Logging & Auditing
- Application logs forwarded to CloudWatch log group `/aws/ecs/<project>`.
- CloudTrail and GuardDuty recommended at account-level (enable via AWS Organizations). Evidence gathered for compliance reporting.

## Future Automation Ideas
- Integrate AWS Config / Security Hub for continuous compliance.
- Add scheduled Lambda to rotate SSM parameters and trigger RDS password updates.
- Implement Terraform Cloud remote backend with Sentinel policies for change approvals.
