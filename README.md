# Lab 4 — AWS Infrastructure as Code & Cloud Security

**Organisation:** SkynetAI-Labs  
**Project:** DevSecOps Lab 4  
**Technologies:** AWS, Terraform, Checkov, Amazon S3, Amazon EventBridge

## Project Overview

This project demonstrates the design and security assessment of AWS infrastructure using Terraform and Infrastructure as Code (IaC).

The lab focuses on secure S3 storage, access logging, event notifications, automated security scanning, remediation and risk management.

**Deployment Status:** Deployed in eu-north-1, verified using AWS APIs, then destroyed after testing.

## Architecture

The Terraform configuration defines:

- Primary S3 bucket for secure storage
- Dedicated S3 bucket for access logs
- Public access blocking on both buckets
- AES-256 server-side encryption
- S3 object versioning
- Lifecycle management and automated cleanup
- S3 server access logging
- Amazon EventBridge event notifications
- Checkov infrastructure security scanning

## Security Controls

| Security Control | Implementation |
|---|---|
| Public access | S3 Block Public Access |
| Encryption | SSE-S3 AES-256 |
| Versioning | Enabled on both buckets |
| Access logging | Dedicated S3 logging bucket |
| Log expiration | 30 days |
| Previous log versions | 7-day expiration |
| Incomplete uploads | 7-day cleanup |
| Event notifications | Amazon EventBridge |
| Security scanning | Checkov |

AWS API checks verified the deployed configuration. Log delivery and EventBridge event delivery were not tested.

## Security Assessment

**Tool:** Checkov 3.3.30

| Result | Checks |
|---|---:|
| Passed | 41 |
| Failed | 4 |
| Skipped | 0 |
| Pass rate | 91.1% |

### Remaining Findings

- CKV_AWS_145: KMS encryption (2 findings)
- CKV_AWS_144: Cross-region replication (2 findings)

Both S3 buckets use SSE-S3 encryption rather than KMS.

Cross-region replication is not configured because this is a non-production learning environment.

The remaining findings are documented as proposed risk-based exceptions rather than hidden or suppressed.

See [Security Risk Assessment](docs/SECURITY_RISK_ASSESSMENT.md).

## Security Evidence

The following reports document the security assessment and remediation process:

- [Baseline Scan](docs/evidence/checkov-baseline.txt)
- [Lifecycle Configuration Scan](docs/evidence/checkov-after-lifecycle.txt)
- [Access Logging Scan](docs/evidence/checkov-after-logging.txt)
- [Lifecycle Remediation Scan](docs/evidence/checkov-after-lifecycle-remediation.txt)
- [Event Notification Scan](docs/evidence/checkov-after-event-notifications.txt)

## Project Structure

- `terraform/s3.tf` — Primary S3 storage and security controls
- `terraform/logging.tf` — Access logging and retention
- `terraform/notifications.tf` — EventBridge integration
- `terraform/providers.tf` — AWS provider configuration
- `terraform/versions.tf` — Terraform provider requirements
- `terraform/variables.tf` — Configuration variables
- `docs/` — Security assessment and scan evidence

## Local Validation

Run the following commands from the repository root:

    terraform -chdir=terraform init
    terraform -chdir=terraform fmt -check
    terraform -chdir=terraform validate
    checkov -d terraform --framework terraform --compact

These commands validate and scan the infrastructure configuration without deploying AWS resources.

## Deployment Status


Terraform created 15 resources in eu-north-1. AWS API checks verified the configuration, the post-deployment plan showed no changes, and all 15 resources were destroyed.

## Skills Demonstrated

- Terraform Infrastructure as Code
- AWS cloud security configuration
- S3 encryption and access controls
- Security logging and lifecycle management
- Event-driven architecture
- Automated security scanning with Checkov
- Vulnerability remediation
- Risk-based security assessment
- Technical documentation and evidence management

---

**SkynetAI-Labs | DevSecOps Engineering Portfolio**

## AWS Deployment Evidence

- [AWS configuration checks](docs/evidence/aws-runtime-verification.txt)
- [No-drift plan](docs/evidence/terraform-post-deploy-plan.txt)
- [Successful teardown](docs/evidence/terraform-destroy.txt)

### Budget email verification

The separate $1 monthly budget remains. Email alerts are inactive because verification is blocked by the managed notifications-contacts restriction. An AWS Support case is pending.
