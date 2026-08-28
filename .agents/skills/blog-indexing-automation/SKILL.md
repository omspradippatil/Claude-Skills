---
name: blog-indexing-automation
description: Design or implement deployment-time workflows that improve blog URL discovery, sitemap submission, and indexing monitoring without relying on unsupported “request indexing” automation for normal web pages. Use when a user wants to automate post-publish indexing operations, connect deployment hooks to Search Console, submit sitemaps, inspect URL index status, or decide what should happen automatically after a blog deploy.
---

# Blog Indexing Automation

## Overview

Automate the parts of indexing that are officially supportable and operationally stable. Do not promise or implement automatic “request indexing” for standard blog posts through unsupported Google Search Console UI automation unless the user explicitly accepts that it is brittle and unofficial.

## Operating Constraints

Apply these rules before designing or implementing anything:

- Treat sitemap generation and discoverability as the default automation surface.
- Treat URL Inspection as a monitoring API, not a submission API.
- Treat Google Indexing API as out of scope for normal blog posts.
- Treat UI automation against Search Console as a last resort, not the standard path.

If the user asks to “auto index every post,” translate that into:

- make every new post discoverable immediately
- submit the sitemap after deploy
- monitor index state after deploy
- alert when URLs stall in a bad state

## Default Workflow

Implement or propose this sequence unless the user has a better existing pipeline:

1. Detect new or changed blog URLs after deployment.
2. Verify each URL is indexable.
3. Ensure those URLs appear in sitemap output.
4. Submit the sitemap through the Search Console Sitemaps API.
5. Queue the new URLs for URL Inspection checks at multiple delays.
6. Report failures or stalled states to the team.

## Step 1: Detect candidate URLs

Identify the set of URLs that matter after a deploy. Prefer one of these sources:

- changed content files from git diff
- generated sitemap diff
- blog build manifest
- content collection output

Do not inspect the whole site on every deploy if the change set is easily derivable.

Output a normalized list of canonical URLs.

## Step 2: Verify indexability

Before any submission or monitoring, check:

- URL returns `200`
- page is not `noindex`
- canonical points to the intended URL
- alternate and hreflang values are coherent
- page is reachable through crawlable internal links
- page is present in sitemap output

If any of these checks fail, stop and report that the URL is not ready for indexing automation.

## Step 3: Submit sitemap, not individual post requests

For standard blog content, prefer sitemap submission over any notion of per-URL forced indexing.

After deploy:

- regenerate `sitemap.xml`
- verify new URLs are included
- submit the sitemap via the Search Console Sitemaps API

Recommend one submission per deploy or per sitemap change, not one per URL.

## Step 4: Monitor URL state

Use URL Inspection API or equivalent verified inspection workflow to check new URLs on a schedule such as:

- T+1 day
- T+3 days
- T+7 days

Track at least:

- whether Google knows the URL
- whether it is indexed
- user-declared canonical
- Google-selected canonical
- last crawl time
- failure bucket if not indexed

## Step 5: Escalate only when automation cannot solve it

Escalate for human review when:

- the URL remains `Discovered - currently not indexed`
- the URL is `Crawled - currently not indexed`
- Google-selected canonical is wrong
- alternate locale routing is causing duplicate or non-canonical states
- a cluster of URLs fails the same readiness check

When escalating, report the likely failure mode rather than saying only “not indexed.”

## Recommended Outputs

When using this skill, produce:

- the intended automation architecture
- the exact trigger point, such as deploy hook or scheduled job
- the data sources used to find new URLs
- the readiness checks to run
- the sitemap submission step
- the inspection schedule
- the alert conditions
- any unsupported or risky parts the user should avoid

## Implementation Guidance

If the user wants code, prefer a minimal, auditable workflow:

- a deploy-time script that extracts changed URLs
- a readiness checker
- a sitemap submitter
- an inspection queue runner
- a reporting step to Slack, Feishu, GitHub issue, or markdown log

Keep each step independent. This makes failures diagnosable and avoids hiding indexing issues behind one opaque script.

## Guardrails

- Do not claim that normal blog posts can be officially “submitted for indexing” by API.
- Do not recommend automating Search Console UI clicks unless the user explicitly accepts an unofficial brittle solution.
- Do not recommend manual copy-paste for every URL as the long-term operating model.
- Do not skip sitemap and internal-link checks just because inspection is available.
- Do not treat absence from one indexing export as proof of index success.

## Example Triggers

Use this skill for prompts like:

- “Design a deployment workflow so new blog posts get discovered by Google faster.”
- “Automate sitemap submission and indexing checks after blog deploy.”
- “We keep manually pasting URLs into Search Console. Replace that with a stable workflow.”
- “Build a post-publish indexing monitor for my blog.”
