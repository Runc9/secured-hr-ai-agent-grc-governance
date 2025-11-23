package secured_hr_agent.governance

# Rego v1 compatible policies for Secured HR AI Agent governance.
# Enforces least privilege, tool allowlist, classification boundaries,
# PII protection, and observability requirements.

default deny := []

############################
# Forbidden data sources
############################

forbidden_keywords := {
  "ssn",
  "social security",
  "salary by employee",
  "employee salary",
  "home address",
  "personal phone",
  "disciplinary",
  "pip",
  "performance improvement",
  "payroll",
  "health record",
  "legal restricted",
  "restricted_hr"
}

deny contains msg if {
  data_sources := get_list(input, "data_sources")
  some i
  ds := data_sources[i]

  some j
  kw := forbidden_keywords[j]

  contains(lower(ds), kw)
  msg := sprintf("Forbidden data source detected: %v contains %v", [ds, kw])
}

deny contains msg if {
  views := get_list(input, "views")
  some i
  v := views[i]

  some j
  kw := forbidden_keywords[j]

  contains(lower(v), kw)
  msg := sprintf("Forbidden view detected: %v contains %v", [v, kw])
}

############################
# Tool allowlist enforcement
############################

allowed_tools := {
  "search_hr_policies",
  "get_benefits_summary",
  "get_pto_policy",
  "get_performance_cycle",
  "get_onboarding_policy",
  "get_org_overview",
  "get_hr_help_resources"
}

deny contains msg if {
  tools := get_list(input, "tools")
  some i
  t := tools[i]

  not allowed_tools[t]
  msg := sprintf("Tool not allowlisted: %v", [t])
}

###############################################
# Identity and least privilege constraints
###############################################

deny contains msg if {
  id := get_string(input, "identity")
  id == ""
  msg := "Agent identity is required and must be a service principal style identity"
}

deny contains msg if {
  id := lower(get_string(input, "identity"))
  contains(id, "@")
  msg := sprintf("Human identity detected. Use a service principal. identity=%v", [id])
}

deny contains msg if {
  perms := get_list(input, "permissions")
  some i
  p := lower(perms[i])

  {"all", "admin", "owner"}[p]
  msg := sprintf("Broad permission detected: %v. Use least privilege.", [p])
}

###############################################
# Classification and PII handling
###############################################

allowed_classifications := {"public", "internal"}

deny contains msg if {
  cls := lower(get_string(input, "classification"))
  cls != ""
  not allowed_classifications[cls]
  msg := sprintf("Restricted classification not allowed for agent access: %v", [cls])
}

deny contains msg if {
  docs := get_list(input, "documents")
  some i
  d := docs[i]

  cls := lower(get_string(d, "classification"))
  cls == "restricted"
  msg := sprintf("Restricted document declared in agent scope: %v", [d])
}

###############################################
# Observability requirements
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

deny contains msg if {
  log_cfg := get_object(input, "logging")
  log_fields := get_list(log_cfg, "fields")

  some i
  f := required_log_fields[i]

  not contains_list(log_fields, f)
  msg := sprintf("Logging field missing: %v", [f])
}

###############################################
# Prompt safety checks
###############################################

deny contains msg if {
  sp := lower(get_string(input, "system_prompt"))
  sp != ""

  some i
  kw := forbidden_keywords[i]

  contains(sp, kw)
  msg := sprintf("System prompt contains forbidden topic keyword: %v", [kw])
}

###############################################
# Helper functions (Rego v1)
###############################################

get_list(obj, key) = out if {
  val := obj[key]
  is_array(val)
  out := val
} else = [] if {
  true
}

get_string(obj, key) = out if {
  val := obj[key]
  is_string(val)
  out := val
} else = "" if {
  true
}

get_object(obj, key) = out if {
  val := obj[key]
  is_object(val)
  out := val
} else = {} if {
  true
}

contains_list(arr, item) if {
  arr[_] == item
}
