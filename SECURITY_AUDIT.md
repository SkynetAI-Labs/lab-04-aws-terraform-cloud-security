# Repository Security Audit — Lab 04

**Review date:** 24 October 2026  
**Reviewed source commit:** [`2219d30f9ada6091af9881d5970a7debe57f5886`](https://github.com/SkynetAI-Labs/lab-04-aws-terraform-cloud-security/tree/2219d30f9ada6091af9881d5970a7debe57f5886)  
**Scope:** Public repository configuration, documentation, retained evidence and available workflow results. This is a repository audit, not a fresh live-environment assessment or penetration test.

## Outcome
The source and retained evidence support a temporary S3 security lab with a historical deployment and teardown. The recorded Checkov result is **41 passed, 4 failed, 0 skipped**, not a fresh scan of the audit publication commit.

## Evidence checked
- All Terraform source, provider lock file, README and risk assessment.
- Five retained Checkov stages: **11/5/0**, **13/4/0**, **37/8/0**, **39/6/0**, then **41/4/0** (passed/failed/skipped).
- AWS configuration evidence records public-access blocks, AES256 encryption, versioning, access-logging configuration and EventBridge configuration.
- Retained post-deployment plan reports no changes; teardown reports **15 resources destroyed**.
- Log delivery and EventBridge event delivery were not demonstrated. No deployment was repeated.
- Log objects expire after 30 days, with noncurrent log versions expiring after 7 days. Primary data objects have no age-based expiration; their lifecycle rule aborts incomplete multipart uploads after 7 days.
- The four recorded scanner findings are two KMS-encryption and two replication findings. Proposed risk acceptance is not formal approval.

## Recommendations
1. **Priority 1 — Add explicit HTTPS-only bucket-policy enforcement to both buckets.** The reviewed source has no `aws:SecureTransport=false` deny. SSE-S3 encryption at rest does not enforce transport encryption. This manual-review finding is additional to the four historical Checkov failures.
2. **Priority 2 — Add credential-free CI** for Terraform formatting, backend-disabled initialization, validation and pinned-version Checkov scanning. There is no Actions workflow in the reviewed repository.
3. **Priority 2 — Test actual S3 access-log delivery and EventBridge receipt** during a future controlled deployment, with timestamps and sanitized evidence.
4. **Priority 2 — Make lifecycle/logging dependencies explicit** so versioning and destination protections are established before dependent configuration.
5. **Priority 2 — Reassess KMS and replication against actual data/recovery requirements**, recording an owner and review date for any accepted residual risk.
6. **Priority 2 — Recheck the separate budget notification state** in the account. The README's prior support-case status is historical and was not independently verified here.

The README was updated to link evidence directly and clarify historical results, retention and audit limitations. Infrastructure was not changed or deployed.

## Banner and evidence integrity

The README links an existing `skynet-lab-04.png` banner and the asset is present. No replacement was needed in this portfolio-wide pass. Historical evidence was preserved. Recommendations above remain open unless explicitly described as completed.

## References

- [GitHub Actions security guidance](https://docs.github.com/en/actions/reference/security/secure-use)
- [AWS S3 transport-encryption guidance](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryptionInTransit.html)
- [Kubernetes NetworkPolicy semantics](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

