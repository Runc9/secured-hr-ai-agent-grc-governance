CONTROL\_ACCEPTANCE\_CRITERIA.md

Technical Enforcement Requirements for the Secured HR AI Agent

Overview



This document contains the developer-facing enforcement rules required to satisfy governance for the Secured HR AI Agent.

Each acceptance criterion maps directly to:



Human Controls



Policy-as-Code Rules



CI/CD Validation Tests



Evidence Collection Requirements



These criteria represent the minimum bar required before deployment of any agent release.



1\. Identity \& Access Control (Least Privilege)

AC-1: Agent Identity



The HR AI Agent must use a dedicated service account (service principal).



The service account must not be shared by humans or other systems.



AC-2: No Direct Access to Raw Tables



The agent must access HR data only through approved views.



Direct queries to base HR tables must be blocked.



AC-3: Permission Minimization



The service principal must be granted:



SELECT only on approved HR views.



EXECUTE only on approved tool functions.



READ only for allowed non-PII classifications.



It must not have:



CREATE TABLE, ALTER, or DROP permissions.



Access to PII, SPI, or Legal Restricted data.



AC-4: Group-Based Access



Agent permissions must be assigned via a developer or agent group.



No individual identity inheritance is allowed.



2\. Data Controls \& Classification Enforcement

AC-5: PII Masking Enforcement



Any field containing PII must:



Be masked at the table level and view level.



Never be returned by a tool function.



Be validated by test queries.



AC-6: Mandatory Data Classification Tags



All Unity Catalog objects must include:



Object	Required Tags

Tables	classification, contains\_pii

Views	classification, contains\_pii

Functions	classification

Models	data\_sensitivity

AC-7: View Requirements



All approved HR analysis views must:



Remove or obfuscate identifiers.



Exclude Legal Restricted rows.



Limit date granularity to Reduce Re-Identification Risk.



3\. Governance Tooling Requirements

AC-8: HR Tools Must Be UC Functions



All permitted tools must be Unity Catalog registered functions.



Functions must reference approved views only.



Functions must produce only aggregate, non-identifying outputs.



AC-9: Tools Must Log Metadata



Each tool function must:



Emit structured logs.



Capture query parameters.



Capture execution timestamps.



Record the calling service principal.



4\. Observability \& Tracing Acceptance Criteria

AC-10: MLflow Trace Logging Required



The agent must log:



Full execution trace (spans)



Tool calls



Inputs and outputs



Token usage



Model version



AC-11: No Hidden Reasoning / Chain of Thought Logging



Logging must not expose raw model reasoning steps.



Only high-level summaries are allowed.



AC-12: Auditability Test



A full agent run must produce:



An audit record in UC



An execution trace in MLflow



Evidence artifacts in /evidence



5\. Security \& Hardening Requirements

AC-13: Forbidden Query Enforcement



The agent must block at least these categories:



Salary lookup by individual



Social Security or any sensitive number pattern



Legal case data



Re-identification attempts



Raw HR table names



AC-14: Input Validation



Every agent request must be passed through a sanitizer.



Dangerous patterns (regex: ssn, salary of, show employee) must be blocked.



AC-15: Prompt Injection Resilience



The system prompt must enforce guardrails.



Tests must validate that override attempts do not bypass controls.



6\. CI/CD Enforcement Acceptance Criteria

AC-16: OPA Rego Policies Must Pass



All policy-as-code rules must pass before deployment.



AC-17: Forbidden Prompt Tests Must Pass



The file /tests/forbidden\_prompts.test must return no failures.



AC-18: Evidence Auto-Export



Pipeline must export:



IAM policy JSON



MLflow model metadata



OPA test results



Classification table



Artifacts must be stored in /evidence/<timestamp>/



7\. Deployment Criteria

AC-19: Service Principal Deployment



The deployed agent endpoint must use the dedicated service principal only.



AC-20: No Manual Deployment Allowed



Deployment must go through the GitHub Actions workflow exclusively.

