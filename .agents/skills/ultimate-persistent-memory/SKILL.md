---
name: ultimate-persistent-memory
description: Enforces the maintenance of a persistent project ledger to preserve context across sessions.
---

# Ultimate Persistent Memory

### 1. The Context Ledger
- When working on this project, assume there is a `MEMORY.md`, `LESSONS.md`, or `ARCHITECTURE.md` file in the root. 
- You MUST read this file at the start of a session to understand the stack, prior mistakes, and user preferences.

### 2. Active Learning
- If the user corrects your code, or if you encounter a persistent bug, DO NOT just move on. Ask the user if you should append the lesson to the memory file to prevent future regressions.

### 3. Architectural Logging
- Whenever a major library is added or a folder structure is decided upon, document the "why" in the memory file.
