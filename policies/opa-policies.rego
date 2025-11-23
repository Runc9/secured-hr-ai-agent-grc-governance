package secured_hr_agent.governance

# Secured HR AI Agent Governance Policies
# Purpose:
# - Enforce least privilege
# - Block restricted and PII data access
# - Enforce tool allowlist usage
# - Require observability fields
# These rules are designed to work with mixed file inputs
# from YAML, JSON, and other structured configs.

default deny = []

############################
# 1. Forbidden data sources
############################

# Disallowed keywords that must never appear in allowed sources, tools, or prompts.
forbidden_keywords := {
  "ssn",
  "social security",
  "salary by employee",
  "employee salary",
  "home address",
  "personal phone",
  "disciplinary",
  "pip",                 # performance improvement plan
  "performance improvement",
  "payroll",
  "health record",
  "legal restricted",
  "restricted_hr"
}

# Deny if a structured config declares a forbidden data source.
deny[msg] {
  some ds
  data_sources := get_list(input, "data_sources")
  ds := data_sources[_]
  kw := forbidden_keywords[_]
  contains(lower(ds), kw)
  msg := sprintf("Forbidden data source detected: %v contains %v", [ds, kw])
}

# Deny if a structured config declares forbidden views.
deny[msg] {
  some v
  views := get_list(input, "views")
  v := views[_]
  kw := forbidden_keywords[_]
  contains(lower(v), kw)
  msg := sprintf("Forbidden view detected: %v contains %v", [v, kw])
}

#################################
# 2. Tool allowlist enforcement
#################################

# Allowed tool names for company wide HR agent.
allowed_tools := {
  "search_hr_policies",
  "get_benefits_summary",
  "get_pto_policy",
  "get_performance_cycle",
  "get_onboarding_policy",
  "get_org_overview",
  "get_hr_help_resources"
}

# Deny if config declares any tool not in the allowlist.
deny[msg] {
  some t
  tools := get_list(input, "tools")
  t := tools[_]
  not allowed_tools[t]
  msg := sprintf("Tool not allowlisted: %v", [t])
}

###############################################
# 3. Identity and least privilege constraints
###############################################

# Deny if agent identity is missing in structured config.
deny[msg] {
  id := get_string(input, "identity")
  id == ""
  msg := "Agent identity is required and must be a service principal style identity"
}

# Deny if identity looks like a human email.
deny[msg] {
  id := lower(get_string(input, "identity"))
  contains(id, "@")
  msg := sprintf("Human identity detected. Use a service principal. identity=%v", [id])
}

# Deny if config grants admin or broad permissions.
deny[msg] {
  perms := get_list(input, "permissions")
  some p
  p := lower(perms[_])
  (p == "all" or p == "admin" or p == "owner")
  msg := sprintf("Broad permission detected: %v. Use least privilege.", [p])
}

###############################################
# 4. Classification and PII handling
###############################################

# Allowed classification levels.
allowed_classifications := {"public", "internal"}

# Deny if any declared classification is restricted.
deny[msg] {
  cls := lower(get_string(input, "classification"))
  cls != ""
  not allowed_classifications[cls]
  msg := sprintf("Restricted classification not allowed for agent access: %v", [cls])
}

# Deny if a document is marked restricted in metadata.
deny[msg] {
  docs := get_list(input, "documents")
  some d
  d := docs[_]
  cls := lower(get_string(d, "classification"))
  cls == "restricted"
  msg := sprintf("Restricted document declared in agent scope: %v", [d])
}

###############################################
# 5. Observability requirements
###############################################

required_log_fields := {
  "request_id",
  "timestamp",
  "query",
  "tools_used",
  "document_ids",
  "document_classifications",
  "redactions_applied",
  "decision",
  "latency_ms"
}

# Deny if logging config is missing required fields.
deny[msg] {
  log_cfg := get_object(input, "logging")
  log_fields := get_list(log_cfg, "fields")
  some f
  f := required_log_fields[_]
  not contains_list(log_fields, f)
  msg := sprintf("Logging field missing: %v", [f])
}

###############################################
# 6. Prompt safety checks (structured prompts)
###############################################

# Deny if system prompt contains forbidden keywords.
deny[msg] {
  sp := lower(get_string(input, "system_prompt"))
  sp != ""
  kw := forbidden_keywords[_]
  contains(sp, kw)
  msg := sprintf("System prompt contains forbidden topic keyword: %v", [kw])
}

###############################################
# Helper functions
###############################################

get_list(obj, key) = out {
  val := obj[key]
  is_array(val)
  out := val
} else = [] {
  true
}

get_string(obj, key) = out {
  val := obj[key]
  is_string(val)
  out := val
} else = "" {
  true
}

get_object(obj, key) = out {
  val := obj[key]
  is_object(val)
  out := val
} else = {} {
  true
}

contains_list(arr, item) {
  arr[_] == item
}
