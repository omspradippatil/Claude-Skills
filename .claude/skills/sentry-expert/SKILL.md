---
name: sentry-expert
description: >-
  Activate this skill for error tracking, telemetry, performance monitoring,
  or configuring Sentry SDKs. Use when diagnosing production stack traces,
  setting up error boundaries, or instrumenting distributed tracing.
---

# Sentry & Production Observability Engineering

> **Scope**: Sentry SDK integration across frontend (React/Next.js) and backend (Node.js/Python), source maps generation, custom breadcrumbs, user context and tagging, error triage, and performance profiling.

---

## When to Activate

- Setting up Sentry in a new frontend, mobile, or backend application
- Investigating production exceptions, unhandled rejections, and crash reports
- Configuring source map uploads for readable production stack traces
- Setting up custom tags, breadcrumbs, and user context for diagnostics
- Defining alerts, issue grouping (fingerprinting), and issue triage workflows
- Scrubbing personally identifiable information (PII) before sending events to Sentry

---

## 1. Sentry SDK Setup & Initialization

### Next.js / React Setup
Initialize Sentry as early as possible in the application lifecycle:
```typescript
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NODE_ENV,
  release: process.env.NEXT_PUBLIC_VERCEL_GIT_COMMIT_SHA,
  
  // Performance Monitoring
  tracesSampleRate: process.env.NODE_ENV === "production" ? 0.1 : 1.0,

  // Session Replay (Mask sensitive text & media)
  replaysSessionSampleRate: 0.05,
  replaysOnErrorSampleRate: 1.0,

  // Scrub PII before sending
  beforeSend(event, hint) {
    if (event.request?.headers) {
      delete event.request.headers["authorization"];
      delete event.request.headers["cookie"];
    }
    return event;
  },
});
```

### Backend (Node.js / Express)
Ensure Sentry's request and error handlers wrap all route handlers:
```typescript
import * as Sentry from "@sentry/node";

// RequestHandler must be the very first middleware
app.use(Sentry.Handlers.requestHandler());
app.use(Sentry.Handlers.tracingHandler());

// All route definitions here...

// ErrorHandler must be placed before any custom error middleware
app.use(Sentry.Handlers.errorHandler());
```

---

## 2. Context, Tags, and Custom Breadcrumbs

Rich metadata turns an ambiguous stack trace into an immediately actionable bug report:

### User Context & Tags
```typescript
// Set user context upon authentication (NEVER include passwords or credit cards)
Sentry.setUser({
  id: user.id,
  email: user.email, // Note: Scrub if PII policy forbids email storage
  role: user.role
});

// Set searchable tags for filtering
Sentry.setTag("tenant_id", tenant.id);
Sentry.setTag("feature_flag_checkout_v2", "enabled");
```

### Manual Error Capture & Breadcrumbs
```typescript
try {
  await chargeCustomer(cardToken, amount);
} catch (error) {
  Sentry.addBreadcrumb({
    category: "billing",
    message: `Attempted charge of amount ${amount}`,
    level: "error",
    data: { currency: "USD", provider: "stripe" }
  });

  Sentry.captureException(error, {
    extra: { cart_id: cart.id, retry_count: 3 }
  });
  throw error;
}
```

---

## 3. Source Maps & Build Automation

Stack traces showing minified code (e.g., `at e.t [as render] (app.min.js:1:3482)`) are useless for debugging.
- Generate hidden source maps during build (`productionBrowserSourceMaps: true` or `sourcemap: 'hidden'`).
- Upload source maps to Sentry using the `@sentry/webpack-plugin`, Vite plugin, or Sentry CLI in your CI/CD pipeline:
  ```bash
  sentry-cli releases files "$RELEASE_VERSION" upload-sourcemaps ./dist \
    --url-prefix '~/assets' --rewrite
  ```
- Delete source map files from your public CDN after uploading to Sentry so proprietary code is not publicly exposed.

---

## 4. Privacy & PII Scrubbing

Always implement strict data minimization:
1. Enable `sendDefaultPii: false`.
2. Mask input fields in Session Replay: configure `maskAllInputs: true` and `blockAllMedia: true`.
3. Scrub sensitive keys (passwords, tokens, SSNs, credit card numbers) using regex or the `beforeSend` hook.

---

## 5. Verification Release Checklist

- [ ] Sentry DSN is configured via environment variable, not hardcoded.
- [ ] Source maps upload successfully in CI and produce readable, unminified stack traces in Sentry.
- [ ] Sensitive headers (cookies, authorization) and user PII are scrubbed in `beforeSend`.
- [ ] Performance sample rate is appropriately configured (e.g., 5-10% in high-traffic production).
- [ ] Error boundaries capture frontend React component crashes gracefully without white-screening.
