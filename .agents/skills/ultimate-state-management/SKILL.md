---
name: ultimate-state-management
description: Activate this skill for complex frontend state, React Query/SWR data fetching, Zustand/Redux global stores, or XState.
---

# Ultimate State Management

### 1. Server State vs. Client State
- Do not put API responses in global state (Redux/Zustand). Use server-state caching libraries (React Query, SWR, RTK Query) to handle loading, caching, re-fetching, and background updates.
- Reserve global client state (Zustand, Pinia) exclusively for UI layout toggles, themes, or multi-step form data.

### 2. Colocation
- Keep state as close to where it is used as possible. Do not lift state globally if only two sibling components need it.

### 3. State Machines for Complexity
- For highly complex logic (e.g., checkout flows, media players), use finite state machines (like XState) rather than scattering `isLoading`, `isError`, and `isSuccess` booleans across your component.
