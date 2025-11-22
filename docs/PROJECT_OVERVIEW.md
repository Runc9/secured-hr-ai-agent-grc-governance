PROJECT OVERVIEW

Project Title



Secured HR AI Agent with GRC Governance



Purpose



This project provides a governance-first package that enables developers to safely build and deploy a company-internal HR AI agent. The goal is to ensure the agent can search and summarize HR resources while respecting strict privacy controls, least privilege access, and enterprise GRC requirements.



It provides governance for:



Data access



Tool usage



Privacy protection



Observability



Evaluation



CI or CD enforcement



This repository is not the full HR agent. It is the GRC control package that developers use to enforce governance as they build their agent.



Background and Motivation



Modern internal copilots (such as Microsoft Copilot or custom LLM agents) can answer HR questions. Without proper governance, they may:



Reveal personal employee data



Access restricted HR documents



Produce outputs that violate privacy policies or laws



Be manipulated through prompt injection



This project implements governance practices inspired by the Databricks “Governing AI Agents” course located at:



/mnt/data/Ai Agent governance.docx





The structure aligns with cloud-agnostic GRC engineering methods.



Scope of the Project



The project includes:



Governed data access controls



Masking and redaction logic



Whitelisted tool layer



Minimal, safe HR agent demo



Observability patterns



Evaluation and safety checks



Policy-as-code enforcement



Evidence automation



Out of Scope



This repository does not include:



Real HR datasets



A production LLM endpoint



Front-end UI



Employee personal records



Full agent logic or retrieval pipelines



These will be implemented by developers in their own repo.



Users of This Repository



GRC Engineers



AI Developers



Security Engineers



HR SMEs



Lifecycle Alignment



This project aligns with the agent lifecycle described in the Databricks training:



Data preparation



Tool definition



Agent construction



Evaluation



Deployment



Monitoring



The governance framework follows the four pillars:



Lifecycle management



Risk management



Security



Observability

