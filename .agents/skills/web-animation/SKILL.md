---
name: web-animation
description: >-
  Activate this skill for UI motion, Framer Motion, GSAP, CSS keyframes, spring physics,
  or scroll-scrubbed animations. Use when crafting high-performance, accessible web animations,
  choreographed transitions, or interactive gestures.
---

# Web Animation & Physics-Driven Motion

> **Scope**: High-performance 60fps web motion, Framer Motion, GSAP ScrollTrigger, CSS hardware-accelerated transitions, spring physics, and accessible motion standards (`prefers-reduced-motion`).

---

## When to Activate

- Adding micro-interactions, page transitions, or modal reveals
- Implementing Framer Motion gesture and layout animations
- Building scroll-scrubbed timelines or pinned sections with GSAP ScrollTrigger
- Optimizing choppy animations, eliminating layout thrashing and jank
- Enforcing accessible reduced-motion compliance
- Crafting responsive, fluid motion across mobile and desktop

---

## 1. Performance & Hardware Acceleration Principles

### The Golden Rule: Animate Composite Properties Only
To achieve consistent 60fps / 120fps animations, strictly restrict animations to properties handled by the browser's GPU compositor thread:
- **Fast / GPU Accelerated**: `transform` (`translate3d`, `scale`, `rotate`), `opacity`.
- **Dangerous / Causes Reflow & Layout Thrashing**: `width`, `height`, `top`, `left`, `margin`, `padding`.
- **Causes Repaint**: `color`, `background-color`, `box-shadow`, `border-radius`.

### Preventing Layout Thrash
- Never read layout metrics (`element.offsetHeight`, `getBoundingClientRect()`) immediately after modifying DOM styles in an animation loop.
- Use `will-change: transform, opacity` sparingly and only during active animation states. Remove `will-change` once animation completes to prevent excessive GPU memory consumption.

---

## 2. Framer Motion Architecture (React)

### Spring Physics Over Linear Easings
Real-world objects possess mass and momentum. Prefer physics-based spring curves over robotic linear or cubic-bezier easings for interactive elements:

```tsx
<motion.div
  initial={{ opacity: 0, y: 16 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{
    type: "spring",
    stiffness: 350,
    damping: 25,
    mass: 0.8
  }}
/>
```

### Choreographed Variants & Stagger
Encapsulate animation states into declarative variants to coordinate parent-child reveals:
```tsx
const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: { staggerChildren: 0.08, delayChildren: 0.1 }
  }
};

const itemVariants = {
  hidden: { opacity: 0, y: 12 },
  visible: { opacity: 1, y: 0, transition: { type: "spring", stiffness: 300, damping: 24 } }
};
```

### Layout Animations & Shared Element Transitions
Use `layout` and `layoutId` for smooth morphing transitions without calculating bounding boxes manually:
```tsx
// Morphing active tab indicator
{isActive && (
  <motion.div
    layoutId="active-indicator"
    className="absolute inset-0 rounded-lg bg-primary/10"
    transition={{ type: "spring", bounce: 0.2, duration: 0.4 }}
  />
)}
```

---

## 3. GSAP & ScrollTrigger Best Practices

### Timeline Sequencing
Always bundle related sequence steps into GSAP timelines for precise scrubbing and playback control:
```javascript
const tl = gsap.timeline({
  scrollTrigger: {
    trigger: "#feature-section",
    start: "top top",
    end: "+=1500",
    scrub: 1,
    pin: true,
    anticipatePin: 1
  }
});

tl.from(".feature-card", { y: 100, opacity: 0, stagger: 0.2 })
  .to(".feature-graphic", { scale: 1.1, rotation: 5 }, "<");
```

### Cleanup & Memory Management
In modern single-page applications (React/Next.js/Vue), always clean up GSAP animations and ScrollTrigger instances on component unmount:
```javascript
// React useEffect / useGSAP cleanup pattern
useEffect(() => {
  const ctx = gsap.context(() => {
    // animations here
  }, containerRef);
  return () => ctx.revert(); // Automatically kills tweens, ScrollTriggers, and resets inline styles
}, []);
```

---

## 4. Accessibility: Mandatory Reduced Motion

Respect user motion sensitivities (`prefers-reduced-motion: reduce`) unconditionally:

### CSS Implementation
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

### Framer Motion Implementation
```tsx
import { useReducedMotion } from "framer-motion";

export function AnimatedCard({ children }) {
  const shouldReduceMotion = useReducedMotion();
  
  return (
    <motion.div
      initial={shouldReduceMotion ? { opacity: 0 } : { opacity: 0, y: 20 }}
      animate={shouldReduceMotion ? { opacity: 1 } : { opacity: 1, y: 0 }}
      transition={{ duration: shouldReduceMotion ? 0 : 0.4 }}
    >
      {children}
    </motion.div>
  );
}
```

---

## 5. Verification Checklist

- [ ] Animations run at a rock-solid 60fps/120fps without dropping frames in DevTools Performance profile.
- [ ] Only `transform` and `opacity` are animated during continuous movement.
- [ ] No layout shifts (CLS = 0) caused by animated components.
- [ ] `prefers-reduced-motion` is tested and gracefully disables intrusive motion.
- [ ] All ScrollTrigger / interval listeners are properly disposed of on unmount.
