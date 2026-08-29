---
name: ultimate-security-auditor
description: Consolidated ultimate skill containing expert knowledge for security auditor. Use this for all tasks in this domain.
---

# Ultimate Security Auditor

> **Agent Instruction:** This is a consolidated expert skill. Read the catalog below and apply the specific rules that match the user's request. Do not mix conflicting styles or rules.

## Skill Catalog

### agent-security-audit
**Description:** Audit AI agent configurations for security risks — excessive permissions, prompt injection surfaces, data exfiltration paths, and missing guardrails. Use when reviewing CLAUDE.md files, MCP configs, agent orchestration code, or any AI agent setup.


#### Agent Security Audit

Evaluate an AI agent's security posture by following the full procedure in `plays/agent-security-audit.md`.

##### Steps

1. **Permission Inventory** — Enumerate every tool, MCP server, file system path, network access, and credential the agent has. Flag capabilities beyond what its stated purpose requires.

2. **Prompt Injection Surface Analysis** — For each input path (user messages, tool outputs, MCP resources, RAG documents), assess whether crafted input could cause the agent to invoke unintended tools, override instructions, or exfiltrate data.

3. **Excessive Agency Assessment (OWASP LLM06)** — Check whether destructive/irreversible actions require confirmation, whether access exceeds need, whether the agent can escalate its own privileges, and whether individually-safe tool calls can chain into harmful outcomes.

4. **Data Exfiltration Path Analysis** — Map how sensitive data could leave the agent boundary: secrets passed to external tools, file contents in web requests, cross-MCP-server data forwarding, sensitive data in logs.

5. **Tool-Call Injection Assessment** — For each tool: can user-controlled input reach tool parameters unsanitized? Check for command injection, path traversal, SSRF, and SQL injection through agent-constructed calls.

6. **Guardrail Evaluation** — Check for system prompt safety instructions, tool call confirmations, output filtering, rate limiting, audit logging, and sandboxing.

##### Output

Use the finding format from `templates/finding.md`. Produce a Permission Summary table, Risk Findings, Injection Surface Map, and prioritized Recommendations.

##### OWASP References

- LLM01: Prompt Injection
- LLM02: Insecure Output Handling
- LLM06: Excessive Agency
- LLM07: System Prompt Leakage
- LLM08: Vector and Embedding Weaknesses


---

### ai-security-verification
**Description:** Comprehensive AI security verification using OWASP AI Security Verification Standard (AISVS) framework. Provides structured checklist to verify security and ethical considerations across 13 categories of AI-driven applications, from training data governance to human oversight.


#### AI Security Verification Standard (AISVS)

Conduct comprehensive security verification of AI-driven applications using the OWASP AI Security Verification Standard (AISVS) framework's 13-category structured checklist.

##### Steps

1. **Training Data Governance & Bias Management** — Assess data quality, provenance, bias detection, and governance controls throughout the data lifecycle.

2. **User Input Validation** — Evaluate input sanitization, prompt injection defenses, adversarial input detection, and boundary validation mechanisms.

3. **Model Lifecycle Management & Change Control** — Review model versioning, deployment controls, rollback capabilities, and change management processes.

4. **Infrastructure, Configuration & Deployment Security** — Examine deployment security, container hardening, network controls, and infrastructure configuration.

5. **Access Control & Identity** — Verify authentication mechanisms, authorization controls, privilege management, and identity governance.

6. **Supply Chain Security for Models, Frameworks & Data** — Assess third-party model security, dependency management, and supply chain integrity.

7. **Model Behavior, Output Control & Safety Assurance** — Evaluate output validation, safety guardrails, behavior monitoring, and harmful content prevention.

8. **Memory, Embeddings & Vector Database Security** — Review vector database security, embedding protection, memory isolation, and context management.

9. **Autonomous Orchestration & Agentic Action Security** — Assess agent coordination security, tool access controls, and autonomous decision-making safeguards.

10. **Adversarial Robustness & Attack Resistance** — Test resilience against adversarial examples, evasion attacks, and model extraction attempts.

11. **Privacy Protection & Personal Data Management** — Verify privacy controls, data minimization, consent management, and regulatory compliance.

12. **Monitoring, Logging & Anomaly Detection** — Evaluate security monitoring, audit logging, anomaly detection, and incident response capabilities.

13. **Human Oversight and Trust** — Assess human-in-the-loop controls, explainability mechanisms, and trust calibration measures.

##### Output

Use the finding format from `templates/finding.md`. Produce:
- **AISVS Compliance Assessment** — Verification status across all 13 categories
- **Security Control Evaluation** — Detailed analysis of implemented controls
- **Gap Analysis** — Missing or inadequate security measures
- **Risk-Based Prioritization** — Critical findings requiring immediate attention
- **Compliance Roadmap** — Structured plan to achieve AISVS compliance
- **Verification Evidence** — Documentation supporting compliance claims

##### OWASP References

- **OWASP AI Security Verification Standard (AISVS)**
- OWASP Top 10 for LLM Applications 2025
- OWASP AI Security and Privacy Guide
- OWASP Application Security Verification Standard (ASVS)
- OWASP AI Testing Guide

---

### api-security-review
**Description:** Comprehensive API security review against OWASP API Security Top 10 (2023). Use when reviewing OpenAPI/Swagger specs, auditing REST/GraphQL/gRPC implementations, testing authentication mechanisms, or checking API gateway configurations. Covers BOLA/IDOR, broken auth, mass assignment, rate limiting, SSRF, and more with real-world attack scenarios.


#### API Security Review

Perform comprehensive API security assessment following `plays/api-security-review.md`.

##### Steps

1. **Discovery & Reconnaissance**
   - Parse OpenAPI/Swagger specs or scan code for endpoints
   - Identify authentication mechanisms (JWT, OAuth 2.0, API keys, mTLS)
   - Map API gateway and middleware configurations
   - Enumerate all API versions and deprecated endpoints

2. **Authentication Deep Dive**
   - JWT security (algorithm confusion, weak signing, token expiration)
   - OAuth 2.0 flows (PKCE, state parameter, redirect URI validation)
   - API key exposure and rotation policies
   - Session management and token storage

3. **Assess All 10 OWASP API Risks** with attack scenarios:
   - **API1 BOLA** — IDOR via predictable IDs, batch endpoint bypasses, ownership verification gaps
   - **API2 Broken Authentication** — JWT attacks, OAuth flaws, brute force, credential stuffing
   - **API3 BOPA** — Mass assignment, response over-exposure, field-level authz bypasses
   - **API4 Resource Consumption** — Rate limit bypasses, pagination abuse, GraphQL DoS
   - **API5 BFLA** — Admin endpoint discovery, horizontal/vertical privilege escalation
   - **API6 Business Flows** — Automated abuse, inventory exhaustion, scraping attacks
   - **API7 SSRF** — URL bypasses, DNS rebinding, cloud metadata access
   - **API8 Misconfiguration** — CORS bypasses, verbose errors, missing headers
   - **API9 Inventory** — Shadow APIs, zombie endpoints, version confusion
   - **API10 Unsafe Consumption** — XXE, deserialization, webhook replay attacks

4. **Automated Testing**
   - Run API security scanners (OWASP ZAP, Burp Suite, Postman tests)
   - Test for common vulnerabilities with specific payloads
   - Validate rate limiting and throttling mechanisms

5. **API Gateway & Infrastructure Review**
   - Kong, nginx, Envoy, AWS API Gateway configurations
   - WAF rules and bypass opportunities
   - TLS configuration and certificate validation

##### Output

Comprehensive API security report including:
- API surface inventory with authentication mechanisms
- Risk matrix with severity ratings for all 10 categories
- Detailed findings with proof-of-concept examples
- Exploit scenarios and business impact analysis
- Prioritized remediation roadmap with code examples
- Testing artifacts and vulnerability evidence

##### OWASP References

- OWASP API Security Top 10 (2023)
- OWASP ASVS v5.0 — V13: API and Web Service
- OWASP Testing Guide: WSTG-APIT
- OWASP Cheat Sheet: REST Security, GraphQL Security, JWT Security, OAuth 2.0


---

### code-review-security
**Description:** Security-focused code review mapped to OWASP Top 10 and ASVS. Use when reviewing pull requests, auditing files or modules for vulnerabilities, or performing pre-merge security gate checks. Covers injection, auth, authorization, cryptography, data exposure, misconfiguration, and deserialization.


#### Security Code Review

Review code for security vulnerabilities by following the full procedure in `plays/code-review-security.md`.

##### Steps

1. **Scope & Context** — Establish language/framework, trust boundary (server/client/library/CLI), data sensitivity (PII, credentials, financial), and exposure (internet-facing, internal, local).

2. **Systematic Review by Vulnerability Class** (priority order):
   - **Injection (A03)** — SQL, command, XSS, SSTI, LDAP, path traversal, header, log injection
   - **Authentication & Session (A07)** — Hardcoded credentials, missing auth, weak sessions, JWT issues
   - **Authorization (A01)** — Missing authz checks, IDOR, horizontal/vertical privilege escalation
   - **Cryptography (A02)** — Weak algorithms, hardcoded keys, missing encryption, custom crypto
   - **Data Exposure (A01)** — Sensitive data in errors/logs, credentials in code, debug mode
   - **Misconfiguration (A05)** — Default credentials, permissive CORS, missing security headers
   - **Deserialization (A08)** — Untrusted deserialization, missing integrity checks, CSRF gaps

3. **Framework-Specific Checks** — Apply checks for detected framework (React, Express, Django, Flask, Spring, Rails, Go).

4. **Diff-Specific Analysis** (for PRs) — Focus on changed lines plus context, verify security controls preserved, check new endpoints match auth patterns, look for removed security controls.

5. **Produce Findings** — Cite file:line, show vulnerable snippet, explain attack scenario, provide fixed code, rate confidence.

##### Output

Scope summary, findings sorted by severity using `templates/finding.md`, positive observations (good security controls in place), and severity count table.

##### OWASP References

- OWASP Top 10 (2021): A01-A10
- OWASP ASVS v5.0
- OWASP Code Review Guide
- OWASP Cheat Sheet Series


---

### web-security-review
**Description:** Review web applications against the OWASP Top 10 for Web Applications (2021). Use when auditing web apps, reviewing server-side code, or assessing web frameworks for the classic OWASP Top 10 risks including injection, broken auth, and XSS.


#### Web Security Review (OWASP Top 10)

Review web applications against all 10 OWASP Top 10 risks by following the full procedure in `plays/owasp-top10-web-review.md`.

##### Steps

1. **Application Mapping** — Identify framework/language, deployment model (monolith/microservices), trust boundaries (internet/internal/local), data sensitivity (PII, financial, health), and authentication mechanisms.

2. **Assess Each OWASP Top 10 Risk**:
   - **A01 Broken Access Control** — Missing authz checks, IDOR, privilege escalation, path traversal, CORS misconfigurations
   - **A02 Cryptographic Failures** — Weak algorithms, missing TLS, hardcoded keys, improper key management, cleartext storage
   - **A03 Injection** — SQLi, NoSQLi, OS command injection, LDAP injection, XSS, SSTI, XPath injection
   - **A04 Insecure Design** — Missing security requirements, business logic flaws, insecure workflows, threat modeling gaps
   - **A05 Security Misconfiguration** — Default configs, verbose errors, missing headers, unnecessary features, outdated components
   - **A06 Vulnerable Components** — Unpatched libraries, unsupported dependencies, lack of inventory, missing SBOM
   - **A07 Identification & Auth Failures** — Weak passwords, session issues, MFA gaps, credential stuffing, brute force
   - **A08 Software & Data Integrity Failures** — Insecure deserialization, unsigned updates, CI/CD attacks, dependency confusion
   - **A09 Security Logging & Monitoring Failures** — Missing audit logs, insufficient monitoring, no incident response capability
   - **A10 Server-Side Request Forgery (SSRF)** — Unvalidated URL parameters, internal service access, cloud metadata endpoints

3. **Framework-Specific Analysis** — Apply checks for detected framework (React, Angular, Vue, Express, Django, Flask, Rails, Spring, ASP.NET, Laravel).

4. **Configuration Review** — Examine web server configs (nginx, Apache), application configs, and deployment manifests for security settings.

##### Output

Application overview, risk matrix for all 10 categories with severity/status, detailed findings using `templates/finding.md`, positive controls observed, and prioritized remediation roadmap.

##### OWASP References

- OWASP Top 10 for Web Applications (2021)
- OWASP ASVS v5.0 — Application Security Verification Standard
- OWASP Testing Guide (WSTG)
- OWASP Cheat Sheet Series


---

### llm-risk-assess
**Description:** Comprehensive LLM security assessment against OWASP Top 10 for LLM Applications 2025. Use when reviewing LLM-integrated applications, RAG pipelines, chatbots, AI agents, or GenAI features. Covers prompt injection, data poisoning, supply chain, excessive agency, and more with real-world attack scenarios and testing methodologies.


#### LLM Risk Assessment (2025)

Comprehensive evaluation of LLM applications against OWASP Top 10 for LLM Applications 2025. Follow the detailed procedure in `plays/llm-risk-assess.md`.

##### Steps

1. **Architecture & Threat Modeling**
   - Map LLM provider (OpenAI, Anthropic, local models)
   - Document data flows: user input → preprocessing → prompt construction → LLM → output processing → actions
   - Identify RAG components, tool integrations, memory systems
   - Define trust boundaries and attack surfaces

2. **Automated Security Testing**
   - Run prompt injection probes (Garak, Giskard, custom scripts)
   - Test output handling vulnerabilities
   - Scan for secrets in prompts and configurations
   - Validate vector database security

3. **Assess All 10 OWASP LLM 2025 Risks** with attack scenarios:
   - **LLM01 Prompt Injection** — Direct/indirect injection, jailbreaks, goal hijacking, delimiter bypasses
   - **LLM02 Sensitive Information Disclosure** — Training data leakage, PII exposure, system info extraction, memorized secrets
   - **LLM03 Supply Chain** — Model poisoning, malicious dependencies, insecure plugins, provenance issues
   - **LLM04 Data and Model Poisoning** — Training data poisoning, RAG poisoning, embedding manipulation
   - **LLM05 Improper Output Handling** — XSS, command injection, SQLi, path traversal via LLM outputs
   - **LLM06 Excessive Agency** — Unauthorized tool calls, permission escalation, dangerous action chains
   - **LLM07 System Prompt Leakage** — Prompt extraction attacks, secret disclosure, instruction reverse engineering
   - **LLM08 Vector and Embedding Weaknesses** — Adversarial embeddings, retrieval poisoning, similarity attacks
   - **LLM09 Misinformation** — Hallucinations, authoritative presentation, grounding failures, harmful domains
   - **LLM10 Unbounded Consumption** — Token exhaustion, cost attacks, resource exhaustion, DoS

4. **Red Team Testing**
   - Attempt real-world attack scenarios
   - Test defense bypasses and evasion techniques
   - Validate guardrails and safety controls

##### Output

Comprehensive LLM security report:
- Architecture diagram with trust boundaries
- Risk matrix (all 10 categories with severity/status)
- Detailed findings with proof-of-concept examples
- Red team test results and bypass techniques
- Remediation roadmap with code examples
- Defense validation checklist

##### OWASP References

- OWASP Top 10 for LLM Applications 2025
- OWASP AI Exchange (owaspai.org)
- OWASP AI Testing Guide
- OWASP Cheat Sheet: Prompt Injection Prevention
- OWASP Prompt Injection Taxonomy (Arcanum)


---

### mobile-code-review
**Description:** Security-focused review of native Android and iOS mobile app source code against OWASP MASVS v2.1.0. Use when reviewing mobile codebases, mobile PR diffs, or auditing a mobile module.

 
#### Mobile Security Code Review

Review native Android and iOS source code for security vulnerabilities by following the full procedure in `plays/mobile-code-review.md`.

##### Steps

1. **Scope & Context** — Language (Java/Kotlin/Swift/Obj-C/Dart), platform, app type, sensitive data, exposure.
2. **Platform Detection** — Fingerprint Android (AndroidManifest.xml, build.gradle) and/or iOS (Info.plist, *.xcodeproj). If only a cross-platform shell is detected, declare partial coverage.
3. **Systematic Review by MASVS Group** — For each of the 8 MASVS groups (STORAGE, CRYPTO, AUTH, NETWORK, PLATFORM, CODE, RESILIENCE, PRIVACY) in priority order:
   - Load `data/masvs/MASVS-<GROUP>-<N>.md` for the control statement and the `mastg_tests:` list.
   - For each MASTG test ID, load `data/mastg/MASTG-TEST-####.md` and apply its Static Analysis content (V1) or Steps/Observation/Evaluation (V2) to the source tree.
   - Note V1-fallback tests in findings using the file's `status_note`.
4. **Diff-Specific Analysis** (for PRs) — Focus on changed lines; verify pinning, permissions, and KeyStore/Keychain usage are not weakened.
5. **Produce Findings** — Use `templates/finding.md`. Sort by severity (CRITICAL > HIGH > MEDIUM > LOW > INFO). Deduplicate cross-group findings (cite the most specific MASVS control in `OWASP Ref`).

##### Output

Scope summary (platform, languages), upstream-pointer note for MASTG IDs (`https://github.com/OWASP/mastg`, `https://mas.owasp.org/MASTG/`), findings sorted by severity using `templates/finding.md` (each finding carries an optional `MASTG references:` bullet listing any non-TEST `@MASTG-<KIND>-####` cross-refs cited in the informing tests, grouped by KIND alphabetically, IDs sorted numerically, omitted when empty), positive observations, severity count table, RESILIENCE static-only notice block, PRIVACY runtime-required caveat for findings against PRIVACY-2/PRIVACY-3, dynamic-test follow-up list (collected from `data/mastg/` entries with `type: [dynamic]` that informed findings).

##### OWASP References

- OWASP MASVS v2.1.0
- OWASP MASTG (forward cross-references)
- OWASP MAS Checklist
- OWASP ASVS v5.0 (overlap items only)
- CWE-312, CWE-327, CWE-295, CWE-926, CWE-749, others per finding


---

### iac-security-review
**Description:** Security review of Infrastructure-as-Code (Terraform, Kubernetes, CloudFormation). Use when reviewing IaC files for misconfigurations, overpermissioning, exposed resources, missing encryption, secrets in code, and supply chain risks. Covers CIS benchmarks and cloud security best practices.


#### IaC Security Review

Review infrastructure-as-code for security risks by following the full procedure in `plays/iac-security-review.md`.

##### Steps

1. **Detect IaC Type** — Identify the infrastructure technology from file extensions and content:
   - `.tf` / `.tofu` files → Terraform/OpenTofu (reference `data/secure-code-prompts/terraform.md`)
   - Kubernetes manifests (apiVersion, kind: Deployment/Pod/Service) → Kubernetes (reference `data/secure-code-prompts/kubernetes.md`)
   - CloudFormation templates (AWSTemplateFormatVersion, Resources with AWS::) → CloudFormation (reference `data/secure-code-prompts/cloudformation.md`)
   - Helm charts (`Chart.yaml`, templates/) → Kubernetes review with Helm-specific checks

2. **Systematic Review by Security Domain** (priority order):
   - **Identity & Access Management** — Overly permissive policies, wildcard permissions, hardcoded credentials, privilege escalation paths
   - **Secrets Management** — Hardcoded secrets, plaintext credentials, missing vault/secret manager integration
   - **Network Security** — Open ingress (`0.0.0.0/0`), unrestricted ports, missing segmentation, public exposure
   - **Encryption** — Missing encryption at rest/in transit, weak algorithms, default keys
   - **Storage Security** — Public buckets, unencrypted volumes, missing versioning
   - **Logging & Monitoring** — Missing audit trails, disabled CloudTrail/audit logging
   - **Resource Exposure** — Databases, admin interfaces, APIs exposed to internet
   - **Supply Chain** — Unpinned versions, untrusted sources, unverified modules/images
   - **Platform-Specific Risks** — Terraform state exposure, K8s privileged containers, CFN nested stack integrity

3. **Check Against Benchmarks** — Validate configurations against:
   - CIS Benchmarks (AWS/Azure/GCP/Kubernetes)
   - Cloud provider security best practices
   - Pod Security Standards (for Kubernetes)

4. **Produce Findings** — For each finding: cite resource path, explain the misconfiguration, describe attack scenario, provide fixed code example, rate severity.

##### Output

Findings sorted by severity using `templates/finding.md` format, summary with severity counts, and secure configuration improvements section.

##### References

- CIS Benchmarks (AWS, Azure, GCP, Kubernetes)
- OWASP Infrastructure Security Cheat Sheet
- NSA/CISA Kubernetes Hardening Guide
- Cloud provider Well-Architected Frameworks


---

