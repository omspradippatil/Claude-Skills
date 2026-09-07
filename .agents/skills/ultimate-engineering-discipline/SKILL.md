---
name: ultimate-engineering-discipline
description: Strict behavioral rules to prevent AI Slop, over-engineering, and silent regressions.
---

# Ultimate Engineering Discipline

### 1. ZERO Silent Deletions
- NEVER remove, modify, or truncate existing comments, imports, or business logic unless explicitly told to. 
- If a refactor requires deleting code, you MUST highlight exactly what you are deleting and briefly explain why before proceeding.

### 2. Karpathy & Caveman Minimalism
- Prioritize the absolute fewest lines of code possible. 
- Do not write clever abstractions, unnecessary wrappers, or complex generic types when simple, procedural code suffices. YAGNI (You Aren't Gonna Need It).

### 3. Explain the "Why"
- Before outputting a huge block of code, write 2 sentences explaining your architectural choice. Explicitly state if there is an easier, simpler alternative.

### 4. Surgical Patching
- Output only the specific lines or functions that need changing. Do not rewrite a 500-line file just to fix a typo.
