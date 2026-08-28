---
title: "LLM02 Sensitive Information Disclosure"
owasp_llm_id: "LLM02"
when_to_use:
  - reviewing LLM apps that handle PII, credentials, or confidential data
  - assessing training data pipelines for data leakage risks
  - evaluating LLM outputs for unintended information exposure
  - auditing access controls on LLM-generated responses
threats:
  - PII leakage through model outputs
  - training data extraction and model inversion attacks
  - proprietary algorithm or business logic exposure
  - credential or API key disclosure via system prompts
summary: "LLMs may inadvertently expose sensitive data — PII, credentials, proprietary algorithms, or confidential business information — through their outputs, training data memorization, or misconfigured system prompts."
aisvs_mappings:
  - section: "C7.3"
    title: "Output Safety & Privacy Filtering"
    requirements: ["7.3.2", "7.3.3"]
  - section: "C5.4"
    title: "Output Filtering & Data Loss Prevention"
    requirements: ["5.4.1", "5.4.2", "5.4.3"]
  - section: "C11.1"
    title: "Anonymization & Data Minimization"
    requirements: ["11.1.1", "11.1.2"]
  - section: "C11.2"
    title: "Right-to-be-Forgotten & Deletion Enforcement"
    requirements: ["11.2.1", "11.2.2"]
  - section: "C11.3"
    title: "Differential-Privacy Safeguards"
    requirements: ["11.3.1", "11.3.2"]
  - section: "C10.3"
    title: "Membership-Inference Mitigation"
    requirements: ["10.3.1", "10.3.2", "10.3.3"]
  - section: "C10.4"
    title: "Model-Inversion Resistance"
    requirements: ["10.4.1", "10.4.2", "10.4.3"]
---

# LLM02:2025 Sensitive Information Disclosure

## Description

This vulnerability encompasses unauthorized exposure of sensitive data through LLM outputs, including PII, financial details, health records, confidential business information, security credentials, and proprietary algorithms. LLMs, especially when embedded in applications, risk exposing sensitive data through their output. The risk extends to both direct users and organizations deploying these systems.

## Common Examples

1. **PII leakage** — Unintended disclosure of personal identifiable information during LLM interactions
2. **Proprietary algorithm exposure** — Model misconfigurations revealing proprietary methods or training data, enabling inversion attacks
3. **Sensitive business data disclosure** — Confidential organizational information inadvertently included in generated responses
4. **Credential leakage** — API keys or credentials stored in system prompts exposed through prompt extraction

## Prevention and Mitigation

| # | Strategy | Description |
|---|----------|-------------|
| 1 | Sanitization | Implement data scrubbing and masking techniques to prevent sensitive content from entering training processes. |
| 2 | Access controls | Limit access to sensitive data based on the principle of least privilege. Restrict model access to external data sources. |
| 3 | Federated learning | Deploy decentralized training across multiple servers to minimize centralized data exposure. |
| 4 | Differential privacy | Incorporate noise into data, making reverse-engineering individual data points difficult. |
| 5 | User education | Educate users on safe LLM interaction practices. Maintain clear data retention and deletion policies. |
| 6 | Secure configuration | Limit user ability to override system settings. Follow OWASP API8:2023 guidelines. |
| 7 | Tokenization and redaction | Use pattern-matching redaction to preprocess sensitive information before model interaction. |

## Example Attack Scenarios

1. **Unintentional data exposure** — Users receive responses containing others' personal data due to inadequate sanitization.
2. **Targeted prompt injection** — Attackers bypass filters to extract sensitive information through manipulated inputs.
3. **Training data leak** — Negligent inclusion of sensitive information in training datasets leads to disclosure.

## AISVS Controls

| AISVS Section | Control | Key Requirements |
|---------------|---------|-----------------|
| C7.3 Output Safety & Privacy Filtering | Scan and redact PII, block confidential data in outputs | 7.3.2, 7.3.3 |
| C5.4 Output Filtering & DLP | Post-inference filtering, validate citations against entitlements, output format restrictions | 5.4.1, 5.4.2, 5.4.3 |
| C11.1 Anonymization & Data Minimization | Remove/hash identifiers, automated audits for k-anonymity | 11.1.1, 11.1.2 |
| C11.2 Right-to-be-Forgotten | Deletion propagation across datasets/checkpoints, machine-unlearning routines | 11.2.1, 11.2.2 |
| C11.3 Differential-Privacy Safeguards | Privacy-loss dashboards, black-box privacy audits | 11.3.1, 11.3.2 |
| C10.3 Membership-Inference Mitigation | Entropy regularization, differentially-private optimization | 10.3.1, 10.3.2, 10.3.3 |
| C10.4 Model-Inversion Resistance | Attribute masking, query-rate limits, privacy-preserving noise | 10.4.1, 10.4.2, 10.4.3 |

## Related Frameworks

- AML.T0024.000 — Infer Training Data Membership (MITRE ATLAS)
- AML.T0024.001 — Invert ML Model (MITRE ATLAS)
- AML.T0024.002 — Extract ML Model (MITRE ATLAS)

## References

- [OWASP Top 10 for LLM Applications](https://genai.owasp.org)
- [ChatGPT Spit Out Sensitive Data When Told to Repeat 'Poem' Forever — Wired](https://www.wired.com/story/chatgpt-poem-forever-security-roundup/)
- [Lessons Learned from ChatGPT's Samsung Leak — Cybernews](https://cybernews.com/security/chatgpt-samsung-leak-explained-lessons/)
