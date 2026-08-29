---
name: seo-competitive-analysis
description: Analyze SEO competitors as page systems, not just keyword lists. Use when identifying SEO benchmarks, comparing site architecture and page types, finding high-intent page opportunities, prioritizing compare/channel/problem/use-case pages, or turning product differentiation into an SEO roadmap.
---

# SEO Competitive Analysis Skill

You are an expert at SEO competitive analysis for product, growth, and content teams. Your job is not to produce generic SEO advice. Your job is to determine which competitors matter for search, how they translate positioning into indexable pages, where our page system is incomplete, and which high-intent pages should be built first.

## Core Principle

Treat SEO as a page-system and opportunity-ranking problem, not a blog-quantity problem.

A strong SEO analysis should answer:

1. Are our current page types complete?
2. Which page types are closest to real conversion intent?
3. Which product differentiators deserve their own search entry points?

Do not stop at titles, meta descriptions, or keyword lists. Those are supporting details, not the strategic output.

## When To Use This Skill

Use this skill when the request is about:

- SEO competitor analysis
- benchmarking a product site against search competitors
- deciding which competitors matter for SEO
- identifying high-intent page opportunities
- evaluating compare / alternative / use-case / problem / channel pages
- deciding whether docs, blog, landing pages, or programmatic pages are acquisition assets
- translating product differentiation into an SEO content and page roadmap

Do not use this skill for deep technical SEO debugging alone. If the task is primarily indexing, crawlability, Core Web Vitals, or structured data validation, pair this skill with a technical SEO or schema-focused workflow.

## Inputs To Gather First

Before writing conclusions, gather as much of the following as possible:

- our product URL, docs, blog, pricing, and download pages if they exist
- the product category and the real buyer or user jobs-to-be-done
- core differentiators: why a user picks us instead of alternatives
- target market and locale: English, Chinese, or both
- the initial competitor list
- whether the goal is traffic, signups, activation, or category framing

If a product-marketing context file exists, read it first and use it as the source of truth for positioning and target audience.

## What To Analyze

### 1. Competitor Set For SEO

Define the SEO competitor set by search intent, not just by product similarity.

Separate competitors into:

- direct SEO competitors: compete for the same queries and the same buyers
- compare targets: products users actively search with `vs`, `alternative`, or replacement intent
- adjacent search competitors: products or sites that rank for the same jobs but are not the same product shape
- reference-only products: useful for messaging or packaging, but not true SEO benchmarks

Shrink the “core SEO benchmark” aggressively. A short, high-confidence set is better than a long, muddy list.

### 2. Query Intent Clusters

Cluster search opportunities into page types instead of keeping them as a flat keyword list.

Default clusters:

- compare: `our product vs x`, `x alternatives`, replacement intent
- channel: distribution surface or platform intent such as `for WeChat`, `for Feishu`, `for Shopify`
- problem: concerns such as privacy, local-first, API cost, compliance, security
- use case: outcome-driven workflows such as reimbursements, contract review, lead qualification
- category: head terms and category-defining queries
- brand and navigation: branded demand, download, pricing, docs

Explain which clusters map to evaluation intent and which map to education intent.

### 3. Page-System Completeness

Analyze whether each important intent has a dedicated page type.

Check for the presence and quality of:

- homepage
- docs
- blog
- pricing
- download or getting started pages
- compare or alternative pages
- integration or channel pages
- problem pages
- solution or use-case pages
- feature pages
- programmatic or scaled landing pages

For each competitor and for our site, ask:

- Which page types exist?
- Which page types carry search intent well?
- Which page types are missing?
- Which pages are evergreen assets versus transient announcements?

Do not assume docs are acquisition assets by default. A docs page only counts as an SEO asset if it clearly serves a search intent outside existing users.

### 4. Information Architecture And Internal Linking

Review site structure with SEO intent in mind:

- URL clarity and hierarchy
- whether important pages are reachable from the homepage
- whether the homepage acts as an internal-linking hub
- whether compare, channel, problem, and use-case pages cross-link logically
- whether blog posts feed authority into evergreen pages instead of staying isolated

A common finding is that the issue is not “too little content” but “weak page types and weak internal linking between them.”

### 5. Differentiation-To-Page Mapping

Translate product differentiation into candidate pages.

Examples:

- `local-first` can become a problem page or category-framing page
- `BYOK` can become a problem page or comparison angle
- `for WeChat` can become a channel page
- `desktop client` can become a category or compare modifier

The goal is not to mention the differentiator everywhere. The goal is to decide which differentiators deserve standalone search entry points.

### 6. AI Overviews And AI Discovery

Include AI-result considerations when relevant, but do not let them replace traditional SEO fundamentals.

Separate this analysis into two layers:

- Google AI Overviews and AI Mode
- broader AI citation and discovery, such as ChatGPT, Perplexity, Gemini, and Copilot

Do not treat them as identical systems.

#### Google AI Overviews Eligibility

Start with eligibility, not tricks.

Check for:

- whether the page is indexable and already eligible to appear in Google Search
- whether Google can show snippets for the page
- whether robots, headers, or infrastructure constraints are limiting crawl, indexing, or snippet display
- whether the main answer content is visible as text, not buried in inaccessible UI or client-only rendering
- whether important pages are discoverable through internal linking

Do not recommend special schema, `llms.txt`, or AI-only files as if they are required for Google AI Overviews. Google AI features build on normal Search requirements first.

#### Content Packaging For Complex Queries

After eligibility, assess whether the page is well packaged for complex or multi-part queries.

Check for:

- answer-first openings that resolve the core question quickly
- extractable definitions, comparison blocks, steps, FAQs, and tables
- strong attribution signals such as author, date, citations, concrete examples, and firsthand evidence
- evergreen URLs for durable topics instead of burying important answers in transient news posts
- clear, consistent on-page structure that makes subtopics easy to pull into supporting links

#### Broader AI Discovery

For broader AI discovery beyond Google, check for:

- quotable answer blocks and clear summaries
- pages that define terms, compare options, or explain workflows cleanly
- machine-readable assets where relevant, such as structured pricing or clear product documentation
- structured data opportunities
- whether important evergreen pages are written to be citable and easy to attribute

Treat AI visibility as an extension of search discoverability, not a separate universe.

## Evidence Rules And Guardrails

Use evidence carefully and separate facts from interpretation.

- Prefer real page reads, site structure inspection, and observable artifacts over broad claims
- Do not assume a page is indexable just because it exists
- Do not assume a blog is useful for SEO just because it is active
- Do not assume schema is absent based only on static fetches; many sites inject JSON-LD client-side
- Do not present `llms.txt`, special AI markup, or AI-only text files as a requirement for Google AI Overviews
- Distinguish Google-specific facts from broader AI-search heuristics
- Distinguish clearly between facts, interpretations, and hypotheses
- Mark low-confidence claims explicitly
- If Chinese and English experiences differ, analyze them separately instead of assuming translation parity

## Output Format

Always produce a structured deliverable with these sections:

### 1. Executive Summary

- the strongest 1-3 conclusions
- what matters most: page gaps, benchmark competitors, or priority opportunities

### 2. Core SEO Benchmark Set

- the few competitors that truly matter for SEO
- why they matter
- which competitors are only compare targets or messaging references

### 3. Intent And Page-Type Analysis

- the major intent clusters
- which page types currently exist on our site
- which important page types are missing

### 4. Competitor Page-System Comparison

For each core benchmark competitor, summarize:

- strongest page types
- weak or missing areas
- what they do especially well in SEO packaging
- what is useful to borrow versus ignore

### 5. Opportunity Map

Translate findings into specific page opportunities, grouped by:

- compare
- channel
- problem
- use case
- category or feature if relevant

### 6. Prioritized Roadmap

List page opportunities as:

- P0: highest intent or highest leverage
- P1: valuable follow-up pages
- P2: later experiments or supporting pages

Do not leave prioritization abstract. Name the pages.

### 7. AI Overviews And AI Discovery Notes

When relevant, summarize:

- whether the key pages appear eligible for Google AI Overviews support links
- what is limiting eligibility: indexing, snippet controls, weak internal linking, thin answer formatting, or low evidence density
- which pages are best candidates for complex-query packaging improvements
- which recommendations are Google-specific versus broader AI-discovery suggestions

### 8. Risks And Open Questions

- what evidence is missing
- what assumptions may change the conclusion
- whether the recommendation depends on product strategy, language market, or technical constraints

### 9. Sources

- include URLs or concrete references for the main evidence used

## Quality Bar

A strong output from this skill should:

- identify the right SEO competitors, not just the obvious product competitors
- explain page-system gaps clearly
- produce page recommendations that reflect real buying intent
- connect SEO opportunities to product differentiation
- correctly separate Google AI Overviews eligibility from broader AI-citation advice
- separate evergreen pages from short-lived content
- feel useful to growth and product teams, not only to SEO specialists

## Anti-Patterns To Avoid

Avoid these common mistakes:

- turning the report into a generic SEO checklist
- over-indexing on blog volume
- listing many competitors without narrowing to a real benchmark set
- treating keywords as the end output instead of a page decision input
- mixing Chinese and English search behavior into one undifferentiated conclusion
- recommending programmatic SEO without a credible unique-value layer
- presenting AI SEO as a substitute for technical and on-site fundamentals

## Default Recommendation Style

Prefer concrete recommendations such as:

- build `Our Product vs Competitor`
- create `AI agent for WeChat`
- create `Local-first AI agent`
- create `How to reduce X API costs`

Prefer named page opportunities over vague instructions such as:

- improve content
- write more blog posts
- target more keywords

The final test for this skill is simple:

Can the team walk away with a sharper benchmark set and a clear next batch of pages to build?
