---
name: ultimate-cloudflare-expert
description: Consolidated ultimate skill containing expert knowledge for cloudflare expert. Use this for all tasks in this domain.
---

# Ultimate Cloudflare Expert

> **Agent Instruction:** This is a consolidated expert skill. Read the catalog below and apply the specific rules that match the user's request. Do not mix conflicting styles or rules.

## Skill Catalog

### cloudflare
**Description:** Comprehensive Cloudflare platform skill covering Workers, Pages, storage (KV, D1, R2), AI (Workers AI, Vectorize, Agents SDK), feature flags (Flagship), networking (Tunnel, Spectrum), security (WAF, DDoS), and infrastructure-as-code (Terraform, Pulumi). Use for any Cloudflare development task. Biases towards retrieval from Cloudflare docs over pre-trained knowledge.


#### Cloudflare Platform Skill

Consolidated skill for building on the Cloudflare platform. Use decision trees below to find the right product, then load detailed references.

Your knowledge of Cloudflare APIs, types, limits, and pricing may be outdated. **Prefer retrieval over pre-training** — the references in this skill are starting points, not source of truth.

##### Retrieval Sources

Fetch the **latest** information before citing specific numbers, API signatures, or configuration options. Do not rely on baked-in knowledge or these reference files alone.

| Source | How to retrieve | Use for |
|--------|----------------|---------|
| Cloudflare docs | `cloudflare-docs` search tool or `https://developers.cloudflare.com/` | Limits, pricing, API reference, compatibility dates/flags |
| Workers types | `npm pack @cloudflare/workers-types` or check `node_modules` | Type signatures, binding shapes, handler types |
| Wrangler config schema | `node_modules/wrangler/config-schema.json` | Config fields, binding shapes, allowed values |
| Product changelogs | `https://developers.cloudflare.com/changelog/` | Recent changes to limits, features, deprecations |

When a reference file and the docs disagree, **trust the docs**. This is especially important for: numeric limits, pricing tiers, type signatures, and configuration options.

##### Quick Decision Trees

###### "I need feature flags"

```
Need feature flags?
└─ Feature toggles, targeting rules, percentage rollouts → flagship/
   ├─ Evaluate in Workers → Flagship binding (env.FLAGS)
   ├─ Evaluate in Node.js / browser → OpenFeature SDK (@cloudflare/flagship)
   └─ Manage flags via API → Flagship REST API
```

###### "I need to run code"

```
Need to run code?
├─ Serverless functions at the edge → workers/
├─ Full-stack web app with Git deploys → pages/
├─ Stateful coordination/real-time → durable-objects/
├─ Long-running multi-step jobs → workflows/
├─ Run containers → containers/
├─ Multi-tenant (customers deploy code) → workers-for-platforms/
├─ Scheduled tasks (cron) → cron-triggers/
├─ Lightweight edge logic (modify HTTP) → snippets/
├─ Process Worker execution events (logs/observability) → tail-workers/
└─ Optimize latency to backend infrastructure → smart-placement/
```

###### "I need to store data"

```
Need storage?
├─ Key-value (config, sessions, cache) → kv/
├─ Relational SQL → d1/ (SQLite) or hyperdrive/ (existing Postgres/MySQL)
├─ Object/file storage (S3-compatible) → r2/
├─ Versioned file trees (repos, build outputs, checkpoints) → artifacts/
├─ Message queue (async processing) → queues/
├─ Vector embeddings (AI/semantic search) → vectorize/
├─ Strongly-consistent per-entity state → durable-objects/ (DO storage)
├─ Secrets management → secrets-store/
├─ Streaming ETL to R2 → pipelines/
├─ Managed Apache Iceberg catalog on R2 → r2-data-catalog/
├─ Serverless SQL analytics over Iceberg tables → r2-sql/
└─ Persistent cache (long-term retention) → cache-reserve/
```

###### "I need AI/ML"

```
Need AI?
├─ Run inference (LLMs, embeddings, images) → workers-ai/
├─ Vector database for RAG/search → vectorize/
├─ Build stateful AI agents → agents-sdk/
├─ Gateway for any AI provider (caching, routing) → ai-gateway/
└─ AI-powered search widget → ai-search/
```

###### "I need networking/connectivity"

```
Need networking?
├─ Expose local service to internet → tunnel/
├─ TCP/UDP proxy (non-HTTP) → spectrum/
├─ WebRTC TURN server → turn/
├─ Private network connectivity → network-interconnect/
├─ Optimize routing → argo-smart-routing/
├─ Optimize latency to backend (not user) → smart-placement/
└─ Real-time video/audio → realtimekit/ or realtime-sfu/
```

###### "I need security"

```
Need security?
├─ Web Application Firewall → waf/
├─ DDoS protection → ddos/
├─ Bot detection/management → bot-management/
├─ API protection → api-shield/
├─ CAPTCHA alternative → turnstile/
└─ Credential leak detection → waf/ (managed ruleset)
```

###### "I need media/content"

```
Need media?
├─ Image optimization/transformation → images/
├─ Video streaming/encoding → stream/
├─ Browser automation/screenshots → browser-rendering/
└─ Third-party script management → zaraz/
```

###### "I need analytics/metrics data"

```
Need analytics?
├─ Query across all Cloudflare products (HTTP, Workers, DNS, etc.) → graphql-api/
├─ Custom high-cardinality metrics from Workers → analytics-engine/
├─ Client-side (RUM) performance data → web-analytics/
├─ Workers Logs and real-time debugging → observability/
├─ SQL over Iceberg data lake (logs, events) → r2-sql/ (+ pipelines/, r2-data-catalog/)
└─ Raw logs (Logpush to external tools) → Cloudflare docs
```

###### "I need infrastructure-as-code"

```
Need IaC? → pulumi/ (Pulumi), terraform/ (Terraform), or api/ (REST API)
```

##### Product Index

###### Feature Flags
| Product | Reference |
|---------|-----------|
| Flagship | `references/flagship/` |

###### Compute & Runtime
| Product | Reference |
|---------|-----------|
| Workers | `references/workers/` |
| Pages | `references/pages/` |
| Pages Functions | `references/pages-functions/` |
| Durable Objects | `references/durable-objects/` |
| Workflows | `references/workflows/` |
| Containers | `references/containers/` |
| Workers for Platforms | `references/workers-for-platforms/` |
| Cron Triggers | `references/cron-triggers/` |
| Tail Workers | `references/tail-workers/` |
| Snippets | `references/snippets/` |
| Smart Placement | `references/smart-placement/` |

###### Storage & Data
| Product | Reference |
|---------|-----------|
| KV | `references/kv/` |
| D1 | `references/d1/` |
| R2 | `references/r2/` |
| Artifacts | `references/artifacts/` |
| Queues | `references/queues/` |
| Hyperdrive | `references/hyperdrive/` |
| DO Storage | `references/do-storage/` |
| Secrets Store | `references/secrets-store/` |
| Pipelines | `references/pipelines/` |
| R2 Data Catalog | `references/r2-data-catalog/` |
| R2 SQL | `references/r2-sql/` |

###### AI & Machine Learning
| Product | Reference |
|---------|-----------|
| Workers AI | `references/workers-ai/` |
| Vectorize | `references/vectorize/` |
| Agents SDK | `references/agents-sdk/` |
| AI Gateway | `references/ai-gateway/` |
| AI Search | `references/ai-search/` |

###### Networking & Connectivity
| Product | Reference |
|---------|-----------|
| Tunnel | `references/tunnel/` |
| Spectrum | `references/spectrum/` |
| TURN | `references/turn/` |
| Network Interconnect | `references/network-interconnect/` |
| Argo Smart Routing | `references/argo-smart-routing/` |
| Workers VPC | `references/workers-vpc/` |

###### Security
| Product | Reference |
|---------|-----------|
| WAF | `references/waf/` |
| DDoS Protection | `references/ddos/` |
| Bot Management | `references/bot-management/` |
| API Shield | `references/api-shield/` |
| Turnstile | `references/turnstile/` |

###### Media & Content
| Product | Reference |
|---------|-----------|
| Images | `references/images/` |
| Stream | `references/stream/` |
| Browser Rendering | `references/browser-rendering/` |
| Zaraz | `references/zaraz/` |

###### Real-Time Communication
| Product | Reference |
|---------|-----------|
| RealtimeKit | `references/realtimekit/` |
| Realtime SFU | `references/realtime-sfu/` |

###### Developer Tools
| Product | Reference |
|---------|-----------|
| Wrangler | `references/wrangler/` |
| Miniflare | `references/miniflare/` |
| C3 | `references/c3/` |
| Observability | `references/observability/` |
| GraphQL Analytics API | `references/graphql-api/` |
| Analytics Engine | `references/analytics-engine/` |
| Web Analytics | `references/web-analytics/` |
| Sandbox | `references/sandbox/` |
| Workerd | `references/workerd/` |
| Workers Playground | `references/workers-playground/` |

###### Infrastructure as Code
| Product | Reference |
|---------|-----------|
| Pulumi | `references/pulumi/` |
| Terraform | `references/terraform/` |
| API | `references/api/` |

###### Other Services
| Product | Reference |
|---------|-----------|
| Email Routing | `references/email-routing/` |
| Email Workers | `references/email-workers/` |
| Static Assets | `references/static-assets/` |
| Bindings | `references/bindings/` |
| Cache Reserve | `references/cache-reserve/` |


---

### cloudflare-one
**Description:** "Guides Cloudflare One Zero Trust and SASE work across Access, Gateway, WARP, Tunnel, Cloudflare WAN, DLP, CASB, device posture, and identity. Use when designing, configuring, troubleshooting, or reviewing Cloudflare One deployments. Retrieval-first: use current Cloudflare docs/API schemas instead of embedded product docs."


#### Cloudflare One

Before citing limits, settings, API fields, category IDs, or exact UI paths, retrieve current information from the [Cloudflare One docs](https://developers.cloudflare.com/cloudflare-one/), the Cloudflare docs MCP server, or the Cloudflare API schema.

##### Workflow

1. Classify the ask: architecture, configuration, troubleshooting, migration, or review.
2. Gather context: account ID, users/sites/apps, identity provider, SCIM/group sync, device management, traffic path, compliance constraints, and rollout blast radius.
3. Retrieve only the current docs needed for the products involved: Access, Gateway, WARP/device client, Tunnel/Mesh, Cloudflare WAN, DLP, CASB, device posture, or identity.
4. If account access is available, inspect existing resources before proposing or making changes: Access apps/policies/groups/IdPs, Gateway rules/lists/categories, device profiles/posture checks, tunnels/routes, DNS/resolver settings, and locations/sites.
5. Propose the change set with prerequisites, validation, and rollback. For risky changes, stage disabled or scoped to a pilot group/site unless the user explicitly asks otherwise.

##### Assessment Prompts

Use these to avoid jumping straight to configuration. Ask only the prompts relevant to the user's task.

###### Architecture and Current State

- Sites and users: offices, branches, data centers, VPCs, remote users, contractors, user counts, and current connectivity model.
- Applications and destinations: SaaS, public apps, private apps, APIs, infrastructure targets, protocols, ports, hostnames, and IP ranges.
- Connectivity: VPN, MPLS, SD-WAN, direct Internet breakout, centralized backhaul, site-to-site needs, and private DNS architecture.
- Security stack: current SWG, NGFW, VPN/ZTNA, DLP, CASB, email security, logging, and compliance requirements.
- Identity: IdP, SCIM/group sync, group naming, multi-IdP needs, service accounts, and contractor/partner access.
- Rollout: pilot users/sites, blast radius, rollback path, support owners, and success criteria.

###### Access and SaaS Federation

- App shape: web app, API, SSH/RDP/VNC, database, SaaS app, public hostname, private IP, or private hostname. Retrieve [Access application type](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/choose-application-type/) docs before choosing.
- Access model: clientless browser access, private networking with device client, peer to peer connectivity, service connections with service tokens or mutual TLS, or SaaS SSO federation.
- Policy needs: user groups, device posture, session duration, mTLS, service tokens, and app launcher visibility. Retrieve [Access policy](https://developers.cloudflare.com/cloudflare-one/access-controls/policies/) docs before configuring selectors or evaluation order.
- SaaS details: SAML vs OIDC support, ACS/redirect URLs, Entity IDs/client IDs, required attributes, and tenant-control requirements.

###### Tunnel and Private Networking

- Sites and segments: which data centers, VPCs, offices, or network segments need connectivity.
- HA: dev/test single connector, production multiple connectors, or advanced multi-tunnel/site redundancy.
- Runtime: where cloudflared or WARP Connector/Mesh will run: VM, container, Kubernetes, bare metal, or other target.
- Egress: whether connectors can reach Cloudflare over the required outbound ports/protocols. Retrieve [Tunnel connectivity prechecks](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/troubleshoot-tunnels/connectivity-prechecks/) before naming exact endpoints.
- Origin reachability: whether the connector can resolve and reach every private origin.
- Routing: required CIDRs/hostnames, overlapping IP spaces, [virtual networks](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/private-net/cloudflared/tunnel-virtual-networks/), [Split Tunnels](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/configure/route-traffic/split-tunnels/), and private DNS/[resolver policy](https://developers.cloudflare.com/cloudflare-one/traffic-policies/resolver-policies/) needs.
- Management model: prefer remotely managed/token-based tunnels for new deployments unless there is a clear reason for local config.

###### Gateway, TLS, and DLP

- Traffic controls: DNS categories, HTTP URL/path inspection, L4 ports/protocols, egress IP requirements, custom lists, and allow/block exceptions. Retrieve [Gateway traffic policy](https://developers.cloudflare.com/cloudflare-one/traffic-policies/) docs for current selectors and order of enforcement.
- Identity: whether Gateway policies need user or group selectors, and whether users will be authenticated through WARP/IdP context. Check [Gateway identity selectors](https://developers.cloudflare.com/cloudflare-one/traffic-policies/identity-selectors/) and [SCIM provisioning](https://developers.cloudflare.com/cloudflare-one/team-and-resources/users/scim/) when groups are involved.
- TLS inspection: root CA deployment path, certificate-pinned applications, compliance exceptions, and FIPS requirements. Retrieve [TLS decryption](https://developers.cloudflare.com/cloudflare-one/traffic-policies/http-policies/tls-decryption/) docs before enabling.
- DLP: sensitive data types, channels to inspect, TLS inspection readiness, DLP profiles, payload logging requirements, and false-positive tolerance. Retrieve [DLP](https://developers.cloudflare.com/cloudflare-one/data-loss-prevention/) docs before creating enforcement.

###### CASB, Device Posture, and Risk

- CASB: SaaS vendors, admin access level, scan policy, org size, remediation owner, and whether inline protection is also required. Retrieve [CASB findings](https://developers.cloudflare.com/cloudflare-one/cloud-and-saas-findings/manage-findings/) docs before recommending remediation.
- Device posture: required checks, third-party EDR/MDM integrations, enrollment rules, device profiles, and split tunnel alignment.
- Risk scoring: relevant behavior signals, false-positive sources such as VPNs or service accounts, and whether risk is for investigation or enforcement. Retrieve [user risk score](https://developers.cloudflare.com/cloudflare-one/team-and-resources/users/risk-score/) docs before using risk in policies.

###### Cloudflare WAN / Site Connectivity

- Site topology, on-ramp type, route ownership, tunnel redundancy, static vs BGP-managed routes, network firewall needs, and appliance/profile ownership. Retrieve [Cloudflare WAN](https://developers.cloudflare.com/cloudflare-wan/) and [Cloudflare Network Firewall](https://developers.cloudflare.com/cloudflare-network-firewall/) docs before proposing site connectivity changes.

##### Guardrails

- Access controls application authorization; Gateway controls traffic inspection/filtering. Use both when the requirement spans identity-aware app access and network/web security.
- Public hostname Access apps can be clientless. Private destination apps require WARP/Device client or another network on-ramp plus routes and DNS resolution. Retrieve [self-hosted private app](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/self-hosted-private-app/) docs before configuring private destinations.
- Cloudflare Tunnel is an off-ramp from a private network to Cloudflare. Cloudflare WAN and Mesh are other off-ramps which can also be on-ramps.
- Group-based policies depend on IdP group claims or SCIM. If group sync is missing, do not invent group selectors.
- Private hostnames need explicit DNS routing/resolution; creating an Access app alone is not enough. Use [resolver policies](https://developers.cloudflare.com/cloudflare-one/traffic-policies/resolver-policies/) and review [Connect a private hostname](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/private-net/cloudflared/connect-private-hostname/)
- HTTP inspection and DLP for encrypted web traffic require TLS inspection and planned Do Not Inspect exceptions.
- Gateway DNS, Network, HTTP, and Egress policies have different evaluation semantics. Retrieve [order of enforcement](https://developers.cloudflare.com/cloudflare-one/traffic-policies/order-of-enforcement/) docs before explaining precedence.
- Start broad block/allow/DLP/TLS policies disabled limited to a pilot with specific target users or groups unless the user approves a wider rollout.

###### Identity and Access

- Access Groups are Cloudflare objects; IdP/SCIM groups are identity claims. Gateway group selectors use synced IdP groups, not Access Groups.
- Group names and SAML/OIDC attributes are case-sensitive. Verify exact claim names and values before creating group-based rules.
- SCIM changes and group membership can be stale until sync and re-authentication complete. Troubleshoot with the user's last authenticated identity, not just the IdP state.
- Access policies are default-deny. A private app with routes but no Allow policy still blocks access.
- Access policy selectors can use IP lists, not Gateway domain or URL lists.
- SaaS federation handles authentication into the SaaS app. SaaS authorization and tenant restrictions usually require SaaS-side roles and/or Gateway tenant controls.
- Browser Rendering for SSH/VNC/RDP is an Access capability. Browser Isolation renders general web content remotely. Do not conflate them.

###### Device Client Deployment

- The [Cloudflare One device client](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/) is the on-ramp for user devices. Two components control it: **enrollment rules** (who can connect) and **device profiles** (how the client behaves after enrollment).
- The enrollment rule is an Access application of type `warp`, not a device setting. It accepts reusable Access policies. Look in Access for enrollment debugging, not Devices.
- For headless or autonomous devices (services, kiosks, Linux hosts), use service token enrollment. Non-human devices authenticate as `non_identity@[team-domain].cloudflareaccess.com` and have no group membership - device profiles targeting IdP groups will not match them. Target headless devices explicitly with the non-identity email, specific conventions about the devices (OS information, etc.),or let them fall to the default profile.
- Device profiles control connection mode, [split tunnel](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/configure/route-traffic/split-tunnels/) configuration, user permissions (disable, switch lock), auto-reconnect, and captive portal behavior. Profiles are matched by user group or device attributes in precedence order - first match wins, default profile catches the rest.
- Split tunnel mode is the single most impactful client setting. Choose the mode based on the deployment goal:

  | Goal | Mode | Rationale |
  |---|---|---|
  | VPN replacement only (private apps) | **Include** | Route only specified private CIDRs and hostnames through the client. Everything else goes direct. Minimal blast radius. |
  | SWG only (internet security) | **Exclude** | All traffic through the client. Exclude only what breaks (local printers, certificate-pinned apps). |
  | VPN replacement + SWG | **Exclude** | All traffic through the client. Most common enterprise configuration. |
  | Coexistence with another VPN | **Include** | Avoids conflict with the other VPN's tunnel interface and DNS control. |
  | DNS filtering only | DNS-only mode | Only DNS queries go to Gateway. No traffic proxying. |

- Include vs exclude is per-profile, not per-entry. You cannot mix modes in the same profile. Switching modes mid-deployment requires re-evaluating every entry.
- Split tunnel entries must align with tunnel routes bidirectionally. A CIDR in the include list without a matching tunnel route causes a black hole. A tunnel route without a matching device profile entry means traffic never enters the tunnel.
- MDM parameters (`mdm.xml` / managed preferences) override dashboard-configured profile settings for any setting specified in the file. If dashboard changes appear to have no effect on managed devices, check MDM config. Retrieve [MDM deployment](https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/deployment/mdm-deployment/) docs for platform-specific file locations and parameters.
- If another VPN client or agent controls DNS on the device, the device client's DNS interception will conflict. In coexistence scenarios, use "traffic only" mode to avoid routing table and DNS conflicts.
- Captive portal detection temporarily disconnects the client when it detects a portal (hotel WiFi, airport).  This is a common source of end-user friction and should be managed carefully.

###### Private Networking

- Split tunnel mode changes the meaning of every route decision: Exclude mode sends traffic to Cloudflare when removed from excludes; Include mode sends traffic only when added to includes.
- Virtual networks should be used primarily when IP subnets overlap and hostname-based routing is not used. It can be used to control other user connectivity behavior, but it is recommended to manage through security policies.
- A healthy tunnel only proves cloudflared can reach Cloudflare. The tunnel must have appropriate published application routes, network routes, or hostname routes for connectivity to function.
- Cloudflare Tunnel and Cloudflare Mesh can both be used to facilitate connectivity to internal networks. Cloudflare WAN can as well, but it is gated behind Enterprise subscriptions. Retrieve [choose an on-ramp](https://developers.cloudflare.com/learning-paths/secure-internet-traffic/connect-devices-networks/choose-on-ramp/) when deliberating between Tunnel types.
- Run multiple cloudflared connectors for production HA, preferably on separate hosts. Token-based, remotely managed tunnels are the default for new deployments.

###### Gateway, TLS, and DLP

- `dns.domains` matches a domain and subdomains; `dns.fqdn` is exact-match only.
- DNS pre-resolution selectors and post-resolution selectors do not behave like a single strict precedence list. Retrieve current evaluation docs before changing rule order.
- HTTP Do Not Inspect rules run before HTTP Allow/Block/Isolate behavior. A later block rule will not override an earlier inspection bypass.
- Certificate-pinned apps need Do Not Inspect exceptions before broad TLS inspection. Deploy the Cloudflare root CA to managed devices before enabling inspection.
- DLP profiles are detection definitions only. They do nothing until referenced by Gateway HTTP policies or CASB scan settings. Rules with body inspection may be evaluated multiple times in a single pass.
- Start DLP with payload logging where appropriate, tune false positives, then block.
- Gateway Network policies are strict L4 controls. Identity-aware L4 matching requires authenticated device context.

###### CASB, Risk, and Operations

- API CASB is out-of-band and periodic. It does not provide real-time inline enforcement although some integrations support "remediation"; use Gateway granular application controls for inline CASB capability for supported applications. Retrieve [Granular application controls](https://developers.cloudflare.com/cloudflare-one/traffic-policies/http-policies/granular-controls/) when creating security policies for specific actions in specific SaaS applications.
- CASB findings are tied to specific assets and instances. Drill into affected assets before recommending remediation.
- Use current Dashboard remediation guidance for CASB fixes. Most remediations happen in the SaaS admin console, not Cloudflare.
- Large SaaS integrations can take 24-48 hours for initial scans. Reauthorizing can restart scan state; check credential health before reconnecting.
- User risk scores are behavior-based and asynchronous. CASB findings do not automatically imply high user risk.

###### Infrastructure Access

- [Zero Trust Infrastructure Access](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/infrastructure-apps/) (ZTIA) is the purpose-built offering for SSH access through the device client. It provides capabilities not available through self-hosted apps: keystroke logging, control over how users authenticate to the target machine, [short-lived certificates](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-infrastructure-access/#generate-a-cloudflare-ssh-ca) that replace static SSH keys with ephemeral certs tied to Access identity, and lightweight privileged access management. Use Infrastructure Access apps for SSH when the device client is deployed.
- [Browser Rendering](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/non-http/browser-rendering/) provides clientless SSH, RDP, and VNC through the browser without requiring the device client. Clientless RDP includes session recording and file transfer controls. Use clientless access when a device client cannot be installed (contractors, partner access, unmanaged devices) - typically not as the default for managed users with the client installed.
- [Audit SSH](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/use-cases/ssh/ssh-infrastructure-access/#enable-ssh-command-logging) is a Gateway Network policy action that logs SSH commands without blocking. It requires the session to be proxied through Cloudflare.
- Short-lived certificates require CA configuration on the target host and `sshd` configured to trust the Cloudflare CA public key. Retrieve [short-lived certificate setup](https://developers.cloudflare.com/cloudflare-one/identity/users/short-lived-certificates/) docs before configuring.
- For kubectl and database access behind private networks, use the device client with private destination routing. There is no Infrastructure Access or browser-rendered equivalent for arbitrary TCP protocols today.

###### Logs, Analytics, and DEX

- [Gateway activity logs](https://developers.cloudflare.com/cloudflare-one/analytics/logs/gateway-logs/) record DNS, HTTP, and Network policy decisions. Filter by rule name, user identity, destination, action, and time range. These are the primary troubleshooting tool for "why was this blocked/allowed."
- [Access audit logs](https://developers.cloudflare.com/cloudflare-one/insights/logs/dashboard-logs/access-authentication-logs/) record authentication decisions per app - who authenticated, which policy matched, and session details. Use for verifying policy behavior and investigating access failures.
- [Shadow IT discovery](https://developers.cloudflare.com/cloudflare-one/insights/analytics/shadow-it-discovery/) uses Gateway HTTP logs to surface unmanaged SaaS applications. Requires TLS inspection for HTTPS visibility.
- [DEX (Digital Experience Monitoring)](https://developers.cloudflare.com/cloudflare-one/insights/dex/) provides fleet-level and per-device connectivity diagnostics. Use [DEX tests](https://developers.cloudflare.com/cloudflare-one/insights/dex/tests/) (HTTP, traceroute) to proactively monitor reachability to critical origins and internal apps. Fleet status shows device client health, connection mode, and connectivity state across the enrolled population.
- [Logpush](https://developers.cloudflare.com/cloudflare-one/analytics/logs/logpush/) exports Gateway, Access, Network, and DEX logs to external SIEM or storage. Configure before go-live if the customer requires centralized log retention or compliance reporting.
- When troubleshooting, work from logs toward config: identify the log entry showing the failure (Gateway block, Access deny, tunnel error, DNS resolution miss), then trace back to the responsible rule, route, or policy.

###### Cloudflare WAN / Site Connectivity

- Cloudflare WAN is connectivity, not a security service. Apply inspection and policy with Gateway and Network Firewall where required.
- WAN firewall expressions are not the same language as Gateway wirefilter expressions. Retrieve the current syntax before editing.
- Generated IPsec PSKs and some OAuth/client secrets are returned once. Store them immediately.

##### Output Defaults

- Designs: current assumptions, target architecture, product responsibilities, rollout phases, validation, and open decisions.
- Configuration work: prerequisites, exact resources to inspect/create/change, test cases, and rollback.
- Troubleshooting: traffic path, likely failure point, evidence to collect, and next test.

##### Validation Prompts

- Access: test authorized, unauthorized, posture-failing, service-token, and multi-IdP flows when applicable; inspect logs and policy precedence.
- Private network access: verify route lookup, tunnel health, origin reachability, split tunnel behavior, DNS resolution, and end-to-end access from a device client test device.
- Gateway: verify rule type, action, traffic expression, precedence/evaluation phase, referenced lists, and Gateway settings before enabling broadly.
- TLS/DLP: test Do Not Inspect exceptions and root CA trust before enabling inspection; test DLP with known samples and monitor false positives before blocking.
- CASB/risk: confirm integration health, credential expiry, asset discovery, scan timing, finding instances, and risk-score signal latency before declaring remediation complete.
- Cloudflare WAN: verify tunnel health, route priority/ownership, traffic flow, firewall expression syntax, and connector/appliance telemetry where applicable.

##### API Safety

- Use fully qualified MCP tool names when MCP tools are available.
- Never guess category IDs, application IDs, wirefilter fields, or API request bodies. Retrieve the current schema/docs and existing account objects.
- Do not enable broad production policies without explicit approval.


---

### workers-best-practices
**Description:** Reviews and authors Cloudflare Workers code against production best practices. Load when writing new Workers, reviewing Worker code, configuring wrangler.jsonc, or checking for common Workers anti-patterns (streaming, floating promises, global state, secrets, bindings, observability). Biases towards retrieval from Cloudflare docs over pre-trained knowledge.


Your knowledge of Cloudflare Workers APIs, types, and configuration may be outdated. **Prefer retrieval over pre-training** for any Workers code task — writing or reviewing.

##### Retrieval Sources

Fetch the **latest** versions before writing or reviewing Workers code. Do not rely on baked-in knowledge for API signatures, config fields, or binding shapes.

| Source | How to retrieve | Use for |
|--------|----------------|---------|
| Workers best practices | Fetch `https://developers.cloudflare.com/workers/best-practices/workers-best-practices/` | Canonical rules, patterns, anti-patterns |
| Workers types | See `references/review.md` for retrieval steps | API signatures, handler types, binding types |
| Wrangler config schema | `node_modules/wrangler/config-schema.json` | Config fields, binding shapes, allowed values |
| Cloudflare docs | Search tool or `https://developers.cloudflare.com/workers/` | API reference, compatibility dates/flags |

##### FIRST: Fetch Latest References

Before reviewing or writing Workers code, retrieve the current best practices page and relevant type definitions. If the project's `node_modules` has an older version, **prefer the latest published version**.

```bash
#### Fetch latest workers types
mkdir -p /tmp/workers-types-latest && \
  npm pack @cloudflare/workers-types --pack-destination /tmp/workers-types-latest && \
  tar -xzf /tmp/workers-types-latest/cloudflare-workers-types-*.tgz -C /tmp/workers-types-latest
#### Types at /tmp/workers-types-latest/package/index.d.ts
```

##### Reference Documentation

- `references/rules.md` — all best practice rules with code examples and anti-patterns
- `references/review.md` — type validation, config validation, binding access patterns, review process

##### Rules Quick Reference

###### Configuration

| Rule | Summary |
|------|---------|
| Compatibility date | Set `compatibility_date` to today on new projects; update periodically on existing ones |
| nodejs_compat | Enable the `nodejs_compat` flag — many libraries depend on Node.js built-ins |
| wrangler types | Run `wrangler types` to generate `Env` — never hand-write binding interfaces |
| Secrets | Use `wrangler secret put`, never hardcode secrets in config or source |
| wrangler.jsonc | Use JSONC config for non-secret settings — newer features are JSON-only |

###### Request & Response Handling

| Rule | Summary |
|------|---------|
| Streaming | Stream large/unknown payloads — never `await response.text()` on unbounded data |
| waitUntil | Use `ctx.waitUntil()` for post-response work; do not destructure `ctx` |

###### Architecture

| Rule | Summary |
|------|---------|
| Bindings over REST | Use in-process bindings (KV, R2, D1, Queues) — not the Cloudflare REST API |
| Queues & Workflows | Move async/background work off the critical path |
| Service bindings | Use service bindings for Worker-to-Worker calls — not public HTTP |
| Hyperdrive | Always use Hyperdrive for external PostgreSQL/MySQL connections |

###### Observability

| Rule | Summary |
|------|---------|
| Logs & Traces | Enable `observability` in config with `head_sampling_rate`; use structured JSON logging |

###### Code Patterns

| Rule | Summary |
|------|---------|
| No global request state | Never store request-scoped data in module-level variables |
| Floating promises | Every Promise must be `await`ed, `return`ed, `void`ed, or passed to `ctx.waitUntil()` |

###### Security

| Rule | Summary |
|------|---------|
| Web Crypto | Use `crypto.randomUUID()` / `crypto.getRandomValues()` — never `Math.random()` for security |
| No passThroughOnException | Use explicit try/catch with structured error responses |

##### Anti-Patterns to Flag

| Anti-pattern | Why it matters |
|-------------|----------------|
| `await response.text()` on unbounded data | Memory exhaustion — 128 MB limit |
| Hardcoded secrets in source or config | Credential leak via version control |
| `Math.random()` for tokens/IDs | Predictable, not cryptographically secure |
| Bare `fetch()` without `await` or `waitUntil` | Floating promise — dropped result, swallowed error |
| Module-level mutable variables for request state | Cross-request data leaks, stale state, I/O errors |
| Cloudflare REST API from inside a Worker | Unnecessary network hop, auth overhead, added latency |
| `ctx.passThroughOnException()` as error handling | Hides bugs, makes debugging impossible |
| Hand-written `Env` interface | Drifts from actual wrangler config bindings |
| Direct string comparison for secret values | Timing side-channel — use `crypto.subtle.timingSafeEqual` |
| Destructuring `ctx` (`const { waitUntil } = ctx`) | Loses `this` binding — throws "Illegal invocation" at runtime |
| `any` on `Env` or handler params | Defeats type safety for all binding access |
| `as unknown as T` double-cast | Hides real type incompatibilities — fix the design |
| `implements` on platform base classes (instead of `extends`) | Legacy — loses `this.ctx`, `this.env`. Applies to DurableObject, WorkerEntrypoint, Workflow |
| `env.X` inside platform base class | Should be `this.env.X` in classes extending DurableObject, WorkerEntrypoint, etc. |

##### Review Workflow

1. **Retrieve** — fetch latest best practices page, workers types, and wrangler schema
2. **Read full files** — not just diffs; context matters for binding access patterns
3. **Check types** — binding access, handler signatures, no `any`, no unsafe casts (see `references/review.md`)
4. **Check config** — compatibility_date, nodejs_compat, observability, secrets, binding-code consistency
5. **Check patterns** — streaming, floating promises, global state, serialization boundaries
6. **Check security** — crypto usage, secret handling, timing-safe comparisons, error handling
7. **Validate with tools** — `npx tsc --noEmit`, lint for `no-floating-promises`
8. **Reference rules** — see `references/rules.md` for each rule's correct pattern

##### Scope

This skill covers Workers-specific best practices and code review. For related topics:

- **Durable Objects**: load the `durable-objects` skill
- **Workflows**: see [Rules of Workflows](https://developers.cloudflare.com/workflows/build/rules-of-workflows/)
- **Wrangler CLI commands**: load the `wrangler` skill

##### Principles

- **Be certain.** Retrieve before flagging. If unsure about an API, config field, or pattern, fetch the docs first.
- **Provide evidence.** Reference line numbers, tool output, or docs links.
- **Focus on what developers will copy.** Workers code in examples and docs gets pasted into production.
- **Correctness over completeness.** A concise example that works beats a comprehensive one with errors.


---

### wrangler
**Description:** Cloudflare Workers CLI for deploying, developing, and managing Workers, KV, R2, D1, Vectorize, Hyperdrive, Workers AI, Containers, Queues, Workflows, Pipelines, and Secrets Store. Load before running wrangler commands to ensure correct syntax and best practices. Biases towards retrieval from Cloudflare docs over pre-trained knowledge.


#### Wrangler CLI

Your knowledge of Wrangler CLI flags, config fields, and subcommands may be outdated. **Prefer retrieval over pre-training** for any Wrangler task.

##### Retrieval Sources

Fetch the **latest** information before writing or reviewing Wrangler commands and config. Do not rely on baked-in knowledge for CLI flags, config fields, or binding shapes.

| Source | How to retrieve | Use for |
|--------|----------------|---------|
| Wrangler docs | `https://developers.cloudflare.com/workers/wrangler/` | CLI commands, flags, config reference |
| Wrangler config schema | `node_modules/wrangler/config-schema.json` | Config fields, binding shapes, allowed values |
| Cloudflare docs | Search tool or `https://developers.cloudflare.com/workers/` | API reference, compatibility dates/flags |

##### FIRST: Check if Wrangler is installed, and if not, install it

Check if Wrangler is installed by running:

```bash
wrangler --version  # Requires v4.x+
```

If Wrangler is not installed, you should install it by running:

```bash
npm install -D wrangler@latest
```

Wherever possible, you should use Wrangler instead of manually constructing API requests.

##### Key Guidelines

- **Use `wrangler.jsonc`**: Prefer JSON config over TOML. Newer features are JSON-only.
- **Set `compatibility_date`**: Use a recent date (within 30 days). Check https://developers.cloudflare.com/workers/configuration/compatibility-dates/
- **Generate types after config changes**: Run `wrangler types` to update TypeScript bindings.
- **Local dev defaults to local storage**: Bindings use local simulation unless `remote: true`.
- **Profile Worker startup**: Run `wrangler check startup` to measure startup time and detect scripts that exceed the startup time limit.
- **Use environments for staging/prod**: Define `env.staging` and `env.production` in config.

##### Quick Start: New Worker

```bash
#### Initialize new project
npx wrangler init my-worker

#### Or with a framework
npx create-cloudflare@latest my-app
```

##### Quick Reference: Core Commands

| Task | Command |
|------|---------|
| Start local dev server | `wrangler dev` |
| Deploy to Cloudflare | `wrangler deploy` |
| Deploy dry run | `wrangler deploy --dry-run` |
| Generate TypeScript types | `wrangler types` |
| Profile Worker startup time | `wrangler check startup` |
| View live logs | `wrangler tail` |
| Delete Worker | `wrangler delete` |
| Auth status | `wrangler whoami` |

---

##### Configuration (wrangler.jsonc)

###### Minimal Config

```jsonc
{
  "$schema": "./node_modules/wrangler/config-schema.json",
  "name": "my-worker",
  "main": "src/index.ts",
  "compatibility_date": "2026-01-01"
}
```

###### Full Config with Bindings

```jsonc
{
  "$schema": "./node_modules/wrangler/config-schema.json",
  "name": "my-worker",
  "main": "src/index.ts",
  "compatibility_date": "2026-01-01",
  "compatibility_flags": ["nodejs_compat"],

  // Environment variables
  "vars": {
    "ENVIRONMENT": "production"
  },

  // KV Namespace
  "kv_namespaces": [
    { "binding": "KV", "id": "<KV_NAMESPACE_ID>" }
  ],

  // R2 Bucket
  "r2_buckets": [
    { "binding": "BUCKET", "bucket_name": "my-bucket" }
  ],

  // D1 Database
  "d1_databases": [
    { "binding": "DB", "database_name": "my-db", "database_id": "<DB_ID>" }
  ],

  // Workers AI (always remote)
  "ai": { "binding": "AI" },

  // Vectorize
  "vectorize": [
    { "binding": "VECTOR_INDEX", "index_name": "my-index" }
  ],

  // Hyperdrive
  "hyperdrive": [
    { "binding": "HYPERDRIVE", "id": "<HYPERDRIVE_ID>" }
  ],

  // Durable Objects
  "durable_objects": {
    "bindings": [
      { "name": "COUNTER", "class_name": "Counter" }
    ]
  },

  // Cron triggers
  "triggers": {
    "crons": ["0 * * * *"]
  },

  // Environments
  "env": {
    "staging": {
      "name": "my-worker-staging",
      "vars": { "ENVIRONMENT": "staging" }
    }
  }
}
```

###### Generate Types from Config

```bash
#### Generate worker-configuration.d.ts
wrangler types

#### Custom output path
wrangler types ./src/env.d.ts

#### Check types are up to date (CI)
wrangler types --check
```

---

##### Local Development

###### Start Dev Server

```bash
#### Local mode (default) - uses local storage simulation
wrangler dev

#### With specific environment
wrangler dev --env staging

#### Force local-only (disable remote bindings)
wrangler dev --local

#### Remote mode - runs on Cloudflare edge (legacy)
wrangler dev --remote

#### Custom port
wrangler dev --port 8787

#### Live reload for HTML changes
wrangler dev --live-reload

#### Test scheduled/cron handlers
wrangler dev --test-scheduled
#### Then visit: http://localhost:8787/__scheduled
```

###### Remote Bindings for Local Dev

Use `remote: true` in binding config to connect to real resources while running locally:

```jsonc
{
  "r2_buckets": [
    { "binding": "BUCKET", "bucket_name": "my-bucket", "remote": true }
  ],
  "ai": { "binding": "AI", "remote": true },
  "vectorize": [
    { "binding": "INDEX", "index_name": "my-index", "remote": true }
  ]
}
```

**Recommended remote bindings**: AI (required), Vectorize, Browser Rendering, mTLS, Images.

###### Local Secrets

Create `.dev.vars` for local development secrets:

```
API_KEY=local-dev-key
DATABASE_URL=postgres://localhost:5432/dev
```

---

##### Deployment

###### Deploy Worker

```bash
#### Deploy to production
wrangler deploy

#### Deploy specific environment
wrangler deploy --env staging

#### Dry run (validate without deploying)
wrangler deploy --dry-run

#### Keep dashboard-set variables
wrangler deploy --keep-vars

#### Minify code
wrangler deploy --minify
```

###### Manage Secrets

> **Security**: Never pass secret values as command arguments or pipe them via `echo`.
> Use the interactive prompt (preferred), pipe from a file, or use `secret bulk`.
> Never output, log, or hardcode secret values in commands.

```bash
#### Set secret — interactive prompt (preferred, wrangler will ask for the value securely)
wrangler secret put API_KEY

#### Set secret from a file (useful for PEM keys, CI environments)
wrangler secret put PRIVATE_KEY < path/to/private-key.pem

#### List secrets
wrangler secret list

#### Delete secret
wrangler secret delete API_KEY

#### Bulk secrets from JSON file (do not commit this file to version control)
wrangler secret bulk secrets.json
```

###### Versions and Rollback

```bash
#### List recent versions
wrangler versions list

#### View specific version
wrangler versions view <VERSION_ID>

#### Rollback to previous version
wrangler rollback

#### Rollback to specific version
wrangler rollback <VERSION_ID>
```

---

##### KV (Key-Value Store)

###### Manage Namespaces

```bash
#### Create namespace
wrangler kv namespace create MY_KV

#### List namespaces
wrangler kv namespace list

#### Delete namespace
wrangler kv namespace delete --namespace-id <ID>
```

###### Manage Keys

```bash
#### Put value
wrangler kv key put --namespace-id <ID> "key" "value"

#### Put with expiration (seconds)
wrangler kv key put --namespace-id <ID> "key" "value" --expiration-ttl 3600

#### Get value
wrangler kv key get --namespace-id <ID> "key"

#### List keys
wrangler kv key list --namespace-id <ID>

#### Delete key
wrangler kv key delete --namespace-id <ID> "key"

#### Bulk put from JSON
wrangler kv bulk put --namespace-id <ID> data.json
```

###### Config Binding

```jsonc
{
  "kv_namespaces": [
    { "binding": "CACHE", "id": "<NAMESPACE_ID>" }
  ]
}
```

---

##### R2 (Object Storage)

###### Manage Buckets

```bash
#### Create bucket
wrangler r2 bucket create my-bucket

#### Create with location hint
wrangler r2 bucket create my-bucket --location wnam

#### List buckets
wrangler r2 bucket list

#### Get bucket info
wrangler r2 bucket info my-bucket

#### Delete bucket
wrangler r2 bucket delete my-bucket
```

###### Manage Objects

```bash
#### Upload object
wrangler r2 object put my-bucket/path/file.txt --file ./local-file.txt

#### Download object
wrangler r2 object get my-bucket/path/file.txt

#### Delete object
wrangler r2 object delete my-bucket/path/file.txt
```

###### Config Binding

```jsonc
{
  "r2_buckets": [
    { "binding": "ASSETS", "bucket_name": "my-bucket" }
  ]
}
```

---

##### D1 (SQL Database)

###### Manage Databases

```bash
#### Create database
wrangler d1 create my-database

#### Create with location
wrangler d1 create my-database --location wnam

#### List databases
wrangler d1 list

#### Get database info
wrangler d1 info my-database

#### Delete database
wrangler d1 delete my-database
```

###### Execute SQL

```bash
#### Execute SQL command (remote)
wrangler d1 execute my-database --remote --command "SELECT * FROM users"

#### Execute SQL file (remote)
wrangler d1 execute my-database --remote --file ./schema.sql

#### Execute locally
wrangler d1 execute my-database --local --command "SELECT * FROM users"
```

###### Migrations

```bash
#### Create migration
wrangler d1 migrations create my-database create_users_table

#### List pending migrations
wrangler d1 migrations list my-database --local

#### Apply migrations locally
wrangler d1 migrations apply my-database --local

#### Apply migrations to remote
wrangler d1 migrations apply my-database --remote
```

###### Export/Backup

```bash
#### Export schema and data
wrangler d1 export my-database --remote --output backup.sql

#### Export schema only
wrangler d1 export my-database --remote --output schema.sql --no-data
```

###### Config Binding

```jsonc
{
  "d1_databases": [
    {
      "binding": "DB",
      "database_name": "my-database",
      "database_id": "<DATABASE_ID>",
      "migrations_dir": "./migrations"
    }
  ]
}
```

---

##### Vectorize (Vector Database)

###### Manage Indexes

```bash
#### Create index with dimensions
wrangler vectorize create my-index --dimensions 768 --metric cosine

#### Create with preset (auto-configures dimensions/metric)
wrangler vectorize create my-index --preset @cf/baai/bge-base-en-v1.5

#### List indexes
wrangler vectorize list

#### Get index info
wrangler vectorize get my-index

#### Delete index
wrangler vectorize delete my-index
```

###### Manage Vectors

```bash
#### Insert vectors from NDJSON file
wrangler vectorize insert my-index --file vectors.ndjson

#### Query vectors
wrangler vectorize query my-index --vector "[0.1, 0.2, ...]" --top-k 10
```

###### Config Binding

```jsonc
{
  "vectorize": [
    { "binding": "SEARCH_INDEX", "index_name": "my-index" }
  ]
}
```

---

##### Hyperdrive (Database Accelerator)

###### Manage Configs

```bash
#### Create config
wrangler hyperdrive create my-hyperdrive \
  --origin-host db.example.com \
  --origin-port 5432 \
  --database my-database \
  --origin-user db-user \
  --origin-password "$DB_PASSWORD"

#### Or using a connection string from an environment variable
wrangler hyperdrive create my-hyperdrive \
  --connection-string "$HYPERDRIVE_CONNECTION_STRING"

#### List configs
wrangler hyperdrive list

#### Get config details
wrangler hyperdrive get <HYPERDRIVE_ID>

#### Update config
wrangler hyperdrive update <HYPERDRIVE_ID> \
  --origin-password "$DB_PASSWORD"

#### Delete config
wrangler hyperdrive delete <HYPERDRIVE_ID>
```

###### Config Binding

```jsonc
{
  "compatibility_flags": ["nodejs_compat"],
  "hyperdrive": [
    { "binding": "HYPERDRIVE", "id": "<HYPERDRIVE_ID>" }
  ]
}
```

---

##### Workers AI

###### List Models

```bash
#### List available models
wrangler ai models

#### List finetunes
wrangler ai finetune list
```

###### Config Binding

```jsonc
{
  "ai": { "binding": "AI" }
}
```

**Note**: Workers AI always runs remotely and incurs usage charges even in local dev.

---

##### Queues

###### Manage Queues

```bash
#### Create queue
wrangler queues create my-queue

#### List queues
wrangler queues list

#### Delete queue
wrangler queues delete my-queue

#### Add consumer to queue
wrangler queues consumer add my-queue my-worker

#### Remove consumer
wrangler queues consumer remove my-queue my-worker
```

###### Config Binding

```jsonc
{
  "queues": {
    "producers": [
      { "binding": "MY_QUEUE", "queue": "my-queue" }
    ],
    "consumers": [
      {
        "queue": "my-queue",
        "max_batch_size": 10,
        "max_batch_timeout": 30
      }
    ]
  }
}
```

---

##### Containers

###### Build and Push Images

```bash
#### Build container image
wrangler containers build -t my-app:latest .

#### Build and push in one command
wrangler containers build -t my-app:latest . --push

#### Push existing image to Cloudflare registry
wrangler containers push my-app:latest
```

###### Manage Containers

```bash
#### List containers
wrangler containers list

#### Get container info
wrangler containers info <CONTAINER_ID>

#### Delete container
wrangler containers delete <CONTAINER_ID>
```

###### Manage Images

```bash
#### List images in registry
wrangler containers images list

#### Delete image
wrangler containers images delete my-app:latest
```

###### Manage External Registries

> **Security**: Never hardcode registry credentials in commands. Use environment variables.

```bash
#### List configured registries
wrangler containers registries list

#### Configure external registry (e.g., ECR)
wrangler containers registries configure <DOMAIN> \
  --aws-access-key-id "$AWS_ACCESS_KEY_ID"

#### Configure DockerHub
wrangler containers registries configure <DOMAIN> \
  --dockerhub-username "$DOCKERHUB_USERNAME"

#### Delete registry configuration
wrangler containers registries delete <DOMAIN>
```

---

##### Workflows

###### Manage Workflows

```bash
#### List workflows
wrangler workflows list

#### Describe workflow
wrangler workflows describe my-workflow

#### Trigger workflow instance
wrangler workflows trigger my-workflow

#### Trigger with parameters
wrangler workflows trigger my-workflow --params '{"key": "value"}'

#### Delete workflow
wrangler workflows delete my-workflow
```

###### Manage Workflow Instances

```bash
#### List instances
wrangler workflows instances list my-workflow

#### Describe instance
wrangler workflows instances describe my-workflow <INSTANCE_ID>

#### Terminate instance
wrangler workflows instances terminate my-workflow <INSTANCE_ID>
```

###### Config Binding

```jsonc
{
  "workflows": [
    {
      "binding": "MY_WORKFLOW",
      "name": "my-workflow",
      "class_name": "MyWorkflow"
    }
  ]
}
```

---

##### Pipelines

###### Manage Pipelines

```bash
#### Create pipeline
wrangler pipelines create my-pipeline --r2 my-bucket

#### List pipelines
wrangler pipelines list

#### Show pipeline details
wrangler pipelines show my-pipeline

#### Update pipeline
wrangler pipelines update my-pipeline --batch-max-mb 100

#### Delete pipeline
wrangler pipelines delete my-pipeline
```

###### Config Binding

```jsonc
{
  "pipelines": [
    { "binding": "MY_PIPELINE", "pipeline": "my-pipeline" }
  ]
}
```

---

##### Secrets Store

###### Manage Stores

```bash
#### Create store
wrangler secrets-store store create my-store

#### List stores
wrangler secrets-store store list

#### Delete store
wrangler secrets-store store delete <STORE_ID>
```

###### Manage Secrets in Store

```bash
#### Add secret to store
wrangler secrets-store secret put <STORE_ID> my-secret

#### List secrets in store
wrangler secrets-store secret list <STORE_ID>

#### Get secret
wrangler secrets-store secret get <STORE_ID> my-secret

#### Delete secret from store
wrangler secrets-store secret delete <STORE_ID> my-secret
```

###### Config Binding

```jsonc
{
  "secrets_store_secrets": [
    {
      "binding": "MY_SECRET",
      "store_id": "<STORE_ID>",
      "secret_name": "my-secret"
    }
  ]
}
```

---

##### Pages (Frontend Deployment)

```bash
#### Create Pages project
wrangler pages project create my-site

#### Deploy directory to Pages
wrangler pages deploy ./dist

#### Deploy with specific branch
wrangler pages deploy ./dist --branch main

#### List deployments
wrangler pages deployment list --project-name my-site
```

---

##### Observability

###### Tail Logs

```bash
#### Stream live logs
wrangler tail

#### Tail specific Worker
wrangler tail my-worker

#### Filter by status
wrangler tail --status error

#### Filter by search term
wrangler tail --search "error"

#### JSON output
wrangler tail --format json
```

###### Config Logging

```jsonc
{
  "observability": {
    "enabled": true,
    "head_sampling_rate": 1
  }
}
```

---

##### Testing

###### Local Testing with Vitest

```bash
npm install -D @cloudflare/vitest-pool-workers vitest
```

`vitest.config.ts`:
```typescript
import { defineWorkersConfig } from "@cloudflare/vitest-pool-workers/config";

export default defineWorkersConfig({
  test: {
    poolOptions: {
      workers: {
        wrangler: { configPath: "./wrangler.jsonc" },
      },
    },
  },
});
```

###### Test Scheduled Events

```bash
#### Enable in dev
wrangler dev --test-scheduled

#### Trigger via HTTP
curl http://localhost:8787/__scheduled
```

---

##### Troubleshooting

###### Common Issues

| Issue | Solution |
|-------|----------|
| `command not found: wrangler` | Install: `npm install -D wrangler` |
| Auth errors | Run `wrangler login` |
| Startup time limit exceeded | Run `wrangler check startup` to profile startup and generate CPU profiles |
| Type errors after config change | Run `wrangler types` |
| Local storage not persisting | Check `.wrangler/state` directory |
| Binding undefined in Worker | Verify binding name matches config exactly |

###### Debug Commands

```bash
#### Check auth status
wrangler whoami

#### Profile Worker startup time
wrangler check startup

#### View config schema
wrangler docs configuration
```

---

##### Best Practices

1. **Version control `wrangler.jsonc`**: Treat as source of truth for Worker config.
2. **Use automatic provisioning**: Omit resource IDs for auto-creation on deploy.
3. **Run `wrangler types` in CI**: Add to build step to catch binding mismatches.
4. **Use environments**: Separate staging/production with `env.staging`, `env.production`.
5. **Set `compatibility_date`**: Update quarterly to get new runtime features.
6. **Use `.dev.vars` for local secrets**: Never commit secrets to config.
7. **Test locally first**: `wrangler dev` with local bindings before deploying.
8. **Use `--dry-run` before major deploys**: Validate changes without deployment.
9. **Never embed secrets in commands**: Use interactive prompts (`wrangler secret put`), file-based input (`wrangler secret bulk`), or secure CI environment variables. Never echo, log, or pass secret values as CLI arguments.


---

### sandbox-stable
**Description:** Use when building or changing Cloudflare Sandbox apps on the current stable @cloudflare/sandbox package (default npm tag)—commands, sessions, files, ports, tunnels, terminals, bridge, production, or deprecated-API cleanup while staying on stable. Not for @cloudflare/sandbox@next (use sandbox-next) or for porting to 1.0 (use sandbox-migrate-to-next).


#### Sandbox SDK — stable package

Isolated Linux environments on [Cloudflare Containers](https://developers.cloudflare.com/containers/), driven from Workers.

**Prefer the main Sandbox docs and installed stable types over memory.** This skill is a gate, a contract, and a retrieval map—not a full manual.

This line is the **current stable** default npm package. The main [Sandbox documentation](https://developers.cloudflare.com/sandbox/) describes it. Existing apps can stay here and keep shipping.

We recommend **new projects** on `@cloudflare/sandbox@next` with **`sandbox-next`**. When you can, plan a move with **`sandbox-migrate-to-next`** so you are ready when 1.0 becomes the stable release. Do not force that port unless the user asks.

##### 1. Gate — confirm the package line

Before writing code, inspect the app:

| Check | Must match |
| ----- | ---------- |
| npm dependency | Default `@cloudflare/sandbox` (**not** `@next` / preview tags) |
| Container image | Matching **stable** image (not `cloudflare/sandbox:next`) |

| If you find… | Action |
| ------------ | ------ |
| `@cloudflare/sandbox@next` or a `next` image | **Stop.** Load **`sandbox-next`**. |
| User wants to port to 1.0 / `@next` | **Stop.** Load **`sandbox-migrate-to-next`**. Do not half-apply preview APIs on a stable package. |
| Only cleaning deprecated stable APIs | Stay here; use the [2026 deprecation guide](https://developers.cloudflare.com/sandbox/guides/2026-deprecation/). That is **not** a move to `@next`. |

Never mix a stable Worker package with an `@next` container image (or the reverse).

Skills install: [Agent setup](https://developers.cloudflare.com/agent-setup/) · [cloudflare/skills](https://github.com/cloudflare/skills)

##### 2. Contract — non-negotiables

- `await sandbox.exec(command)` takes a **command string** and resolves when the command **finishes**, with buffered `stdout` / `stderr` / `exitCode` (and related fields).
- Long-running and streaming work use the **stable** command APIs (`startProcess`, `execStream`, and related helpers)—not the `@next` single-handle model. Open the Commands docs; do not invent `@next` `output()` handles on stable.
- **Sessions** can preserve working directory and environment across commands (default session / `enableDefaultSession`, `createSession`). See Sessions docs when state must carry across calls.
- Interactive browser terminals often use **`sandbox.terminal(request)`** and session/xterm helpers on stable—not preview `createTerminal` unless the package is `@next`.
- Prefer **RPC** transport when using tunnels or large/binary streaming. HTTP/WebSocket transports are deprecated (cleanup guide below).
- Files, mounts, ports, tunnels, backups, lifecycle, and interpreter: use main docs for signatures; trust installed **stable** types.
- Non-secret config in sandbox env; live credentials in the Worker. Use outbound handlers when processes call external APIs.
- Production preview hostnames need wildcard DNS on a custom domain when using those URL patterns.
- Do **not** apply `@next` argv/`process.output()` APIs while the dependency is still stable.
- Self-deployed **bridge** stays on the stable package and image. [Bridge](https://developers.cloudflare.com/sandbox/bridge/)

Minimal shape:

```ts
import { getSandbox, proxyToSandbox, Sandbox } from "@cloudflare/sandbox";

export { Sandbox };

const sandbox = getSandbox(env.Sandbox, "user-123");
const result = await sandbox.exec('python3 -c "print(2 + 2)"');
// result.stdout, result.exitCode, result.success
```

##### 3. Retrieve — open the doc for the task

Fetch the page before implementing. Installed stable types win over guesses.

| You need to… | Open |
| ------------ | ---- |
| Orient | [Sandbox overview](https://developers.cloudflare.com/sandbox/) |
| First Worker, template, Docker | [Get started](https://developers.cloudflare.com/sandbox/get-started/) |
| `exec`, streaming, background processes | [Commands API](https://developers.cloudflare.com/sandbox/api/commands/) · [Execute commands](https://developers.cloudflare.com/sandbox/guides/execute-commands/) · [Background processes](https://developers.cloudflare.com/sandbox/guides/background-processes/) · [Streaming output](https://developers.cloudflare.com/sandbox/guides/streaming-output/) |
| Sessions / shell state across commands | [Sessions concept](https://developers.cloudflare.com/sandbox/concepts/sessions/) · [Sessions API](https://developers.cloudflare.com/sandbox/api/sessions/) |
| `getSandbox` options, sleep, destroy | [Lifecycle API](https://developers.cloudflare.com/sandbox/api/lifecycle/) · [Sandbox options](https://developers.cloudflare.com/sandbox/configuration/sandbox-options/) |
| Env vars | [Environment variables](https://developers.cloudflare.com/sandbox/configuration/environment-variables/) |
| Files | [Files API](https://developers.cloudflare.com/sandbox/api/files/) · [Manage files](https://developers.cloudflare.com/sandbox/guides/manage-files/) · [File watching](https://developers.cloudflare.com/sandbox/api/file-watching/) |
| Buckets / mounts | [Storage API](https://developers.cloudflare.com/sandbox/api/storage/) · [Mount buckets](https://developers.cloudflare.com/sandbox/guides/mount-buckets/) |
| Backups | [Backups API](https://developers.cloudflare.com/sandbox/api/backups/) · [Backup and restore](https://developers.cloudflare.com/sandbox/guides/backup-restore/) |
| Ports, preview URLs, expose | [Ports API](https://developers.cloudflare.com/sandbox/api/ports/) · [Expose services](https://developers.cloudflare.com/sandbox/guides/expose-services/) |
| Tunnels | [Tunnels API](https://developers.cloudflare.com/sandbox/api/tunnels/) |
| Proxy / Workers connections | [Proxy requests](https://developers.cloudflare.com/sandbox/guides/proxy-requests/) · [Workers connections](https://developers.cloudflare.com/sandbox/guides/workers-connections/) |
| Browser / PTY terminal | [Terminal API](https://developers.cloudflare.com/sandbox/api/terminal/) · [Terminal concept](https://developers.cloudflare.com/sandbox/concepts/terminal/) · [Browser terminals](https://developers.cloudflare.com/sandbox/guides/browser-terminals/) |
| Code interpreter | [Interpreter API](https://developers.cloudflare.com/sandbox/api/interpreter/) · [Code execution](https://developers.cloudflare.com/sandbox/guides/code-execution/) |
| Git in the sandbox | [Git workflows](https://developers.cloudflare.com/sandbox/guides/git-workflows/) |
| Secrets / egress | [Outbound traffic](https://developers.cloudflare.com/sandbox/guides/outbound-traffic/) |
| WebSockets | [WebSocket connections](https://developers.cloudflare.com/sandbox/guides/websocket-connections/) |
| Docker-in-Docker | [Docker in Docker](https://developers.cloudflare.com/sandbox/guides/docker-in-docker/) |
| Production deploy | [Production deployment](https://developers.cloudflare.com/sandbox/guides/production-deployment/) |
| Containers concept | [Containers](https://developers.cloudflare.com/sandbox/concepts/containers/) |
| How-to index | [Guides](https://developers.cloudflare.com/sandbox/guides/) |
| API index | [API reference](https://developers.cloudflare.com/sandbox/api/) |
| Deprecated APIs **while staying on stable** | [2026 deprecation guide](https://developers.cloudflare.com/sandbox/guides/2026-deprecation/) |
| Self-deployed bridge | [Bridge](https://developers.cloudflare.com/sandbox/bridge/) · [Bridge HTTP API](https://developers.cloudflare.com/sandbox/bridge/http-api/) |
| Examples (stable/`main`) | [examples on GitHub](https://github.com/cloudflare/sandbox-sdk/tree/main/examples) |
| New work on 1.0 preview | **`sandbox-next`** · [1.0 preview](https://developers.cloudflare.com/sandbox/1-0-preview/) |
| Port existing app to `@next` | **`sandbox-migrate-to-next`** · [Migrate](https://developers.cloudflare.com/sandbox/1-0-preview/migrate/) |

###### Deprecated-API cleanup (stay on stable)

Update package + matching image first, then follow the guide. Typical search:

```sh
rg 'SANDBOX_TRANSPORT|transport:|exposePort\(|enableDefaultSession|execStream\(|readFileStream|writeFileStream'
```

This path does **not** switch you to `@next`.

##### 4. Before you ship

- Worker package and container image on the **same stable** line  
- Typecheck against installed stable types  
- No live secrets in sandbox env  
- If using deprecated transports/helpers, finish or track [2026 deprecation](https://developers.cloudflare.com/sandbox/guides/2026-deprecation/) cleanup  
- When the team is ready for 1.0, use **`sandbox-migrate-to-next`**—do not force cutover unprompted  


---

### sandbox-next
**Description:** Use when building or changing Cloudflare Sandbox apps on @cloudflare/sandbox@next (Sandbox SDK 1.0 preview)—code execution, AI runners, interpreters, CI-like jobs, terminals, files, mounts, tunnels, preview URLs, lifecycle, or errors. Not for the default stable package (use sandbox-stable) or for porting stable to @next (use sandbox-migrate-to-next).


#### Sandbox SDK — `@next` (1.0 preview)

Isolated Linux environments on [Cloudflare Containers](https://developers.cloudflare.com/containers/), driven from Workers.

**Prefer preview docs and installed `@next` types over memory.** APIs change; this skill is a gate, a contract, and a retrieval map—not a full manual.

We recommend **new projects** on this line. Apps still on the default package use **`sandbox-stable`**. Port only when asked, via **`sandbox-migrate-to-next`**.

##### 1. Gate — confirm the package line

Before writing code, inspect the app:

| Check | Must match |
| ----- | ---------- |
| npm dependency | `@cloudflare/sandbox@next` (or another preview tag) |
| Container image | Same line (e.g. `cloudflare/sandbox:next`, `next-python`) |

| If you find… | Action |
| ------------ | ------ |
| Default `@cloudflare/sandbox` (no `@next`) | **Stop.** Load **`sandbox-stable`**. Do not apply this skill’s APIs. |
| User wants to port stable → `@next` | **Stop.** Load **`sandbox-migrate-to-next`**. |
| Self-deployed **bridge** only | Bridge is **not** on the 1.0 preview line yet. Keep bridge on stable package + image. [Bridge (stable)](https://developers.cloudflare.com/sandbox/bridge/) |

Never mix an `@next` Worker package with a stable container image (or the reverse).

Skills install: [Agent setup](https://developers.cloudflare.com/agent-setup/) · [cloudflare/skills](https://github.com/cloudflare/skills)

##### 2. Contract — non-negotiables

- `sandbox.exec(argv)` takes an **argv** list and resolves when the process **starts**. It returns a **handle**, not a finished command result.
- Collect results with handle methods: `output()`, `logs()`, `waitForExit()`, `waitForPort()`, `waitForLog()`, `kill(signal?)`.
- No implicit shell. Shell syntax needs an explicit shell, e.g. `["/bin/bash", "-lc", script]`.
- Each launch is independent. A `cd` / `export` in one `exec` is not visible to the next. Pass `cwd` and `env` per launch, or one shell script.
- Process handles have **no stdin**. Interactive use → terminals (`createTerminal` + `connect`).
- Local wait `timeout` / `AbortSignal` cancel the **wait only**. They do not kill the process. Use `kill` or `exec`’s remote `timeout`.
- `getProcess` / `listProcesses` / `getTerminal` / `listTerminals` do **not** start a container; they return `null` / `[]` when none is up.
- Process and terminal IDs belong to the **current container**, not forever to a sandbox ID. For work that must survive replace, store the full job (argv, cwd, env, app state)—not only an id.
- Non-secret config only in `setEnvVars` / launch `env`. Live credentials stay in the Worker; use outbound handlers when the sandbox calls external APIs.
- Do **not** invent removed stable APIs (`gitCheckout` on core, string-`exec` completion, session execution, `sandbox.terminal(request)`).
- Do **not** use one retry loop for every error (see Errors docs).

Minimal shape:

```ts
import { getSandbox, proxyToSandbox, Sandbox } from "@cloudflare/sandbox";

export { Sandbox };

const sandbox = getSandbox(env.Sandbox, "user-123");
const process = await sandbox.exec(["python3", "-c", "print(2 + 2)"]);
const result = await process.output({ encoding: "utf8" });
// result.stdout, result.exitCode
```

Optional **non-exhaustive** cheatsheet (process/terminal/interpreter only): [references/api-quick-ref.md](references/api-quick-ref.md)  
Examples index (`next` branch): [references/examples.md](references/examples.md)

##### 3. Retrieve — open the doc for the task

Fetch the page before implementing. Installed `@next` types win over guesses.

| You need to… | Open |
| ------------ | ---- |
| Orient / choose preview | [1.0 preview overview](https://developers.cloudflare.com/sandbox/1-0-preview/) |
| First Worker, wrangler, Dockerfile | [Get started](https://developers.cloudflare.com/sandbox/1-0-preview/get-started/) |
| `exec`, handles, readiness, durability | [Process execution](https://developers.cloudflare.com/sandbox/1-0-preview/processes/) |
| Process API signatures | [Processes API](https://developers.cloudflare.com/sandbox/1-0-preview/api/processes/) |
| Sandbox ID vs container vs sleep/destroy | [Lifecycle](https://developers.cloudflare.com/sandbox/1-0-preview/lifecycle/) |
| `cwd` / `env` / `setEnvVars` | [Environment](https://developers.cloudflare.com/sandbox/1-0-preview/environment/) |
| Interactive PTY / browser terminal | [Terminals](https://developers.cloudflare.com/sandbox/1-0-preview/terminals/) · [Terminals API](https://developers.cloudflare.com/sandbox/1-0-preview/api/terminals/) |
| Python/JS code interpreter | [Interpreter](https://developers.cloudflare.com/sandbox/1-0-preview/interpreter/) · [Interpreter API](https://developers.cloudflare.com/sandbox/1-0-preview/api/interpreter/) |
| Extensions model | [Extensions](https://developers.cloudflare.com/sandbox/1-0-preview/extensions/) |
| Error classes and recovery | [Errors](https://developers.cloudflare.com/sandbox/1-0-preview/errors/) · [Errors API](https://developers.cloudflare.com/sandbox/1-0-preview/api/errors/) |
| Common failures | [Troubleshooting](https://developers.cloudflare.com/sandbox/1-0-preview/troubleshooting/) |
| API hub | [API reference](https://developers.cloudflare.com/sandbox/1-0-preview/api/) |
| Files, mounts, backups, ports, tunnels, `proxyToSandbox` | Main docs for shared surfaces (ignore stable-only session/transport/`sandbox.terminal`): [Files](https://developers.cloudflare.com/sandbox/api/files/) · [Storage / mounts](https://developers.cloudflare.com/sandbox/api/storage/) · [Ports](https://developers.cloudflare.com/sandbox/api/ports/) · [Tunnels](https://developers.cloudflare.com/sandbox/api/tunnels/) · [Backups](https://developers.cloudflare.com/sandbox/api/backups/) · [Outbound traffic](https://developers.cloudflare.com/sandbox/guides/outbound-traffic/) · [Expose services](https://developers.cloudflare.com/sandbox/guides/expose-services/) · [Production](https://developers.cloudflare.com/sandbox/guides/production-deployment/) |
| Example apps | [examples on `next`](https://github.com/cloudflare/sandbox-sdk/tree/next/examples) |
| Still on stable package | **`sandbox-stable`** · [Main Sandbox docs](https://developers.cloudflare.com/sandbox/) |
| Porting an existing stable app | **`sandbox-migrate-to-next`** · [Migrate](https://developers.cloudflare.com/sandbox/1-0-preview/migrate/) |

##### 4. Before you ship

- Lockfile and Dockerfile on the **same** `@next` line  
- Typecheck against installed `@next` types  
- No live secrets in sandbox env  
- Production preview hostnames need wildcard DNS on a custom domain when using those URL patterns  


---

### sandbox-migrate-to-next
**Description:** Use when porting a Cloudflare Sandbox app from stable @cloudflare/sandbox to @cloudflare/sandbox@next (Sandbox SDK 1.0 preview), or when the user asks to migrate or upgrade to Sandbox 1.0 / @next. Not for day-to-day stable work (sandbox-stable) or new @next apps (sandbox-next).


#### Migrate stable → Sandbox SDK 1.0 preview (`@next`)

**Perform** the port. Follow the steps in order. Depth lives in docs—fetch the linked page when a step needs detail.

Human guide: [Migrate](https://developers.cloudflare.com/sandbox/1-0-preview/migrate/) · [1.0 preview](https://developers.cloudflare.com/sandbox/1-0-preview/)

**New projects** should start on `@next` (**`sandbox-next`**), not this skill. **Day-to-day stable work** → **`sandbox-stable`**. Deprecated-API cleanup **without** moving to `@next` → [2026 deprecation guide](https://developers.cloudflare.com/sandbox/guides/2026-deprecation/) first if needed.

Existing apps should migrate **when you can**, so you are ready when 1.0 becomes the stable release. Do **not** force production cutover without the user agreeing.

**Prefer installed `@next` types and the migrate doc over memory.**

##### Workflow

1. **Review** hard rules and the replacement map  
2. **Audit** the codebase; list hits and target shapes  
3. **Clarify** with the user (cutover, bridge, Python image, unclear sites)  
4. **Upgrade** package, image, and code  
5. **Validate**  

Stop after any step that needs a user decision.

##### Hard rules

- Worker package and container image must be the **same** `@next` line.  
- Production cutover uses **immediate** container rollout. Stable and `@next` control protocols are incompatible both ways; gradual rollout leaves a broken mixed window. In-flight container work can stop.  
- After cutover, `await sandbox.exec(...)` means process **started**, not command **finished**.  
- Argv is as-is (no implicit shell). Shell syntax needs an explicit shell binary.  
- Process handles have **no stdin** → terminals for interactive input.  
- Observation `timeout` / `AbortSignal` cancel the **wait only**, not the process.  
- No single retry loop for every error.  
- Do not invent APIs (`gitCheckout` on core, process stdin, string-exec completion helper).  
- Self-deployed bridge stays on **stable** (not part of the preview line yet).  

##### Replacement map

| Stable | `@next` |
| ------ | ------- |
| `SANDBOX_TRANSPORT` / `transport` / `setTransport` | Remove — RPC only |
| `await sandbox.exec("cmd")` → buffered result | `await sandbox.exec(argv)` → handle, then `output` / waits |
| `execStream` / `startProcess` | Same handle: `logs`, `waitFor*`, `kill` |
| Default / named sessions | Gone — `cwd`/`env` per launch, or one shell script |
| `sandbox.terminal(request)` / session terminal | `createTerminal` + `terminal.connect(request)` |
| xterm `sessionId` | `terminalId` |
| Interpreter methods on `Sandbox` | `withInterpreter` → `sandbox.interpreter.*` |
| `gitCheckout` | argv `git` via `exec` |
| String kill signals | Numeric only |
| Files, mounts, backups, ports, tunnels, `proxyToSandbox` | Mostly unchanged (ignore session/transport bits on stable pages) |

Depth: [Migrate](https://developers.cloudflare.com/sandbox/1-0-preview/migrate/) · after port, day-to-day → **`sandbox-next`**

##### Audit

```sh
rg 'SANDBOX_TRANSPORT|transport:|setTransport|enableDefaultSession|createSession|getSession|deleteSession|execStream\(|startProcess\(|killProcess\(|sandbox\.terminal\(|sessionId|gitCheckout\(|SandboxTransport|ExecutionSession'
```

Also: string `exec(`, `cd` then a later `exec`, bare `createCodeContext` / `runCode` on `Sandbox`.

##### Clarify (ask when needed)

- OK to cut production with `--containers-rollout=immediate` (live processes/terminals/streams may stop)?  
- Self-deployed bridge? Leave on stable.  
- Python interpreter → **`-python`** image variant?  
- Call sites not covered by the map?  

##### Upgrade

###### Package and image

```sh
npm install @cloudflare/sandbox@next
```

```dockerfile
FROM cloudflare/sandbox:next
#### Python: cloudflare/sandbox:next-python
```

Same prerelease tag on Worker and image when not on floating `next`.

###### Code by area

Apply replacements from the map. For each area, implement from the doc—not from stable habits:

| Area | Doc |
| ---- | --- |
| Commands / handles / waits | [Processes](https://developers.cloudflare.com/sandbox/1-0-preview/processes/) · [Processes API](https://developers.cloudflare.com/sandbox/1-0-preview/api/processes/) |
| `cwd` / `env` / secrets | [Environment](https://developers.cloudflare.com/sandbox/1-0-preview/environment/) · [Outbound traffic](https://developers.cloudflare.com/sandbox/guides/outbound-traffic/) |
| Drop sessions | [Migrate](https://developers.cloudflare.com/sandbox/1-0-preview/migrate/) · [Lifecycle](https://developers.cloudflare.com/sandbox/1-0-preview/lifecycle/) |
| Terminals | [Terminals](https://developers.cloudflare.com/sandbox/1-0-preview/terminals/) |
| Interpreter | [Interpreter](https://developers.cloudflare.com/sandbox/1-0-preview/interpreter/) |
| Errors | [Errors](https://developers.cloudflare.com/sandbox/1-0-preview/errors/) |
| Durable job across requests | [Process execution — lifetime / durability](https://developers.cloudflare.com/sandbox/1-0-preview/processes/) |

**Commands (shape):**

```ts
// Before (stable)
const result = await sandbox.exec("npm test");

// After (@next)
const process = await sandbox.exec(["/bin/bash", "-lc", "npm test"]);
const result = await process.output({ encoding: "utf8" });
```

```ts
const server = await sandbox.exec(["/bin/bash", "-lc", "npm run dev"], {
  cwd: "/workspace/app",
});
await server.waitForPort(3000, { timeout: 60_000 });
await server.kill(); // numeric; default 15
```

**Terminals (shape):**

```ts
const terminal = await sandbox.createTerminal({ command: ["bash"], cwd: "/workspace" });
const t = await sandbox.getTerminal(terminal.id);
if (!t) return new Response("terminal gone", { status: 410 });
return t.connect(request, { cursor, cols, rows });
```

**Interpreter (shape):**

```ts
import { Sandbox as BaseSandbox } from "@cloudflare/sandbox";
import { withInterpreter } from "@cloudflare/sandbox/interpreter";

export class Sandbox extends BaseSandbox<Env> {
  interpreter = withInterpreter(this);
}
```

**Git (shape):**

```ts
const clone = await sandbox.exec(
  ["git", "clone", "--depth", "1", "--", repoUrl, "/workspace/repo"],
  { cwd: "/workspace" },
);
const result = await clone.output({ encoding: "utf8" });
```

Delete transport settings entirely. Remove session APIs. Isolate users with **separate sandbox IDs**.

###### Deploy cutover

Staging/branch first. Production is **one** deploy of matching Worker + image:

```sh
npx wrangler deploy --containers-rollout=immediate
```

Leave `rollout_active_grace_period` at default `0` (or set `0` if raised). After cutover, pre-deploy process/terminal IDs are invalid. Details: [Migrate](https://developers.cloudflare.com/sandbox/1-0-preview/migrate/) · [Container rollouts](https://developers.cloudflare.com/containers/platform-details/rollouts/)

##### Validate

1. Lockfile + Dockerfile on the same `@next` line  
2. Typecheck against `@next`  
3. Smoke argv `exec` + `output({ encoding: "utf8" })`  
4. Smoke long process / terminal / interpreter if used  
5. Errors distinguished: unavailable / interrupted-RPC / stale / local wait  
6. No live secrets in sandbox env  
7. Grep again for removed APIs  
8. Production used `--containers-rollout=immediate`  

Then day-to-day work uses **`sandbox-next`**.

##### Red flags — stop and fix

- Mixing `@next` Worker with stable image (or reverse)  
- Gradual container rollout for this cutover  
- Treating `await exec` as command completion  
- Assuming `cd` / exports persist across `exec` calls  
- One retry wrapper for every error  
- Inventing `gitCheckout`, process stdin, or undocumented APIs  
- Keeping pre-cutover process/terminal IDs after deploy  
- Forcing production cutover without user agreement  
- Putting live secrets in `setEnvVars` / launch `env`  


---

### durable-objects
**Description:** Create and review Cloudflare Durable Objects. Use when building stateful coordination (chat rooms, multiplayer games, booking systems), implementing RPC methods, SQLite storage, alarms, WebSockets, or reviewing DO code for best practices. Covers Workers integration, wrangler config, and testing with Vitest. Biases towards retrieval from Cloudflare docs over pre-trained knowledge.


#### Durable Objects

Build stateful, coordinated applications on Cloudflare's edge using Durable Objects.

##### Retrieval Sources

Your knowledge of Durable Objects APIs and configuration may be outdated. **Prefer retrieval over pre-training** for any Durable Objects task.

| Resource | URL |
|----------|-----|
| Docs | https://developers.cloudflare.com/durable-objects/ |
| API Reference | https://developers.cloudflare.com/durable-objects/api/ |
| Best Practices | https://developers.cloudflare.com/durable-objects/best-practices/ |
| Examples | https://developers.cloudflare.com/durable-objects/examples/ |

Fetch the relevant doc page when implementing features.

##### When to Use

- Creating new Durable Object classes for stateful coordination
- Implementing RPC methods, alarms, or WebSocket handlers
- Reviewing existing DO code for best practices
- Configuring wrangler.jsonc/toml for DO bindings and migrations
- Writing tests with `@cloudflare/vitest-pool-workers`
- Designing sharding strategies and parent-child relationships

##### Reference Documentation

- `./references/rules.md` - Core rules, storage, concurrency, RPC, alarms
- `./references/testing.md` - Vitest setup, unit/integration tests, alarm testing
- `./references/workers.md` - Workers handlers, types, wrangler config, observability

Search: `blockConcurrencyWhile`, `idFromName`, `getByName`, `setAlarm`, `sql.exec`

##### Core Principles

###### Use Durable Objects For

| Need | Example |
|------|---------|
| Coordination | Chat rooms, multiplayer games, collaborative docs |
| Strong consistency | Inventory, booking systems, turn-based games |
| Per-entity storage | Multi-tenant SaaS, per-user data |
| Persistent connections | WebSockets, real-time notifications |
| Scheduled work per entity | Subscription renewals, game timeouts |

###### Do NOT Use For

- Stateless request handling (use plain Workers)
- Maximum global distribution needs
- High fan-out independent requests

##### Quick Reference

###### Wrangler Configuration

```jsonc
// wrangler.jsonc
{
  "durable_objects": {
    "bindings": [{ "name": "MY_DO", "class_name": "MyDurableObject" }]
  },
  "migrations": [{ "tag": "v1", "new_sqlite_classes": ["MyDurableObject"] }]
}
```

###### Basic Durable Object Pattern

```typescript
import { DurableObject } from "cloudflare:workers";

export interface Env {
  MY_DO: DurableObjectNamespace<MyDurableObject>;
}

export class MyDurableObject extends DurableObject<Env> {
  constructor(ctx: DurableObjectState, env: Env) {
    super(ctx, env);
    ctx.blockConcurrencyWhile(async () => {
      this.ctx.storage.sql.exec(`
        CREATE TABLE IF NOT EXISTS items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          data TEXT NOT NULL
        )
      `);
    });
  }

  async addItem(data: string): Promise<number> {
    const result = this.ctx.storage.sql.exec<{ id: number }>(
      "INSERT INTO items (data) VALUES (?) RETURNING id",
      data
    );
    return result.one().id;
  }
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const stub = env.MY_DO.getByName("my-instance");
    const id = await stub.addItem("hello");
    return Response.json({ id });
  },
};
```

##### Critical Rules

1. **Model around coordination atoms** - One DO per chat room/game/user, not one global DO
2. **Use `getByName()` for deterministic routing** - Same input = same DO instance
3. **Use SQLite storage** - Configure `new_sqlite_classes` in migrations
4. **Initialize in constructor** - Use `blockConcurrencyWhile()` for schema setup only
5. **Use RPC methods** - Not fetch() handler (compatibility date >= 2024-04-03)
6. **Persist first, cache second** - Always write to storage before updating in-memory state
7. **One alarm per DO** - `setAlarm()` replaces any existing alarm

##### Anti-Patterns (NEVER)

- Single global DO handling all requests (bottleneck)
- Using `blockConcurrencyWhile()` on every request (kills throughput)
- Storing critical state only in memory (lost on eviction/crash)
- Using `await` between related storage writes (breaks atomicity)
- Holding `blockConcurrencyWhile()` across `fetch()` or external I/O

##### Stub Creation

```typescript
// Deterministic - preferred for most cases
const stub = env.MY_DO.getByName("room-123");

// From existing ID string
const id = env.MY_DO.idFromString(storedIdString);
const stub = env.MY_DO.get(id);

// New unique ID - store mapping externally
const id = env.MY_DO.newUniqueId();
const stub = env.MY_DO.get(id);
```

##### Storage Operations

```typescript
// SQL (synchronous, recommended)
this.ctx.storage.sql.exec("INSERT INTO t (c) VALUES (?)", value);
const rows = this.ctx.storage.sql.exec<Row>("SELECT * FROM t").toArray();

// KV (async)
await this.ctx.storage.put("key", value);
const val = await this.ctx.storage.get<Type>("key");
```

##### Alarms

```typescript
// Schedule (replaces existing)
await this.ctx.storage.setAlarm(Date.now() + 60_000);

// Handler
async alarm(): Promise<void> {
  // Process scheduled work
  // Optionally reschedule: await this.ctx.storage.setAlarm(...)
}

// Cancel
await this.ctx.storage.deleteAlarm();
```

##### Testing Quick Start

```typescript
import { env } from "cloudflare:test";
import { describe, it, expect } from "vitest";

describe("MyDO", () => {
  it("should work", async () => {
    const stub = env.MY_DO.getByName("test");
    const result = await stub.addItem("test");
    expect(result).toBe(1);
  });
});
```


---

