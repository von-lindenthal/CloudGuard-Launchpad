## Cyber Security Project

Secure, cloud-native starter kit for deploying a containerized web app on AWS with a defense-in-depth focus. Includes Terraform infrastructure, sample Flask API, GitHub Actions CI/CD, and documentation covering security controls and future hardening work.

### Project Highlights
- AWS reference architecture with VPC, public and private subnets, ALB, ECS Fargate, RDS, CloudWatch, CloudTrail, and security guardrails.
- DevSecOps pipeline featuring linting, testing, SAST (Bandit), SCA (pip-audit), container scanning (Trivy), and infrastructure policy checks (tfsec, checkov).
- Containerized Flask baseline app showcasing health endpoint, protected sample API route, and AWS integration placeholders.
- Documentation summarizing frameworks (ISO 27001, NIST CSF, CIS), operations runbook, and backlog of future improvements.

### Repository Layout
- `app/` - Flask sample API, Dockerfile, unit tests, and runtime configuration.
- `cicd/` - Shared GitHub Actions workflow templates and pipeline scripts.
- `docs/` - Architecture notes, threat model, operations checklist, and future enhancement log.
- `infrastructure/` - Terraform configuration for AWS networking, security controls, ECS services, and supporting resources.

### Quick Start
1. **Prerequisites**
   - Terraform >= 1.5, AWS CLI configured with permissions to create VPC, ECS, RDS, IAM.
   - Docker, Python 3.11, and Make (or PowerShell equivalents) for local testing.
2. **Bootstrap Infrastructure**
   ```bash
   cd infrastructure
   terraform init
   terraform plan -out tfplan
   terraform apply tfplan
   ```
3. **Build & Test Application**
   ```bash
   cd app
   python -m venv .venv
   .venv\\Scripts\\activate
   pip install -r requirements.txt -r requirements-dev.txt
   pytest
   docker build -t cyber-sec-app:local .
   ```
4. **Run CI Locally (Optional)**
   ```bash
   act --workflows cicd/workflows/ci.yml
   ```
5. **Deploy** - Push to `main` triggers GitHub Actions workflow that runs security gates, builds the image, and deploys via Terraform Cloud and ECS.

### Security & Compliance Mapping
- **Prevent** - Least-privilege IAM, security groups, parameterized secrets, TLS, WAF integration hook.
- **Detect** - CloudTrail, GuardDuty ready, CloudWatch alarms, centralized logging.
- **Respond** - Runbooks in `docs/operations.md`, incident response checklists, contact escalation tree.

### Future Improvements
- Replace sample API with production workload and integrate AWS Cognito and WAF.
- Add automated evidence collection for ISO 27001 and NIST CSF controls.
- Extend CI/CD with IaC drift detection and supply chain attestations (Sigstore).
- Implement centralized secrets management via AWS Secrets Manager rotation policies.

Refer to `docs/` for detailed diagrams, threat models, and deployment notes inspired by "The Ultimate Beginner Cloud Project" reference diagram.
