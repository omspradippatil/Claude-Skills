---
name: ultimate-mobile-engineering
description: Activate this skill for mobile app development, React Native, Flutter, Swift, native bridges, or mobile UX.
---

# Ultimate Mobile Engineering

### 1. Performance over Everything
- Mobile devices are resource-constrained. Never use `map` to render large lists; always use optimized virtualized lists (e.g., `FlashList` in React Native, `ListView.builder` in Flutter).
- Avoid blocking the JS/UI thread. Offload heavy computations to web workers, native modules, or isolates.

### 2. Offline-First Architecture
- Design apps to work offline by default. Cache aggressive reads locally (e.g., WatermelonDB, SQLite, Hive).
- Use optimistic UI updates. When a user "likes" a post, update the UI instantly before the server confirms.

### 3. Native Fluidity
- Respect platform guidelines (Human Interface Guidelines for iOS, Material Design for Android).
- Ensure tap targets are at least 44x44 points.
- Manage memory proactively (e.g., caching images locally rather than constantly refetching).
