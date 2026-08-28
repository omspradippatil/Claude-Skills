---
name: seo-optimization
description: Diagnose SEO issues from Search Console data, indexing exports, URL lists, and source code, then prioritize structural fixes, indexing work, and page-level CTR improvements. Use when a user asks what to fix first in SEO, wants to connect GSC evidence to code changes, needs title/meta recommendations for high-potential pages, or needs a defensible priority order across templates, routes, and individual pages.
---

# SEO Optimization

## Overview

Optimize SEO by deciding the right layer of work first. Separate structural defects, indexing instability, and page-level click-through problems before recommending code or content changes.

## Default Order Of Operations

Use this order unless the user explicitly wants only one subtask:

1. Validate the data scope.
2. Identify the site-level traffic pattern.
3. Classify pages by bottleneck.
4. Check for repeated structural failures.
5. Recommend page-level rewrites only for pages that already have real opportunity.

## 1. Validate the data scope

Confirm:

- date range
- search type
- whether the export is site-wide or filtered
- whether totals reconcile across files
- whether different exports came from different dates

If there is a mismatch, state it and choose the authoritative dataset. Do not continue as if the scope were clean.

## 2. Identify the traffic pattern

Summarize:

- total clicks
- total impressions
- site CTR
- where clicks are concentrated

Then classify the pattern:

- brand-heavy
- download-heavy
- early content acquisition
- broad non-brand discovery

Use this classification to decide whether the site needs discovery work, CTR work, or indexing cleanup first.

## 3. Classify pages by bottleneck

Put each relevant URL into one of these buckets:

- `Low impressions`
- `High impressions, low CTR`
- `Investigate indexing first`
- `Fix structure first`
- `Observe for now`

Use these rules:

- A page with impressions and a workable position but weak clicks is a CTR candidate.
- A page with almost no impressions is not a CTR candidate yet.
- A page in an indexing failure bucket needs indexing work before title polishing.
- A recurring template issue across multiple URLs is a structure problem, not a page problem.

## 4. Check structural issues before rewriting pages

Inspect for:

- weak list-page metadata
- duplicate route patterns
- broken canonical logic
- incorrect hreflang or alternates
- fake locale pages
- bad sitemap inclusion rules
- weak internal linking
- category or tag pages with little unique value

If two or more URLs show the same defect, prioritize the template or route fix.

## 5. Recommend page-level changes only when justified

Recommend title or meta rewrites only when all of these are true:

- the page already has impressions
- ranking is within a realistic click range
- CTR is weak for the page type
- search intent is identifiable
- the page matters to the business

Prefer:

- guides
- comparisons
- setup pages
- use-case pages

Default to lower priority for news pages unless the data clearly supports action.

## Code Mapping

If source code is available, connect the SEO problem to implementation files. Inspect:

- metadata templates
- route generation
- locale fallbacks
- canonical and alternate builders
- sitemap generation
- list-page templates
- internal linking components

Output:

- the file or files responsible
- whether the change should be template-level or page-level
- which URLs should not be changed yet

## Output Format

Produce:

1. Executive summary
2. Data scope validation
3. Site-level pattern
4. Priority buckets with reasons
5. Structural issues
6. Recommended actions in strict priority order
7. Optional title/meta rewrites for the top justified pages only
8. Confidence and limitations

## Guardrails

- Do not equate visibility in Performance with stable indexing.
- Do not assume a URL is indexed because it is absent from one coverage export.
- Do not recommend bulk manual indexing as a primary strategy.
- Do not give generic advice when the evidence supports a specific file-level or page-level action.
- Do not optimize every page equally.

## Example Triggers

Use this skill for prompts like:

- “Analyze these Search Console exports and tell me what to fix first.”
- “Review this blog code and identify structural SEO problems.”
- “Which pages should I optimize for CTR versus indexing?”
- “Give me a priority order for title rewrites based on GSC data.”
- “Tell me whether this is a sitemap, hreflang, canonical, or metadata problem.”
