---
title: "LLM10 Unbounded Consumption"
owasp_llm_id: "LLM10"
when_to_use:
  - reviewing LLM API configurations for rate limiting and cost controls
  - assessing LLM applications for denial of service risks
  - evaluating model API exposure for extraction or replication attacks
  - auditing cloud-deployed LLMs for resource consumption controls
threats:
  - denial of service via resource-intensive queries
  - denial of wallet via cost exploitation in pay-per-use models
  - model extraction through systematic API querying
  - context window overflow causing excessive computation
  - side-channel attacks extracting model architecture details
summary: "Unbounded consumption occurs when LLM applications permit excessive inferences without rate limiting, cost controls, or resource management — enabling denial of service, denial of wallet, and model extraction attacks."
aisvs_mappings:
  - section: "C2.6"
    title: "Input Rate Limiting & Abuse Prevention"
    requirements: ["2.6.1", "2.6.2", "2.6.3", "2.6.4"]
  - section: "C4.6"
    title: "AI Infrastructure Resource Management"
    requirements: ["4.6.1", "4.6.2"]
  - section: "C9.1"
    title: "Execution Budgets & Circuit Breakers"
    requirements: ["9.1.1", "9.1.2", "9.1.3"]
  - section: "C10.5"
    title: "Model-Extraction Defense"
    requirements: ["10.5.1", "10.5.2", "10.5.3", "10.5.5"]
  - section: "C13.1"
    title: "Kill-Switch & Override Mechanisms"
    requirements: ["13.1.1", "13.1.2", "13.1.3"]
---

# LLM10:2025 Unbounded Consumption

## Description

This vulnerability describes how LLM applications permit excessive, uncontrolled inferences, creating risks including denial of service, financial losses, model theft, and degraded performance. The computational intensity of LLMs, particularly in cloud settings, makes them susceptible to resource exploitation.

## Common Examples

1. **Variable-length input flood** — Overwhelming systems with numerous inputs of varying sizes to deplete resources
2. **Denial of wallet (DoW)** — Initiating high volumes of operations to exploit cost-per-use pricing models
3. **Continuous input overflow** — Sending inputs exceeding context windows causing excessive computation
4. **Resource-intensive queries** — Submitting demanding queries with complex language patterns
5. **Model extraction via API** — Using carefully crafted inputs to replicate or create shadow models
6. **Functional model replication** — Generating synthetic training data to fine-tune equivalent models
7. **Side-channel attacks** — Exploiting input filtering to harvest model weights and architecture details

## Prevention and Mitigation

| # | Strategy | Description |
|---|----------|-------------|
| 1 | Input validation | Implement strict input validation with reasonable size limits. |
| 2 | Restrict logits | Limit exposure of logits and logprobs in API responses. |
| 3 | Rate limiting | Apply rate limiting and per-user quotas on requests. |
| 4 | Resource management | Monitor and manage resource allocation dynamically. |
| 5 | Timeouts | Set timeouts and throttle resource-intensive operations. |
| 6 | Sandboxing | Restrict LLM access to external resources. |
| 7 | Monitoring | Deploy comprehensive logging, monitoring, and anomaly detection. |
| 8 | Watermarking | Implement watermarking frameworks for unauthorized use detection. |
| 9 | Graceful degradation | Design systems to degrade gracefully under heavy load. |
| 10 | Access controls | Enforce strong RBAC and least privilege principles. |
| 11 | Model inventory | Maintain centralized ML model inventory with governance workflows. |

## Example Attack Scenarios

1. **Uncontrolled input size** — Large inputs cause memory exhaustion and system crashes.
2. **Repeated requests** — High-volume API requests deplete computational resources.
3. **Denial of wallet** — Excessive operations exploit pay-per-use pricing, causing unexpected costs.
4. **Model replication** — Attacker uses API to generate synthetic training data, cloning the model's capabilities.

## AISVS Controls

| AISVS Section | Control | Key Requirements |
|---------------|---------|-----------------|
| C2.6 Rate Limiting & Abuse Prevention | Per-user/IP/API-key rate limits, burst/sustained tuning, anomalous pattern blocking | 2.6.1, 2.6.2, 2.6.3, 2.6.4 |
| C4.6 Resource Management | Workload resource quotas, automated protections on threshold breach | 4.6.1, 4.6.2 |
| C9.1 Execution Budgets | Per-execution budgets, cumulative counters, circuit breakers on violations | 9.1.1, 9.1.2, 9.1.3 |
| C10.5 Model-Extraction Defense | Rate limits, query-entropy detection, watermarks, extraction alerts with incident response | 10.5.1, 10.5.2, 10.5.3, 10.5.5 |
| C13.1 Kill-Switch & Override | Manual kill-switch, authorized override controls, rollback procedures | 13.1.1, 13.1.2, 13.1.3 |

## Related Frameworks

- CWE-400 — Uncontrolled Resource Consumption
- CWE-770 — Allocation of Resources Without Limits or Throttling

## References

- [OWASP Top 10 for LLM Applications](https://genai.owasp.org)
- [Stealing Part of a Production Language Model](https://arxiv.org/abs/2403.06634)
- [Sponge Examples: Energy-Latency Attacks on Neural Networks](https://arxiv.org/abs/2006.03463)
