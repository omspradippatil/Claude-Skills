# SEO Policy

This policy applies to all tasks involving search engine optimization, domain changes, metadata, sitemaps, structured data, or performance optimization that affects discoverability. Load this file for any task categorized as **SEO**, **Marketing**, or **Deployment** when URLs or domains are affected.

---

## 1. Technical SEO Fundamentals

### Inspect Before Recommending

Before making any SEO recommendation or change:

1. **Inspect the framework and routing** — Determine whether the site uses SSR (Next.js, Nuxt, SvelteKit), SSG (Astro, Hugo, Jekyll), or CSR (pure React/Vue/Angular SPA). SEO recommendations differ significantly based on rendering mode.
2. **Check the actual production domain** — Do not assume. Read configuration files, `package.json` scripts, Vercel/Netlify config, or ask the user before setting canonical URLs.
3. **Check existing metadata** — Read the current `<head>` implementation before writing new tags to avoid duplication.

### Canonical URLs

- Every indexable page must have a self-referencing canonical tag: `<link rel="canonical" href="https://example.com/page-path" />`
- Canonical URLs must be:
  - Absolute (including protocol and domain)
  - The final destination URL (not a redirect)
  - Consistent with the sitemap entry
- Do not set canonical tags pointing to redirect chains. Canonicals must resolve to a `200 OK` response.
- When duplicate content exists (e.g., pagination, query strings, UTM params), use canonicals or `noindex` appropriately.

### Robots.txt

- Ensure `robots.txt` is accessible at the root: `https://example.com/robots.txt`
- Do not block crawling of pages that should be indexed.
- Do not allow crawling of admin panels, API endpoints, or private content.
- Verify that `robots.txt` references the sitemap URL.

### Metadata

- **Title tags**: Unique per page; descriptive; target keyword near the front; 50–60 characters recommended.
- **Meta descriptions**: Unique per page; 150–160 characters; summarize the page's value; include a call to action where appropriate. Do not keyword-stuff.
- **Heading hierarchy**: One `<h1>` per page; use `<h2>`–`<h6>` for logical structure; do not skip levels.
- **Alt text**: All meaningful images must have descriptive alt text. Decorative images use `alt=""`. Never leave alt text as the filename or a generic placeholder like "image1".
- **Open Graph / Twitter Cards**: Set `og:title`, `og:description`, `og:image`, `og:url` for social sharing on all key pages.

### CSR Limitations

- Client-side-rendered (CSR) pages with no SSR or SSG have limited SEO value. Search engine crawlers may not execute JavaScript reliably or consistently.
- For CSR apps: implement pre-rendering, SSR, or SSG for pages that need to be indexed.
- Do not recommend CSR-only solutions for landing pages, blog posts, or product pages that need to rank.

### Redirect Handling

- Use `301` (permanent) redirects for permanent URL changes (domain migrations, slug changes).
- Use `302` for truly temporary redirects only.
- Avoid redirect chains (A → B → C). Resolve to a single redirect.
- After a domain migration, verify all old URLs 301 to the correct new URLs.
- Update internal links to point to the destination URL directly — do not rely on redirects for internal navigation.

### Hreflang

- Only implement `hreflang` when the site actually serves content in multiple languages or for multiple regional locales.
- Do not add `hreflang` tags speculatively or as a future-proofing measure.
- `hreflang` tags must be reciprocal: each alternate page must reference all other alternates including itself.
- Use valid BCP 47 language codes (e.g., `en-US`, `fr-FR`, `es`).

---

## 2. Domain Migrations

Domain migrations are high-risk SEO operations. Follow this procedure:

1. **Inspect the actual production domain** before touching any canonical tags, sitemaps, manifests, or configuration files. Read `vercel.json`, `netlify.toml`, DNS records documentation, or ask the user.
2. **Remove obsolete deployment preview URLs** from canonical tags, sitemaps, and web manifests. Preview URLs (e.g., `*.vercel.app`, `*.netlify.app`) must never appear in canonical tags or sitemaps when a custom production domain is in use.
3. **Verify DNS**: Confirm the new domain's DNS records are correctly configured and propagated.
4. **Verify HTTPS**: Confirm SSL/TLS certificates are valid and auto-renewing on the new domain.
5. **Verify redirects**: Old domain → new domain redirects must return `301`, with correct target URLs.
6. **Update all internal references**: Update hardcoded URLs in code, environment variables, and content.
7. **Submit to Search Console**: After migration, submit the new sitemap and use the Change of Address tool in Google Search Console.
8. **Monitor**: Watch Search Console for crawl errors and indexing status in the weeks following migration.

---

## 3. Sitemaps

- The sitemap must only include URLs that:
  - Return `200 OK`
  - Are indexable (not `noindex`)
  - Are canonical (not duplicated by canonicals pointing elsewhere)
  - Do not redirect to another URL
- Do not include admin pages, API endpoints, or private content in the sitemap.
- Update the sitemap whenever new indexable pages are added or removed.
- Reference the sitemap in `robots.txt`: `Sitemap: https://example.com/sitemap.xml`
- For large sites (>50,000 URLs), use a sitemap index file.

---

## 4. Performance and Core Web Vitals

SEO is directly affected by Core Web Vitals. Optimize for:

### Largest Contentful Paint (LCP) — Target: < 2.5s
- Preload the LCP image with `<link rel="preload" as="image">`.
- Serve images in next-gen formats (WebP, AVIF).
- Avoid lazy-loading the LCP element.
- Use a CDN for static assets.

### Interaction to Next Paint (INP) — Target: < 200ms
- Minimize long JavaScript tasks (>50ms) on the main thread.
- Defer non-critical JavaScript.
- Use `requestIdleCallback` or web workers for heavy computation.

### Cumulative Layout Shift (CLS) — Target: < 0.1
- Always set explicit `width` and `height` on images and video.
- Reserve space for ads, embeds, and dynamic content.
- Avoid inserting content above existing content after page load.

**Constraint**: Do not sacrifice accessibility for performance gains. Never hide content with `display:none` purely for performance if that content is needed by screen readers or keyboard users.

### Additional Performance
- Optimize font loading: use `font-display: swap`; preload critical fonts; self-host fonts where possible.
- Minify and compress JavaScript and CSS bundles.
- Enable HTTP/2 or HTTP/3.
- Set appropriate caching headers for static assets.

---

## 5. Structured Data

- Validate all structured data against [schema.org](https://schema.org) definitions before deploying.
- Use Google's Rich Results Test to verify eligibility for rich results.
- Support JSON-LD format (preferred by Google) in the `<head>` of the document.

### Strict Integrity Rules

**NEVER fabricate or invent structured data values. Specifically:**

- **Never add fake reviews or ratings** to `Product`, `LocalBusiness`, or `Recipe` schema. Only include real, verifiable reviews.
- **Never invent aggregate ratings** (`aggregateRating`). Only include if real rating data exists.
- **Never fabricate author information** in `Article` or `BlogPosting` schema. Authors must be real people or organizations that produced the content.
- **Never add invented `datePublished` or `dateModified`** timestamps. Use accurate dates.
- Fabricated structured data violates Google's guidelines and can result in manual actions against the site.

---

## 6. Validation Checklist

Before completing any SEO-related task, verify:

- [ ] **Canonical tags**: Present on all indexable pages; absolute URLs; no redirect chains
- [ ] **Sitemap validity**: All URLs return `200 OK`; no redirects, errors, or noindex pages included; sitemap referenced in `robots.txt`
- [ ] **Robots.txt**: Accessible; no accidental blocking of indexable content; sitemap referenced
- [ ] **Broken links**: No internal 404s on key pages
- [ ] **HTTP status**: All canonical pages return `200 OK`
- [ ] **Duplicate titles**: Each page has a unique title tag
- [ ] **Missing descriptions**: All key pages have meta descriptions
- [ ] **Missing alt text**: All meaningful images have descriptive alt text
- [ ] **Structured data**: Valid JSON-LD; no fabricated values; validated with Rich Results Test
- [ ] **Mobile usability**: No viewport or tap-target issues
- [ ] **HTTPS**: All pages served over HTTPS; no mixed content warnings
- [ ] **Preview URLs removed**: No `*.vercel.app` or `*.netlify.app` URLs in canonicals, sitemaps, or manifests
- [ ] **Core Web Vitals**: LCP < 2.5s, INP < 200ms, CLS < 0.1 (verify with PageSpeed Insights or CrUX)
