---
name: frontend-design
description: >-
  Activate this skill for UI/UX tasks, CSS styling, layout building, component design,
  or aesthetic improvements. Use when redesigning interfaces, building new pages, reviewing
  visual polish, ensuring accessibility, or establishing a design system.
---

# Frontend Design Skill — UI/UX Pro Max

---

## When to Activate

- Designing or redesigning pages, components, or entire UI systems
- CSS layout work (grid, flexbox, positioning, responsive breakpoints)
- Component API design and variant systems
- Visual polish and design consistency reviews
- Accessibility audits (WCAG AA compliance)
- Motion design and animation implementation
- Design token / design system setup
- Dark mode implementation

---

## Design Read Process (Before Generating Any UI)

Before writing a single line of CSS or JSX, answer these questions by reading the existing codebase and context:

1. **Page kind**: Landing page? Dashboard? Auth flow? Content page? Checkout? Each has different visual conventions and user expectations.
2. **Audience**: B2B SaaS? Consumer app? Developer tool? Young users? Enterprise? This defines tone, density, and sophistication.
3. **Brand vibe**: What adjectives describe the brand? (e.g., "reliable, friendly, modern" vs "premium, minimal, serious"). Look at existing color usage, typography, logo style.
4. **Constraints**: Existing design system? Tailwind config? Figma tokens? CSS variables already defined? Component library (shadcn, Radix, MUI)? Don't introduce conflicting patterns.
5. **Content reality**: What is the actual content? Never design with fake testimonials, fake user counts, or lorem ipsum shipped to production.

Only after this read should you begin designing or coding.

---

## Anti-Slop Rules (Never Do These)

These are the defaults that make AI-generated UI look generic and forgettable:

- ❌ **No AI purple gradient** — `linear-gradient(to right, #6366f1, #8b5cf6)` hero backgrounds. It signals "AI made this."
- ❌ **No generic glassmorphism** — `backdrop-filter: blur(10px); background: rgba(255,255,255,0.1)` on everything without purpose.
- ❌ **No Inter + slate-900 as the only typographic choice** — fine as a base, but differentiate with weight, size, and spacing intentionally.
- ❌ **No Heroicons + rounded cards + gradient CTAs** if everything on the page uses this pattern — vary the visual language.
- ❌ **No placeholder content shipped** — "Lorem ipsum", "John Doe", "3,482 happy customers" (when unverified) never ship.
- ❌ **No fake reviews or testimonials** — fabricated social proof is deceptive.
- ❌ **No dark overlays on images just to place white text** without checking actual contrast ratio.
- ❌ **No animations on everything** — motion should have semantic meaning, not just make things feel "alive."

---

## Design System Approach

### Design Tokens First
Before styling components, define tokens. These belong in CSS custom properties, a Tailwind config extension, or a JS theme object:

```css
:root {
  /* Color: use semantic names, not raw values */
  --color-primary: #0f62fe;
  --color-primary-hover: #0043ce;
  --color-surface: #ffffff;
  --color-surface-subtle: #f4f4f4;
  --color-border: #e0e0e0;
  --color-text-primary: #161616;
  --color-text-secondary: #525252;
  --color-text-disabled: #a8a8a8;

  /* Typography */
  --font-sans: 'Inter', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;

  /* Spacing scale (4px base) */
  --space-1: 0.25rem;  /* 4px */
  --space-2: 0.5rem;   /* 8px */
  --space-3: 0.75rem;  /* 12px */
  --space-4: 1rem;     /* 16px */
  --space-6: 1.5rem;   /* 24px */
  --space-8: 2rem;     /* 32px */
  --space-12: 3rem;    /* 48px */
  --space-16: 4rem;    /* 64px */

  /* Radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-full: 9999px;

  /* Shadow */
  --shadow-sm: 0 1px 2px rgba(0,0,0,0.05);
  --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -2px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.1);
}
```

### Typography Rhythm
- Set a base line-height of 1.5 for body text, 1.2 for headings.
- Use a modular scale: don't pick font sizes randomly. A 1.25 ratio scale: 12 / 14 / 16 / 20 / 25 / 31 / 39px.
- Limit prose width: `max-width: 65ch` for readability.
- Never set font size below 14px for body copy (12px for supplemental only).

### Spacing Rhythm
- Use consistent multiples of 4px or 8px for all spacing.
- Section vertical padding: typically 64–96px on desktop, 40–48px on mobile.
- Card internal padding: 24px standard, 16px compact, 32px relaxed.
- Never mix arbitrary values (`margin: 13px`) with the spacing scale.

---

## Accessibility (WCAG AA Required)

### Color Contrast
- Normal text (< 18pt): minimum 4.5:1 contrast ratio against background.
- Large text (≥ 18pt regular or 14pt bold): minimum 3:1.
- UI components and icons: minimum 3:1 against adjacent colors.
- Check with: WebAIM Contrast Checker, browser DevTools accessibility panel, or `axe`.
- Never rely on color alone to convey information (use icon + color, or pattern + color).

### Keyboard Navigation
- All interactive elements reachable via Tab.
- Logical tab order matches visual reading order.
- `Escape` closes modals/dropdowns.
- Arrow keys navigate within composite widgets (menus, tabs, listboxes).
- No keyboard traps (unless intentional modal — must be escapable).

### Focus States
- Never `outline: none` without providing a custom focus indicator.
- Use `:focus-visible` (not `:focus`) for showing outlines only for keyboard users.
```css
:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}
```

### Semantic HTML
- Use semantic elements: `<nav>`, `<main>`, `<header>`, `<footer>`, `<section>`, `<article>`, `<aside>`, `<button>`, `<a>`.
- `<button>` for actions, `<a>` for navigation. Never `<div onClick>` for interactive elements.
- Headings in logical hierarchy — one `<h1>` per page.
- Forms: every `<input>` has a `<label>` (using `htmlFor` / `for`, not just placeholder text).

### ARIA
- Don't add ARIA where native semantics suffice.
- Required ARIA: `role="dialog"` with `aria-modal="true"`, `aria-labelledby`, `aria-describedby` for modals.
- Dynamic regions: `aria-live="polite"` for status messages, `aria-live="assertive"` for errors.
- Icons: `aria-hidden="true"` on decorative icons; `aria-label` on icon-only buttons.
- Loading states: `aria-busy="true"` on the loading container.

---

## UI States — Design All of Them

Every interactive component must handle all states. Don't design only the happy path:

| State | What to design |
|-------|---------------|
| **Default** | Normal appearance |
| **Hover** | Subtle feedback (color shift, shadow, cursor change) |
| **Focus** | Visible focus ring (keyboard navigation) |
| **Active/Pressed** | Scale down slightly or darken |
| **Disabled** | Reduced opacity + `cursor: not-allowed`, not interactive |
| **Loading** | Skeleton, spinner, or shimmer — preserve layout space |
| **Error** | Red border + error message below input; error summary at top of form |
| **Success** | Confirmation message, check icon, green accent |
| **Empty** | Empty state illustration + action CTA (not just blank space) |

### Empty State Pattern
```jsx
<div className="empty-state">
  <Icon name="inbox" aria-hidden="true" />
  <h3>No items yet</h3>
  <p>When you create your first item, it will appear here.</p>
  <Button variant="primary">Create your first item</Button>
</div>
```

---

## Responsive Design

**Mobile-first CSS:**
- Write base styles for mobile, then use `min-width` media queries to enhance for larger screens.
- Never use `max-width` queries as primary breakpoints.

```css
/* Mobile base */
.grid { display: grid; grid-template-columns: 1fr; gap: var(--space-4); }

/* Tablet */
@media (min-width: 768px) {
  .grid { grid-template-columns: repeat(2, 1fr); }
}

/* Desktop */
@media (min-width: 1024px) {
  .grid { grid-template-columns: repeat(3, 1fr); }
}
```

**Common breakpoints:**
- `sm`: 640px (large phones)
- `md`: 768px (tablets)
- `lg`: 1024px (small laptops)
- `xl`: 1280px (desktop)
- `2xl`: 1536px (large screens)

**Always verify on desktop** — mobile-first doesn't mean desktop is an afterthought.

**Touch targets**: minimum 44×44px for all interactive elements on touch devices.

---

## Performance

- **No decorative-only animations by default** — add animation with purpose (feedback, orientation, attention).
- **Respect `prefers-reduced-motion`:**
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```
- Lazy-load images below the fold (`loading="lazy"`).
- Avoid layout shifts: set explicit `width` and `height` on images.
- Use `content-visibility: auto` on long off-screen sections.
- Web fonts: `font-display: swap`, preload critical fonts with `<link rel="preload">`.

---

## Component Patterns

### Design Tokens + Variants
```tsx
// Button: tokens drive all variants, no hardcoded colors
const buttonVariants = {
  primary: 'bg-[--color-primary] text-white hover:bg-[--color-primary-hover]',
  secondary: 'bg-transparent border border-[--color-border] hover:bg-[--color-surface-subtle]',
  ghost: 'bg-transparent hover:bg-[--color-surface-subtle]',
  destructive: 'bg-red-600 text-white hover:bg-red-700',
};
```

### Composable Components
- Separate logic from presentation: container/presentational, or hooks + dumb components.
- Props for customization: `className`, `style`, `as` (polymorphic), slot props.
- Avoid hardcoding colors or sizes inside components — always derive from tokens.

### Dark Mode
- Use CSS custom properties that swap on `[data-theme="dark"]` or `prefers-color-scheme: dark`.
- Never use `dark:bg-black` and `dark:text-white` naively — test the actual contrast.
- Shadows often need to be removed or changed in dark mode (shadows don't read well on dark).

---

## Authentic Content Rules

- **No lorem ipsum in shipped code** — even in templates.
- **No fake user testimonials** unless clearly labeled as fictional examples.
- **No placeholder stat counters** ("10,000+ users") without real backing data.
- **No stock photo avatars** labeled as "real customers" without permission.
- If content isn't ready, use clearly labeled `[PLACEHOLDER: description]` in development, never ship it.

---

## Review Checklist

Before calling any UI work done:

- [ ] Contrast ratios verified for all text/background combinations
- [ ] Keyboard navigation tested (Tab through the entire component)
- [ ] All UI states implemented (loading, error, empty, success, disabled)
- [ ] Responsive: tested at 375px, 768px, 1280px minimum
- [ ] Touch targets ≥ 44×44px
- [ ] No hardcoded colors outside design tokens
- [ ] `prefers-reduced-motion` respected
- [ ] Semantic HTML used throughout
- [ ] All images have meaningful alt text
- [ ] No placeholder/fake content shipped
- [ ] Dark mode checked (if applicable)
- [ ] Font sizes ≥ 14px for body copy
