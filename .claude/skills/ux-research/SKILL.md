---
name: ux-research
description: >-
  Activate this skill for user discovery, usability heuristics, cognitive load reduction,
  UX copywriting, or user interface audit workflows. Use when evaluating design decisions,
  refining user journeys, or improving usability.
---

# UX Research & Usability Engineering

> **Scope**: Jakob Nielsen's 10 usability heuristics, cognitive load reduction, UX copywriting, accessible design verification, user interview synthesis, and evidence-based design decisions.

---

## When to Activate

- Conducting usability audits on existing applications or prototypes
- Writing or revising UX microcopy, error states, and empty screens
- Simplifying complex user workflows and reducing cognitive friction
- Planning user testing sessions or synthesizing feedback
- Evaluating accessibility and usability compliance (WCAG & heuristics)
- Reviewing forms, onboarding flows, and navigation architectures

---

## 1. Usability Heuristics (Nielsen Norman Group)

Every user interface audit must evaluate against the foundational usability heuristics:

1. **Visibility of System Status**: Keep users informed about what is happening through timely, appropriate visual feedback (e.g., progress indicators, upload progress bars, saving badges).
2. **Match Between System and Real World**: Use words, phrases, and concepts familiar to the user, not internal system jargon or database enum names.
3. **User Control and Freedom**: Provide clear "emergency exits" — undo actions, cancel buttons, and effortless navigation back from accidental steps.
4. **Consistency and Standards**: Users should not have to wonder whether different words, buttons, or icons mean the same thing. Follow platform conventions.
5. **Error Prevention**: Eliminate error-prone conditions or check for them and present users with a confirmation option before they commit to destructive actions.
6. **Recognition Rather than Recall**: Minimize user memory load by making objects, actions, and options visible. Don't force users to remember information from one step to the next.
7. **Flexibility and Efficiency of Use**: Provide accelerators (keyboard shortcuts, bulk actions) for experienced users while keeping the interface clear for novices.
8. **Aesthetic and Minimalist Design**: Dialogues should not contain irrelevant or rarely needed information. Every extra unit of information competes with the relevant units.
9. **Help Users Recognize, Diagnose, and Recover from Errors**: Error messages must be expressed in plain language, indicate the problem precisely, and constructively suggest a solution.
10. **Help and Documentation**: Even though it is better if the system can be used without documentation, help should be easy to search, focused on user tasks, and concrete.

---

## 2. Cognitive Load Reduction

### Progressive Disclosure
- Present only the primary, essential choices upfront.
- Hide secondary, advanced options under accordion drawers, expandable filters, or modal steps ("Show advanced options").

### Chunking & Visual Hierarchy
- Break long forms into logically grouped sections or multi-step wizards with explicit progress indicators.
- Use clear whitespace rhythm and typographic scale to guide the eye naturally through content: Title → Summary → Detail → Action.

### Smart Defaults & Safe Affordances
- Pre-fill fields whenever predictable (e.g., user's timezone, country, or default billing address).
- Disable primary action buttons only when required inputs are missing, and always provide contextual tooltips explaining why an action is currently disabled.

---

## 3. UX Copywriting Principles

### Error Messages
Never blame the user or display raw system errors. Follow the **Problem + Reason + Next Step** formula:
- ❌ `Error 500: Internal server null pointer exception`
- ❌ `You entered an invalid date format!`
- ✅ `We couldn't save your changes. Your connection appears offline. Please check your network and try again.`

### Action Buttons
Use specific, verb-first action labels rather than generic "OK" or "Submit":
- ❌ `Submit` / `OK`
- ✅ `Create workspace` / `Save billing address` / `Delete project permanently`

### Empty States
An empty state is an onboarding opportunity. Never leave an empty table or list blank:
1. Explain what belongs here.
2. Explain why it is currently empty.
3. Provide a clear primary action button to create the first item.

---

## 4. Verification & Usability Gate Checklist

- [ ] Every destructive action (delete, downgrade, revoke access) requires explicit confirmation or offers immediate undo.
- [ ] Error messages describe the exact issue in plain language and offer a concrete resolution step.
- [ ] Forms provide inline validation and clear labels (never rely solely on placeholder text).
- [ ] Loading and empty states exist for every dynamic list and dashboard view.
- [ ] Interactive controls have visible focus rings and meet minimum touch target sizes (44x44 CSS pixels).
