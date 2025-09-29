# Security Controls & Runbooks

## Control Matrix
| Domain | Control | Implementation |
| --- | --- | --- |
| Identity & Access | IAM least privilege | Dedicated ECS task/execution roles with optional policy attachments. |
| Network Segmentation | Tiered security groups | ALB, app, database, and bastion security groups scoped to required ports. |
| Data Protection | Encrypted secrets | DB password sourced from SSM Parameter Store (`password_ssm_param`). |
| Vulnerability Mgmt | CI scanning | Bandit, pip-audit, Trivy, tfsec, checkov executed in GitHub Actions. |
| Monitoring | CloudWatch alarms & dashboard | Alarms for ALB 5xx, ECS CPU, AWS Logs ingestion; dashboard consolidates metrics. |
| Incident Response | Runbooks | See below for triage/escalation/resolution guidance. |

## Incident Response Playbooks
1. **ALB 5xx Spike**
   - Check ALB metrics/dashboards for request surge.
   - Review ECS task logs via CloudWatch; capture failing request IDs.
   - If app issue: rollback via previous container tag; if infra issue: run `terraform apply` to reconcile.
2. **ECS CPU Saturation**
   - Inspect service autoscaling (manual) by adjusting `desired_count` and redeploy.
   - Check for runaway requests; consider throttling at ALB or enabling WAF.
3. **Database Connectivity Failure**
   - Validate security group ingress from ECS tasks; confirm RDS endpoint output.
   - Use bastion host (if provisioned) for psql test; rotate credentials via SSM parameter if compromised.

## Maintenance Checklist
- Quarterly patch Docker base image; ensure image scanning is passing.
- Run `terraform plan` weekly to spot drift; enable remote state backend for collaboration.
- Rotate IAM access keys and SSM parameters per policy (recommend <=90 days).
- Review CloudWatch alarm history monthly; adjust thresholds to minimize noise.
