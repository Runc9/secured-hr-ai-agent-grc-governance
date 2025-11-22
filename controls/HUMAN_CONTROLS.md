Human Readable GRC Controls



Secured HR AI Agent Governance Package



Purpose



This document defines the human readable governance controls that a GRC engineer provides to developers building the Secured HR AI Agent. These controls are designed to be translated into policy as code and enforced in CI or CD pipelines. The controls align to the four pillars of agent governance: lifecycle management, risk management, security, and observability.



These controls are inspired by the Databricks governing AI agents course. Reference notes are located at:

/mnt/data/Ai Agent governance.docx



Control Family 1. Lifecycle Management



Separation of duties, change control, and safe promotion of agent changes.



LC 01 Version control for all agent artifacts:



Control statement-

All agent related artifacts must be version controlled, including prompts, tools, policies, evaluation datasets, and documentation.



Why it matters-

Version control enables review, rollback, and traceability across environments.



Developer obligations-

Store prompts, tools, and policy rules in the repository.



Use pull requests for changes.



Tag releases or versions before deployment.



Evidence-



Git history showing review and approval.



Release tags or versioned artifacts.



Mapped frameworks-

ISO 42001, ISO 27001, SOC 2, NIST 800 53, CSA CCM



LC 02 Controlled promotion and rollback :



Control statement-

Agent updates must be promotable through dev, staging, and production with rollback support.



Why it matters-

Prevents unsafe changes from reaching production without validation.



Developer obligations-



Use CI checks as gating controls.



Maintain rollback instructions.



Do not deploy directly from unreviewed branches.



Evidence-



CI logs and approvals.



Documented rollback steps.



Mapped frameworks -

ISO 42001, NIST AI RMF, SOC 2, NIST 800 53



Control Family 2. Risk Management -



Defense-in-depth to reduce failure modes, privacy breaches, and unsafe behavior.



RM 01 Data classification for HR knowledge -



Control statement-

All HR resources must be classified as Public, Internal, or Restricted. Classification metadata must exist before indexing or retrieval.



Why it matters-

Classification enables least privilege retrieval and GDPR minimization.



Developer obligations -



Add metadata for every document.



Block ingestion of Restricted sources.



Evidence-



classification.yml and metadata\_index.json



CI data quality check output



Mapped frameworks -

GDPR, ISO 42001, ISO 27001, CSA CCM, NIST AI RMF



RM 02 Masking and redaction enforced at ingestion and output :



Control statement

PII masking must occur before indexing and must be rechecked before any response is returned.



Why it matters

Prevents accidental PII leakage even during tool usage or hallucination scenarios.



Developer obligations



Use governance/masking.py on all retrieved text.



Run PII leakage tests in CI.



Evidence



Masking code



Eval outputs with zero leakage findings



Mapped frameworks

GDPR, ISO 27001, NIST 800 53, SOC 2



RM 03 Forbidden access and refusal handling



Control statement

The agent must refuse requests for Restricted or PII based topics and log all such attempts.



Why it matters

Stops data exfiltration and prompt based privilege escalation.



Developer obligations



Maintain forbidden\_access\_list.md



Include forbidden prompt tests



Ensure refusal messages are safe and consistent



Evidence



Forbidden test cases passing



Logs showing denied attempts



Mapped frameworks

ISO 42001, NIST AI RMF, GDPR, SOC 2



Control Family 3. Security



Least privilege access and tools only access patterns.



SEC 01 Least privilege tool access



Control statement

The agent must access HR knowledge only through approved tools bound to curated views. Direct access to raw sources is prohibited.



Why it matters

Tools are the security boundary. Least privilege prevents broad access.



Developer obligations



Enforce a strict tool allowlist.



Do not expose raw retrieval, file browsing, or database admin tools.



Bind tools only to Public and Internal views.



Evidence



tools.py allowlist



OPA allowlist policy report



Mapped frameworks

ISO 27001, NIST 800 53 AC 6, CSA CCM IAM, SOC 2



SEC 02 Service identity for agent execution



Control statement

Agent execution must be attributable to a non human identity with scoped permissions.



Why it matters

Prevents use of human admin credentials and ensures consistent audit trails.



Developer obligations



Deploy with a dedicated service identity.



Scope permissions to minimum required datasets and tools.



Evidence



Identity configuration



Audit logs tied to service identity



Mapped frameworks

ISO 27001, NIST 800 53 IA and AC, SOC 2



SEC 03 Prompt injection and manipulation resistance



Control statement

The agent must ignore attempts to override rules, access restricted content, or expand scope.



Why it matters

Prompt injection is a primary attack vector for internal copilots.



Developer obligations



Use strict system prompt grounding.



Require tool based answers only.



Include adversarial prompt tests.



Evidence



adversarial\_prompts.json



Passing injection resistance evals



Mapped frameworks

NIST AI RMF, ISO 42001, SOC 2, NIST 800 53 SI 4



Control Family 4. Observability



Audit everything. Full traceability of agent actions.



OBS 01 Mandatory structured logging



Control statement

All agent requests and tool calls must be logged with required fields.



Why it matters

Observability enables troubleshooting, compliance reporting, and incident response.



Developer obligations



Implement JSON structured logs.



Include classification and redaction markers.



Log refusals and injection attempts.



Evidence



logging\_config.yml



sample\_logs outputs



Mapped frameworks

ISO 27001, SOC 2 CC7, NIST 800 53 AU 6 and AU 12, CSA CCM LOG



OBS 02 Continuous evaluation and monitoring



Control statement

Agents must be evaluated pre deployment and monitored post deployment using correctness, relevance, safety, and leakage metrics.



Why it matters

Evaluation gates prevent unsafe releases and catch drift.



Developer obligations



Maintain eval\_dataset.json



Enforce safety thresholds in CI.



Define monitoring metrics for production.



Evidence



Eval reports in evidence folder



CI gating logs



Mapped frameworks

ISO 42001, NIST AI RMF, SOC 2, GDPR



Summary



These controls define the governance boundary for the Secured HR AI Agent. Developers must integrate these controls into their build and release lifecycle. Failing any control means the agent is not production ready.

