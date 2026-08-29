---
name: ultimate-postgres-ecosystem
description: Consolidated ultimate skill containing expert knowledge for postgres ecosystem. Use this for all tasks in this domain.
---

# Ultimate Postgres Ecosystem

> **Agent Instruction:** This is a consolidated expert skill. Read the catalog below and apply the specific rules that match the user's request.

## Skill Catalog

### neon
**Description:** >-


#### Neon

Important: Neon is no longer just a Postgres provider. Neon is a complete set of cloud backend primitives built around Lakebase Postgres, for developers, startups, and agent platforms, from Databricks — bundling Lakebase Postgres, Auth (managed Better Auth), long-running Functions, Object Storage, and an AI Gateway, all instant, branchable, and serverless.

**Lakebase Postgres** is the database itself. It is one product, reached two ways: through Neon, with a free plan and the full set of backend primitives above, or through Databricks, alongside the rest of the Databricks suite. Same infrastructure, same features, same engineering team. Call the database Lakebase Postgres, and use "Neon" for the brand and for this access path — not as a name for the database.

A Neon branch is an isolated, copy-on-write clone of your data, taken from its current state or from a past state within your project's retained history window. You can freely modify or delete it. It shares data with its parent until writes cause it to diverge, and those writes are stored independently as deltas.

##### Backend Primitives

Neon bundles several backend primitives for building apps and agents that all branch together:

- **Lakebase Postgres** — Postgres that scales and branches with your app, built on the lakebase architecture: OLTP directly on cloud object storage, with storage decoupled from compute. _Generally available._
- **Auth** — Managed Better Auth with users and sessions stored in Postgres. _Generally available._
- **Object Storage** — S3-compatible object storage that branches with your projects. _Public beta._
- **Functions** — Neon's compute offering: long-running serverless functions that run close to your database, for WebSocket servers, long agent HTTP streams, APIs, and server-sent event servers. _Public beta._
- **AI Gateway** — One API for frontier and open-source models, supporting the chat completions API and the responses API, powered by Databricks Unity AI Gateway. _Public beta._

###### Public Beta Service Availability

Object Storage, Functions, and AI Gateway are in public beta.

Beta access features are only available on projects in the `us-east-2` region. Before guiding a user through any of these services, confirm they are working in `us-east-2`. If not, they will need to create a new project in that region.

##### Architecture: How to Use Neon

Neon is **not** a place to host your app frontend. Neon provides the backend primitives (Lakebase Postgres, Auth, Object Storage, Functions, AI Gateway) that **compose with** the application platform you already use.

Recommended architectures:

**Full-stack app on Vercel** (or Netlify) augmented with Neon — the app framework (Next.js, TanStack Start, etc.) owns your UI and routes and talks directly to your Neon services (Lakebase Postgres, Auth, Object Storage, Functions, AI Gateway).

**Reach for Neon Functions when you outgrow the host's limits** — a WebSocket or SSE server, long-running agents, or an MCP server that risks timing out on short, lambda-style serverless functions. As long as there is an active connection, a Neon Function can run up to 24 hours without interruption, with the added benefit of running close to your data.

**Move your whole backend control plane onto Neon Functions** — especially useful when the frontend is **client-only** rather than full-stack: TanStack Router, React Router in client mode, and similar SPAs hosted on Vercel or Netlify. The client talks **directly to Neon Functions**, where you build REST APIs and request/response agents. Secure these functions like any standalone REST API — verify a JWT or API key at the top of each handler (see the `neon-functions` skill).

Because Functions are just your backend, they compose with a full-stack app that already has one (Next.js route handlers, etc.), too.

##### Neon Documentation

The Neon documentation is the source of truth for all Neon-related information. Always verify claims against the official docs before responding. Neon features and APIs evolve, so prefer fetching current docs over relying on training data.

###### Finding the Right Page

Look the page up before you fetch it — **don't guess URLs!** The docs index lists every available page with its URL and a short description:

```
https://neon.com/docs/llms.txt
```

###### Fetching Docs as Markdown

Any Neon doc page can be fetched as markdown in two ways:

1. **Append `.md` to the URL** (simplest): https://neon.com/docs/introduction/branching.md
2. **Request `text/markdown`** on the standard URL: `curl -H "Accept: text/markdown" https://neon.com/docs/introduction/branching`

Both return the same markdown content. Use whichever method your tools support.

##### Choosing the Right Skill

Neon provides a set of agent skills in addition to the official documentation. When a task matches one of the rows below, work from that skill rather than from this overview. You may have some of these skills already installed, or you may need to install them.

The skills below live in the [`neondatabase/agent-skills`](https://github.com/neondatabase/agent-skills) repo:

| Skill                            | Use it for                                                                                                                                                                           |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `neon-postgres`                  | Working with databases, including connections, schemas, queries, and autoscaling: SQL development, schema design, performance optimization, and scaling decisions.                   |
| `neon-postgres-branches`         | Choosing or creating the right branch type for dev, preview, test, or CI workflows. Use this skill as a slash command.                                                               |
| `neon-object-storage`            | Storing and serving files (uploads, images, blobs), including branching them with the database.                                                                                      |
| `neon-functions`                 | Deploying long-running or streaming serverless functions — APIs, agents, SSE/WebSocket servers.                                                                                      |
| `neon-ai-gateway`                | Calling an LLM or routing across model providers with one credential, including discovering the branch's servable models at runtime via the OpenAI-compatible `/v1/models` endpoint. |
| `neon-postgres-egress-optimizer` | Diagnosing or fixing excessive Postgres egress (network data-transfer) costs in a codebase.                                                                                          |

For guidance on agent platforms that provision and operate Lakebase Postgres on Neon at scale, use `neon-postgres-agent-platforms`, which lives in a separate repo: [`neondatabase/neon-for-agent-platforms`](https://github.com/neondatabase/neon-for-agent-platforms).

###### Installing the Right Skill

First check whether the target skill is already installed and accessible (for example, it appears in the available skills list or its `SKILL.md` is present). If it is, use it directly. If it is not installed, install it via the `skills` CLI, if available, with `npx`/`bunx`:

```bash
npx skills add neondatabase/agent-skills -s <skill-name>
```

Replace `<skill-name>` with the skill you need (for example, `neon-object-storage`, `neon-functions`, or `neon-ai-gateway`). Useful flags:

- `-g` — install globally instead of into the current project.
- `-y` — non-interactive mode (skip prompts).
- `-a <agent-name>` — pick the target agent(s) for non-interactive mode.

For example, to install the object storage skill globally for a specific agent without prompts:

```bash
npx skills add neondatabase/agent-skills -s neon-object-storage -g -y -a <agent-name>
```

If you don't have access to the `skills` CLI, you can visit https://neon.com/.well-known/agent-skills for a registry of all available Neon skills and fetch them manually.

###### Updating Skills

Keep the skills up to date: for every new session, update them so you are working with the latest best practices.

Use the same method that was used to install them. With the `skills` CLI, run the install command above with `update` in place of `add`, or run `npx skills update` to update all Neon skills. If the skills were installed via a plugin, they are updated automatically.

##### Getting Started with Neon

Before `npx neon@latest init --agent`, check whether the CLI is already authenticated:

- `NEON_API_KEY` is set
- `npx neon@latest profile list -o json` lists a profile whose `account` is not `-`

A `DEFAULT` row with `account: "-"` and `file: "missing"` is not an account. If `neon` is not installed, or `npx neon@latest profile list` cannot run, that is not an account.

If none of those hold, follow [Starting without a Neon account](#starting-without-a-neon-account).

The easiest way to get started with Neon is to use our CLI and the project bootstrap wizard:

```bash
npx neon@latest init --agent
```

Use the `--agent` flag to run in a non-interactive, state-machine mode.

This init command will guide you through installation of suggested Neon development tools. Everything is customizable. The defaults are:

- Neon CLI installed globally
- Neon MCP server installed globally
- Neon Agent skills installed into the project

If `init` is run in an empty project, it will run the `bootstrap` command, offering to install one of our project templates.

###### Getting Started with the Neon CLI

**Prefer the CLI over the MCP server** unless the user instructs otherwise, the CLI is unavailable or blocked in your environment, or it is not authenticated, since it provides more capabilities, including deploying Neon Functions.

The above `init` command will install the Neon CLI, but the CLI can also be installed manually with `npm i -g neon` or `bun i -g neon`. For full CLI installation options, see https://neon.com/docs/cli/install.md

####### Useful CLI Commands

These commands are included in the `init` command but can be run manually as needed.

1. `neon link` — Interactively links the workspace to a Neon org, project, and branch, writing the IDs to a git-ignored `.neon` file. Run once per project. Once linked, project- and branch-scoped commands no longer need `--project-id` or `--branch` (for example, `neon branch list`).
2. `neon checkout <branch-name>` — Pins a different branch in `.neon`, creating it if it doesn't exist yet, and pulls that branch's env. It drives the [Branch-First Dev Flow](#branch-first-dev-flow) described below.
3. `neon config init` — Initializes a `neon.ts` file, which declares how you provision and manage Neon services, in the root of the project.
4. `neon env pull` — Fetches the current branch's Neon environment variables (`DATABASE_URL`, …) into your existing `.env`, or `.env.local` if you don't have one (override the target with `--file`). No branch ID needed; it reads `.neon`. **`link` and `checkout` run this for you by default**, so you rarely call it directly.

   Without `neon.ts` it pulls the vars of every service the branch actually has (Postgres, plus Neon Auth, the Data API, and bucket `AWS_*` once provisioned); with `neon.ts` it pulls only the services declared there and errors if the branch is missing one — and the AI Gateway vars are never pulled unless `neon.ts` declares `aiGateway`.

###### Getting Started with the Neon MCP Server

The above `init` command will install the Neon MCP server globally, but it can also be installed manually using: `npx -y add-mcp https://mcp.neon.tech/mcp -g -n Neon -y -a <agent-name>` or through your IDE plugin.

For all available plugins, see: https://neon.com/docs/ai/ai-agents-tools.md

For full MCP server installation options, see https://neon.com/docs/ai/connect-mcp-clients-to-neon.md

Useful MCP tools to initialize a project:

- `list_projects` — Lists the first 10 Neon projects in your account, providing a summary of each project. If you can't find a specific project, increase the limit by passing a higher value to the `limit` parameter.
- `create_project` — Creates a new Neon project in your Neon account. A project acts as a container for branches, databases, roles, and computes.
- `get_connection_string` — Returns your database connection string.

##### Starting without a Neon account

If the Getting Started account check found credentials, use them. If a command waits on a browser (`Awaiting authentication in web browser`) or authentication fails, stop and ask the user to sign in (`neon auth`) or mint an API key. Prefer that over Claimable Neon unless they say otherwise.

If they cannot sign in or provide a key right now, ask before using Claimable Neon. Continue only after they say yes. That is a temporary workaround.

If there is no Neon account yet, follow [references/claimable-neon.md](https://neon.com/docs/ai/skills/neon/references/claimable-neon.md). Do not run `neon init --agent` or `neon auth` on this path; those need a human Neon account. If `neon claim` is missing, the reference has the REST fallback. Unclaimed projects expire at `project_expires_at` (72 hours today). Claim codes expire in `expires_in` (15 minutes today). Add Auth or the Data API with `neon.ts` and `neon deploy` before or after claim.

Requests for neon.new, Claimable Postgres, claimable.neon.tech, instant Postgres, or a no-signup database are the same path.

##### Neon Infrastructure as Code

`neon.ts` is Neon's branch config and infrastructure-as-code file: declare which Neon services your project's branches should have, get type-safe env vars, and program branch settings — all in TypeScript. It's the config layer for your Neon services, and it composes with the branch-first loop below. Add it with `@neon/config`:

```bash
npm i @neon/config
```

```typescript
// neon.ts
import { defineConfig } from "@neon/config/v1";

export default defineConfig({
  preview: {
    aiGateway: true,
    buckets: {
      images: {
        access: "private",
      },
    },
    functions: {
      imagegen: {
        name: "AI SDK image agent",
        source: "src/index.ts",
      },
    },
  },
});
```

###### Provision services with neon config

Every project ships with Lakebase Postgres; `neon.ts` lets you also declare Neon Auth and the Data API today, with Functions, buckets, and the AI Gateway under a `preview` block — every service for the branch composes in one file:

```typescript
// neon.ts
export default defineConfig({
  auth: true,
  dataApi: true,
  preview: {
    functions: {},
    buckets: {},
    aiGateway: true, // see the neon-ai-gateway skill
  },
});
```

Reconcile the declaration from the CLI — the Neon equivalent of `terraform status` / `plan` / `apply`:

```bash
neon status          # print the branch's live config (read-only). Alias for `neon config status`.
neon config plan     # dry-run diff of what apply would change (read-only)
neon deploy          # provision the declared services. Alias for `neon config apply`
```

`apply` / `deploy` provision the declared services **and then pull the branch's env into your local `.env.local`** (e.g. `Pulled 5 Neon variables into .env.local: DATABASE_URL, …`), so your local env always matches what's deployed.

###### Type-safe env vars with parseEnv

`@neon/env`'s `parseEnv` takes your `neon.ts` config object and returns a parsed, typed env object, validated against the services you declared. The shape of `env` follows your config, and missing variables are flagged with clear errors.

```bash
npm i @neon/env
```

```typescript
import { parseEnv } from "@neon/env";
import config from "./neon";

const env = parseEnv(config);

console.log(env.postgres.databaseUrl);
console.log(env.auth.baseUrl);
```

By default `parseEnv` requires _every_ variable your config implies. When one of your apps only uses a subset, for example when you need to read `DATABASE_URL` but never the unpooled URL, pass an array of env-var keys to require and validate only those. The keys are typesafe: autocomplete only offers variables your config enables, and the returned shape is narrowed to exactly what you selected (so unselected variables are neither enforced nor present).

```typescript
import { parseEnv } from "@neon/env";
import config from "./neon";

// Only DATABASE_URL is required and returned; DATABASE_URL_UNPOOLED is not enforced.
const { postgres } = parseEnv(config, ["DATABASE_URL"]);
console.log(postgres.databaseUrl);

// Selecting across services — only these keys are validated.
const env = parseEnv(config, ["DATABASE_URL", "NEON_AUTH_BASE_URL"]);
console.log(env.postgres.databaseUrl, env.auth.baseUrl);
```

###### Branch configuration

Beyond services, `neon.ts` can program what configuration _new_ branches receive via the `branch` property — a function of the branch being evaluated that returns its settings:

```typescript
// neon.ts
import { defineConfig } from "@neon/config/v1";

export default defineConfig({
  auth: true,
  dataApi: true,
  branch: (branch) => {
    if (branch.exists) {
      // leave existing branches untouched
      return {};
    }
    if (branch.name.startsWith("dev")) {
      return {
        ttl: "7d", // clean up the branch after 7 days
        postgres: {
          computeSettings: {
            autoscalingLimitMinCu: 0.25, // scale to zero
            autoscalingLimitMaxCu: 1, // keep it cheap
            suspendTimeout: "5m",
          },
        },
      };
    }
    return {};
  },
});
```

The `branch` function receives the target branch (its `name`, whether it `exists` yet, whether it's the default, and more) and returns the tuning you want. Here new `dev-*` branches get a 7-day TTL so they clean themselves up, plus a cheap scale-to-zero compute profile, while existing branches and everything else fall through to the defaults. Because `neon checkout` applies this policy on create, a fresh `dev-*` branch comes up with these settings already in place.

###### Type-safe config: invalid setups don't compile

Because `neon.ts` is TypeScript, the compiler catches invalid infrastructure before you ever deploy — and Neon encodes the actual rules (and their fixes) into the types, so the error tells you what to do rather than failing with a useless `Type 'true' is not assignable to type 'never'`. The canonical case: the Data API verifies requests with Neon Auth by default, so enabling it on its own is a type error _on_ `dataApi`:

```typescript
export default defineConfig({
  dataApi: true, // type error: `dataApi` (default authProvider 'neon') requires Neon Auth
});
```

The message names both fixes, so pick one:

```typescript
// 1. Enable Neon Auth (the default Data API auth provider):
export default defineConfig({ auth: true, dataApi: true });

// 2. Or verify a third-party IdP instead of Neon Auth:
export default defineConfig({
  dataApi: {
    authProvider: "external",
    jwksUrl: "https://your-idp/.well-known/jwks.json",
  },
});
```

Treat a `neon.ts` type error as the config telling you which services must go together — read the message, it spells out the valid combinations.

See https://neon.com/docs/reference/neon-ts.md for documentation on the `neon.ts` file.

##### Branch-First Dev Flow

Neon branches enable a branch-first development flow, which we recommend when using Neon services. This and `neon.ts` above are the two halves of the recommended setup — `neon.ts` declares what every branch should have, and the branch-first loop is how you move between those branches day to day. Each works on its own, and they compose.

Create a Neon branch any time you would create a git branch. Use the following commands if you have CLI access:

- `neon checkout <branch-name>` — Creates the branch if it doesn't exist, or checks out the existing one, by updating only the branch pointer in `.neon`. Run without a name for an interactive picker. It does not touch code or local Postgres.
- `neon env pull` — Fetches the current branch's Neon environment variables into your `.env` (see [Useful CLI Commands](#useful-cli-commands) above). **`link` and `checkout` run this for you by default**, so you rarely call it directly.
- `neon diff` — Shows the schema diff between the child branch and its parent. Run this to see what changes have been made to the schema since the last branch was created and before you commit your changes.

```bash
neon link                     # once; also pulls the linked branch's env
neon checkout dev-add-search  # per feature; also pulls the branch's env
```

Because `link` and `checkout` pull env by default, the branch's `DATABASE_URL` lands in your local `.env` automatically — build against it, then `checkout` the next branch and repeat. As the agent, drive this loop yourself: run `checkout` between tasks.

###### How checkout composes with neon.ts

When a `neon.ts` is present, `neon checkout` applies your policy as it **creates** a branch, so a fresh branch comes up with its declared settings and services already in place. Checking out an _existing_ branch never reconciles it — apply config changes to it explicitly with `neon config apply` (or `neon deploy`). The bundled `env pull` also checks `neon.ts` against the linked branch and fails fast if the branch is missing a declared service, pointing you at `neon deploy` to provision it, so your local env and the remote branch never drift apart silently.

###### Opting out of local env vars

If env vars are injected at runtime instead of written to disk — or you simply don't want secrets in the working tree — pass `--no-env-pull` to `link` / `checkout` and supply the env another way:

- `neon-env run -- <your dev command>` (from `@neon/env`) fetches the branch's vars from your `neon.ts` and injects them into the child process at runtime — no `.env` file needed. This is the runtime counterpart to the on-disk `env pull`.
- `neon-env export` (from `@neon/env`) prints the branch's env to stdout as dotenv lines or, with `--format json`, JSON — for piping into another env manager rather than running a command. For example, [varlock](https://varlock.dev) can bulk-load it from a `.env.schema` with `@setValuesBulk(exec("neon-env export --format json"), format=json)`.
- `fetchEnv` from `@neon/env` is the programmatic version of the same thing: resolve the branch's env in code at runtime instead of shelling out to `neon-env run`.
- `neon dev` injects the same vars into your local dev server — it's part of Neon Functions local development (a public beta feature).

When an agent should not write a local `.env`, instruct it (for example in your `AGENTS.md`) to run `neon checkout <branch> --no-env-pull` and rely on runtime injection.

For reading env you _already_ have on disk (typed and validated against your `neon.ts`), use `parseEnv` — see [Type-safe env vars with parseEnv](#type-safe-env-vars-with-parseenv) above.

##### Observability

Neon exposes branch-scoped logs. **Today they cover Neon Functions and Object Storage only.** Postgres computes and the AI Gateway are coming; until then, neither emits records. Logs are region-gated like the other beta services above. Only `us-east-2` is enabled today. A branch that can't serve logs at all answers `404` with `reason: telemetry_not_enabled` (the message says whether it's the wrong region or a branch not collecting telemetry yet), versus a `200` empty result when the branch is enabled but has no records in the window; an unknown branch answers `reason: branch_not_found`.

Use Neon CLI 3.1 or newer first. **Decide which branch you are querying.** Without `--branch`, the CLI uses the branch pinned in `.neon`, or the project's default branch when the workspace isn't linked. A deployed function or bucket usually lives on a different branch than the one checked out for development, so an empty result is more often the wrong branch than a missing log.

```bash
neon logs query --since 1h
neon logs query --branch production --source function --minimum-severity error --since 6h
neon logs query --source storage --since 1h --output json
neon logs fields
neon logs field-values service_name --since 1h
```

`--source` accepts `function`, `storage`, and `pg_endpoint`, but only `function` and `storage` return records today — `pg_endpoint` is accepted and comes back empty until Postgres logs ship. The window defaults to 1h on `query` and 6h on `field-values`, and cannot exceed 7d on either. If Neon reports `--minimum-severity` as unsupported on a branch, use `--severity-text` instead (an exact, case-sensitive match, e.g. `ERROR`); severities vary by source, so confirm what a branch carries with `neon logs field-values severity_text`. Run `neon logs --help` for the full filter and pagination interface.

`--logql` replaces the structured filters with a raw stream selector or line filter. Its stream label is `entity_type`, not `source`:

```bash
neon logs query --since 1h --logql '{entity_type="function"} |= "timeout"'
```

If the CLI is unavailable, fall back to the Neon MCP server's read-only `query_logs`, `list_log_fields`, and `list_log_field_values` tools.

In TypeScript applications, use `@neon/sdk`. Project and branch are positional, and `query` returns a lazy paginated iterable rather than a promise:

```typescript
for await (const record of neon.logs.query(projectId, branchId, {
  since: "1h",
  source: "function",
})) {
  console.log(record.timestamp, record.severity_text, record.message);
}

const { data: fields } = await neon.logs.fields(projectId, branchId);
const { data: serviceNames } = await neon.logs.fieldValues(
  projectId,
  branchId,
  "service_name",
);
```

`query`'s iterator always throws on error, but `fields` and `fieldValues` follow the client's `throwOnError`, which defaults to `false` and hands back `{ data, error }`. `fieldValues` resolves to the whole response, not a bare array: read `serviceNames.values`, and treat them as an arbitrary subset whenever `serviceNames.is_truncated` is true.

###### Loki-compatible read API

For direct HTTP reads, authenticate with `Authorization: Bearer <NEON_API_KEY>` and use this branch-scoped base URL:

```text
https://console.neon.tech/telemetry/v1/projects/{projectId}/branches/{branchId}/loki
```

The available endpoints are:

- `GET /api/v1/query_range`
- `GET /api/v1/labels`
- `GET /api/v1/label/{name}/values`

This is a read-only Loki-compatible subset, not a push endpoint or complete Loki deployment. `query_range` supports LogQL stream selectors and line filters, plus `since` or `start`/`end`, `limit`, and `direction`; it does not support aggregations, parsers, or formatting stages.

The paths above are the ones to call directly. A Loki client that builds its own paths — a Grafana data source appends `/loki/api/v1` to whatever URL it is given — may need a different root, so confirm the data-source URL against the Neon docs rather than pasting this base.

##### Manage Neon Resources

Recommended: Use `@neon/sdk` to manage Neon resources programmatically, such as creating projects, branches, and snapshots for dev scripts, CI/CD automations, and platforms building on top of Neon.

`@neon/sdk` is the official TypeScript client for the [Neon API](https://neon.com/docs/reference/api-reference.md): **Fetch-based, zero-dependency, ESM-only**, generated from Neon's [OpenAPI spec](https://neon.com/api_spec/release/v2.json) with an ergonomic layer on top. It is the successor to [`@neondatabase/api-client`](https://www.npmjs.com/package/@neondatabase/api-client) (axios-based, generated-only). The old client is **not deprecated** and is safe to keep using, but new code should prefer `@neon/sdk`.

###### Neon for (Agentic) Platforms

If you're building agents that generate apps from prompts, your users want to build apps, not manage databases. Industry-leading platforms like Replit and V0 create databases on Neon because it aligns with how agents work: an instant, branchable, serverless Lakebase Postgres data layer, invisible to users.

Neon features for agents:

- Instant Provisioning: your users never wait for infrastructure.
- Snapshots: let users toggle between checkpoints of code and state together.
- Low cost-per-Database: automatic scale to zero and 350ms cold starts.
- Full-Stack, Batteries-Included: Neon Auth, Data API included at no added charge.
- Granular API Controls: Track and control usage for flexible limits and invoicing.

All details here: https://neon.com/programs/agents.md

Apply for the Neon Agent Program for special program pricing here: https://neon.com/programs/agents

##### Gotchas

###### Neon Auth: "invalid domain"

Neon Auth only redirects back to domains on its trusted-domains list. Anytime the domain your app runs on changes — a new production custom domain, a new deploy/preview URL, moving from `localhost` to a hosted environment, and so on — you must register the new domain with Neon Auth. Otherwise sign-in and OAuth callbacks fail with an **`invalid domain`** error because the redirect target isn't trusted.

The easiest way to fix this is the CLI. With the workspace linked to the project (see the branch-first flow above), add the new domain to the trusted list:

```bash
neon neon-auth domain add <domain>   # e.g. neon neon-auth domain add https://app.example.com
neon neon-auth domain list           # verify what's currently trusted
neon neon-auth domain delete <domain> # remove one you no longer use
```

If the workspace isn't linked, pass `--project-id <id>` (and `--branch <id|name>`) explicitly. For local development, `neon neon-auth domain allow-localhost` manages whether `localhost` is permitted. Register the domain before pointing users at the new URL, so they never hit the `invalid domain` error.


---

### neon-ai-gateway
**Description:** >-


**FIRST**: Use the parent `neon` skill for a Neon overview, getting started with Neon, Neon development best practices, and more.

If the `neon` skill is not installed, fetch it from https://neon.com/docs/ai/skills/neon/SKILL.md or install it with:

```bash
npx skills add neondatabase/agent-skills --skill neon
```

#### Neon AI Gateway

This is a public beta feature and only available in `us-east-2`.

The Neon AI Gateway is the LLM inference layer built into your Neon branch: one API and one Neon credential give you access to frontier and open-source models from many providers (Anthropic, OpenAI, Google, Meta, and more), all hosted and powered by Databricks. The catalog shifts over time, so treat `/v1/models` and the [models.dev Neon page](https://models.dev/providers/neon) as the source of truth rather than a fixed provider list. Your existing OpenAI/Anthropic/Gemini SDK works by changing only the base URL.

Use this skill to help the user send model calls through the gateway, wire it into the AI SDK or Mastra, and switch providers without rewiring code. Deliver a working inference request, a configured agent, or a precise answer from the official Neon docs.

##### When to Use

Reach for the AI Gateway whenever an app or agent needs to call an LLM and the user would rather not manage model providers themselves:

- **One credential instead of many provider accounts.** A single Neon credential reaches the entire model catalog across every provider Databricks hosts. No separate OpenAI / Anthropic / Google billing, keys, or signups to provision and rotate.
- **Switch models without rewiring.** The unified endpoint is OpenAI-compatible and works with every model in the catalog — change one `model` field to move between Claude, GPT, and Gemini. Standard SDKs (OpenAI, Anthropic, google-genai) work with just a base-URL change.
- **AI follows your branches.** Each branch has its own gateway endpoint, scoped with the same lineage as your database. AI requests from a preview/feature branch are isolated to that branch — the same isolation your data already gets — which makes preview, CI, and agent environments self-contained.
- **No extra infrastructure, and it's already next to your data.** The gateway lives inside your Neon project (and is injected into Neon Functions automatically), runs on the same Databricks infrastructure that serves trillions of tokens a month, and supports streaming (SSE) out of the box.

If the user already has a deep, single-provider integration and no interest in Neon branching or multi-model routing, a direct provider SDK is fine — but the moment they want one credential, model portability, or branch-scoped AI, this is the reason to use it.

##### What It Does

- **One API for all models** — Frontier and open-source models behind a single endpoint, addressed by their catalog ID (e.g. `claude-sonnet-4-6`, `gpt-5-mini`, `gemini-3-flash`).
- **Standard SDKs, one URL change** — OpenAI SDK and AI SDK (OpenAI-compatible MLflow/Responses routes), Anthropic SDK (native Messages), google-genai (native Gemini).
- **Branch-scoped** — Each branch gets its own gateway host; the Neon credential authorizes requests for that branch and its descendants.
- **Streaming** — Server-sent events work on all endpoints with no extra configuration.

##### Availability

Check these preconditions before setting anything up:

The AI Gateway is a public beta feature available in the `us-east-2` region. Foundation model access requires a paid Neon plan. Confirm the user's project is in `us-east-2`.

###### Enabling the gateway: plan and model-catalog gating

The AI Gateway is credential-gated rather than a provisioning step, but two plan/beta limits gate it — one blocks provisioning, the other only trims the catalog — and the CLI surfaces each:

- **Free plan → provisioning is blocked.** `neon config apply` / `deploy` and `neon checkout` **refuse** to enable the gateway on a Free plan (the gateway can't serve requests there), with a friendly "upgrade to a paid plan, or remove `preview.aiGateway`" error. A dry-run `neon config plan` and `neon env pull` don't provision, so they only **warn**. So: to use the gateway the project's account must be on a paid Neon plan.
- **Paid plan with a reduced model catalog.** On a paid plan the gateway provisions and serves, but during the beta an account can start with a trimmed catalog — some flagship models (e.g. Anthropic Opus, OpenAI Codex / `*-pro`) are missing from `GET /v1/models`. This is expected; `neon env pull` (and the env pull bundled into `apply` / `deploy` / `checkout`) warns and links the user to their branch's AI Gateway page in the Neon Console (`https://console.neon.tech/app/projects/<project-id>/branches/<branch-id>/ai-gateway`) to request access to more models. Verify what's actually available for the branch by reading `/v1/models` (see the models section below) rather than assuming the full catalog.

When helping a user debug "the gateway isn't working" or "a model is missing", use `/v1/models` plus the account's plan to distinguish these two cases — a Free plan blocks provisioning entirely, while a reduced catalog on a paid plan just needs a model-access request.

##### Setup

The gateway is part of `neon.ts` (see the `neon` skill for the branch-first workflow and `neon.ts` basics). Enable it under `preview.aiGateway`:

```typescript
// neon.ts
import { defineConfig } from "@neon/config/v1";

export default defineConfig({
  preview: {
    aiGateway: true,
  },
});
```

```bash
neon deploy   # provisions the gateway on the linked branch
```

##### Neon Infrastructure as Code (`neon.ts`)

The `preview.aiGateway` toggle above is part of `neon.ts`, Neon's infrastructure-as-code file — one TypeScript file declares the gateway alongside every other branch service, in version control (see the `neon` skill for the full reference). Reconcile it against a branch the Terraform way:

```bash
neon config status   # print the branch's live config (is the gateway on?)
neon config plan     # dry-run diff of what apply would change
neon config apply    # enable the gateway on the branch  (neon deploy is an alias)
```

The gateway is **branch-scoped**: each branch gets its own gateway host. When a `neon.ts` is present, `neon checkout` applies the policy as it _creates_ a branch, so a fresh preview/CI branch comes up with the gateway already enabled. Checking out an _existing_ branch doesn't reconcile it — run `neon deploy` to apply changes. Provisioning (`config apply` / `deploy`), `link`, and `checkout` also pull the branch's gateway credentials into your local `.env.local`, so local runs hit the same branch gateway as the deployed function (no manual `env pull` needed).

##### Environment Variables

When `preview.aiGateway` is enabled, Neon injects the gateway credentials as **Neon-branded** env vars. Inside a deployed Neon Function these are injected automatically; locally, `neon env pull` writes them to `.env`/`.env.local` (or use `neon-env run -- <cmd>` to inject at runtime without a file):

| Variable                   | Meaning                                                                                                                             |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `NEON_AI_GATEWAY_TOKEN`    | Gateway bearer token (a Neon credential, `nt_live_...`)                                                                              |
| `NEON_AI_GATEWAY_BASE_URL` | **Bare branch gateway host** (`scheme://host`, **no path** — no `/ai-gateway`): `https://<branch-id>-api.ai.<region>.aws.neon.tech` |

> Neon injects **only** these two vars — it does **not** set `OPENAI_API_KEY` / `OPENAI_BASE_URL`. The `@neon/ai-sdk-provider` and Mastra's `neon/<model>` read `NEON_AI_GATEWAY_*` directly (zero config); for the plain OpenAI SDK / `@ai-sdk/openai`, build the client's `apiKey` + `baseURL` from them (shown below), or set your own `OPENAI_*` by hand (`env pull` leaves user-set vars untouched).

`NEON_AI_GATEWAY_BASE_URL` is the **bare host** — you append the dialect path yourself (which is exactly what the `@neon/ai-sdk-provider` does for you). The routes under the host are:

- `/v1` — unified, OpenAI **Chat Completions**-compatible; recommended default, works with every provider (`/v1/chat/completions`).
- `/openai/v1` — OpenAI **Responses** API (required for `gpt-5-…-codex` variants and `gpt-5-5-pro`); the `@ai-sdk/openai` provider uses the Responses API by default (`/openai/v1/responses`).
- `/anthropic` — native Anthropic Messages (extended thinking, prompt caching). Give the Anthropic SDK this as its base URL and it appends `/v1/messages` itself, so the full request path is `/anthropic/v1/messages`.
- `/gemini` — native Gemini `generateContent`. Give google-genai this as its base URL and it appends `/v1beta/models/<model>:generateContent` itself, so the full request path is `/gemini/v1beta/models/<model>:generateContent`.

So `${NEON_AI_GATEWAY_BASE_URL}/v1` is the chat-completions endpoint and `${NEON_AI_GATEWAY_BASE_URL}/openai/v1` the OpenAI Responses endpoint (both appended by you); for the native Anthropic and Gemini dialects you hand the SDK the shorter `/anthropic` or `/gemini` base and it appends the rest. See [Use with Plain SDKs](#use-with-plain-sdks-lower-level) below.

For typed, validated access to the injected credentials, pass the same `neon.ts` config object to `parseEnv` from `@neon/env` — it returns an `env.aiGateway` namespace (`apiKey`, `baseUrl`) derived from your config.

##### Build Agents with the Vercel AI SDK (Recommended)

The [Vercel AI SDK](https://ai-sdk.dev) is the recommended way to call the gateway and build agents from TypeScript: one set of primitives (`generateText`, `streamText`, tool calling, structured output) over every catalog model, with first-class streaming for the long agent responses Neon Functions are built to host.

The dedicated `@neon/ai-sdk-provider` reads `NEON_AI_GATEWAY_BASE_URL` + `NEON_AI_GATEWAY_TOKEN` from the injected env with **zero config** and routes each model to the best endpoint (Anthropic → Messages, OpenAI/Codex → Responses, everything else → MLflow). On a Neon Function that streams text and generates images, just pick a catalog model:

```typescript
import { neon } from "@neon/ai-sdk-provider";
import { streamText } from "ai";

const result = streamText({
  model: neon("gpt-5-mini"), // or claude-sonnet-4-6, gemini-3-flash, ...
  messages,
  tools: {
    image_generation: neon.tools.imageGeneration({
      outputFormat: "jpeg",
      size: "1024x1024",
    }),
  },
});
return result.toUIMessageStreamResponse();
```

A single completion is the same provider with `generateText`:

```typescript
import { neon } from "@neon/ai-sdk-provider";
import { generateText } from "ai";

const { text } = await generateText({
  model: neon("claude-haiku-4-5"), // or gpt-5-3-codex, gemini-3-flash, ...
  prompt: "Summarize Postgres for me.",
});
```

> Prefer `@neon/ai-sdk-provider` over the bare `@ai-sdk/openai` `openai()`: Neon injects only `NEON_AI_GATEWAY_*`, not `OPENAI_*`, so `openai()` won't pick up the gateway from the env on its own. If you do use `@ai-sdk/openai`, configure it explicitly with `createOpenAI({ apiKey: process.env.NEON_AI_GATEWAY_TOKEN, baseURL: `${process.env.NEON_AI_GATEWAY_BASE_URL}/openai/v1` })`.

To build an **agent** — a model that calls tools in a loop and then answers — add `tools` and a `stopWhen` budget. The loop runs in-process, so on a Neon Function it isn't cut off by lambda-style timeouts:

```typescript
import { neon } from "@neon/ai-sdk-provider";
import { generateText, tool, stepCountIs } from "ai";
import { z } from "zod";

const { text } = await generateText({
  model: neon("claude-sonnet-4-6"),
  prompt: "How many open todos do I have, and what's the oldest one?",
  tools: {
    listTodos: tool({
      description: "List the user's open todos.",
      inputSchema: z.object({}), // AI SDK v5+: `inputSchema`, not `parameters`
      execute: async () => db.select().from(todos),
    }),
  },
  stopWhen: stepCountIs(5), // let the model call tools, then summarize
});
```

For a full AI SDK agent deployed as a Neon Function (streaming, tool calling, image generation, persistence), see the `neon-functions` skill's `references/ai-sdk.md`.

##### Build Agents with Mastra (Recommended)

[Mastra](https://mastra.ai) is the recommended framework when you want batteries-included agents — built-in memory, tools, workflows, and tracing — with the model still pointed at the gateway. With `@mastra/core` 1.47+, use a `neon/<model>` magic string; Mastra reads `NEON_AI_GATEWAY_BASE_URL` and `NEON_AI_GATEWAY_TOKEN` from the environment (injected by `neon deploy` when `preview.aiGateway` is enabled). Use `parseEnv` only for other declared services (e.g. `env.postgres.databaseUrl` for `@mastra/pg` memory):

```typescript
import { Agent } from "@mastra/core/agent";
import { parseEnv } from "@neon/env";
import config from "../neon";

const env = parseEnv(config);

export const personalAssistant = new Agent({
  id: "personal-assistant",
  name: "personal-assistant",
  instructions:
    "You are a warm, concise personal assistant with long-term memory.",
  model: "neon/claude-haiku-4-5",
  memory, // your Mastra memory store, e.g. @mastra/pg on env.postgres.databaseUrl
});
```

##### Use with Plain SDKs (Lower-Level)

When you don't need an agent framework — a single completion, an existing provider-SDK integration, or native provider features — call the gateway with the plain SDKs. Neon injects the `NEON_AI_GATEWAY_*` vars (not `OPENAI_*`), so set the client's `apiKey` + `baseURL` from them. For the OpenAI **Responses** dialect (`/openai/v1`):

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  apiKey: process.env.NEON_AI_GATEWAY_TOKEN,
  baseURL: `${process.env.NEON_AI_GATEWAY_BASE_URL}/openai/v1`,
});

const res = await client.responses.create({
  model: "gpt-5-mini", // swap to claude-sonnet-4-6, gemini-3-flash, ...
  input: "What is Neon?",
});
```

For the unified **chat-completions** dialect, point `baseURL` at `/v1` instead:

```typescript
const client = new OpenAI({
  apiKey: process.env.NEON_AI_GATEWAY_TOKEN,
  baseURL: `${process.env.NEON_AI_GATEWAY_BASE_URL}/v1`,
});

const res = await client.chat.completions.create({
  model: "claude-sonnet-4-6",
  messages: [{ role: "user", content: "What is Neon?" }],
});
```

The Anthropic SDK and google-genai work the same way for native provider features — point the Anthropic SDK at `${NEON_AI_GATEWAY_BASE_URL}/anthropic` (it appends `/v1/messages` itself) and google-genai at `${NEON_AI_GATEWAY_BASE_URL}/gemini` (it appends `/v1beta/models/...`).

##### Model Identifiers

Use a model's catalog ID directly in the `model` field — e.g. `claude-sonnet-4-6`, `gpt-5-mini`, `gemini-3-flash`. No provider prefix is needed. To look up the exact identifiers the gateway serves, which underlying model each maps to, and their context windows, pricing, and capabilities, use any of:

- **models.dev Neon provider page: https://models.dev/providers/neon** — the canonical, always-current list of the Neon provider's model IDs and their underlying models. The machine-readable catalog is at https://models.dev/api.json (the `neon` key).
- **Models doc:** see Further Reading.

##### List Available Models at Runtime (`/v1/models`)

The gateway also exposes the model catalog **live from your own branch endpoint**, so an app or agent can discover exactly which models this branch serves without hard-coding the list. It is an OpenAI-compatible list endpoint, served **only on the unified dialect** (`/v1`):

```bash
curl "$NEON_AI_GATEWAY_BASE_URL/v1/models" \
  -H "Authorization: Bearer $NEON_AI_GATEWAY_TOKEN"
```

- `GET ${NEON_AI_GATEWAY_BASE_URL}/v1/models` → **200**
- `GET ${NEON_AI_GATEWAY_BASE_URL}/openai/v1/models` → **404** (not served on the Responses dialect — use `/v1`)

**Getting the credentials for the request.** Both values come from the same branch-scoped Neon credential the gateway uses everywhere else — you never manage a provider key:

- **Provision via `neon.ts` (recommended).** Enable `preview.aiGateway` in `neon.ts` and run `neon deploy` (or `neon config apply`). Provisioning, `neon link`, and `neon checkout` pull `NEON_AI_GATEWAY_TOKEN` + `NEON_AI_GATEWAY_BASE_URL` into your local `.env.local`; inside a deployed Neon Function they're injected automatically. See **Setup** and **Environment Variables** above.
- **Pull into the environment via CLI.** `neon env pull` writes the two vars to `.env`/`.env.local`, or `neon-env run -- <cmd>` injects them at runtime without a file — but only when `neon.ts` declares `preview.aiGateway`; the vars are never pulled off branch state alone.
- **Provision via the Console UI.** Enable the AI Gateway on the branch in the Neon Console and copy the branch's gateway base URL and a Neon credential (token) from the project's connection/credentials view.

Any Neon credential (`nt_live_...`) valid for the branch works as the bearer token; `NEON_AI_GATEWAY_BASE_URL` is the bare branch host (no path).

**Response shape** — OpenAI/OpenRouter-compatible list:

```jsonc
{
  "object": "list",
  "data": [
    {
      "id": "claude-sonnet-4-6",              // catalog model ID — use directly in the `model` field
      "canonical_slug": "claude-sonnet-4-6",
      "name": "Claude Sonnet 4.6",            // human-readable display name
      "object": "model",
      "owned_by": "anthropic",                // provider slug, e.g. anthropic | openai | google | meta | alibaba | databricks | ... (non-exhaustive; read live)
      "created": 0,
      "enabled": true,
      "context_length": null,
      "architecture": {
        "modality": "text->text",
        "input_modalities": ["text"],
        "output_modalities": ["text"],
        "tokenizer": "Claude",                // Claude | Gemini | GPT | "" (empty for open-source)
        "instruct_type": null
      },
      "top_provider": {
        "is_moderated": false,
        "context_length": null,
        "max_completion_tokens": null
      },
      "pricing": null,
      "per_request_limits": null
    }
    // ... one entry per model in the branch's catalog
  ]
}
```

> Note: `context_length`, `pricing`, and `per_request_limits` are currently `null` and `created` is `0` for every entry — for context windows, pricing, and capabilities use the models.dev catalog above. Use `/v1/models` when you need the live, branch-scoped list of servable model IDs (e.g. to populate a model picker or validate a `model` before a request).

##### Neon Documentation

The Neon documentation is the source of truth and the AI Gateway is evolving rapidly, so always verify against the official docs. Any doc page can be fetched as markdown by appending `.md` to the URL or by requesting `Accept: text/markdown`. Find the right page from the docs index (https://neon.com/docs/llms.txt) and the changelog announcements.

##### Further Reading

- https://neon.com/docs/ai-gateway/overview.md
- https://neon.com/docs/ai-gateway/get-started.md
- https://neon.com/docs/ai-gateway/models.md
- https://neon.com/docs/ai-gateway/chat-completions.md
- https://neon.com/docs/ai-gateway/anthropic-messages.md
- https://neon.com/docs/ai-gateway/openai-responses.md
- https://neon.com/docs/ai-gateway/gemini.md
- https://neon.com/docs/ai-gateway/authentication.md
- https://neon.com/docs/ai-gateway/troubleshooting.md


---

### neon-functions
**Description:** >-


**FIRST**: Use the parent `neon` skill for a Neon overview, getting started with Neon, Neon development best practices, and more.

If the `neon` skill is not installed, fetch it from https://neon.com/docs/ai/skills/neon/SKILL.md or install it with:

```bash
npx skills add neondatabase/agent-skills --skill neon
```

#### Neon Functions

This is a public beta feature and only available in `us-east-2`.

Neon Functions are long-running Node.js HTTP handlers deployed onto a Neon branch. Each function gets a public HTTPS URL, runs in the same region as your database, and — if the branch has Postgres — gets `DATABASE_URL` injected automatically. You deploy and manage them through the same Neon CLI, `neon.ts`, and API you already use.

Use this skill to help the user define, run locally, deploy, and manage functions next to their database. Deliver a deployed function with its invocation URL, a working local `neon dev` loop, or a precise answer from the official Neon docs.

##### When to Use

Reach for Neon Functions when the workload is a request/response handler that benefits from staying alive and staying close to the data:

- **Long-running request/response flows that outlast lambda-style limits.** Agents that make several LLM calls and tool invocations per request, or image/video generation, routinely blow past the ~10–60s execution caps and short streaming windows of traditional serverless functions. Neon Functions are long-running: the handler just needs to _start_ responding within 15 minutes, and an open stream stays alive as long as bytes keep flowing. That's enough headroom for real agent workloads.
- **Stateful streaming without bolting on Redis.** Because a function stays alive across a request, it can host an SSE endpoint or a WebSocket server and hold the connection open in-process — no external state store (Redis, etc.) needed just to keep a stream coherent. Module-scope state (a `pg` pool, an in-memory counter) persists across requests on the same isolate.
- **Compute that must sit next to Postgres.** The function runs in the same region as the branch's database, so there are no cross-region round trips on every query. `DATABASE_URL` is injected for you.
- **A backend that branches with your data.** Each branch runs its own version of the function at its own URL, against its own isolated database (and storage, and gateway) state. Preview deployments, CI, and dev environments each get a self-contained backend — deploying to a child never affects the parent.
- **Webhooks, bots, and post-response work.** Webhook handlers that fan out into multiple DB writes, Discord/WebSocket bots, and fire-and-forget follow-ups via `waitUntil` (analytics, audit logs) all fit.

If the workload is a pure static site, a cron/background job that needs its own lifecycle and cancellation, or something that must run outside `us-east-2` today, this isn't the right tool yet (see [Timeouts and Runtime Limits](#timeouts-and-runtime-limits) and [Availability](#availability)).

##### What It Does

- **Long-running & serverless** — Built for WebSocket servers (see [WebSocket Servers](#websocket-servers)), SSE endpoints (see [Server-Sent Events (SSE)](#server-sent-events-sse)), long agent HTTP streams, and APIs. Still scales to zero when idle.
- **Web-standard handler** — A function is any default export with a `fetch(request)` method returning a `Response` (Workers/WinterTC-compatible). A Hono app exports exactly that shape, so `export default app` just works. Runs on Node.js 24, so all Node APIs are available.
- **Close to your database** — Runs in the branch's region; `DATABASE_URL` injected automatically when the branch has Postgres.
- **Branchable** — Each branch runs its own function version at its own URL against its own isolated state.
- **Same CLI/API** — Deploy and manage via `neon`, `neon.ts`, or the Neon API.

##### Availability

Check this precondition before setting anything up: Neon Functions is a public beta feature available in the `us-east-2` region. Confirm the user's Neon project is in `us-east-2`. Functions usage isn't billed during the public beta.

##### Architecture: Where Functions Fit

Neon (Functions included) is **backend primitives, not full-stack app hosting**. Host your app on **Vercel** (or Netlify, or another frontend/app host); Functions are the long-running, stateful slice of your backend that lives next to your data. They compose with that platform in two ways:

- **Add a Function to a full-stack app.** Your Next.js / TanStack Start app on Vercel (or Netlify) owns UI, auth (e.g. Neon Auth), and talks directly to Lakebase Postgres and Object Storage. When one workload outgrows the host's short serverless limits — a WebSocket or SSE server, or a long-running agent that would time out — move just that piece onto a Neon Function. (See [Functions as an Agent Backend](#functions-as-an-agent-backend-nextjs-and-similar-frameworks) for the client-direct pattern.)
- **Run the whole backend control plane on Functions.** Especially when the frontend is **client-only** — TanStack Router, React Router in client mode, and similar SPAs hosted on Vercel or Netlify — the client calls Functions **directly**. Build REST APIs and request/response agents, host **MCP servers**, and run anything stateful or that belongs close to Postgres and Object Storage.

Either way, secure a Function like any standalone REST API: verify a JWT or API key at the top of the handler (see the WARNING under [Functions as an Agent Backend](#functions-as-an-agent-backend-nextjs-and-similar-frameworks)). Because a Function is just your backend, you can **move pieces between your host and Neon** — relocate an agent or a stateful WebSocket server onto a Function when it needs more runtime, and back if needed.

##### Setup

Functions are declared in `neon.ts` (see the `neon` skill for the branch-first workflow and `neon.ts` basics). Add `@neon/config` and declare functions under `preview.functions`, keyed by **slug**:

```typescript
// neon.ts
import { defineConfig } from "@neon/config/v1";

export default defineConfig({
  preview: {
    functions: {
      todos: {
        // slug: ^[a-z0-9]{1,20}$ — lowercase letters/digits, no hyphens
        name: "todo api", // display label only
        source: "src/index.ts", // entry file, relative to neon.ts
      },
    },
  },
});
```

The slug is the function's permanent identity (it appears in the invocation URL and CLI commands) and can't be changed after the first deploy. Use `name` for a human-readable label.

A minimal function — a Hono app that queries the branch's Postgres via the injected `DATABASE_URL`:

```typescript
// src/index.ts
import { Hono } from "hono";
import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import { parseEnv } from "@neon/env";
import { attachDatabasePool } from "@neon/functions";
import config from "../neon";
import { todos } from "./db/schema";

const env = parseEnv(config);
const pool = new Pool({ connectionString: env.postgres.databaseUrl, max: 5 });
attachDatabasePool(pool);
const db = drizzle(pool);

const app = new Hono();
app.get("/", (c) => c.text("Neon + Hono + Drizzle"));
app.post("/todos", async (c) => {
  const { text } = await c.req.json<{ text: string }>();
  const [row] = await db.insert(todos).values({ text }).returning();
  return c.json(row, 201);
});
app.get("/todos", async (c) => c.json(await db.select().from(todos)));

export default app;
```

Create the `pg` pool at module scope (reused across requests on the same isolate) and keep `max` small (e.g. 5), since each isolate keeps its own pool. Call `attachDatabasePool(pool)` so an idle disconnect is not an `uncaughtException` — see [Connecting to Postgres](#connecting-to-postgres).

`parseEnv(config)` requires _every_ variable the config implies. A function that only talks to Postgres over the pooled URL can scope it to just that key — `parseEnv` then validates and returns only what you asked for (the keys autocomplete from your `neon.ts`):

```typescript
const { postgres } = parseEnv(config, ["DATABASE_URL"]); // not the unpooled URL, auth, etc.
const pool = new Pool({ connectionString: postgres.databaseUrl, max: 5 });
attachDatabasePool(pool);
```

##### Develop Locally and Deploy

```bash
neon dev      # serves every function in neon.ts with hot reload; injects DATABASE_URL & friends
neon deploy   # bundles with esbuild, uploads, and applies neon.ts to the linked branch
```

To deploy a single function without `neon.ts`: `neon functions deploy <slug> --src src/index.ts` (`--src` takes either the entry file or a directory containing `index.ts`, `index.mjs`, or `index.js`). Retrieve the public URL with `neon functions get <slug>` (the `invocation_url` field, of the form `https://<branch_id>-<slug>.compute.<cell>.us-east-2.aws.neon.tech`). Manage with `neon functions list|get|delete`.

When `neon checkout` _creates_ a new branch and a `neon.ts` is present, it applies the policy automatically — deploying the function to the fresh branch. Checking out an existing branch does not re-deploy; run `neon deploy` explicitly.

##### Neon Infrastructure as Code (`neon.ts`)

The `preview.functions` block from [Setup](#setup) is part of `neon.ts`, Neon's infrastructure-as-code file — one TypeScript file declares every function (its `source`, display `name`, and `env`) alongside any other branch services, in version control (see the `neon` skill for the full reference). Treat it like Terraform for your branch:

```bash
neon config status   # print the branch's live config (deployed functions)
neon config plan     # dry-run diff of what apply would change
neon config apply    # bundle + deploy the declared functions  (neon deploy is an alias)
```

Functions are **branch-scoped**: each branch runs its own deployment at its own URL. When a `neon.ts` is present, `neon checkout` applies the policy as it _creates_ a branch, so a fresh preview/CI branch comes up with the function already deployed. Checking out an _existing_ branch doesn't redeploy — run `neon deploy` to apply changes.

Per-branch deploy tuning (e.g. `runtime`) lives in the `branch` closure, keyed by slug, so it can vary by branch without changing which functions exist:

```typescript
export default defineConfig({
  preview: {
    functions: { todos: { name: "todo api", source: "src/index.ts" } },
  },
  branch: (branch) => ({
    preview: { functions: { todos: { runtime: "nodejs24" } } },
  }),
});
```

##### Environment Variables

Neon injects branch-scoped connection strings and service URLs at runtime — you don't declare these or pass them at deploy time:

| Variable                | Notes                                                                                              |
| ----------------------- | -------------------------------------------------------------------------------------------------- |
| `NEON_BRANCH`           | The branch **name** (e.g. `main`, `preview/foo`). Injected on every branch, including the default. |
| `DATABASE_URL`          | Pooled connection string. Use for most queries. Present only if the branch has Postgres.           |
| `DATABASE_URL_UNPOOLED` | Direct connection. Use for migrations, `LISTEN`/`NOTIFY`, multi-round-trip transactions.           |
| `NEON_AUTH_BASE_URL`    | Present when Neon Auth is enabled on the branch.                                                   |
| `NEON_DATA_API_URL`     | Present when the Data API is enabled on the branch.                                                |

Object storage (`AWS_*`) and AI Gateway (`NEON_AI_GATEWAY_*`) vars are also injected when those services are declared — see the `neon-object-storage` and `neon-ai-gateway` skills.

`neon env pull` / `neon-env run` / `neon dev` emit `NEON_BRANCH` (and the connection strings) into your local dev environment too, so local runs mirror the deployed runtime.

**Your own secrets** are per-deployment. Set them with `--env KEY=VALUE` on `neon functions deploy` (repeatable; `--env KEY=` deletes a key, unmentioned keys carry over), or declare them in `neon.ts` under the function's `env` (resolved at deploy time, so read from `process.env` to avoid hardcoding):

```typescript
functions: {
  todos: {
    name: "todo api",
    source: "src/index.ts",
    env: { RESEND_API_KEY: process.env.RESEND_API_KEY! },
  },
}
```

Load a `.env` before deploy with `neon deploy --env .env.production`. Pull the branch's Neon-managed vars onto disk for local dev with `neon env pull` (`link`/`checkout` do this automatically; pass `--no-env-pull` to skip and use `neon-env run -- <cmd>` for runtime injection). Limits: ≤1,000 vars, ≤64 KiB total, and the `NEON_` prefix is reserved.

##### Connecting to Postgres

When the branch has Postgres, Neon **injects the connection strings at runtime** — you don't declare them, pass them at deploy time, or hardcode anything. The two you'll use:

- `DATABASE_URL` — **pooled** connection string (routed through Neon's connection pooler). Use it for normal request/response query traffic. Kept un-prefixed because every Postgres ORM (Drizzle, Prisma, Knex, …) reads `DATABASE_URL` by default.
- `DATABASE_URL_UNPOOLED` — **direct** connection string to the same database. Use it for migrations, `LISTEN`/`NOTIFY`, and long multi-statement transactions.

**Use Drizzle (or another ORM) on top of node-postgres (`pg`)** for queries and schema management — not Neon's serverless driver. Functions are long-running and reuse an isolate across many requests, so a persistent `pg` pool is the right fit; the serverless driver's HTTP transport is meant for fully isolated, lambda-style runtimes.

Create the connection pool **once at module scope** and reuse it across requests — don't open a connection per request:

```typescript
import { attachDatabasePool } from "@neon/functions";
import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";

const pool = new Pool({ connectionString: process.env.DATABASE_URL, max: 5 });
attachDatabasePool(pool);
const db = drizzle(pool);
```

node-postgres emits idle-client failures as `error` on the pool. With no listener that is an `uncaughtException` and Node exits the isolate. Call `attachDatabasePool(pool)` once after `new Pool`. Requires `@neon/functions` ≥ 0.8.0. Expected idle disconnects (`ECONNRESET`, `EPIPE`, `ETIMEDOUT`, Postgres `57P01`, node-postgres's `Connection terminated unexpectedly`) are silent. Anything else is `console.error`, or `onUnexpectedError` if you pass it on the first call. The first call wins; a later call that passes `onUnexpectedError` is ignored and warns. This does not close the pool.

**Pooling is recommended because an isolate is reused across many requests** (and several requests can be in flight on the same isolate at once — see [Timeouts and Runtime Limits](#timeouts-and-runtime-limits)). A module-scope pool is opened once on cold start and then shared by every subsequent request that isolate serves, so you amortize connection setup instead of paying it on every request and you avoid exhausting Postgres connections under load.

Keep `max` small (e.g. `5`): each isolate keeps its own pool, so total connections to Postgres scale with the number of live isolates. You don't need to close the pool on shutdown — when the runtime evicts an isolate it sends `SIGINT`/`SIGTERM`, and Neon's pooler reclaims those connections for you, so an explicit drain handler is redundant.

> Reading `process.env.DATABASE_URL` directly works everywhere. The function in [Setup](#setup) instead uses `@neon/env`'s `parseEnv(config)` to read the same value in a typed, validated way — either is fine.

##### Timeouts and Runtime Limits

Functions are long-running but **still serverless** — they are a request/response runtime, not a background job runner. The hard limits:

- **Time to first byte: 15 minutes.** Your handler must _begin_ returning a response within 15 minutes of receiving a request. Most handlers finish in seconds; the 15-minute ceiling exists so agent workloads like image/video generation have room.
- **Heartbeat: 15 minutes.** Open WebSocket/SSE connections stay alive as long as data flows. The timeout only fires when a connection goes silent — send at least one byte every 15 minutes to keep a quiet stream alive.
- **`waitUntil`: 15 minutes.** Work registered with `waitUntil` (from `@neon/functions`) keeps the invocation alive after the response is sent, up to 15 minutes — for cleanup like analytics writes and audit logs, **not** a background job runner. Off the Neon runtime (local `neon dev`, tests) it's a no-op: the promise still runs but isn't tracked.
- **Idle eviction.** With no active connections Neon shuts the function down; it may also evict/restart for operational reasons — e.g. maintenance, or moving the function to a different compute node (active functions can run for hours first). Treat eviction like a process restart — WebSocket/SSE clients must reconnect. Neon sends `SIGINT` before evicting, so a `process.on("SIGINT", ...)` handler lets you detect that the function is about to be evicted and run any last-minute cleanup. You don't need one just to close Postgres connections — Neon's pooler reclaims those on its own.
- **Runtime:** Node.js 24, memory fixed at 2048 MiB during the preview. Slugs must match `^[a-z0-9]{1,20}$`. **An isolate is reused across many requests** — multiple requests can be in flight on the same isolate at once (interleaved on Node's single-threaded event loop), and under load the runtime runs several isolates in parallel, each with its own copy of module state. State held in module scope is therefore per-isolate (shared by every request that isolate handles) and in-memory only — persist anything that must survive eviction in Postgres. This reuse is exactly why you create a connection pool once at module scope rather than per request (see [Connecting to Postgres](#connecting-to-postgres)).

##### Functions as an Agent Backend (Next.js and Similar Frameworks)

A Neon Function is a great home for an AI agent precisely because it **doesn't time out** the way lambda-style serverless does (15-minute budget, see [Timeouts and Runtime Limits](#timeouts-and-runtime-limits)). But that advantage disappears the moment you **proxy the agent stream through your web app's backend** — a Next.js route handler, Remix/SvelteKit/Nuxt action, etc. hosted on Vercel, Netlify, Cloudflare, and the like. Those platforms cap serverless/edge execution at short windows (often ~10–60s, sometimes up to ~300s), so a long agent or image/video generation stream gets cut off mid-response even though the Neon Function would happily keep going.

**Building the agent itself.** The [Vercel AI SDK](https://ai-sdk.dev) and [Mastra](https://mastra.ai) are the recommended ways to build the agent — point either at the Neon AI Gateway (see the `neon-ai-gateway` skill) for one credential across every model, with no extra provider keys. For a complete AI SDK agent running as a Function (streaming `toUIMessageStreamResponse`, multi-step tool calling next to Postgres, and persisting generated images to Object Storage), see [references/ai-sdk.md](https://neon.com/docs/ai/skills/neon-functions/references/ai-sdk.md); for the Mastra equivalent with built-in tracing, see [references/mastra-studio.md](https://neon.com/docs/ai/skills/neon-functions/references/mastra-studio.md).

**The fix: call the function directly from the client.** Don't route the long request through your app server.

```
Browser ──(Authorization: Bearer <JWT>)──▶  Neon Function (agent)   ✅ no host timeout
Browser ──▶ your app backend ──▶ Neon Function                       ❌ host cuts the stream
```

- Mint a **short-lived JWT** on your app backend (e.g. better-auth's `jwt` plugin, NextAuth, or your own signer) — that call is fast and well within host limits.
- Hand the token to the client and have it call the Neon Function **directly** (cross-origin), e.g. with the Vercel AI SDK: `new DefaultChatTransport({ api: NEON_FUNCTION_URL, fetch })` where `fetch` attaches `Authorization: Bearer <token>`. Your app server is never in the path of the long stream.
- Add **CORS** so the browser can reach it (handle `OPTIONS`, set `Access-Control-Allow-Origin`/`-Headers`).

> [!WARNING]
> A Neon Function has a **public HTTPS URL — it is reachable by anyone.** A direct client→function call means there is no app backend in front of it to gate access, so **you must authenticate the function yourself.** Verify a JWT (e.g. against your app's JWKS), check a shared secret / API key, or validate a session token at the top of the handler and reject anything else. Never deploy an unauthenticated agent.

```typescript
// src/index.ts — verify the caller before doing any work
import { createRemoteJWKSet, jwtVerify } from "jose";

const jwks = createRemoteJWKSet(
  new URL(`${process.env.AUTH_BASE_URL}/api/auth/jwks`),
);

export default {
  async fetch(request: Request) {
    if (request.method === "OPTIONS")
      return new Response(null, { status: 204, headers: cors(request) });

    const auth = request.headers.get("authorization");
    if (!auth?.toLowerCase().startsWith("bearer ")) {
      return new Response("Unauthorized", {
        status: 401,
        headers: cors(request),
      });
    }
    try {
      const { payload } = await jwtVerify(auth.slice(7), jwks, {
        issuer: process.env.AUTH_BASE_URL,
        audience: process.env.AUTH_BASE_URL,
      });
      const userId = payload.sub; // scope the agent to this user
      // ... run the agent, return result.toUIMessageStreamResponse({ headers: cors(request) })
    } catch {
      return new Response("Unauthorized", {
        status: 401,
        headers: cors(request),
      });
    }
  },
};
```

Pass the JWKS/issuer URL to the function via its `env` (see [Environment Variables](#environment-variables)). Persist anything you need to keep (generated images, history) in Postgres — module state doesn't survive eviction.

##### WebSocket Servers

A WebSocket server is the canonical Functions workload: a long-running handler holds connections open in-process, with no external state store needed to keep a stream coherent. The connection stays alive as long as bytes flow (15-minute heartbeat, see [Timeouts](#timeouts-and-runtime-limits)).

**Upgrade from inside `fetch`.** Call `upgradeWebSocket(request)` from [`@neon/functions`](https://www.npmjs.com/package/@neon/functions) and return the response it gives you. There is one entrypoint and no WebSocket dependency to install:

```typescript
import { upgradeWebSocket } from "@neon/functions";

export default {
  async fetch(req: Request): Promise<Response> {
    if (req.headers.get("upgrade")?.toLowerCase() !== "websocket") {
      return new Response("expected a websocket upgrade", { status: 426 });
    }

    const { socket, response } = upgradeWebSocket(req);
    socket.addEventListener("message", (event) => socket.send(event.data));
    return response;
  },
};
```

`socket` is a standard [`WebSocket`](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket), so `addEventListener` and the `onopen`/`onmessage`/`onclose`/`onerror` properties both work. It is still `CONNECTING` when you get it — the runtime writes the `101` only once your handler returns `response`, and the socket opens then.

Three rules that matter:

- **Return `response` unchanged.** A `101` can't be built as a plain `Response` (the fetch spec caps constructed responses at 200–599), so the runtime hands back an object carrying the pending upgrade. `clone()`, or rebuilding it with `new Response(res.body, res)` as response-rewriting middleware does, discards the upgrade and fails the request.
- **Refuse a handshake by returning an ordinary `Response`.** A `401`, `403` or `404` is relayed to the client as-is. That is how you gate a socket.
- **`binaryType` defaults to `"arraybuffer"`**, not the browser's `"blob"`. `event.data` is a `string` for text frames and an `ArrayBuffer` for binary ones, so branch on `typeof`.

**With auth.** Browsers can't set headers on a WebSocket, so authenticate with a `?token=` query param (verify it the same way as the [agent backend](#functions-as-an-agent-backend-nextjs-and-similar-frameworks): `jwtVerify` against your JWKS) and refuse before upgrading:

```typescript
// src/index.ts
import { upgradeWebSocket } from "@neon/functions";

const clients = new Set<WebSocket>();

export default {
  async fetch(request: Request): Promise<Response> {
    if (request.headers.get("upgrade")?.toLowerCase() !== "websocket") {
      return new Response("WebSocket endpoint — connect with ?token=<jwt>");
    }

    const url = new URL(request.url);
    const identity = await verifyToken(url.searchParams.get("token"));
    if (!identity) return new Response("unauthorized", { status: 401 });

    const { socket, response } = upgradeWebSocket(request);
    clients.add(socket);
    socket.addEventListener("close", () => clients.delete(socket));
    socket.addEventListener("message", (event) => {
      if (typeof event.data !== "string") return;
      persist(identity.id, event.data); // fan out to every isolate — see below
    });
    return response;
  },
};
```

**Subprotocols.** Pass `{ protocol }` to select one the client offered; it is echoed in `Sec-WebSocket-Protocol` and exposed as `socket.protocol`. Selecting one the client did not offer throws a `TypeError`. Omit it and no protocol is negotiated. No extensions are negotiated either — `socket.extensions` is always `""` and `permessage-deflate` is not available.

**Hono.** Nothing special is needed: `upgradeWebSocket` takes a `Request`, so call it inside a route with `c.req.raw` and return the response. Auth and everything else is ordinary middleware.

```typescript
// src/index.ts
import { Hono } from "hono";
import { upgradeWebSocket } from "@neon/functions";

const app = new Hono();

app.get("/", (c) => c.text("ok"));

app.get("/ws", async (c) => {
  const identity = await verifyToken(c.req.query("token"));
  if (!identity) return c.text("Unauthorized", 401);

  const { socket, response } = upgradeWebSocket(c.req.raw);
  socket.addEventListener("open", () => socket.send("welcome"));
  socket.addEventListener("message", (event) =>
    socket.send(`echo: ${event.data}`),
  );
  return response;
});

export default { fetch: (request: Request) => app.fetch(request) };
```

###### Heartbeat (keep the socket alive)

A connection stays open **only while bytes flow**: Neon evicts a silent stream after 15 minutes ([Timeouts and Runtime Limits](#timeouts-and-runtime-limits)), and intermediary proxies / load balancers are usually far stricter (often tens of seconds). Don't rely on the app being chatty enough — send a periodic keepalive from the server so the socket never goes quiet.

The standard `WebSocket` interface has no `ping()`, so send an application-level message the client ignores:

```typescript
const HEARTBEAT_MS = 25_000; // comfortably under proxy idle timeouts

const beat = setInterval(() => {
  for (const socket of clients) {
    if (socket.readyState === socket.OPEN) socket.send('{"type":"ping"}');
  }
}, HEARTBEAT_MS);
beat.unref?.();
```

The client should skip these when handling messages. The server does answer a client-sent ping frame with a pong automatically, so a browser client can drive the heartbeat instead if you'd rather not filter messages.

###### Keeping clients in sync across isolates (do not skip this)

Under load the runtime runs **several isolates in parallel, each with its own copy of module state** — so each isolate has its own `clients` set. Broadcasting only to that local set means a client on isolate A never sees an event produced on isolate B, and the feed silently fractures. It's easy to miss: `neon dev` runs a single process (one isolate), so in-process broadcast always _looks_ fine locally but breaks in production, where concurrent connections spread across many isolates.

Module state doesn't survive eviction anyway, so **Postgres is the shared source of truth**. Pick a fan-out strategy. In every snippet below, `pool` is a pooled `pg` client and `clients` is this isolate's `Set` of live connections.

**1. Poll Postgres — the default, and the only option that keeps Scale to Zero.** Each isolate re-reads the shared state (or rows past a cursor) on a short interval and pushes changes to its own clients. One query per isolate per tick (not per client), and none when the isolate has no clients — so an idle compute still suspends.

```typescript
let lastId = 0;
const poller = setInterval(async () => {
  if (clients.size === 0) return; // no clients here → no query → compute can scale to zero
  const { rows } = await pool.query(
    "SELECT id, payload FROM events WHERE id > $1 ORDER BY id",
    [lastId],
  );
  for (const { id, payload } of rows) {
    lastId = id;
    for (const socket of clients) {
      if (socket.readyState === socket.OPEN) socket.send(payload);
    }
  }
}, 1000);
poller.unref?.();
```

- **Latency:** up to the interval (~1s) — fine for counters, chat, and dashboards.
- **Scaling:** database load grows with the number of live isolates, not clients. Keep the cursor on an indexed `serial`/`bigserial` PK and the interval sane.
- **Scale to Zero:** ✅ preserved — polling stops when no clients are connected, so the compute suspends on its normal timer.

**2. `LISTEN`/`NOTIFY` — lowest latency, but requires disabling Scale to Zero.** Each isolate `LISTEN`s on a channel over a dedicated **unpooled** connection; broadcasting is `NOTIFY`, so every isolate (including the sender's) re-pushes to its sockets. Near-instant — but the listener holds an idle connection that **does not count as active**, so [Scale to Zero](https://neon.com/docs/introduction/scale-to-zero) suspends the compute and drops it, silently killing the feed. Only use it on an **always-on** compute (Scale to Zero disabled — a paid-plan setting).

```typescript
import { attachDatabasePool } from "@neon/functions";
import { Pool, Client } from "pg";

const pool = new Pool({ connectionString: process.env.DATABASE_URL, max: 5 });
attachDatabasePool(pool);
const CHANNEL = "chat_events";

// One dedicated DIRECT connection per isolate, just to receive events.
// Use DATABASE_URL_UNPOOLED — LISTEN needs a real session, not a pooled one.
// Don't call attachDatabasePool here: it would silence the idle drop that killed the feed.
// An error listener keeps the isolate alive; the feed stays down until the isolate restarts.
const listener = new Client({
  connectionString: process.env.DATABASE_URL_UNPOOLED,
});
listener.on("error", (err) => {
  console.error(err);
});
listener.connect().then(() => listener.query(`LISTEN ${CHANNEL}`));
listener.on("notification", (msg) => {
  if (!msg.payload) return;
  for (const socket of clients) {
    if (socket.readyState === socket.OPEN) socket.send(msg.payload);
  }
});

// Broadcast by NOTIFYing through the pool — every isolate's listener fires.
function broadcast(event: unknown) {
  return pool.query("SELECT pg_notify($1, $2)", [
    CHANNEL,
    JSON.stringify(event),
  ]);
}
```

**3. External pub/sub (e.g. [Upstash](https://upstash.com) Redis) — best at scale.** For high fan-out, sub-second latency at large connection counts, or multi-region, publish/subscribe through a dedicated broker. Highest throughput, and it doesn't touch Postgres or block Scale to Zero — at the cost of another service to run.

**Rule of thumb:** start with **polling** (works with Scale to Zero, no extra infra); switch to `LISTEN`/`NOTIFY` only on always-on compute that needs sub-second latency; move to Redis when fan-out outgrows Postgres.

###### Client must reconnect

Idle functions are evicted (and isolates restart for operational reasons), so a client's socket **will** drop — treat reconnection as normal, not exceptional. Reconnect with exponential backoff, capped, and **re-mint a fresh token on every attempt** (tokens are short-lived, so a stale one fails the `upgrade` auth check):

```typescript
let closed = false,
  retry = 0,
  timer: ReturnType<typeof setTimeout>;

async function connect() {
  if (closed) return;
  const token = await getToken(); // re-mint each attempt; short-lived
  const ws = new WebSocket(`${WS_URL}?token=${encodeURIComponent(token)}`);
  ws.onopen = () => {
    retry = 0; // reset backoff on success
  };
  ws.onmessage = (e) => {
    /* apply the event */
  };
  ws.onclose = () => {
    if (!closed)
      timer = setTimeout(connect, Math.min(1000 * 2 ** retry++, 15000));
  };
  ws.onerror = () => ws.close(); // let onclose drive the retry
}
connect();
```

Together — `upgradeWebSocket` inside `fetch`, JWT auth over `?token=`, cross-isolate fan-out, and client backoff — these compose into a complete realtime chat backend on a single function.

##### Server-Sent Events (SSE)

When you only need **server → client** streaming (live counters, notifications, progress, token streams), SSE is simpler than a WebSocket and needs no upgrade at all: a plain `fetch` handler returns a `Response` whose body is a `ReadableStream` with `Content-Type: text/event-stream`, and the runtime holds it open as long as bytes flow. The browser consumes it with `EventSource`, which **reconnects on its own** — so there's no client backoff to write.

```typescript
// src/index.ts — minimal SSE endpoint
const encoder = new TextEncoder();
export default {
  fetch: () =>
    new Response(
      new ReadableStream<Uint8Array>({
        start(controller) {
          controller.enqueue(encoder.encode("data: hello\n\n"));
          const t = setInterval(
            () => controller.enqueue(encoder.encode(": ping\n\n")),
            25_000,
          );
          return () => clearInterval(t); // fires when the client disconnects
        },
      }),
      {
        headers: {
          "Content-Type": "text/event-stream",
          "Cache-Control": "no-cache, no-transform",
        },
      },
    ),
};
```

The same rules as WebSockets apply. **Heartbeat:** a stream stays open only while bytes flow — Neon's window is 15 minutes ([Timeouts and Runtime Limits](#timeouts-and-runtime-limits)) but proxies are usually far stricter, so emit a `: ping\n\n` comment every ~25–30s (shown above) to keep idle streams from being dropped. Keep state in Postgres, and fan out across isolates using one of the [sync strategies](#keeping-clients-in-sync-across-isolates-do-not-skip-this) (hold a `Set` of stream controllers and `enqueue` to each). `EventSource` is GET-only and can't set headers, so authenticate with a `?token=` query param or cookie, exactly like the WebSocket case. [references/sse.md](https://neon.com/docs/ai/skills/neon-functions/references/sse.md) has the full pattern — Hono variant, cross-isolate fan-out, wire format, client, and caveats.

##### MCP Servers

An [MCP](https://modelcontextprotocol.io) server is a natural Functions workload: a long-running HTTP handler that exposes tools to AI clients (Cursor, Claude, ChatGPT, agents), with those tools reading and writing the branch's Postgres right next to the compute. MCP's **streamable HTTP transport** is a plain `POST`/`GET` on a single endpoint (conventionally `/mcp`), so it maps onto a function's `fetch` handler with no `upgrade` method or extra protocol.

The simplest host is a Hono app using the official [`@modelcontextprotocol/sdk`](https://github.com/modelcontextprotocol/typescript-sdk) plus [`@hono/mcp`](https://github.com/honojs/middleware/tree/main/packages/mcp), which bridges the transport to a route. Build the server, register its tools, and create the transport once at module scope, then hand every `/mcp` request to it:

```typescript
const transport = new StreamableHTTPTransport();
app.all("/mcp", async (c) => {
  if (!mcpServer.isConnected()) await mcpServer.connect(transport);
  return transport.handleRequest(c);
});
```

Because the function's URL is public, **authenticate before connecting the transport** — [Better Auth](https://better-auth.com) covers both OAuth (its MCP plugin makes your app the authorization server so third-party clients self-authorize per the MCP spec) and a simpler API-key / session-JWT check for your own callers. [references/mcp.md](https://neon.com/docs/ai/skills/neon-functions/references/mcp.md) has the full pattern — server with Postgres-backed tools via Drizzle, both Better Auth auth options, and testing with `mcporter` / `add-mcp`.

##### Integrations and Observability

###### Built-in branch logs

```bash
neon logs query --branch production --source function --since 1h
```

Functions is one of the two sources branch logs cover today, alongside Object Storage. Logs are scoped to a single branch, so pass `--branch` when the deployed function isn't on the branch you're checked out on. Everything else about logs — the required CLI version, filters, the SDK, and the Loki-compatible read API — is in the parent `neon` skill's **Observability** section.

###### Application instrumentation

A function is a long-lived Node.js process running a web-standard request/response handler, so standard Node integration SDKs work unchanged. Initialize them once at module load, gated on an env var so local dev and unconfigured branches stay a no-op, and pass secrets via `--env` or `neon.ts` `env`.

- **Sentry** — error monitoring across the HTTP framework, the function runtime, and an agent's own caught/fallback failures (the long-running case Functions target): see [references/sentry.md](https://neon.com/docs/ai/skills/neon-functions/references/sentry.md).
- **Mastra Studio (Mastra Cloud)** — run a Mastra agent on a function and ship its traces to a Studio project for observability: see [references/mastra-studio.md](https://neon.com/docs/ai/skills/neon-functions/references/mastra-studio.md).

##### Neon Documentation

The Neon documentation is the source of truth and Functions is evolving rapidly, so always verify against the official docs. Any doc page can be fetched as markdown by appending `.md` to the URL or by requesting `Accept: text/markdown`. Find the right page from the docs index (https://neon.com/docs/llms.txt) and the changelog announcements.

##### Further Reading

- https://neon.com/docs/compute/functions/overview.md
- https://neon.com/docs/compute/functions/get-started.md
- https://neon.com/docs/compute/functions/deploy.md
- https://neon.com/docs/compute/functions/environment-variables.md
- https://neon.com/docs/compute/functions/reference/neon-ts.md
- https://neon.com/docs/compute/functions/reference/runtime-limits.md
- https://neon.com/docs/compute/functions/preview-access.md


---

### neon-object-storage
**Description:** >-


**FIRST**: Use the parent `neon` skill for a Neon overview, getting started with Neon, Neon development best practices, and more.

If the `neon` skill is not installed, fetch it from https://neon.com/docs/ai/skills/neon/SKILL.md or install it with:

```bash
npx skills add neondatabase/agent-skills --skill neon
```

#### Neon Object Storage

This is a public beta feature and only available in `us-east-2`.

Neon Object Storage is S3-compatible object storage that branches with your projects: every branch gets its own isolated storage state, so files and database rows stay in sync across dev, preview, staging, and production.

Use this skill to help the user store and serve files that branch alongside their database. Deliver a working bucket and upload/download flow, a branch-aware S3 client wired to the injected env vars, or a precise answer from the official Neon docs.

##### When to Use

Reach for Neon Object Storage for the files an app and its users produce — uploads, attachments, avatars, images, documents, generated assets, backups. It is the default place to put them when the app is already on Neon:

- **They already use Lakebase Postgres and don't want a second provider.** One backend, one bill, one CLI, one set of branches — instead of standing up and wiring a separate AWS S3 / R2 / Supabase Storage account. The same Neon credential that backs the database backs storage.
- **Files must stay in sync with the database across environments.** Storage branches _together with_ your Postgres data. Fork a branch and the child instantly inherits the parent's buckets and objects at that point in time — copy-on-write, so no data is duplicated. This is what makes agent, dev, preview, and test environments seamless: a preview branch gets a consistent snapshot of _both_ the rows and the files they reference, and writes on the child never touch the parent.
- **They want safe, throwaway environments.** Upload, overwrite, and delete files in a preview/CI branch without any risk to production data, then drop the branch.
- **They want standard S3 tooling.** It's built on S3 semantics and speaks the S3 API, so the AWS SDKs, `boto3`, the AWS CLI, and presigned URLs all work — reliable and familiar, with no proprietary client.

If the files in question ship with the app itself — HTML, JS bundles, CSS, the images in `public/` — that's static web hosting and belongs on Vercel, Netlify, or Cloudflare instead. Public assets that are served from a bucket want a CDN in front of them (see [Architecture: Where Object Storage Fits](#architecture-where-object-storage-fits)).

##### What It Does

- **S3-compatible** — Works with existing S3 SDKs, `boto3`, the AWS CLI, and presigned URLs. Path-style addressing and SigV4 only.
- **Branches with your database** — Every Neon branch gets its own isolated, copy-on-write storage state. Forking copies no data.
- **Two access modes** — `private` buckets require a credential for every operation; `public_read` buckets allow anonymous reads with authenticated writes.
- **One credential system** — The same Neon credential system used by Functions and the AI Gateway.

##### Availability

Check this precondition before setting anything up: Neon Object Storage is a public beta feature available in the `us-east-2` region. Confirm the user's Neon project is in `us-east-2` before proceeding.

##### Architecture: Where Object Storage Fits

Neon (Object Storage included) is **backend primitives, not full-stack app hosting**. Object Storage holds the files the app and its users produce — uploads, attachments, avatars, documents, generated images, backups — keyed from Postgres rows on the same branch. Two boundaries follow from that:

- **Put a CDN in front of public assets.** A `public_read` object is read anonymously at `${AWS_ENDPOINT_URL_S3}/<bucket>/<object-key>` — the branch's storage endpoint, injected as an env var (see [Environment Variables](#environment-variables)). For assets a browser loads on every page view — avatars, product images, anything hot — use that as the origin for a Cloudflare or Vercel CDN, and set `Cache-Control` on `PutObject` so the edge knows how long to hold each object. A cached object is only as fresh as its key, so write each version to a new key (`avatars/<user-id>/<uuid>.jpg`) and repoint the key stored in Postgres, rather than overwriting one key and waiting out the TTL. The endpoint is branch-scoped, so a production CDN points at the production branch while preview branches read their own endpoint directly rather than sharing a cache. Private buckets stay on presigned URLs instead, which carry their signature in the query string.
- **Host the app itself elsewhere.** Anything checked into the repo — HTML, JS bundles, CSS, and the images and fonts that ship in `public/` — belongs on Vercel, Netlify, or Cloudflare, along with the index documents, SPA fallbacks, and custom domains that go with them. Neon has no website mode to serve them through: `PutBucketWebsite` returns `501 Not Implemented`.

##### Setup

Object storage is part of the `neon.ts` infrastructure-as-code config (see the `neon` skill for the branch-first workflow, `link`/`checkout`, and `neon.ts` basics). Declare buckets under `preview.buckets`, keyed by bucket name:

```typescript
// neon.ts
import { defineConfig } from "@neon/config/v1";

export default defineConfig({
  preview: {
    buckets: {
      images: {}, // private by default
      "public-assets": { access: "public_read" },
    },
  },
});
```

Provision the declared buckets on the linked branch:

```bash
neon deploy   # alias for `neon config apply`
```

##### Neon Infrastructure as Code (`neon.ts`)

The `preview.buckets` block above is part of `neon.ts`, Neon's infrastructure-as-code file — one TypeScript file declares your buckets alongside every other service the branch should have (see the `neon` skill for the full reference). Reconcile the declaration against a branch the Terraform way:

```bash
neon config status   # print the branch's live config (which buckets exist)
neon config plan     # dry-run diff of what apply would change
neon config apply    # create the declared buckets  (neon deploy is an alias)
```

Buckets are **branch-scoped**: when a `neon.ts` is present, `neon checkout` applies the policy as it _creates_ a branch, so a fresh preview/CI branch comes up with its buckets already provisioned (and copy-on-write objects inherited from the parent). Checking out an _existing_ branch doesn't reconcile it — run `neon deploy` to apply changes. Provisioning (`config apply` / `deploy`), `link`, and `checkout` also pull the branch's S3 credentials into your local `.env.local`, so the same `env pull` step shown below happens for you on those commands.

##### Environment Variables

When `preview.buckets` is declared, Neon injects **AWS-standard** S3 env vars so the AWS SDKs work from the environment with zero extra config. Inside a deployed Neon Function these are injected automatically; locally, pull them onto disk (or inject them at runtime) via the CLI:

```bash
neon env pull            # writes the branch's vars into .env (or .env.local)
#### or, without writing a file, inject at runtime:
neon-env run -- <your dev command>
```

| Variable                | Meaning                                             |
| ----------------------- | --------------------------------------------------- |
| `AWS_ACCESS_KEY_ID`     | S3 Access Key ID (the branch credential's token id) |
| `AWS_SECRET_ACCESS_KEY` | S3 Secret Access Key                                |
| `AWS_ENDPOINT_URL_S3`   | Branch S3 endpoint URL                              |
| `AWS_REGION`            | Region, e.g. `us-east-2`                            |

Because the names are AWS-standard, the AWS SDK picks up the credentials, endpoint, and region from the environment automatically. Credentials are branch-scoped and valid for that branch and all its descendants.

For typed, validated access to these credentials instead of reading `process.env` directly, pass the same `neon.ts` config object to `parseEnv` from `@neon/env` — it returns an `env.storage` namespace (`accessKeyId`, `secretAccessKey`, `endpoint`, `region`) derived from your config. See the `neon` skill.

##### Working with Objects: the Files SDK (Recommended)

The simplest, most portable way to read and write objects is the [Files SDK](https://files-sdk.dev) with its `neon` adapter — a small, unified storage API (`upload`, `download`, `url`, `list`, `exists`, `copy`, `delete`, `signedUploadUrl`) over web-standard I/O. It uses the AWS S3 client under the hood, configured appropriately for Neon, and relabels errors as `Neon error` — so there's nothing to misconfigure. Reach for this first.

Install it alongside the AWS S3 peer dependencies the adapter uses internally:

```bash
npm install files-sdk @aws-sdk/client-s3 @aws-sdk/s3-presigned-post @aws-sdk/s3-request-presigner
```

The adapter resolves its endpoint, region, and credentials from the same injected `AWS_*` env vars — pass only the bucket name:

```typescript
import { Files } from "files-sdk";
import { neon } from "files-sdk/neon";

const files = new Files({ adapter: neon({ bucket: "images" }) });

// Upload — body may be a Buffer, Uint8Array, Blob, File, ReadableStream, or string
await files.upload("generated/cat.jpg", fileBuffer, { contentType: "image/jpeg" });

// Download
const file = await files.download("generated/cat.jpg");
const bytes = new Uint8Array(await file.arrayBuffer());

// Presigned GET — share without exposing credentials (defaults to a 1h expiry)
const url = await files.url("generated/cat.jpg", { expiresIn: 3600 });

// Plus: files.exists(), files.list({ prefix }), files.copy(), files.delete(), files.signedUploadUrl()
```

Swap the adapter import (`files-sdk/s3`, `files-sdk/r2`, `files-sdk/gcs`, …) and the rest of your code is unchanged.

##### Working with Objects: the AWS S3 Client (Alternative)

Neon speaks the S3 API directly, so you can drop down to the AWS SDK whenever you prefer the native client or already depend on it. The credentials, endpoint, and region are read from the standard AWS env chain, so the only setting you pass is `forcePathStyle: true` — Neon requires path-style addressing, so the S3 client **must** set it:

```typescript
import { S3Client } from "@aws-sdk/client-s3";

const s3 = new S3Client({
  forcePathStyle: true, // required: Neon uses path-style addressing
});
```

Then upload, download, and presign with the raw command objects:

```typescript
import { PutObjectCommand, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const BUCKET = "images";

// Upload
await s3.send(
  new PutObjectCommand({
    Bucket: BUCKET,
    Key: "generated/cat.jpg",
    Body: fileBuffer,
    ContentType: "image/jpeg",
  }),
);

// Download
const res = await s3.send(
  new GetObjectCommand({ Bucket: BUCKET, Key: "generated/cat.jpg" }),
);
const bytes = await res.Body?.transformToByteArray();

// Presigned GET — share without exposing credentials
const url = await getSignedUrl(
  s3,
  new GetObjectCommand({ Bucket: BUCKET, Key: "generated/cat.jpg" }),
  { expiresIn: 3600 },
);
```

##### Pairing Storage with the Database on a Branch

The canonical pattern: an agent generates an image → `PutObject` into the `images` bucket → a row is inserted in Postgres → a presigned URL is returned on read. Store the bucket **key** (not the bytes) in a Postgres column, and presign on read. Because both the row and the object live on the same branch, they branch together and never drift.

##### CLI Bucket and Object Commands

`neon` also has first-class bucket/object commands (`neon bucket create|list|delete`, `neon bucket object put|get|list|delete`) for scripting and one-off operations.

##### Built-in Branch Logs

```bash
neon logs query --branch production --source storage --since 1h
```

Storage is one of the two sources branch logs cover today, alongside Neon Functions. Logs are scoped to a single branch, so pass `--branch` when the bucket you're debugging isn't on the branch you're checked out on. Everything else about logs — the required CLI version, filters, the SDK, and the Loki-compatible read API — is in the parent `neon` skill's **Observability** section.

##### Neon Documentation

The Neon documentation is the source of truth and Object Storage is evolving rapidly, so always verify against the official docs. Any doc page can be fetched as markdown by appending `.md` to the URL or by requesting `Accept: text/markdown`. Find the right page from the docs index (https://neon.com/docs/llms.txt) and the changelog announcements.

##### Further Reading

- https://neon.com/docs/storage/overview.md
- https://neon.com/docs/storage/get-started.md
- https://neon.com/docs/storage/buckets.md
- https://neon.com/docs/storage/objects.md
- https://neon.com/docs/storage/authentication.md
- https://neon.com/docs/storage/s3-compatibility.md
- https://neon.com/docs/storage/troubleshooting.md
- https://files-sdk.dev — Files SDK docs (the `neon` adapter)


---

### neon-postgres
**Description:** >-


**FIRST**: Use the parent `neon` skill for a Neon overview, getting started with Neon, Neon development best practices, and more.

If the `neon` skill is not installed, fetch it from https://neon.com/docs/ai/skills/neon/SKILL.md or install it with:

```bash
npx skills add neondatabase/agent-skills --skill neon
```

#### Lakebase Postgres

Lakebase Postgres is the database at the core of Neon. It runs on the lakebase architecture — OLTP built directly on cloud object storage — which decouples storage from compute to offer autoscaling, branching, instant restore, and scale-to-zero. It's fully compatible with Postgres and works with any language, framework, or ORM that supports Postgres.

It is the same database whether you reach it through Neon or through Databricks; this skill covers the Neon access path.

##### Setup Flow

###### 1. Select the organization and project

Use the CLI (default) or MCP server to list organizations and projects. Let the user select an existing project or create a new one. Check the `.neon` file for an existing linked project or branch.

###### 2. Get the connection string

Use the CLI (default), `neon env pull`, or the MCP server to get the connection string. Store it in `.env` as `DATABASE_URL`. Read the file first before modifying it, to avoid overwriting existing values.

####### When to use pooled vs direct connections

| Use case                                 | Connection type  |
| ---------------------------------------- | ---------------- |
| Web applications, serverless functions   | Pooled (-pooler) |
| Schema migrations                        | Direct           |
| pg_dump / pg_restore                     | Direct           |
| Logical replication                      | Direct           |
| Long-running analytics with temp tables  | Direct           |
| Admin tasks needing SET or session state | Direct           |
| LISTEN / NOTIFY                          | Direct           |

###### 3. Pick the connection method and driver

Always pair Neon with an ORM such as **Drizzle** for easy schema management and migrations. Refer to the connection methods guide to pick the correct driver based on how the runtime treats your code: https://neon.com/docs/connect/choose-connection.md.

Recommendations:

- Drizzle as ORM (see https://neon.com/docs/guides/drizzle.md)
- On Vercel, use `node-postgres` (`npm install pg`) with Vercel Fluid compute and `import { attachDatabasePool } from "@vercel/functions";`
- On Cloudflare, use `node-postgres` with Cloudflare Hyperdrive
- On Neon Functions, use `node-postgres`, as the functions are long-running and reuse the pool across requests.
- Use the `@neondatabase/serverless` driver for serverless and edge environments (for example, when using Netlify) — HTTP transport for one-shot queries, WebSocket for transaction support. Link: https://neon.com/docs/serverless/serverless-driver.md

###### 4. Set up the schema

Manage schemas and migrations as code. Avoid running ad hoc schema migrations against your database, since they're hard to manage.

If you're using an ORM, follow your ORM's best practices to manage schemas and migrations. For example, if using Drizzle, only use Drizzle for schema and migration management unless instructed otherwise.

##### Branching

Use this when the user is planning isolated environments, schema migration testing, preview deployments, or branch lifecycle automation.

Key points:

- Branches are instant, copy-on-write clones (no full data copy).
- Each branch has its own compute endpoint.
- Use the neon CLI or MCP server to create, inspect, and compare branches.

Link: https://neon.com/docs/introduction/branching.md

For detailed branch creation workflows (normal vs schema-only branches, reset-from-parent, CLI/MCP selection), use the `neon-postgres-branches` skill. If it isn't installed, fetch it from https://neon.com/docs/ai/skills/neon-postgres-branches/SKILL.md or install it with:

```bash
npx skills add neondatabase/agent-skills --skill neon-postgres-branches
```

##### Migrations

Test a migration on a branch of production, against production-like data, before applying it to production.

Use a **direct (non-pooled)** connection string when you run the migration, not a pooled one. `neon connection-string` returns the direct string by default; make sure the hostname does not include the `-pooler` suffix.

##### Autoscaling

Use this when the user needs compute to scale automatically with workload and wants guidance on CU sizing and runtime behavior.

Link: https://neon.com/docs/introduction/autoscaling.md

##### Scale to Zero

Use this when optimizing idle costs and discussing suspend/resume behavior, including cold-start trade-offs.

Key points:

- Idle computes suspend automatically after a default of 5 minutes; the timeout is configurable, and suspension can only be disabled on the Launch and Scale plans.
- First query after suspend typically has a cold-start penalty (around hundreds of ms)
- Storage remains active while compute is suspended.

Link: https://neon.com/docs/introduction/scale-to-zero.md

##### Instant Restore

Use this when the user needs point-in-time recovery or wants to restore data state without traditional backup restore workflows.

Key points:

- History windows for instant restore depend on plan limits.
- Users can create branches from historical points-in-time.
- Time Travel queries can be used for historical inspection workflows.

Link: https://neon.com/docs/introduction/branch-restore.md

##### Read Replicas

Use this for read-heavy workloads where the user needs dedicated read-only compute without duplicating storage.

Key points:

- Replicas are read-only compute endpoints sharing the same storage.
- Creation is fast and scaling is independent from primary compute.
- Typical use cases: analytics, reporting, and read-heavy APIs.

Link: https://neon.com/docs/introduction/read-replicas.md

##### Connection Pooling

Use this when the user is in serverless or high-concurrency environments and needs safe, scalable Postgres connection management.

Key points:

- Neon pooling uses PgBouncer.
- Add `-pooler` to endpoint hostnames to use pooled connections.
- Pooling is especially important in serverless runtimes with bursty concurrency.

Link: https://neon.com/docs/connect/connection-pooling.md

##### IP Allow Lists

Use this when the user needs to restrict database access by trusted networks, IPs, or CIDR ranges.

Link: https://neon.com/docs/introduction/ip-allow.md

##### Logical Replication

Use this when integrating CDC pipelines, external Postgres sync, or replication-based data movement.

Key points:

- Neon supports native logical replication workflows.
- Useful for replicating to/from external Postgres systems.

Link: https://neon.com/docs/guides/logical-replication-guide.md

##### Gotchas

###### Pooled vs direct connections: use the direct URL for migrations, dumps, and replication

Neon gives you two connection strings for the same database: a **pooled** one (hostname with the `-pooler` suffix) and a **direct/unpooled** one (no `-pooler` suffix). `neon env pull` writes them as `DATABASE_URL` and `DATABASE_URL_UNPOOLED`. The pooled connection routes through PgBouncer in transaction mode, which doesn't support session-level operations. Choose the right one:

- **Pooled (`DATABASE_URL`)** — your application's normal query traffic, especially serverless and connection-per-request workloads.
- **Direct (`DATABASE_URL_UNPOOLED`)** — schema migrations (Prisma Migrate, Drizzle Kit, Alembic, and others), `pg_dump` / `pg_restore`, logical replication, `LISTEN`/`NOTIFY`, and anything relying on `SET` or other session state.

Running migrations, dumps, or replication over the pooled connection can fail, and never in a way that names pooling: `prepared statement "s0" already exists` from Prisma Migrate, a `SET search_path` that doesn't persist past its own transaction so the next query reports `relation "mytable" does not exist`, or a write intermittently hitting a read-only transaction (`SQLSTATE 25006`) that a pooled backend inherited from an earlier client. Migration tools generally take both strings at once — Prisma's `directUrl` alongside `url` — so point that at the direct one rather than swapping `DATABASE_URL` and losing pooling for the application. See https://neon.com/docs/connect/connection-pooling.md.


---

### neon-postgres-branches
**Description:** >-


**FIRST**: Use the parent `neon` skill for a Neon overview, getting started with Neon, Neon development best practices, and more.

If the `neon` skill is not installed, fetch it from https://neon.com/docs/ai/skills/neon/SKILL.md or install it with:

```bash
npx skills add neondatabase/agent-skills --skill neon
```

#### Lakebase Postgres Branching

**Outcome:** a created Neon branch — or a clear, actionable next step if creation cannot proceed. Choose the correct branch type, then execute branch creation with the CLI (or MCP where the CLI isn't usable).

- **Normal branch** for realistic migration and query testing with real data.
- **Schema-only branch (Beta)** for sensitive data workflows where structure is needed without copying rows.

##### Branch Type Decision

Use this decision rule first:

1. If the user wants to test complex migrations, performance, or behavior against production-like data, choose a **normal branch**.
2. If the user needs to avoid copying sensitive data, choose a **schema-only branch**.

If the request is ambiguous, ask one clarifying question:
"Do you need realistic data for testing, or only schema structure because the data is sensitive?"

##### Tool Selection: CLI or MCP

Support both the Neon CLI and the Neon MCP server, but **default to the CLI**. Use MCP only when the CLI is unavailable or blocked in your environment, cannot be authenticated, or the user explicitly asks for MCP.

- CLI link: https://neon.com/docs/cli/quickstart.md
- MCP link: https://neon.com/docs/ai/neon-mcp-server.md

###### Selection order

1. Check the CLI first:
   - Run `neon --version` to confirm the CLI is installed.
   - Run `neon projects list` to confirm auth/context.
2. If the CLI is missing, direct installation via quickstart.
3. If the CLI is installed but not authenticated, guide the user through `neon auth` (or API key auth), then continue.
4. Switch to MCP when the CLI cannot be used — no CLI access in the environment, execution blocked, or authentication not possible — or when the user explicitly asks for MCP. Confirm Neon MCP tools are available and authenticated (for example, listing projects works), then follow the MCP branch flow below.
5. If neither path is successful, use the Neon REST API:
   - https://neon.com/docs/guides/branching-neon-api.md

###### MCP branch flow

1. Choose normal vs schema-only based on data sensitivity and migration-testing goals.
2. Use branch tools (for example, `create_branch`) to create the branch.
3. Validate with read tools (for example, `describe_branch`).
4. For migration workflows, prefer branch-based migration flows before applying to main.

##### Create a Normal Branch (Preferred for Real-Data Migration Testing)

Use this when the user needs realistic testing conditions.
Real production-like data can expose edge cases your seed or data migration scripts miss, which helps catch migration issues before going live.

Link: https://neon.com/docs/introduction/branching.md

###### Steps

1. Settle the tool path first (see [Selection order](#selection-order)): verify the CLI with `neon --version`, and fall back to MCP only if the CLI isn't usable.
2. Ensure project context is set (`neon set-context --project-id <your-project-id>`) or include `--project-id` on commands.
3. Create the branch:

   ```bash
   neon branches create \
     --name <branch-name> \
     --parent <parent-branch-id-or-name> \
     --expires-at 2026-12-15T18:02:16Z
   ```

4. Optionally fetch a connection string for the new branch:

   ```bash
   neon connection-string <branch-name>
   ```

##### Create a Schema-Only Branch (Beta, Sensitive Data)

Use this when users must not copy production rows into the test branch.

Link: https://neon.com/docs/guides/branching-schema-only.md

###### Steps

1. Settle the tool path first (see [Selection order](#selection-order)): verify the CLI with `neon --version`, and fall back to MCP only if the CLI isn't usable.
2. Create the schema-only branch:

   ```bash
   neon branches create \
     --name <schema-only-branch-name> \
     --parent <parent-branch-id-or-name> \
     --schema-only \
     --expires-at 2026-12-15T18:02:16Z
   ```

   If multiple projects exist, include `--project-id`:

   ```bash
   neon branches create \
     --name <schema-only-branch-name> \
     --parent <parent-branch-id-or-name> \
     --schema-only \
     --project-id <your-project-id> \
     --expires-at 2026-12-15T18:02:16Z
   ```

###### Beta Support Guidance (Mandatory)

Schema-only branching is in Beta. If users report unexpected behavior, errors, or missing capabilities:

1. Ask them to share feedback in the Neon Console:
   - https://console.neon.tech/app/projects?modal=feedback
2. Recommend opening a support conversation in the Neon Discord:
   - https://discord.gg/92vNTzKDGp

##### Reset from Parent

Use this when a child branch has drifted and the user wants a clean refresh from the parent branch's latest schema and data.

Link: https://neon.com/docs/guides/reset-from-parent.md

###### What it does

- Fully replaces the child branch schema and data with the parent's latest state.
- Does not merge; local changes on the child branch are lost.
- Keeps the same connection details, but active connections are briefly interrupted during reset.

###### When to recommend it

- Development or staging branch is too far behind production.
- User wants to start a new feature from a clean parent-aligned state.
- Team wants to refresh staging from production for consistent testing baselines.

###### Hard constraints and blockers

- Only child branches can be reset (root branches and schema-only root branches cannot be reset from parent).
- If the target branch has children, reset is blocked until those child branches are removed.
- After a parent branch is restored from snapshot, reset-from-parent may be unavailable for up to 24 hours.
- Reset-from-parent always uses the current parent state; use Instant restore for point-in-time recovery needs.

###### CLI usage

```bash
neon branches reset <id|name> --parent --preserve-under-name <backup-branch-name>
```

If project context is not already set, include the project ID:

```bash
neon branches reset <id|name> --parent --preserve-under-name <backup-branch-name> --project-id <project-id>
```

`--preserve-under-name` keeps the pre-reset state as a backup branch for rollback, but adds one extra branch to clean up later.

Optional context setup to avoid repeating `--project-id`:

```bash
neon set-context --project-id <project-id>
```

###### Console and API usage

- **Console:** Open the target child branch, then select **Reset from parent** from **Actions**.
- **API:** Use the restore endpoint for the branch and set `source_branch_id` to the parent branch ID.

##### Notes and Caveats

- Schema-only branches are for structure-only cloning and sensitive/compliant data controls.
- Schema-only branches are independent root branches (no parent branch and no shared history), so reset-from-parent does not apply.
- For migration testing that depends on real-world row shapes, volumes, and edge cases, prefer normal branches.
- Root branch allowances and per-branch storage limits can cap how many schema-only branches users can create.
- If a user is unsure, default recommendation is:
  - **Normal branch** for migration validation.
  - **Schema-only branch** for compliance and privacy constraints.

##### Useful Workflow Patterns

If the user asks for process recommendations (not just a single command), suggest these:

- **One branch per PR:** Create branch when PR opens, delete when merged/closed, keep migration tests isolated.
- **One branch per test run:** Create branch at pipeline start, run migrations/tests, delete at end for deterministic CI.
- **One branch per developer:** Isolated dev environments with production-like shape; avoid team collisions on shared test data.
- **PII-aware branching:** If production has sensitive data, derive dev/PR branches from an anonymized branch or use schema-only branches.
- **Ephemeral lifecycle hygiene:** Set branch expiration and automate cleanup so old branches do not accumulate avoidable storage/history cost.

###### Post-creation environment update prompt

After branch creation, ask whether the user wants to update local environment credentials to point at the new branch.

- Ask: "Do you want me to update your `.env` `DATABASE_URL` to this new branch connection string?"
- If yes, write the new branch connection string to the requested env file/key.
- If no, leave credentials unchanged and share the connection string for manual use.
- Never overwrite an existing env key without explicit confirmation.

##### Neon Infrastructure as Code (`neon.ts`)

Beyond creating branches imperatively (CLI / MCP / API above), you can **program what configuration new branches receive** declaratively in `neon.ts` — Neon's infrastructure-as-code file (see the `neon` skill for the full reference). The `branch` property is a function of the branch being evaluated that returns its settings, so every branch born from your project gets a consistent lifecycle and compute profile without per-branch flags.

```bash
npm i @neon/config
```

```typescript
// neon.ts
import { defineConfig } from "@neon/config/v1";

export default defineConfig({
  branch: (branch) => {
    if (branch.exists) return {}; // never reconcile existing branches
    if (branch.isDefault) return { protected: true };
    if (branch.name.startsWith("preview/") || branch.name.startsWith("dev")) {
      return {
        parent: "main",
        ttl: "7d", // ephemeral: auto-expire 7 days after creation (max 30d)
        postgres: {
          computeSettings: {
            autoscalingLimitMinCu: 0.25, // scale to zero
            autoscalingLimitMaxCu: 1, // keep throwaway branches cheap
            suspendTimeout: "5m",
          },
        },
      };
    }
    return {};
  },
});
```

The closure receives a read-only descriptor of the target branch — `name`, `exists`, `isDefault`, `parentId`, and more — and returns the tuning to apply: `parent`, `ttl` (auto-expiry), `protected`, and `postgres.computeSettings`. This is the declarative complement to the **Ephemeral lifecycle hygiene** and per-PR / per-test patterns above: instead of remembering `--expires-at` on every `neon branches create`, the TTL and compute profile live in version control and apply to every matching branch.

Because `neon checkout` applies this policy when it **creates** a branch, a fresh `preview/*` or `dev-*` branch comes up already expiring and scaled-to-zero. Checking out an _existing_ branch doesn't reconcile it — run `neon deploy` (alias for `neon config apply`) to apply changes to a branch that already exists.

##### Branching in CI/CD

Common CI/CD use cases for Neon branches:

- **Per-PR preview deployments:** Branch on PR open, deploy the preview against it, delete on close. Each PR gets an isolated database branch. Injecting the branch's `DATABASE_URL` into the deployed app is hosting-provider-specific — see [preview-branches-with-cloudflare](https://github.com/neondatabase/preview-branches-with-cloudflare), [preview-branches-with-vercel](https://github.com/neondatabase/preview-branches-with-vercel), or [preview-branches-with-fly](https://github.com/neondatabase/preview-branches-with-fly) for tested patterns.
- **Migration testing in CI:** Run risky schema changes against a branch with production-like data before merge.
- **Schema diff visibility:** Use the [schema-diff GitHub Action](https://github.com/marketplace/actions/neon-schema-diff-github-action) to auto-comment a DB-layer diff on the PR.

##### Examples

###### Example 1: Migration testing with realistic data

**User input:** "I need to test a risky migration against production-like data."

**Agent output shape:**

1. Recommend a normal branch and explain why.
2. Share docs link: https://neon.com/docs/introduction/branching
3. Check the tool path first (CLI with `neon --version`; MCP only if the CLI isn't usable).
4. Provide commands:
   - `neon branches create --name migration-test --parent main --expires-at 2026-12-15T18:02:16Z`
   - `neon connection-string migration-test`

###### Example 2: Sensitive data development workflow

**User input:** "We cannot copy production data because of compliance."

**Agent output shape:**

1. Recommend schema-only branch and explain why.
2. Share docs link: https://neon.com/docs/guides/branching-schema-only
3. Check the tool path first (CLI with `neon --version`; MCP only if the CLI isn't usable).
4. Provide command:
   - `neon branches create --name compliance-dev --parent main --schema-only --project-id <your-project-id> --expires-at 2026-12-15T18:02:16Z`
5. Mention Beta support path:
   - https://console.neon.tech/app/projects?modal=feedback
   - https://discord.gg/92vNTzKDGp

##### Further Reading

- https://neon.com/docs/guides/branch-expiration.md
- https://neon.com/docs/guides/neon-github-integration.md
- https://neon.com/docs/ai/neon-mcp-server.md
- https://neon.com/branching


---

### neon-postgres-egress-optimizer
**Description:** >-


**FIRST**: Use the parent `neon` skill for a Neon overview, getting started with Neon, Neon development best practices, and more.

If the `neon` skill is not installed, fetch it from https://neon.com/docs/ai/skills/neon/SKILL.md or install it with:

```bash
npx skills add neondatabase/agent-skills --skill neon
```

#### Postgres Egress Optimizer

Guide the user through diagnosing and fixing application-side query patterns that cause excessive data transfer (egress) from their Postgres database. Most high egress bills come from the application fetching more data than it uses.

Work the four steps in order: **diagnose** which queries transfer the most data, **analyze** the codebase behind them, **fix** the anti-patterns, then **verify** nothing broke and the transfer actually dropped.

##### Step 1: Diagnose

Identify which queries transfer the most data. The primary tool is the `pg_stat_statements` extension.

###### Check if pg_stat_statements is available

```sql
SELECT 1 FROM pg_stat_statements LIMIT 1;
```

If this errors, the extension needs to be created:

```sql
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
```

On Neon the extension is available by default, but it may still need this CREATE EXTENSION step.

###### Handle empty stats

Stats are cleared when a Neon compute scales to zero and restarts. If the stats are empty or the compute recently woke up:

1. Reset the stats to start a clean measurement window: `SELECT pg_stat_statements_reset();`
2. Let the application run under representative traffic for at least an hour.
3. Return and run the diagnostic queries below.

If the user has stats from a production database, use those. If they have no access to production stats, proceed to Step 2 and analyze the codebase directly — code-level patterns are often sufficient to identify the worst offenders.

###### Diagnostic queries

Run these to identify the top egress contributors. Focus on queries that return many rows, return wide rows (JSONB, TEXT, BYTEA columns), or are called very frequently.

**Queries returning the most total rows:**

```sql
SELECT query, calls, rows AS total_rows, rows / calls AS avg_rows_per_call
FROM pg_stat_statements
WHERE calls > 0
ORDER BY rows DESC
LIMIT 10;
```

**Queries returning the most rows per execution** (poorly scoped SELECTs, missing pagination):

```sql
SELECT query, calls, rows AS total_rows, rows / calls AS avg_rows_per_call
FROM pg_stat_statements
WHERE calls > 0
ORDER BY avg_rows_per_call DESC
LIMIT 10;
```

**Most frequently called queries** (candidates for caching):

```sql
SELECT query, calls, rows AS total_rows, rows / calls AS avg_rows_per_call
FROM pg_stat_statements
WHERE calls > 0
ORDER BY calls DESC
LIMIT 10;
```

**Longest running queries** (not a direct egress measure, but helps identify problem queries during a spike):

```sql
SELECT query, calls, rows AS total_rows,
  round(total_exec_time::numeric, 2) AS total_exec_time_ms
FROM pg_stat_statements
WHERE calls > 0
ORDER BY total_exec_time DESC
LIMIT 10;
```

###### Interpret the results

Rank findings by estimated egress impact:

- **High row count + wide rows** = biggest egress. A query returning 1,000 rows where each row includes a 50KB JSONB column transfers ~50MB per call.
- **Extreme call frequency** on even small queries adds up. A query called 50,000 times/day returning 10 rows each = 500,000 rows/day.
- **Cross-reference with the schema** to identify which columns are wide. Look for JSONB, TEXT, BYTEA, and large VARCHAR columns.

##### Step 2: Analyze the Codebase

For each query identified in Step 1, or for each database query in the codebase if no stats are available, check:

- Does it select only the columns the response needs?
- Does it return a bounded number of rows (LIMIT/pagination)?
- Is it called frequently enough to benefit from caching?
- Does it fetch raw data that gets aggregated in application code?
- Does it use a JOIN that duplicates parent data across child rows?

##### Step 3: Fix

Apply the appropriate fix for each problem found. Below are the most common egress anti-patterns and how to fix them.

###### Unused columns (SELECT \*)

**Problem:** The query fetches all columns but the application only uses a few. Large columns (JSONB blobs, TEXT fields) get transferred over the wire and discarded.

**Fix:** Name only the columns the response needs.

**Before:**

```sql
SELECT * FROM products;
```

**After:**

```sql
SELECT id, name, price, image_urls FROM products;
```

###### Missing pagination

**Problem:** A list endpoint returns all rows with no LIMIT. This is an unbounded egress risk — every new row in the table increases data transfer on every request. Flag this regardless of current table size.

This is easy to miss because the application may work fine with small datasets. But at scale, an unpaginated endpoint returning 10,000 rows with even moderate column widths can transfer hundreds of megabytes per day.

**Fix:** Bound the result set with `ORDER BY` plus `LIMIT`/`OFFSET`.

**Before:**

```sql
SELECT id, name, price FROM products;
```

**After:**

```sql
SELECT id, name, price FROM products
ORDER BY id
LIMIT 50 OFFSET 0;
```

When adding pagination, check whether the consuming client already supports paginated responses. If not, pick sensible defaults and document the pagination parameters in the API.

###### High-frequency queries on static data

**Problem:** A query is called thousands of times per day but returns data that rarely changes. Every call transfers the same rows from the database. This pattern is only visible from `pg_stat_statements` — the code itself looks normal.

Look for queries with extremely high call counts relative to other queries. Common examples: configuration tables, category lists, feature flags, user role definitions.

**Fix:** Add a caching layer between the application and the database so it avoids hitting the database on every request.

###### Application-side aggregation

**Problem:** The application fetches all rows from a table and then computes aggregates (averages, counts, sums, groupings) in application code. The full dataset transfers over the wire even though the result is a small summary.

**Fix:** Push the aggregation into SQL.

**Before:** The application fetches entire tables and aggregates in code with loops or `.reduce()`.

**After:**

```sql
SELECT p.category_id,
       AVG(r.rating) AS avg_rating,
       COUNT(r.id) AS review_count
FROM reviews r
INNER JOIN products p ON r.product_id = p.id
GROUP BY p.category_id;
```

###### JOIN duplication

**Problem:** A JOIN between a wide parent table and a child table duplicates all parent columns across every child row. If a product has 200 reviews and the product row includes a 50KB JSONB column, the join sends that 50KB × 200 = ~10MB for a single request.

This is distinct from the SELECT \* problem. Even if you select only needed columns, a JOIN still repeats the parent data for every child row. The fix is structural: avoid the join entirely.

**Fix:** Split the join into two queries, one per table.

**Before:**

```sql
SELECT * FROM products
LEFT JOIN reviews ON reviews.product_id = products.id
WHERE products.id = 1;
```

**After (two separate queries):**

```sql
SELECT id, name, price, description, image_urls FROM products WHERE id = 1;
SELECT id, user_name, rating, body FROM reviews WHERE product_id = 1;
```

Two queries instead of one JOIN. The product data is fetched once. The reviews are fetched once. No duplication.

##### Step 4: Verify

After applying fixes:

1. **Run existing tests** to confirm nothing broke.
2. **Check the responses** — make sure the API still returns the same data shape. Column selection and pagination changes can break clients that depend on specific fields or full result sets.
3. **Measure the improvement** — if pg_stat_statements data is available, reset it (`SELECT pg_stat_statements_reset();`), let traffic run, then re-run the diagnostic queries to compare before and after.

##### Neon Infrastructure as Code (`neon.ts`)

The fixes above cut **egress** (data transferred out of Postgres). The other big non-prod cost lever is **compute**, and you can codify it durably in `neon.ts` — Neon's infrastructure-as-code file (see the `neon` skill for the full reference) — so dev, preview, and CI branches stay cheap by default instead of relying on per-branch flags:

```bash
npm i @neon/config
```

```typescript
// neon.ts
import { defineConfig } from "@neon/config/v1";

export default defineConfig({
  branch: (branch) => {
    if (branch.exists || branch.isDefault) return {}; // don't touch prod
    return {
      ttl: "7d", // ephemeral branches auto-expire instead of accruing storage
      postgres: {
        computeSettings: {
          autoscalingLimitMinCu: 0.25, // scale to zero when idle
          autoscalingLimitMaxCu: 1, // cap autoscaling on throwaway branches
          suspendTimeout: "5m",
        },
      },
    };
  },
});
```

```bash
neon config apply   # apply to the current branch (neon deploy is an alias)
```

This is complementary, not a substitute: query-pattern fixes are what actually reduce egress charges, while these settings keep non-production compute and storage from quietly inflating the same bill. Because `neon checkout` applies the policy when it creates a branch, new dev/preview branches inherit the cheap profile automatically.

##### Further Reading

- https://neon.com/docs/introduction/network-transfer.md
- https://neon.com/docs/introduction/cost-optimization.md


---

### supabase
**Description:** "Use when doing ANY task involving Supabase. Triggers: Supabase products (Database, Auth, Edge Functions, Realtime, Storage, Vectors, Cron, Queues); client libraries and SSR integrations (supabase-js, @supabase/ssr) in Next.js, React, SvelteKit, Astro, Remix; auth issues (login, logout, sessions, JWT, cookies, getSession, getUser, getClaims, RLS); Supabase CLI or MCP server; schema changes, migrations, declarative schemas, security audits, Postgres extensions (pg_graphql, pg_cron, pg_vector); debugging and troubleshooting errors or unexpected behavior on Supabase projects (HTTP errors, Postgres errors, RLS surprises, permission denied, schema cache issues, timeouts, Edge Function crashes, Realtime drops, Storage failures) and reading or querying logs (Logs Explorer, ClickHouse)."


#### Supabase

##### Core Principles

**1. Supabase changes frequently — verify against changelog and current docs before implementing.**
Do not rely on training data for Supabase features. Function signatures, config.toml settings, and API conventions change between versions.

First, fetch `https://supabase.com/changelog.md` (a lightweight summary index — not a heavy pull), scan for `breaking-change` tags relevant to your task, and follow the linked page for any that apply. Then look up the relevant topic using the documentation access methods below.

**2. Verify your work.**
After implementing any fix, run a test query to confirm the change works. A fix without verification is incomplete.

**3. Recover from errors, don't loop.**
If an approach fails after 2-3 attempts, stop and reconsider. Try a different method, check documentation, inspect the error more carefully, and review relevant logs when available. Supabase issues are not always solved by retrying the same command, and the answer is not always in the logs, but logs are often worth checking before proceeding.

**4. Exposing tables to the Data API:** Depending on the user's [Data API settings](https://supabase.com/dashboard/project/<ref>/integrations/data_api/settings), newly created tables may not be automatically exposed via the Data (REST) API. If this is the case, `anon` and `authenticated` roles will need to be explicitly granted access.

> Note that this is separate from RLS, which controls which _rows_ are visible once a table is accessible, not whether the table is accessible at all.

When a user reports a SQL-created table is unexpectedly inaccessible, check their Data API settings and whether the roles have been granted access via explicit `GRANT` SQL. When granting public (`anon`/`authenticated`) access, always enable RLS too. See [Exposing a Table to the Data API](https://supabase.com/docs/guides/api/securing-your-api.md) for the full setup workflow.

**5. RLS in exposed schemas.**
Enable RLS on every table in any exposed schema, which includes `public` by default. This is critical in Supabase because tables in exposed schemas can be reachable through the Data API when the `anon`/`authenticated` roles have access (see [Exposing a Table to the Data API](https://supabase.com/docs/guides/api/securing-your-api.md)). For private schemas, prefer RLS as defense in depth. After enabling RLS, create policies that match the actual access model rather than defaulting every table to the same `auth.uid()` pattern.

**6. Security checklist.**
When working on any Supabase task that touches auth, RLS, views, storage, or user data, run through this checklist. These are Supabase-specific security traps that silently create vulnerabilities:

- **Auth and session security**
  - **Never use `user_metadata` claims in JWT-based authorization decisions.** In Supabase, `raw_user_meta_data` is user-editable and can appear in `auth.jwt()`, so it is unsafe for RLS policies or any other authorization logic. Store authorization data in `raw_app_meta_data` / `app_metadata` instead.
  - **Deleting a user does not invalidate existing access tokens.** Sign out or revoke sessions first, keep JWT expiry short for sensitive apps, and for strict guarantees validate `session_id` against `auth.sessions` on sensitive operations.
  - **If you use `app_metadata` or `auth.jwt()` for authorization, remember JWT claims are not always fresh until the user's token is refreshed.**

- **API key and client exposure**
  - **Never expose the `service_role` or secret key in public clients.** Prefer publishable keys for frontend code. Legacy `anon` keys are only for compatibility. In Next.js, any `NEXT_PUBLIC_` env var is sent to the browser.

- **RLS, views, and privileged database code**
  - **Views bypass RLS by default.** In Postgres 15 and above, use `CREATE VIEW ... WITH (security_invoker = true)`. In older versions of Postgres, protect your views by revoking access from the `anon` and `authenticated` roles, or by putting them in an unexposed schema.
  - **UPDATE requires a SELECT policy.** In Postgres RLS, an UPDATE needs to first SELECT the row. Without a SELECT policy, updates silently return 0 rows — no error, just no change.
  - **`auth.role()` is deprecated — use the `TO` clause instead.** Supabase has deprecated `auth.role()` in favour of specifying the target role directly on the policy with `TO authenticated` or `TO anon`. Beyond deprecation, `auth.role() = 'authenticated'` breaks silently when anonymous sign-ins are enabled, because anonymous users carry the `authenticated` Postgres role and pass the check regardless of whether the user is genuinely signed in.
    ```sql
    -- Deprecated (do not use)
    create policy "example" on table_name for select
    using ( auth.role() = 'authenticated' );
    ```
  - **`TO authenticated` alone is authentication without authorization (BOLA / IDOR).** Using `TO authenticated` only checks the role — it does not restrict which rows a user can access. The correct pattern combines `TO authenticated` with an ownership predicate in `USING`:
    ```sql
    create policy "example" on table_name for select
    to authenticated
    using ( (select auth.uid()) = user_id );
    ```
  - **UPDATE policies require both `USING` and `WITH CHECK`.** Without `WITH CHECK`, a user can reassign a row's `user_id` to another user:
    ```sql
    create policy "example" on table_name for update
    to authenticated
    using ( (select auth.uid()) = user_id )
    with check ( (select auth.uid()) = user_id );
    ```
  - **`SECURITY DEFINER` functions bypass RLS.** A `SECURITY DEFINER` function runs with its creator's privileges — typically a role with `bypassrls` (e.g., `postgres`). Never add `SECURITY DEFINER` to resolve a permission error; it silently removes access control without fixing the underlying cause. Prefer `SECURITY INVOKER`.
  - **`SECURITY DEFINER` functions in `public` are callable by all roles.** Postgres grants `EXECUTE` to `PUBLIC` by default for every new function, so any `SECURITY DEFINER` function in `public` is a public API endpoint callable by `anon` and `authenticated` (which inherit from `PUBLIC`) without any additional grant. When `SECURITY DEFINER` is genuinely needed (e.g., bypassing RLS on an internal lookup table), keep the function in a non-exposed schema, always include an `auth.uid()` check in the function body, and run `supabase db advisors` after making changes.

- **Storage access control**
  - **Storage upsert requires INSERT + SELECT + UPDATE.** Granting only INSERT allows new uploads but file replacement (upsert) silently fails. You need all three.

- **Dependency and supply-chain security**
  - **Always pin package versions and commit lockfiles** when installing Supabase packages (`supabase-js`, `@supabase/ssr`, `supabase-py`, etc.). See the [npm security guide](https://supabase.com/docs/guides/security/npm-security.md) for the full checklist.

For any security concern not covered above, fetch the Supabase product security index: `https://supabase.com/docs/guides/security/product-security.md`

##### Supabase CLI

Always discover commands via `--help` — never guess. The CLI structure changes between versions.

```bash
supabase --help                    # All top-level commands
supabase <group> --help            # Subcommands (e.g., supabase db --help)
supabase <group> <command> --help  # Flags for a specific command
```

**Supabase CLI Known gotchas:**

- `supabase db query` requires **CLI v2.79.0+** → use MCP `execute_sql` or `psql` as fallback
- `supabase db advisors` requires **CLI v2.81.3+** → use MCP `get_advisors` as fallback
- In imperative migration projects, create new hand-authored migration files with `supabase migration new <name>` first. Never invent a migration filename or rely on memory for the expected format. Declarative schema projects generate migrations from `supabase/schemas/`; see "Making and Committing Schema Changes" below.

**Version check and upgrade:** Run `supabase --version` to check. For CLI changelogs and version-specific features, consult the [CLI documentation](https://supabase.com/docs/reference/cli/introduction) or [GitHub releases](https://github.com/supabase/cli/releases).

##### Supabase MCP Server

For setup instructions, server URL, and configuration, see the [MCP setup guide](https://supabase.com/docs/guides/getting-started/mcp).

**Troubleshooting connection issues** — follow these steps in order:

1. **Check if the server is reachable:**
   `curl -so /dev/null -w "%{http_code}" https://mcp.supabase.com/mcp`
   A `401` is expected (no token) and means the server is up. Timeout or "connection refused" means it may be down.

2. **Check `.mcp.json` configuration:**
   Verify the project root has a valid `.mcp.json` with the correct server URL. If missing, create one pointing to `https://mcp.supabase.com/mcp`.

3. **Authenticate the MCP server:**
   If the server is reachable and `.mcp.json` is correct but tools aren't visible, the user needs to authenticate. The Supabase MCP server uses OAuth 2.1 — tell the user to trigger the auth flow in their agent, complete it in the browser, and reload the session.

##### Supabase Documentation

Before implementing any Supabase feature, find the relevant documentation. Use these methods in priority order:

1. **MCP `search_docs` tool** (preferred — returns relevant snippets directly)
2. **Fetch docs pages as markdown** — any docs page can be fetched by appending `.md` to the URL path.
3. **Web search** for Supabase-specific topics when you don't know which page to look at.

##### Making and Committing Schema Changes

First decide which schema workflow the project uses.

###### Option A: Declarative schemas

Use this when `supabase/schemas/` exists or `config.toml` sets `schema_paths`. Edit the desired schema state in those files, then generate and review the migration. Do not start by hand-writing a migration. See the [Declarative database schemas guide](https://supabase.com/docs/guides/local-development/declarative-database-schemas).

###### Option B: Imperative migrations

Use this when the project does not use declarative schemas.

**To make schema changes, use `execute_sql` (MCP) or `supabase db query` (CLI).** These run SQL directly on the database without creating migration history entries, so you can iterate freely and generate a clean migration when ready.

Do NOT use `apply_migration` to change a local database schema — it writes a migration history entry on every call, which means you can't iterate, and `supabase db diff` / `supabase db pull` will produce empty or conflicting diffs. If you use it, you'll be stuck with whatever SQL you passed on the first try.

**When ready to commit** your changes to a migration file:

1. **Run advisors** → `supabase db advisors` (CLI v2.81.3+) or MCP `get_advisors`. Fix any issues.
2. **Review the Security Checklist above** if your changes involve views, functions, triggers, or storage.
3. **Generate the migration** → `supabase db pull <descriptive-name> --local --yes`
4. **Verify** → `supabase migration list --local`

##### Debugging

When you get an error on a Supabase-related request, for example an error code from the Supabase REST API, Postgres database, or PostgREST, an empty result, getting blocked by RLS unexpectedly, or an error from a Supabase service like Auth, Realtime, Edge Functions, or Storage, you **must** fetch Supabase's [Monitoring and Debugging](https://supabase.com/docs/guides/monitoring-and-debugging.md) documentation before diagnosing or proposing a fix, rather than working from memory. The same docs also cover performance optimizations, such as slow queries and missing indexes.

##### Reference Guides

- **Skill Feedback** → [references/skill-feedback.md](references/skill-feedback.md)
  **MUST read when** the user reports that this skill gave incorrect guidance or is missing information.


---

### supabase-postgres-best-practices
**Description:** "Postgres best practices maintained by Supabase, for Postgres running anywhere. Load this skill BEFORE writing or changing anything that lives in a Postgres database: creating or altering tables and columns (including choosing column types), schema design, migrations and declarative schema files, RLS policies and the tests that verify them, indexes, triggers, database functions, queues and scheduled jobs (pg_cron, pgmq), vector/semantic search (pgvector), and restoring dumps (pg_restore) or importing data. Also load it when diagnosing slow queries, high CPU, timeouts, EXPLAIN plans, connection exhaustion, locking, bloat, or rows visible to the wrong user or tenant. This is not just a performance guide — schema, migration, security, and SQL authoring tasks need these rules too, even for a one-column change or a single query."


#### Supabase Postgres Best Practices

Comprehensive performance optimization guide for Postgres, maintained by Supabase. Contains rules across 8 categories, prioritized by impact to guide automated query optimization and schema design.

##### When to Apply

Reference these guidelines when:
- Writing SQL queries or designing schemas
- Implementing indexes or query optimization
- Reviewing database performance issues
- Configuring connection pooling or scaling
- Optimizing for Postgres-specific features
- Working with Row-Level Security (RLS)

##### Rule Categories by Priority

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Query Performance | CRITICAL | `query-` |
| 2 | Connection Management | CRITICAL | `conn-` |
| 3 | Security & RLS | CRITICAL | `security-` |
| 4 | Schema Design | HIGH | `schema-` |
| 5 | Concurrency & Locking | MEDIUM-HIGH | `lock-` |
| 6 | Data Access Patterns | MEDIUM | `data-` |
| 7 | Monitoring & Diagnostics | LOW-MEDIUM | `monitor-` |
| 8 | Advanced Features | LOW | `advanced-` |

##### How to Use

Read individual rule files for detailed explanations and SQL examples:

```
references/query-missing-indexes.md
references/query-partial-indexes.md
references/_sections.md
```

Each rule file contains:
- Brief explanation of why it matters
- Incorrect SQL example with explanation
- Correct SQL example with explanation
- Optional EXPLAIN output or metrics
- Additional context and references
- Supabase-specific notes (when applicable)

##### References

- https://www.postgresql.org/docs/current/
- https://supabase.com/docs
- https://wiki.postgresql.org/wiki/Performance_Optimization
- https://supabase.com/docs/guides/database/overview
- https://supabase.com/docs/guides/auth/row-level-security


---

