# Frontend and UI/UX Policy

This policy applies to all tasks involving user interface implementation, component design, styling, accessibility, and user experience. Load this file for any task categorized as **Frontend / UI**.

---

## 1. Design System Coherence

- **Establish and follow a design system.** Every project should have a defined color palette, type scale, spacing scale, and component library. Do not make one-off styling decisions that deviate from the system without a documented reason.
- **No generic AI purple gradients by default.** Do not apply purple-to-pink or blue-to-purple gradient backgrounds as a default aesthetic choice. If a gradient is needed, choose one that is deliberate, brand-appropriate, and discussed with stakeholders.
- **Consistent spacing**: Use the design system's spacing scale (e.g., 4px grid). Avoid arbitrary pixel values that are not part of the scale.
- **Consistent typography**: Use the defined type scale. Do not mix fonts that are not in the system.
- **Consistent component states**: Buttons, inputs, cards, and other components must look consistent across the entire application, not vary per page.

---

## 2. Responsive Layouts

- All layouts must work correctly at mobile (320px minimum), tablet (768px), and desktop (1280px+) widths.
- Use CSS Grid and Flexbox for layout. Avoid fixed pixel widths for containers.
- Test on real device sizes — do not only test at the browser's default desktop size.
- Images must be responsive: use `srcset`, `sizes`, and/or CSS `max-width: 100%`.
- Touch targets must be at minimum 44×44 CSS pixels (WCAG 2.5.5 guideline) — preferably 48×48px.
- Verify both desktop and mobile layouts before declaring a UI change complete.

---

## 3. Accessibility (a11y)

Accessibility is not optional. All UI implementations must meet **WCAG 2.1 AA** minimum.

### Color Contrast
- Normal text (< 18px regular, < 14px bold): minimum contrast ratio **4.5:1**
- Large text (≥ 18px regular or ≥ 14px bold): minimum contrast ratio **3:1**
- UI components and graphical objects: minimum contrast ratio **3:1** against adjacent color
- Use a contrast checker (e.g., WebAIM Contrast Checker) to verify — do not estimate by eye.

### Keyboard Accessibility
- Every interactive element must be reachable and operable by keyboard alone (Tab, Shift+Tab, Enter, Space, arrow keys as appropriate).
- Implement logical tab order that follows visual reading order.
- Do not use `tabindex` values greater than `0` — these disrupt natural tab order.
- Modal dialogs must trap focus within the dialog when open, and return focus to the trigger element on close.
- Dropdown menus, date pickers, and custom widgets must follow WAI-ARIA Authoring Practices patterns.

### Focus States
- **Never suppress focus outlines globally** (e.g., `* { outline: none }` is forbidden).
- Implement visible, high-contrast focus indicators for all interactive elements.
- Using `:focus-visible` to hide focus rings for mouse users while keeping them for keyboard users is acceptable.
- Focus indicators must meet 3:1 contrast ratio against adjacent colors.

### Semantic HTML
- Use semantic elements: `<nav>`, `<main>`, `<header>`, `<footer>`, `<article>`, `<section>`, `<aside>`, `<button>`, `<a>`, `<form>`, `<label>`, `<table>`, etc.
- Do not use `<div>` or `<span>` for interactive elements — use `<button>` for actions and `<a>` for navigation.
- If a custom element must be interactive, add full ARIA roles, states, and properties.

### Form Labels
- Every form input must have a programmatically associated label: use `<label for="inputId">` or `aria-label` or `aria-labelledby`.
- Do not use `placeholder` as a substitute for a label — placeholders disappear on input and fail for users who need persistent labels.
- Group related inputs with `<fieldset>` and `<legend>`.
- Provide descriptive error messages associated with the invalid field using `aria-describedby`.

### ARIA Usage
- Prefer native HTML semantics over ARIA. Only add ARIA when native semantics are insufficient.
- Do not add ARIA roles that conflict with the native element's semantics.
- Always set required ARIA states (e.g., `aria-expanded`, `aria-checked`, `aria-selected`) and update them dynamically with JavaScript.

---

## 4. Component States

Every interactive component must implement all relevant states. Do not ship components with missing states.

| State | Required For |
|---|---|
| **Default** | All components |
| **Hover** | Buttons, links, interactive cards, form inputs |
| **Focus** | All keyboard-focusable elements |
| **Active / Pressed** | Buttons, toggles |
| **Disabled** | Buttons, inputs, selects |
| **Loading** | Buttons (async actions), data containers |
| **Error** | Form inputs, data fetching components |
| **Empty** | Lists, tables, search results |
| **Success** | Form submissions, confirmations |

**Loading states**: Show a skeleton or spinner. Do not leave UI blank or unresponsive during async operations.
**Error states**: Show a human-readable error message. Provide a recovery action (retry, go back) where possible.
**Empty states**: Explain why the content is empty and, where appropriate, provide an action to populate it.

---

## 5. Real Interactions Only

- **No decorative controls that do nothing.** Every button, link, toggle, dropdown, and interactive element must do something when activated.
- Do not add placeholder click handlers that `console.log("clicked")` or show `alert("Coming soon")`.
- If a feature is not yet implemented, do not render the UI for it at all — or clearly mark it as "coming soon" in a non-interactive way.
- Form submissions must either complete the action or display a clear error. Forms must never silently fail.

---

## 6. Content Authenticity

Do not fabricate or generate fake content in the UI:

- **No fake testimonials** — Do not generate invented user reviews, quotes attributed to fictional people, or fabricated success stories.
- **No fake counters** — Do not add "10,000+ happy customers" or "5M downloads" counters without real data to back them up.
- **No invented logos** — Do not add logo sections ("As seen in" / "Our clients") with placeholder or fabricated brand logos.
- Use placeholder content (`Lorem ipsum`, placeholder image services) only during development, and remove it before shipping.

---

## 7. No AI Slop

Reject these low-quality, overused AI-generated UI patterns:

- **No automatic purple gradients** — Do not default to `purple → pink` or `blue → purple` backgrounds.
- **No excessive pill buttons** — Pill-shaped (fully rounded) buttons are not universally appropriate. Match button style to the design system.
- **No emoji as interface icons** — Emoji are not icons. Use a proper icon library (Lucide, Heroicons, Phosphor, etc.) for interface elements.
- **No excessive animations** — Do not add page transitions, hover animations, scroll-triggered animations, or particle effects unless they serve a clear UX purpose. Motion can harm users with vestibular disorders (respect `prefers-reduced-motion`).
- **No hero sections with vague "AI-powered" marketing copy** unless the product actually uses AI and the copy is accurate.
- **No over-engineered glass-morphism** applied universally — use frosted glass effects sparingly and intentionally.

Always respect `@media (prefers-reduced-motion: reduce)` — disable or minimize animations for users who have indicated this preference.

---

## 8. Maintainability

- **Component composition over duplication**: Extract shared UI into reusable components. Do not copy-paste JSX blocks.
- **Single responsibility**: Each component should do one thing well. Break large components into smaller, focused ones.
- **Prop documentation**: Document component props with TypeScript types or JSDoc. Include descriptions for non-obvious props.
- **Avoid magic numbers**: Define spacing, colors, and sizes using design tokens or CSS custom properties — not hardcoded values scattered throughout files.
- **Co-locate styles**: Keep component styles close to the component (CSS Modules, Tailwind classes, styled-components) rather than in large global stylesheets that are hard to reason about.

---

## 9. Verification

Before declaring any frontend change complete:

- [ ] **Responsive**: Verified at 320px, 768px, and 1280px+ widths
- [ ] **Accessible**: Color contrast passes WCAG AA; keyboard navigation works; focus states visible
- [ ] **Semantic HTML**: Correct element choices; no `<div>` for interactive elements
- [ ] **Form labels**: All inputs have visible, programmatically associated labels
- [ ] **Component states**: All states (loading, error, empty, disabled, success) are implemented
- [ ] **Real interactions**: No decorative or non-functional controls
- [ ] **No fabricated content**: No fake testimonials, counters, or logos
- [ ] **Reduced motion**: Animations respect `prefers-reduced-motion`
- [ ] **No AI slop patterns**: No unjustified purple gradients, emoji icons, or excessive animations
- [ ] **Cross-browser**: Verified in Chrome and Firefox minimum; Safari if targeting Apple users
