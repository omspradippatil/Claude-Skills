---
name: seo-marketing
description: >-
  Activate this skill for technical SEO audits, meta tags, structured data (JSON-LD),
  Core Web Vitals optimization, sitemaps, robots.txt, and Open Graph. Use when improving
  search visibility, auditing indexability, or preparing a site for launch.
---

# SEO & Marketing Skill

---

## When to Activate

- Technical SEO audits (indexability, crawlability)
- Adding or fixing meta titles, descriptions, canonical tags
- Implementing structured data with JSON-LD (schema.org)
- Validating Open Graph and Twitter Card tags
- Core Web Vitals analysis and optimization (LCP, CLS, INP)
- Sitemap XML generation and validation
- robots.txt auditing
- Domain migrations with 301 redirect strategies
- Auditing client-side rendered (CSR/SPA) apps for indexing gaps

---

## Audit Process (Step-by-Step)

### Step 1 — Identify Framework, Rendering Mode & Hosting
Before any SEO work, establish the rendering context:
- **Rendering mode**: SSR (Next.js, Nuxt, SvelteKit), SSG (static export), CSR (pure SPA), ISR (incremental static regen)
- **Hosting**: Vercel, Netlify, Cloudflare Pages, Firebase Hosting, custom server
- **Framework**: Next.js App Router vs Pages Router, Astro, Remix, Gatsby, etc.

Rendering mode determines indexability risk:
- SSR/SSG → generally safe for SEO
- CSR → significant risk; Googlebot may not execute JS reliably; prefer prerendering or SSR for key pages

### Step 2 — Check Canonical URLs
- Every page must have a self-referencing `<link rel="canonical" href="...">` tag.
- Canonical must use the production domain with consistent protocol (always `https://`).
- www vs non-www must be consistent and canonical must reflect the chosen form.
- Paginated pages: use canonical pointing to self (not page 1) or use `rel=prev/next` pattern.
- Check for duplicate content: trailing slash consistency (`/about` vs `/about/`).
- Verify dynamic pages (filters, sorting) use canonical to suppress parameter variants.

```html
<!-- Correct: absolute URL, https, consistent subdomain -->
<link rel="canonical" href="https://www.example.com/blog/my-post" />
```

### Step 3 — Validate Sitemap XML
- Sitemap should exist at `/sitemap.xml` (or linked from `robots.txt`).
- All important URLs included; exclude: 404s, 301s, noindex pages, paginated duplicates.
- `<lastmod>` dates should reflect actual content modification (not build time for static pages).
- For large sites, use sitemap index with multiple sub-sitemaps.
- Validate with Google Search Console or `xmllint --noout sitemap.xml`.
- Image sitemap recommended for image-heavy sites.
- Submit sitemap to Google Search Console and Bing Webmaster Tools.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://www.example.com/</loc>
    <lastmod>2024-01-15</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
```

### Step 4 — Review robots.txt
- Must be at `/robots.txt` (root, lowercase, `.txt` extension).
- Ensure `Disallow:` rules don't accidentally block important pages or assets.
- CSS/JS files must NOT be blocked — Googlebot needs them to render pages.
- Check `Sitemap:` directive points to correct sitemap URL.
- Never block `Googlebot` entirely in production.
- Environment-specific: staging/preview environments should use `Disallow: /` or be blocked via `X-Robots-Tag` header.

```
User-agent: *
Disallow: /api/
Disallow: /admin/
Disallow: /_next/  # WRONG — blocks Next.js assets
Allow: /

Sitemap: https://www.example.com/sitemap.xml
```

### Step 5 — Audit Metadata (Titles, Descriptions, Headings, Alt Text)
**Title tags:**
- Unique per page — no duplicates.
- Length: 50–60 characters (displayed); include primary keyword near front.
- Format: `Primary Keyword | Brand Name` or `Descriptive Title — Brand`.
- Never: generic titles like "Home", "Page", or the same title on every page.

**Meta descriptions:**
- Unique per page.
- Length: 120–160 characters.
- Written as a compelling call-to-action, not a keyword dump.
- Not a ranking factor directly, but influences click-through rate (CTR).

**Heading hierarchy:**
- One `<h1>` per page — matches or complements title tag.
- Logical hierarchy: `h1 > h2 > h3` — no skipping levels for styling.
- Headings describe content, not decorative text.

**Image alt text:**
- Every `<img>` has a meaningful `alt` attribute (or `alt=""` for decorative images).
- Describe what the image shows; avoid "image of" or "photo of" prefixes.
- Include keyword naturally where contextually accurate.

### Step 6 — Check Structured Data with JSON-LD
- Prefer JSON-LD over Microdata/RDFa (Google's recommended format).
- **Never fabricate data** — structured data must reflect actual page content. Fabricated data violates Google's guidelines and can result in manual penalties.
- Validate with [Google Rich Results Test](https://search.google.com/test/rich-results) and [Schema.org Validator](https://validator.schema.org/).
- Common schema types:

```html
<!-- Article / BlogPosting -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Actual Article Title",
  "author": { "@type": "Person", "name": "Actual Author Name" },
  "datePublished": "2024-01-15",
  "dateModified": "2024-02-01",
  "image": "https://example.com/actual-image.jpg",
  "publisher": {
    "@type": "Organization",
    "name": "Brand Name",
    "logo": { "@type": "ImageObject", "url": "https://example.com/logo.png" }
  }
}
</script>
```

```html
<!-- Organization (homepage) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "Brand Name",
  "url": "https://www.example.com",
  "logo": "https://www.example.com/logo.png",
  "sameAs": [
    "https://twitter.com/brand",
    "https://linkedin.com/company/brand"
  ]
}
</script>
```

```html
<!-- FAQ -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [{
    "@type": "Question",
    "name": "Actual question from the page?",
    "acceptedAnswer": { "@type": "Answer", "text": "Actual answer text." }
  }]
}
</script>
```

### Step 7 — Validate Open Graph & Twitter Cards
```html
<!-- Open Graph (required) -->
<meta property="og:title" content="Page Title" />
<meta property="og:description" content="Page description for social sharing" />
<meta property="og:image" content="https://example.com/og-image.jpg" />
<meta property="og:url" content="https://example.com/page" />
<meta property="og:type" content="website" /> <!-- or "article" -->
<meta property="og:site_name" content="Brand Name" />

<!-- Twitter Card -->
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:title" content="Page Title" />
<meta name="twitter:description" content="Page description" />
<meta name="twitter:image" content="https://example.com/og-image.jpg" />
```

OG image requirements:
- Minimum 1200×630px; recommended 1200×630 exactly.
- Under 8MB file size.
- Ratio: 1.91:1 landscape preferred.
- Use a unique, page-specific OG image where possible (not the same one on every page).

Validate with: Facebook Sharing Debugger, LinkedIn Post Inspector, Twitter Card Validator.

### Step 8 — Check CSR Indexing Limitations
For React, Vue, Angular SPAs without SSR:
- Key content must be in the initial HTML — not rendered exclusively by JS.
- Check page source (`Ctrl+U` / `view-source:`) — if content is absent there, crawlers may miss it.
- Solutions: implement SSR, SSG, or use a prerendering service (e.g., Prerender.io).
- Dynamic `<title>` and meta tags must be set at SSR time or via a framework (Next.js `<Head>`, React Helmet).
- Test with `curl -A "Googlebot"` to simulate bot perspective.
- Check Google Search Console → URL Inspection for how Google actually sees the page.

### Step 9 — Review Redirects & Status Codes
- All important pages return 200 OK.
- Removed/renamed pages return 301 (permanent) redirect to the correct URL — not 302 (temporary).
- Redirect chains: A→B→C should be collapsed to A→C.
- Redirect loops: detect with `curl -L -v` and trace the chain.
- 404 pages: return HTTP 404 status (not 200 with "Not Found" content — "soft 404").
- 410 Gone: use for permanently deleted content to signal removal to search engines.
- Monitor: `curl -o /dev/null -s -w "%{http_code}" https://example.com/page`

### Step 10 — Measure Core Web Vitals
Key metrics (as of 2024 thresholds):
| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| **LCP** (Largest Contentful Paint) | ≤2.5s | 2.5–4.0s | >4.0s |
| **INP** (Interaction to Next Paint) | ≤200ms | 200–500ms | >500ms |
| **CLS** (Cumulative Layout Shift) | ≤0.1 | 0.1–0.25 | >0.25 |

Tools: Google PageSpeed Insights, Lighthouse (Chrome DevTools), Web Vitals Chrome Extension, CrUX (field data in Search Console).

**LCP optimization:**
- Preload the LCP image: `<link rel="preload" as="image" href="hero.jpg">`
- Avoid lazy-loading the LCP element
- Use next-gen formats: WebP, AVIF
- Use a CDN for image delivery

**CLS optimization:**
- Set explicit `width` and `height` on all images and video
- Reserve space for ads and embeds
- Avoid inserting content above existing content after load
- Use `font-display: swap` with fallback font matching

**INP optimization:**
- Break up long tasks (>50ms) with `scheduler.yield()`
- Minimize JS parsing on the main thread
- Defer non-critical third-party scripts

---

## Domain Migration Checklist

When migrating to a new domain or restructuring URLs:

**Pre-launch:**
- [ ] Map all old URLs to new URLs (complete redirect map)
- [ ] 301 redirects configured server-side (not JS redirects)
- [ ] All internal links updated to new URLs
- [ ] New sitemap ready with new URLs
- [ ] Canonical tags point to new domain
- [ ] robots.txt updated for new domain

**At launch:**
- [ ] Verify 301s working for top pages
- [ ] Submit new sitemap in Google Search Console
- [ ] Use "Change of Address" tool in GSC (for full domain moves)
- [ ] Monitor crawl errors in GSC for 48–72 hours

**Post-launch:**
- [ ] Old domain redirects maintained for minimum 12 months
- [ ] Monitor organic traffic for 4–8 weeks (expect short-term dip)
- [ ] Disavow file reviewed if old domain had spam links
- [ ] Update backlinks where possible (reach out to top referring domains)

---

## SEO Release Gate Checklist

### Blocking (Must Pass)
- [ ] **Canonical tag** present and correct on every indexable page
- [ ] **Sitemap XML** valid, submitted, and excludes noindex/redirect pages
- [ ] **robots.txt** not blocking CSS, JS, or key content pages
- [ ] **HTTP status codes** correct (200 for live pages, 301 for moved, 404 for missing)
- [ ] **No duplicate titles** across key pages
- [ ] **No missing meta descriptions** on priority pages
- [ ] **HTTPS only** — no mixed content, no HTTP pages
- [ ] **Structured data validates** with no errors in Rich Results Test

### High Priority
- [ ] **Alt text** on all meaningful images
- [ ] **Mobile usability** passing (Google Mobile-Friendly Test)
- [ ] **Open Graph tags** present on shareable pages
- [ ] **Core Web Vitals** in "Good" range for LCP and CLS
- [ ] **No soft 404s** — missing content returns actual 404 status
- [ ] **One H1 per page** that matches page intent

### Recommended
- [ ] Schema markup for applicable page types (Article, Product, FAQ, etc.)
- [ ] Twitter Card tags for social sharing
- [ ] `hreflang` configured for multi-language/region sites
- [ ] Google Search Console property verified and sitemap submitted
- [ ] Page speed score ≥ 70 on mobile in PageSpeed Insights
