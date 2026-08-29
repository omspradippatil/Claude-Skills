---
name: gsc-seo-prioritizer
description: Analyze Google Search Console exports and indexing reports to identify whether an SEO problem is caused by low impressions, low CTR, unstable indexing, or site-structure issues. Use when working with Search Console Performance CSV exports, Coverage/Page Indexing exports, URL inspection results, sitemap/indexability questions, or when deciding which pages to fix first and whether the right action is structural SEO work or page-level title/meta updates.
---

# GSC SEO Prioritizer

## Overview

Turn Search Console data into execution priorities. Distinguish between:

- not enough search demand or exposure
- enough exposure but weak click-through
- indexing instability
- structural SEO problems that invalidate page-level tuning

Do not treat this skill as a reporting exercise. Use it to decide what to fix first.

## Inputs

Work with any subset of these inputs:

- Search Console `Performance` exports such as `Pages.csv`, `Queries.csv`, `Chart.csv`, `Devices.csv`, `Countries.csv`, `Filters.csv`
- `Page indexing` or `Coverage` exports
- URL Inspection outputs or screenshots
- a list of URLs the user cares about
- optional source code or templates for metadata, canonical, hreflang, sitemap, and internal linking

If the user provides both exported files and a live Search Console URL, treat the exported files as the authoritative dataset unless the user confirms otherwise.

## Workflow

### 1. Validate the data scope first

Before drawing conclusions, verify:

- date range
- search type
- whether totals reconcile across exported files
- whether multiple exports come from different dates or filters

Call out any mismatch explicitly. Typical examples:

- the shared Search Console link says `Last 28 days` but `Filters.csv` says `Last 3 months`
- `Chart.csv` contains only a 7-day slice while totals reflect the full export
- one export is site-wide and another is page-filtered

If the scope is inconsistent, state which dataset you are using for analysis and why.

### 2. Summarize the site-level pattern

Compute and state:

- total clicks
- total impressions
- site CTR
- where clicks are concentrated

Then classify the traffic pattern:

- brand-heavy: homepage, download, or brand queries dominate clicks
- content-acquisition early: blog pages have impressions but few or zero clicks
- broad discovery: non-brand queries and long-tail pages are already earning clicks

This classification determines whether the current bottleneck is content discovery or click conversion.

### 3. Split problems into four buckets

For each page or page group, classify the issue as one of:

1. `Low impressions`
   - The page is not yet getting meaningful exposure.
   - Do not default to title rewrites.
   - Check indexing, internal links, sitemap inclusion, and topical fit first.

2. `High impressions, low CTR`
   - The page is visible and ranked well enough to matter.
   - Prioritize title, meta description, search intent match, and SERP positioning.

3. `Indexed exposure with unstable indexing signals`
   - The page appears in Performance, but related URLs or alternates show indexing issues.
   - Check canonical, hreflang, duplicates, alternate language routes, and route generation.

4. `Structural SEO problem`
   - Multiple URLs show the same failure pattern.
   - Fix the system before editing more pages.

Do not collapse these buckets into one vague “SEO issue.”

## Performance Analysis Rules

### Treat exposure and clicks separately

Use these rules:

- If a page has impressions, decent average position, and zero clicks, it is a CTR candidate.
- If a page has almost no impressions, it is not yet a CTR candidate.
- If clicks are concentrated on brand or download pages, content SEO has not matured yet.
- If a list page like `/blog` has impressions but no clicks, inspect list-page title and description before rewriting articles.

### Prioritize pages for CTR work only when all of these are true

- impressions already exist
- average position is in a clickable range, usually top 10
- CTR is materially below expectation for that page type
- search intent is clear
- the page is business-relevant

For business-relevance, prefer:

- guides
- comparisons
- setup or integration pages
- use-case pages

Default to lower priority for news pages unless data clearly supports them.

### Interpret query patterns

Use query data to separate:

- brand demand
- download intent
- setup or integration intent
- comparison intent
- broad news or commentary intent

Do not recommend title changes that ignore the actual query pattern. Make page recommendations reflect the search intent already surfacing in GSC.

## Indexing Analysis Rules

### Keep indexing and performance concepts separate

Use these rules:

- `Appears in Performance` does not mean “stable indexing is solved.”
- `Not present in one coverage export` does not mean “indexed.”
- `Discovered - currently not indexed` means Google knows the URL but has not admitted it into the index.
- `Crawled - currently not indexed` means Google evaluated it and did not keep it.
- `Alternate page with proper canonical` means that URL is not the page to optimize directly.

If a page is in a specific coverage bucket, say exactly which bucket and what that bucket implies.

### When the user gives only one coverage export

State the limitation clearly:

- one coverage export is one issue bucket, not the full indexing state
- URLs absent from that file may still be indexed, or may be in other buckets

Do not overclaim.

## Structural SEO Diagnosis

Before recommending broad title rewrites, check for recurring structural problems such as:

- duplicate or weak list-page metadata
- fake or fallback language versions
- incorrect `hreflang` or alternate generation
- canonical conflicts
- route duplication like `/home` versus `/`
- sitemap containing URLs that should not be promoted
- weak article-to-article internal links
- category or tag pages that dilute crawl budget without unique value

If two or more pages show the same problem pattern, default to a structural fix rather than page-by-page editing.

## Decision Rules

### Recommend structural fixes first when any of these are true

- language alternates are generated for content that does not truly exist
- multiple pages share the same metadata weakness
- indexing issues cluster by route pattern
- list pages or templates are obviously under-optimized
- internal linking is too weak for new pages to be discovered reliably

### Recommend page-level title/meta work only when all of these are true

- the page already has exposure
- the template is not the main blocker
- the page is a high-intent asset
- a clear rewrite can better match observed search intent

### Recommend manual indexing only sparingly

Use `Request indexing` as a tactical acceleration step, not the main strategy.

Suggest it only for:

- a small number of high-value pages
- pages with recent meaningful fixes
- pages explicitly stuck in an indexing state where faster reevaluation matters

Do not recommend manual submission for every URL in a list.

## Output Format

Produce these sections when the user wants a full analysis:

### 1. Executive summary

State:

- what the core bottleneck is
- whether the site currently needs structure work, CTR work, or indexing work first
- what the immediate next action should be

### 2. Priority buckets

Group URLs into:

- `Fix structure first`
- `Prioritize CTR optimization`
- `Investigate indexing first`
- `Observe for now`

Explain why each URL belongs in its bucket.

### 3. Specific actions

For each recommended action, tie it to evidence. Examples:

- rewrite `/blog` title because it has strong impressions but no clicks
- remove false `/zh/blog/...` alternates because language-route noise is clustering in indexing issues
- add related-post links because new or deeper articles lack discovery support

### 4. Constraints and confidence

State what you know, what you infer, and what remains unverified.

## If source code is available

Extend the analysis into implementation guidance. Inspect:

- metadata templates
- page routes
- locale fallback logic
- canonical and alternate generation
- sitemap generation
- article templates and internal linking components

Then output:

- which files drive the issue
- whether the fix should be template-level or page-level
- which pages should not be touched yet

## Guardrails

- Do not equate visibility with index stability.
- Do not recommend broad title rewrites before checking template-level issues.
- Do not prioritize news-page rewrites unless GSC data clearly justifies them.
- Do not claim that a URL is indexed solely because it is absent from one coverage export.
- Do not give generic SEO advice when the data supports a specific action.

## Example Triggers

Use this skill for prompts like:

- “Analyze these Search Console exports and tell me what to fix first.”
- “Which pages should I optimize for CTR versus indexing?”
- “These blog URLs have impressions but no clicks. Is this a title problem or a structure problem?”
- “This coverage export says discovered but not indexed. What should I do?”
- “Review my blog code and tell me whether the SEO issue is hreflang, canonical, sitemap, or titles.”
