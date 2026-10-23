---
name: assets-media
description: >-
  Activate this skill to optimize images (WebP/AVIF), fonts, lazy loading, and media performance
  on the web. Use when optimizing Core Web Vitals (LCP, CLS), reducing bundle sizes, or auditing assets.
---

# Digital Assets & Media Performance Engineering

> **Scope**: High-performance image formats (AVIF, WebP), responsive image sizing, font optimization (FOIT/FOUT mitigation, subsetting), video streaming, asset caching headers, and Core Web Vitals optimization (LCP, CLS).

---

## When to Activate

- Auditing slow page loads or heavy page payloads
- Optimizing Largest Contentful Paint (LCP) caused by hero images
- Eliminating Cumulative Layout Shift (CLS) caused by unsized media or web fonts
- Converting legacy image assets (PNG, JPEG) to modern formats (WebP, AVIF)
- Implementing web font loading strategies and system font fallbacks
- Configuring CDN caching, immutable hashes, and responsive asset delivery

---

## 1. Image Optimization & Modern Delivery

### Formats Hierarchy
1. **AVIF**: Highest compression efficiency (typically 20-30% smaller than WebP at equivalent visual quality). Best for hero images and rich photography.
2. **WebP**: Broad compatibility across all modern browsers; excellent compression for photos and transparency.
3. **SVG**: For vector icons, logos, and geometric illustrations. Always sanitize SVGs to prevent stored XSS attacks.
4. **PNG/JPEG**: Fallbacks only when legacy browser compatibility is strictly required.

### Picture Element with Fallbacks
Always serve modern formats progressively:
```html
<picture>
  <source srcset="/hero.avif" type="image/avif">
  <source srcset="/hero.webp" type="image/webp">
  <img
    src="/hero.jpg"
    alt="Detailed description of hero visual"
    width="1200"
    height="630"
    loading="eager"
    fetchpriority="high"
    decoding="async"
    class="w-full h-auto object-cover"
  >
</picture>
```

### Cumulative Layout Shift (CLS) Prevention
- **Always provide explicit `width` and `height` attributes** on `<img>` and `<video>` tags. Browsers use these dimensions to compute the aspect ratio before image bytes arrive, preventing disruptive layout jumps.
- Use CSS `aspect-ratio: 16 / 9;` when image dimensions are dynamic.

### Loading Strategies (LCP vs Lazy)
- **Hero / Above-the-Fold Images (LCP)**:
  - NEVER use `loading="lazy"` on the LCP image.
  - Set `loading="eager"` and `fetchpriority="high"`.
  - Add `<link rel="preload" as="image" href="/hero.avif" type="image/avif">` in the document `<head>` for critical hero visuals.
- **Below-the-Fold Images**:
  - Always use `loading="lazy"`.
  - Use `decoding="async"` to keep image decoding off the main UI thread.

---

## 2. Web Font Optimization

### Eliminating Flash of Invisible Text (FOIT)
- Always specify `font-display: swap` in `@font-face` declarations to ensure text remains readable while custom web fonts download.
- Preload critical primary fonts (maximum 1 or 2 files):
  ```html
  <link rel="preload" href="/fonts/inter-latin-var.woff2" as="font" type="font/woff2" crossorigin>
  ```

### Modern Font Formats & Subsetting
- Use **WOFF2** exclusively (brotli-compressed; universally supported in modern browsers).
- Subset fonts to include only the characters required for the target locales (e.g., Latin subset, eliminating unused glyph tables).
- Prefer variable fonts (`font-weight: 100 900`) over loading 6 individual static font weights.

### Metric Override Fallbacks
Match fallback system fonts (Arial, Helvetica, Times) to the custom web font metrics using `@font-face` descriptor overrides (`size-adjust`, `ascent-override`, `descent-override`) to eliminate CLS during font swap.

---

## 3. Video & Media Streaming

- For short loop animations (under 10 seconds), replace bloated GIFs with looped, muted MP4/WebM videos (often 90% smaller payload):
  ```html
  <video autoplay loop muted playsinline width="600" height="400">
    <source src="/demo.webm" type="video/webm">
    <source src="/demo.mp4" type="video/mp4">
  </video>
  ```
- Always include `muted` and `playsinline` attributes to allow autoplay on iOS and modern browsers.
- For longer video content, use HLS / DASH adaptive bitrate streaming via a dedicated media provider (Mux, Cloudflare Stream, Vimeo) rather than hosting raw MP4 files.

---

## 4. HTTP Caching Headers & CDN Strategy

### Static Assets with Content Hashes (Vite, Webpack, Next.js)
For versioned assets with unique content hashes (e.g., `/assets/main.a8b1c2.js`, `/images/logo.f9e8d7.avif`):
```http
Cache-Control: public, max-age=31536000, immutable
```

### Unversioned Static Assets (e.g., `/favicon.ico`, `/robots.txt`)
```http
Cache-Control: public, max-age=3600, must-revalidate
```

---

## 5. Verification Release Checklist

- [ ] LCP image is preloaded or marked `fetchpriority="high"`, with NO lazy loading.
- [ ] Every `<img>` tag has explicit `width` and `height` attributes (or CSS aspect-ratio).
- [ ] Images are converted to AVIF/WebP formats with appropriate compression quality (typically 75-85%).
- [ ] Critical fonts use WOFF2 and `font-display: swap`.
- [ ] No bloated GIFs used for UI motion (replaced with WebM/MP4).
- [ ] Lighthouse Performance audit scores 90+ with Core Web Vitals in the green zone.
