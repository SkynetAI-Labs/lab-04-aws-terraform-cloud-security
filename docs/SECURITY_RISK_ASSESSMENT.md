# Lab 4 — Security Risk Assessment

Project: AWS Infrastructure as Code & Cloud Security
Organisation: SkynetAI-Labs
Assessment date: 20 October 2026
Environment: Terraform configuration and temporary AWS deployment
Deployment status: Subsequently deployed in eu-north-1, verified using AWS APIs, and destroyed after testing. All 15 Terraform-managed resources were removed.

## Security Scan Results

- Tool: Checkov 3.3.30
- Passed: 41
- Failed: 4
- Skipped: 0

## Finding 1 — CKV_AWS_145: KMS Encryption

Affected resources:
- aws_s3_bucket.secure_lab
- aws_s3_bucket.access_logs

Current protection:
Both buckets are configured with SSE-S3 (AES256).

Risk:
SSE-S3 provides encryption at rest but does not offer
the same customer-controlled key management, access
policies and auditing capabilities as SSE-KMS.

Decision:
Proposed risk acceptance for this non-production lab.

Justification:
No sensitive or production data is intended.
Additional KMS configuration and potential charges
are not justified for the current learning objectives.

Future remediation:
Evaluate SSE-KMS for production deployments requiring
customer-managed key controls.

## Finding 2 — CKV_AWS_144: Cross-Region Replication

Affected resources:
- aws_s3_bucket.secure_lab
- aws_s3_bucket.access_logs

Current protection:
S3 versioning is configured for both buckets.

Risk:
Versioning does not protect against regional outages.
Without replication, regional disaster recovery is limited.

Decision:
Proposed risk acceptance for this non-production lab.

Justification:
The lab uses fictional data and has no production
availability or disaster recovery requirements.
Cross-region replication introduces additional
storage and transfer costs.

Future remediation:
Define recovery objectives and evaluate cross-region
replication if production requirements justify it.

## Review Conditions

Reassess these decisions before:
- Deploying production workloads
- Storing sensitive or regulated information
- Introducing customer data
- Establishing disaster recovery requirements

## Evidence

See docs/evidence/ for baseline and remediation scans.

These findings remain visible in Checkov.
They have not been suppressed or marked as passed.
