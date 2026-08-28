---
title: "LLM07 System Prompt Leakage"
owasp_llm_id: "LLM07"
when_to_use:
  - reviewing system prompts for embedded secrets or credentials
  - assessing whether system prompt disclosure reveals exploitable information
  - evaluating guardrail configurations that rely on prompt secrecy
  - auditing LLM apps for prompt extraction vulnerabilities
threats:
  - credential or API key exposure via system prompt extraction
  - business logic disclosure enabling targeted attacks
  - content filtering bypass through revealed filter criteria
  - privilege escalation via disclosed role configurations
summary: "System prompt leakage exposes instructions, credentials, business logic, or filtering criteria that were intended to guide LLM behavior — revealing attack surface to adversaries."
aisvs_mappings:
  - section: "C2.1"
    title: "Prompt Injection Defense"
    requirements: ["2.1.2"]
  - section: "C5.4"
    title: "Output Filtering & Data Loss Prevention"
    requirements: ["5.4.1", "5.4.2", "5.4.3"]
  - section: "C4.4"
    title: "Secrets & Cryptographic Key Management"
    requirements: ["4.4.3"]
  - section: "C7.5"
    title: "Explainability & Transparency"
    requirements: ["7.5.2"]
  - section: "C5.2"
    title: "Authorization & Policy"
    requirements: ["5.2.1", "5.2.5"]
---

# LLM07:2025 System Prompt Leakage

## Description

System prompt leakage occurs when instructions designed to guide LLM behavior inadvertently contain sensitive information. The system prompt should not be considered a secret, nor should it be used as a security control. The actual vulnerability lies not in disclosure itself, but in underlying weaknesses: storing sensitive data in prompts, bypassing authorization mechanisms, or delegating critical security functions to the LLM.

## Common Examples

1. **Exposure of sensitive functionality** — Revealing system architecture details, API keys, or database credentials through system prompts
2. **Exposure of internal rules** — Leaking business logic like transaction limits enables circumvention of security controls
3. **Revealing of filtering criteria** — Disclosing content filtering mechanisms shows attackers what restrictions exist and how to bypass them
4. **Disclosure of permissions and user roles** — Revealed privilege structures enable escalation attacks

## Prevention and Mitigation

| # | Strategy | Description |
|---|----------|-------------|
| 1 | Separate sensitive data | Keep API keys, credentials, and permission structures external to system prompts. |
| 2 | Don't rely on prompt secrecy | Use external systems for content filtering and harmful output detection. |
| 3 | Implement guardrails | Create independent inspection systems rather than relying solely on model training. |
| 4 | Enforce controls independently | Authorization and privilege separation must occur outside the LLM through deterministic, auditable mechanisms. |

## Example Attack Scenarios

1. **Credential extraction** — Attackers extract system prompt credentials and reuse them to access backend systems.
2. **Rule extraction and bypass** — Attackers extract prohibition rules, then use prompt injection to bypass restrictions and enable code execution.

## AISVS Controls

| AISVS Section | Control | Key Requirements |
|---------------|---------|-----------------|
| C2.1 Prompt Injection Defense | Enforce instruction hierarchy where system/developer messages override user instructions | 2.1.2 |
| C5.4 Output Filtering & DLP | Post-inference filtering redacts PII and classified data, validate citations, output format restrictions | 5.4.1, 5.4.2, 5.4.3 |
| C4.4 Secrets Management | Deploy secrets at runtime; never embed in code, configs, or prompts | 4.4.3 |
| C7.5 Explainability & Transparency | Sanitize explanations to remove system prompts and backend data | 7.5.2 |
| C5.2 Authorization & Policy | Access controls with default-deny, real-time alerts for unauthorized access | 5.2.1, 5.2.5 |

## Related Frameworks

- AML.T0051.000 — LLM Prompt Injection: Direct / Meta Prompt Extraction (MITRE ATLAS)

## References

- [OWASP Top 10 for LLM Applications](https://genai.owasp.org)
- [chatgpt_system_prompt — LouisShark (GitHub)](https://github.com/LouisShark/chatgpt_system_prompt)
- [leaked-system-prompts — Jujumilk3 (GitHub)](https://github.com/jujumilk3/leaked-system-prompts)
