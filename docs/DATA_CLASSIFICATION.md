Data Classification and Privacy Model

Purpose



This document defines the data classification scheme and privacy handling rules for the Secured HR AI Agent. The classification model controls what the agent can access through governed views and tools, and what must remain inaccessible.



This design is inspired by the governance practices described in the Databricks Governing AI Agents course. Reference notes are stored at:

/mnt/data/Ai Agent governance.docx



Classification Levels

1\. Public



Definition

Information safe for all employees and safe for the agent to retrieve and summarize.



Examples



Employee handbook summary



General benefit descriptions



PTO policy overview



Public workplace policies



HR help desk contact methods (generic)



Agent access rule

Allowed. Public documents can be indexed and retrieved without redaction beyond standard safety checks.



2\. Internal



Definition

Information intended for employees only. Still safe for the agent to access if privacy rules are applied.



Examples



Internal onboarding procedures



Department level org summaries



Internal HR process guidance



Career development policy details



Internal forms and workflow steps



Agent access rule

Allowed only through curated views and governed tools. Internal data must be scanned for accidental PII before indexing. Outputs must be masked if any sensitive patterns exist.



3\. Restricted



Definition

Highly sensitive HR information that must never be available to the company wide agent.



Examples



Employee personal records



Salary by employee



Social security numbers or national IDs



Home addresses



Personal phone numbers



Disciplinary actions



Performance improvement plans



Payroll files



Health or disability related HR documentation



Legal department personnel files



Agent access rule

Denied. Restricted documents must never be loaded into the retriever, never indexed, and never reachable by any tool.



Personal Data Tagging



Each document must include metadata with:



classification: public, internal, restricted



contains\_personal\_data: true or false



region: EU, US, Global



last\_reviewed: date



The contains\_personal\_data tag triggers masking and stricter evaluation gates. Region tags enable GDPR specific minimization and logging requirements.



Masking and Redaction Rules



Masking is applied in two places:



At ingestion or indexing



Detect and remove or redact PII patterns before vector storage.



At output



Recheck responses before returning to users.



PII patterns to remove or mask include:



Full names when tied to HR records



National ID formats (SSN, SIN, etc.)



Home address strings



Personal phone numbers



Personal emails



Employee identifiers that allow re identification



If any restricted data pattern is detected, the tool must refuse retrieval and log the event as a security denial.



Curated Views and Least Privilege



The agent does not access files directly.



It only accesses curated views that:



Load Public and Internal documents only



Exclude Restricted documents entirely



Apply masking automatically to any Internal content that includes personal data patterns



Maintain lineage of what was accessed



This ensures least privilege and blocks bypass attempts.



Forbidden Query Handling



The agent must refuse questions requesting any restricted data.



Examples of forbidden queries:



What is John Smith salary



Show me all employee social security numbers



Who was placed on a performance improvement plan last quarter



List EU employees with their phone numbers



Expected behavior



Refuse the request



Provide a short policy based reason



Log the denial with classification context



Do not reveal any partial sensitive content



Compliance Alignment



GDPR



Data minimization: only Public and Internal content allowed



Purpose limitation: HR policy support only



Privacy by design: masking plus policy as code enforcement



Logging: denials and access events recorded



ISO 42001 and NIST AI RMF



Risk controls through classification and forbidden list



Continuous evaluation for leakage detection



Documented governance model for audit readines

