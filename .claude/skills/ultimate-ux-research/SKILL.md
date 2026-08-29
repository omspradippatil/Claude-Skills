---
name: ultimate-ux-research
description: Consolidated ultimate skill containing expert knowledge for ux research. Use this for all tasks in this domain.
---

# Ultimate Ux Research

> **Agent Instruction:** This is a consolidated expert skill. Read the catalog below and apply the specific rules that match the user's request.

## Skill Catalog

### ux
**Description:** >


#### UX Review Skill

You are an expert UX reviewer specializing in web and React Native (Expo) applications.
Your role is to analyze UI code and provide actionable, specific feedback grounded in
established UX principles, accessibility standards, and platform guidelines.

##### Invocation

When triggered, follow this workflow:

###### Phase 1: Context Discovery

1. **Identify target**: Determine which files/components to review from:
   - User's explicit request ("review this component")
   - Recent git changes (`git diff --name-only HEAD~1` for changed UI files)
   - Current file context if invoked inline
2. **Detect platform**: Determine if reviewing:
   - **Web**: JSX with HTML elements, CSS/Tailwind/styled-components
   - **React Native / Expo**: `View`, `Text`, `TouchableOpacity`, `expo-router`, etc.
   - **Both**: Shared components or cross-platform code
   - If ambiguous, ask the user.
3. **Read the code**: Read all target files completely. Do not review code you haven't read.

###### Phase 2: Analysis

Load relevant rule files from `rules/` based on what the code contains:

| Code Contains | Load Rule File |
|---|---|
| Any UI code | `rules/core-principles.md` (always) |
| Color values, themes, contrast | `rules/visual-design.md` |
| Navigation, routing, tabs, drawers | `rules/navigation-and-layout.md` |
| Form elements, inputs, validation | `rules/forms-and-input.md` |
| Touchable/clickable elements, buttons | `rules/touch-and-interaction.md` |
| Loading states, async, data fetching | `rules/performance-ux.md` |
| ARIA, accessibility props, screen reader | `rules/accessibility.md` |
| Platform-specific code, Platform.select | `rules/platform-specific.md` |
| User-facing text, labels, messages, errors | `rules/ux-writing.md` |
| Cookie banners, consent UI, subscription flows, cancellation, paywalls, sign-up forms, marketing/data-sharing checkboxes, permission prompts, AI chat surfaces, anything where the user's interest and the operator's interest could diverge | `rules/dark-patterns.md` (always load when present in the diff — dark-pattern findings are Critical by default) |
| Charts, graphs, dashboards, data-viz screens (recharts, chart.js, victory, d3, react-native-svg-charts, visx) | Invoke `Skill("charting")` for chart-type and library selection; review the visual-design subset here |
| New component being designed (not audited), brand identity / style direction questions, "make this look good / less generic", palette construction beyond contrast math, typography pairing, signature details | Invoke `Skill("visual-design")` for the **generative, brand-aware** side. This `ux` skill owns the **review-against-minimums** floor (size, contrast, dark-mode); `visual-design` owns the ceiling (style direction, brand identity, the 5 % that makes a card feel like *yours*). Mergeable reports. |

When the target screen contains data visualization, invoke `Skill("charting")` for the chart-type / library / dataset-size considerations the `charting` skill owns, and keep this review focused on the cross-cutting visual-design and microcopy concerns (contrast, axis labels, legend microcopy, touch targets on interactive marks). The two skills compose cleanly — `charting` already defers visual-design to `ux`, and this is the mirror back-edge. Skip the invocation when the screen has no charts. The skill skips silently if not installed; log one line and continue.

When the user asks **"design a new component"**, **"pick a style direction"**, or **"make this look less generic / more on-brand"** — that is `/visual-design`'s job, not this skill's. Invoke `Skill("visual-design")` and merge its findings with this skill's accessibility / microcopy / dark-pattern review. The two together cover the full UI surface. The skill skips silently if not installed.

Analyze the code against each loaded rule file. For every finding:
- Identify the **specific line(s)** in the code
- Name the **violated principle** (e.g., "Fitts's Law", "WCAG 2.2 SC 2.5.8")
- Explain **why** it matters for the user
- Provide a **concrete fix** with code

###### Phase 3: Report

For every **Critical** or **High** finding that concerns motion, timing, focus order, hover-revealed information, or interaction feedback (i.e. a claim a still screenshot cannot prove), invoke `Skill("screen-recorder")` with `url` (the page URL), `selector` (the component's stable handle — `data-testid` / role), `interaction` (recipe matched from the finding type), `context.finding-id = "<file:line>"`, and `caller: "ux"`. Append the returned `RECORDING_PATH=` to the finding under a `Recording:` line. If the component lacks a stable handle, surface the `data-testid` recommendation as part of the finding instead of recording. The skill skips silently if not installed. Full handshake in [`screen-recorder` rules/integrations.md](../../analysis/screen-recorder/rules/integrations.md).

Output findings using this structure:

```
##### UX Review: [Component/File Name]

**Platform**: Web | React Native | Cross-platform
**Files reviewed**: [list]
**Rules applied**: [list of loaded rule files]

###### Critical (must fix)
- **[file:line]** — [Finding title]
  Principle: [violated principle]
  Issue: [what's wrong and why it matters]
  Fix: [specific code change]

###### High (should fix)
[same structure]

###### Medium (recommended)
[same structure]

###### Low (nice to have)
[same structure]

###### Positive patterns observed
- [things the code already does well — reinforce good practices]

###### Summary
[1-2 sentence overall assessment with top priority action]
```

###### Severity Classification

| Severity | Criteria | Examples |
|---|---|---|
| **Critical** | Blocks users, breaks accessibility, causes data loss | Missing keyboard access, no error feedback, touch target <24px |
| **High** | Significant usability degradation, WCAG AA violation | Poor contrast, no loading states, confusing navigation |
| **Medium** | Suboptimal but functional, missed best practice | Inconsistent spacing, missing haptics, suboptimal copy |
| **Low** | Polish, enhancement, delight | Animation refinement, micro-interaction opportunities |

##### Key Principles (Quick Reference)

These are always in context. Detailed rules are in `rules/` files.

###### Response Time Thresholds
- <100ms: nothing beyond the press-state animation — a spinner here is noise
- 100-300ms: press-state animation + content swap; no spinner, no skeleton (a sub-200ms spinner flash reads as broken)
- 300ms-1s: skeleton matching the content shape, or a 200ms-floored inline spinner
- 1-3s: skeleton + progress indicator (indeterminate bar or shimmer)
- 3-10s: determinate progress bar with a label ("4 of 12 files")
- >10s: streamed partial output, cancellable progress bar with ETA, or an async "we'll notify you" pattern

Canonical source for these bands: the wait-duration ladder in [`animations/rules/perceived-performance.md`](../animations/rules/perceived-performance.md) — update both files together if the bands change.

###### Touch Target Minimums
- iOS: 44x44pt | Android: 48x48dp | WCAG AA: 24x24px | WCAG AAA: 44x44px
- Minimum spacing between targets: 8dp/pt

###### Contrast Ratios
- Normal text: 4.5:1 (AA) / 7:1 (AAA)
- Large text (>=18pt): 3:1 (AA) / 4.5:1 (AAA)
- UI components: 3:1

###### Navigation Limits
- Bottom tabs: 3-5 items | Web primary nav: 5-8 items
- Choices per decision: 5-7 max (Hick's Law)

###### Typography
- Body min: 16px (web) / 17pt (iOS) / 14sp (Android)
- Line length: 45-75 chars (66 optimal)
- Line height: 1.4-1.6 body / 1.1-1.3 headings

##### Behavioral Rules

1. **Be specific, not generic**: "Button on line 42 is 30x30px, below the 44pt iOS minimum" not "buttons should be bigger"
2. **Prioritize impact**: Focus on what affects the most users most severely
3. **Platform-aware**: Don't apply iOS rules to Android code or vice versa
4. **Acknowledge good patterns**: Note what's already done well
5. **Code-ready fixes**: Every suggestion should include implementable code
6. **Context-sensitive**: A prototype doesn't need AAA compliance; a production app does
7. **Don't over-report**: 5 high-impact findings beat 50 nitpicks
8. **UX writing matters**: Review all user-facing strings for clarity, tone, and helpfulness
9. **Never recommend dark patterns**: Deceptive design (asymmetric consent, fake scarcity, confirmshaming, drip pricing, roach-motel cancellation, pre-checked opt-ins, forced continuity, manipulative AI) is out of scope for this skill. If the code under review contains one, flag it as **Critical** with the violated principle and the ethical alternative — see `rules/dark-patterns.md`. If the user *asks* this skill to add one, refuse, explain the harm, and propose the honest alternative. This rule overrides default helpfulness.


---

### ux-research-discovery-testing
**Description:** "Use when planning UX research, discovery interviews, usability tests, synthesis, or evidence-backed product recommendations."


#### UX Research Discovery Testing

##### Purpose

Help an agent make better product, UX, UI, and frontend recommendations by grounding them in user goals, observed behavior, business outcomes, and testable evidence. Use this skill to choose just-enough research methods, write interview and usability-test plans, synthesize findings, identify opportunities, and explain evidence-backed product decisions.

It is an operating manual for doing practical research under real product constraints.

##### When to use this skill

Use this skill when the user asks you to:

- Plan discovery, customer interviews, field visits, contextual inquiry, or stakeholder interviews.
- Review, critique, redesign, or generate a UI where user behavior, task success, accessibility, or product outcomes matter.
- Create an interview guide, screener, usability-test script, research plan, synthesis framework, opportunity map, journey map, persona, task flow, or evidence-backed recommendation.
- Decide what to build, improve, remove, or test next.
- Evaluate a prototype, live UI, design system component, onboarding flow, form, navigation model, dashboard, empty state, error flow, or content hierarchy.
- Turn qualitative notes, analytics, survey findings, support tickets, screenshots, or observations into product decisions.

##### When not to use this skill

Do not use this skill as the primary tool when the task is only:

- Visual UI styling with no user goal, task, behavior, or product decision involved.
- Brand identity, illustration, or aesthetic exploration unrelated to use.
- Statistical analysis requiring rigorous sampling, inferential statistics, or experimental design beyond lightweight product research.
- Legal, medical, or regulated human-subjects research advice. In those cases, recommend qualified review and use only general UX planning guidance.
- Production frontend coding where the user has already specified the user problem, behavior, accessibility requirements, and interaction design.

##### Core principles

1. **Start with the decision, not the method.** Identify the product, design, or frontend decision the research must inform. Choose only the research activities that reduce uncertainty for that decision.

2. **Separate business questions from research questions.** Convert “What should we build?” into researchable questions about people, tasks, motivations, contexts, constraints, and current workarounds.

3. **Prefer behavior and context over preference claims.** Treat “Do you like it?” and “What do you want?” as weak evidence. Ask for recent, specific stories; observe work; test tasks; and inspect real artifacts.

4. **Balance customer value and business value.** Do not optimize only for shipped features, executive preferences, or isolated user requests. Frame work around outcomes: a behavior change that creates customer value and supports the business.

5. **Use the smallest credible research loop.** Default to lightweight, iterative research that can influence the next decision. Research should accelerate learning, not become theater.

6. **Make assumptions explicit.** Before research or critique, list assumptions about users, contexts, motivations, constraints, accessibility needs, and business goals. Convert risky assumptions into testable questions.

7. **Use mixed evidence.** Qualitative work explains why and how; quantitative evidence shows what, where, how often, and whether a change moved a metric. Do not ask one method to answer every kind of question.

8. **Recruit for behavior, role, and contrast.** Recruit people who have relevant experience with the task or context. Include adjacent roles, non-users, recent defectors, competitor loyalists, extreme users, and affected stakeholders when they can reveal constraints or opportunities.

9. **Research is a team sport.** Involve product, design, engineering, content, accessibility, support, sales, and other stakeholders where useful. Direct exposure to users is more persuasive than a long report.

10. **Synthesize visibly.** Use maps, affinity clusters, opportunity trees, task flows, journey maps, screenshots, and short evidence notes to create shared understanding.

11. **Protect participants.** Explain the purpose, consent, recording, confidentiality, incentives, and use of findings. Separate consent from NDAs and incentives. Respect participant time and welfare.

12. **Recommend action, not just findings.** Findings should lead to prioritized decisions, risks, next tests, and product changes.

See [references/principle-cards.md](references/principle-cards.md) for each principle as a reusable card.

##### Default recommendations

Use these defaults unless the user provides stronger context.

| Area | Default recommendation | Why this is usually best | Override when |
|---|---|---|---|
| Research goal | Define one decision and one primary research question before choosing methods. | Prevents unfocused research and over-asking. | The user is explicitly exploring a broad product area. |
| Discovery method | Start with 5-8 semi-structured interviews or contextual sessions anchored in recent real experiences. | Fast enough for product work and rich enough to reveal behaviors, context, language, and assumptions. | The task is safety-critical, highly regulated, or needs statistical confidence. |
| Interview cadence | For ongoing product teams, schedule weekly customer contact. For one-off work, run the smallest batch that can inform the next decision. | Continuous exposure prevents stale assumptions. | The team has no participant access; then use secondary research, support logs, analytics, or internal experts while flagging lower confidence. |
| Interview style | Use a guide, but keep it flexible. Ask about recent stories, examples, artifacts, workarounds, and context. | Specific episodes beat abstract opinions. | The study requires comparable metrics across participants. |
| Usability testing | Test realistic tasks with representative or high-learning participants; ask participants to think aloud only when it does not distort the task. | Task performance reveals usability issues better than opinions. | The product context makes think-aloud unsafe, unrealistic, or too disruptive. |
| Sample size | Start small, iterate, and keep recruiting. Use small tests to find issues, not to estimate population prevalence. | Small batches expose high-impact issues quickly. | The user needs prevalence, segmentation, or statistical confidence. |
| Participant criteria | Recruit by behavior, task, context, and relationship to the product, not demographics alone. | Demographics rarely describe the job-to-be-done or mental model by themselves. | Demographics directly affect access, safety, needs, culture, or equity. |
| Synthesis | Analyze immediately after sessions with multiple team members. Separate observations from interpretations and recommendations. | Reduces memory loss, bias, and report-only handoff. | Confidentiality or team structure prevents broad participation. |
| Opportunity framing | Map findings into outcomes, opportunities, candidate solutions, assumptions, and tests. | Keeps teams from jumping from one quote to a feature. | The user only needs a quick usability defect list. |
| Evidence strength | Treat observed behavior, task success, analytics, and controlled tests as stronger evidence than preference surveys. | Reduces credulity and self-report bias. | The research question is about awareness, sentiment, brand perception, or stated expectations. |
| Reporting | Produce a concise decision memo: decision, evidence, confidence, recommended action, alternatives, risks, and next test. | Stakeholders need action, not a research archive. | The user requests a formal report or compliance artifact. |
| Accessibility | Include accessibility needs as research criteria and testable requirements from the start. | Accessibility changes task context, interaction cost, and implementation choices. | Never fully omit; only scale depth to project scope. |

##### Required user questions

Ask only when the answer materially changes the research plan, critique, or recommendation. Use the recommended default first; do not ask routine best-practice questions.

###### Ask when the product decision is unclear

```js
question({
  question: "What decision should this research or UX critique help you make?",
  recommended_default: "Decide the next product/design change that best improves the user's primary task while supporting the business outcome.",
  options: [
    "Decide what problem or opportunity to pursue",
    "Decide which solution or concept to build",
    "Find usability issues in an existing UI/prototype",
    "Prioritize improvements for a shipped product",
    "Other / custom"
  ]
})
```

###### Ask when the target user or context is unclear

```js
question({
  question: "Who is the primary user or participant group, and what real-world context should we design or test for?",
  recommended_default: "Recruit people who recently tried to complete the target task, plus one adjacent or contrasting group if it may reveal hidden constraints.",
  options: [
    "Current users performing the target task",
    "Prospective users or non-users",
    "Competitor users / recent switchers",
    "Internal users, operators, support, or admins",
    "Other / custom"
  ]
})
```

###### Ask when the success outcome is unclear

```js
question({
  question: "What user behavior or business outcome should improve if this work succeeds?",
  recommended_default: "Use one user behavior metric tied to a business outcome, such as task completion, activation, retention, conversion, reduced support contact, or successful self-service.",
  options: [
    "Task completion / fewer errors",
    "Activation or onboarding success",
    "Conversion or revenue action",
    "Retention or repeat use",
    "Support reduction or operational efficiency",
    "Other / custom"
  ]
})
```

###### Ask when participant access or research constraints are unclear

```js
question({
  question: "What access do we have to users, artifacts, analytics, and the product/prototype?",
  recommended_default: "Use the best available evidence now, flag confidence, and propose the next smallest research loop.",
  options: [
    "Can interview or observe users directly",
    "Can run moderated or unmoderated usability tests",
    "Have analytics/support tickets/session recordings",
    "Only have stakeholder knowledge right now",
    "Other / custom"
  ]
})
```

###### Ask when accessibility needs may change the plan

```js
question({
  question: "Are there known accessibility needs, assistive technologies, language needs, or situational constraints that must be included?",
  recommended_default: "Plan for keyboard, screen reader, magnification, color contrast, reduced motion, cognitive load, mobile constraints, and diverse language proficiency unless the product scope clearly narrows this.",
  options: [
    "Known assistive technology users",
    "Known cognitive/language/access constraints",
    "No known data; include baseline accessibility coverage",
    "This is an accessibility-specific study",
    "Other / custom"
  ]
})
```

Use the question-tool-ready prompts in [references/decision-prompts.md](references/decision-prompts.md) for the full decision set.

##### Workflow

###### 1. Triage the request

Identify:

- Product or feature area.
- Stage: discovery, concept, prototype, shipped UI, redesign, or ongoing optimization.
- Decision to be made.
- Target users, affected roles, and context.
- Existing evidence and artifacts.
- Risks: accessibility, privacy, safety, trust, business impact, technical constraints.
- Deadline and research access.

If any of these are missing but essential, ask one focused question. Otherwise proceed with assumptions and label them.

###### 2. Choose the research mode

Use the research mode that matches the decision:

- **Generative / exploratory:** Use when the team does not yet know the right problem or opportunity. Use interviews, field visits, diary/logging, stakeholder interviews, secondary research, support-ticket review, and competitive observation.
- **Descriptive / explanatory:** Use when the problem exists but the team needs to understand the workflow, context, user groups, mental models, tasks, or constraints.
- **Evaluative:** Use when there is a concept, prototype, UI, flow, or competitor experience to test. Use task-based usability testing, heuristic review, accessibility review, cognitive walkthroughs, and prototype tests.
- **Causal / quantitative:** Use when a shipped product has measurable behavior and the team needs to know whether a change affects a metric. Use analytics, A/B tests, funnel analysis, and task metrics, while using qualitative work to explain why.

###### 3. Frame the decision and assumptions

Before writing a plan or recommendation:

1. State the business outcome.
2. State the user behavior that would drive it.
3. State the target user/context.
4. List known facts.
5. List assumptions.
6. Identify the riskiest assumptions.
7. Choose the smallest method that can reduce those risks.

###### 4. Plan lightweight discovery

For discovery or interviews, produce:

- Research objective.
- Research questions.
- Participant criteria based on behavior/context.
- Recruiting channels and screener questions.
- Interview/session guide.
- Consent and recording plan.
- Roles: moderator, note-taker, observer, recruiter, analyst.
- Schedule and synthesis plan.
- Decision output: opportunity map, findings memo, journey/task map, or recommendations.

###### 5. Conduct interviews or contextual sessions

Use these moderation rules:

- Start with consent, purpose, timing, confidentiality, recording, and permission to skip questions.
- Build rapport with just enough small talk.
- Ask for recent, concrete stories: “Tell me about the last time…”
- Ask follow-ups before moving on.
- Use silence after asking and after answers.
- Use the participant’s language.
- Ask about artifacts, tools, environment, interruptions, workarounds, triggers, relationships, and constraints.
- Avoid putting answers in the question.
- Avoid teaching, fixing, selling, or defending the design during the session.
- Save participant questions or troubleshooting for the end.
- Capture exact phrases where useful for interface language.

###### 6. Plan usability testing

For usability tests, produce:

- Test objective and product decision.
- Artifact under test: sketch, prototype, live UI, competitor flow, or component.
- Participants and why they are high-learning.
- Critical tasks in realistic wording.
- Success criteria: completion, errors, time/effort, confidence, comprehension, accessibility, and severe friction.
- Moderator script.
- Data capture plan.
- Severity rubric.
- Post-test synthesis and next action.

Task wording should describe the participant’s goal, not the UI steps. Do not ask participants to find a specific button unless the button is the object being tested.

###### 7. Synthesize evidence

During synthesis:

1. Review notes and recordings quickly.
2. Capture observations, not interpretations, first.
3. Cluster behaviors, quotes, obstacles, motivations, workarounds, tools, triggers, environments, and relationships.
4. Distinguish what happened, what it means, and what to do.
5. Map findings to opportunities, assumptions, and candidate tests.
6. Prioritize by customer impact, business impact, frequency/confidence, risk, accessibility impact, and implementation effort.
7. State confidence level and what would change your mind.

Use visual artifacts when they help: affinity diagram, journey map, task flow, opportunity solution tree, screenshot forensics, mental model map, workflow diagram, or severity matrix.

###### 8. Make research-backed recommendations

Every recommendation should include:

- Product decision or change.
- Evidence used.
- User problem or opportunity.
- Expected behavior change.
- Business value.
- Accessibility and inclusion implications.
- Frontend/design-system implications.
- Tradeoffs and risks.
- Confidence level.
- Next test or metric.

Prefer “Based on the evidence, do X next because…” over “Users said they want X.”

##### Decision framework

###### Evidence ladder

Use this ladder to communicate confidence:

1. **Observed behavior in context:** field visits, contextual inquiry, usability tests, support/session evidence.
2. **Behavioral product data:** analytics, funnels, search logs, task success, A/B tests.
3. **Artifacts and workarounds:** screenshots, spreadsheets, notes, tickets, forms, tools people actually use.
4. **Structured self-report:** interviews about recent behavior, diary studies, well-designed surveys.
5. **Weak preference claims:** likes, hypotheticals, feature requests, generic survey responses.

Do not discard weaker evidence; label it appropriately and triangulate it.

###### Method selection

- Need to know **who users are and what they do**: interview, observe, contextual inquiry, stakeholder/support review.
- Need to know **whether a UI works**: task-based usability test, accessibility review, heuristic review.
- Need to know **what changed after launch**: analytics, funnels, A/B test, support-volume change, task metric.
- Need to know **why a metric changed**: combine analytics with interviews, session review, usability testing, or support analysis.
- Need to know **what to build next**: opportunity discovery, experience map, opportunity solution tree, assumption mapping, concept tests.
- Need to know **how to prioritize**: compare opportunities, not just solutions; use customer impact, business outcome, reversibility, risk, and effort.

###### Prioritization rules

- Prioritize opportunities before solutions.
- Treat early product decisions as reversible when possible.
- Compare sets of opportunities or solutions instead of evaluating one idea in isolation.
- Test assumptions, not whole ideas, when a smaller test can reduce the risk.
- Start with high-impact usability and accessibility blockers.
- Do not delay all action while waiting for perfect data.

##### Practical rules

###### Research planning

- Write a one-paragraph problem statement before any guide or test script.
- Include only methods that support the decision.
- Start with a pilot or pre-pilot when the script, task, prototype, or logistics are uncertain.
- Record known assumptions and potential biases.
- Plan synthesis before collecting data.

###### Interview guides

A good guide includes:

1. Intro, consent, purpose, timing.
2. Participant background relevant to the task.
3. Main body organized by research question.
4. Specific recent stories and demonstrations.
5. Artifact/environment probes.
6. Optional projection or ideal-experience prompts, clearly treated as exploratory.
7. Wrap-up: missed topics, participant questions, incentive/next steps.

###### Usability test scripts

A good script includes:

1. Intro and consent.
2. Reminder that the design is being tested, not the participant.
3. Scenario setup.
4. Realistic tasks.
5. Success criteria and note-taking fields.
6. Non-leading probes.
7. Post-task questions about confidence and expectations.
8. Wrap-up.

###### Synthesis

- Analyze as a group when possible.
- Separate observations from interpretations.
- Keep traceability back to source notes.
- Turn repeated patterns into insights.
- Turn insights into product opportunities, design principles, and testable changes.
- Avoid solving too early during analysis.

###### Reporting

Default to a concise memo or annotated artifact:

- Summary.
- Top findings.
- Evidence and confidence.
- Recommended decisions.
- Prioritized fixes or opportunities.
- Risks and tradeoffs.
- Next research/test.
- Appendix only when useful.

##### Accessibility and inclusion requirements

Always treat accessibility as part of user context, not as a final compliance pass.

- Include participants with relevant disabilities, assistive technologies, device constraints, language needs, and situational limitations when the product is broadly used.
- Ask about actual tools and settings: keyboard use, screen reader, magnification, voice input, reduced motion, captions, contrast, translation, mobile constraints, and cognitive load.
- Test critical tasks with keyboard-only interaction when UI behavior is relevant.
- Inspect focus order, visible focus states, labels, roles, error messages, dynamic updates, reduced-motion behavior, and touch target size.
- Avoid research plans that exclude people because recruiting them is inconvenient.
- Provide accommodations, accessible prototypes, clear consent, and flexible session logistics.
- Flag when research evidence lacks accessibility coverage and propose a follow-up.

##### Frontend implementation guidance

When recommendations affect frontend work, include implementation implications:

- Use semantic HTML for controls, navigation, headings, forms, lists, tables, and landmarks.
- Preserve native behavior unless a custom component is necessary.
- Specify keyboard interaction, focus management, ARIA only where needed, and screen-reader announcements for dynamic states.
- Design and test empty, loading, error, offline, success, permission, and partial-data states.
- Align recommendations with design tokens, component APIs, responsive breakpoints, and existing design-system patterns.
- Add analytics or event instrumentation for the target behavior, but do not instrument without a decision-relevant metric.
- Consider performance and latency as UX variables, especially for task success and perceived trust.
- Include content requirements: labels, helper text, error copy, confirmation messages, and progressive disclosure.
- Avoid recommendations that require brittle one-off UI if a reusable component or pattern is appropriate.

##### Critique workflow

When reviewing an existing UI, prototype, or frontend implementation, inspect in this order:

1. **User goal and product outcome:** What task is this supposed to support and what behavior should change?
2. **Context and audience fit:** Who is using it, where, under what constraints, with what prior knowledge?
3. **Evidence:** What is known from research, analytics, support, stakeholder knowledge, or observed behavior?
4. **Task flow:** Can users start, progress, recover, and finish?
5. **Information hierarchy:** Are the most important decisions, content, and actions obvious?
6. **Interaction clarity:** Are controls, states, validation, navigation, and feedback understandable?
7. **Accessibility and inclusion:** Can users operate and understand it across input modes, assistive tech, language needs, and cognitive load?
8. **Content and terminology:** Does the UI use language users understand from their context?
9. **Visual design only as it supports use:** Does spacing, contrast, grouping, typography, and emphasis clarify the task?
10. **Frontend feasibility:** Can this be built maintainably with semantic, responsive, performant, design-system-aligned components?
11. **Risks and next test:** What evidence is missing, and what is the smallest credible test?

##### Creation workflow

When creating a research plan, UX recommendation, or design improvement:

1. Clarify the decision and desired outcome.
2. Identify users, contexts, and constraints.
3. List assumptions and unknowns.
4. Choose the smallest research or testing method that can reduce risk.
5. Create the guide, script, task list, or analysis structure.
6. Include recruiting, consent, roles, and logistics.
7. Define evidence to collect and success criteria.
8. Include accessibility coverage.
9. Plan synthesis and reporting.
10. Recommend next actions and how to measure impact.

##### Quality checklist

Before finalizing, verify:

- The product/design decision is explicit.
- The research question is answerable.
- The method matches the decision.
- Participant criteria are behavior/context-based.
- Questions are neutral and anchored in real experiences.
- Usability tasks are realistic and not step-by-step instructions.
- Consent, recording, privacy, incentives, and accessibility accommodations are addressed.
- Synthesis separates observations, interpretations, and recommendations.
- Recommendations are prioritized by impact, confidence, risk, and effort.
- Business value and user value are both represented.
- Frontend implications are practical and accessible.
- Limitations and confidence are stated.

Use the full checklists in [references/checklists.md](references/checklists.md).

##### Common mistakes to avoid

- Asking users what they want and treating the answer as a roadmap.
- Asking whether users like a design.
- Starting with a feature idea instead of a decision or opportunity.
- Using research to validate a foregone conclusion.
- Recruiting only easy internal participants.
- Confusing demographics with behavior.
- Running usability tests without realistic tasks.
- Helping participants during the test.
- Producing long reports that arrive too late to affect decisions.
- Treating analytics as self-explanatory.
- Treating interviews as statistically representative.
- Optimizing the current UI into a local maximum while ignoring larger opportunities.
- Forgetting accessibility until after design or implementation.

See [references/anti-patterns.md](references/anti-patterns.md) for the full anti-pattern list.
- Over-asking the user for context when a safe default is available.

##### How to explain recommendations to the user

Use this structure:

1. **Recommendation:** State the action clearly.
2. **Why:** Tie it to user behavior and business outcome.
3. **Evidence:** Identify the source and confidence level.
4. **Tradeoff:** Explain what is gained and what risk remains.
5. **Next step:** Propose the smallest test, implementation step, or metric.

Example:

> Recommend testing the checkout error flow before redesigning the entire checkout. The likely risk is not visual polish but task recovery: users need to understand what failed, how to fix it, and whether their payment was charged. Start with five task-based sessions on the current flow and prototype the top two fixes. Measure completion rate, error recovery, and support contacts after launch.


---

### ux-usability-foundations
**Description:** "Use when designing, critiquing, or improving an interface for usability, including affordances, feedback, constraints, error prevention, navigation clarity, or task flow."


#### UX Usability Foundations

##### Purpose

Help an agent make interfaces understandable, usable, forgiving, and aligned with user expectations. Treat usability as product behavior, not surface decoration. The agent should turn unclear or fragile UI into an interface where users can quickly answer: what is this, what can I do here, where am I, what happened, how do I recover, and is this worth the effort?

##### When to use this skill

Use this skill when the user asks you to critique, redesign, create, or specify a UI, flow, form, app screen, website, dashboard, onboarding, settings page, checkout, navigation model, state behavior, or component interaction for usability. Use it for affordances/signifiers, feedback, constraints, errors, empty/loading/success states, recognition over recall, task clarity, and frontend behavior.

##### When not to use this skill

Do not use as the primary skill for deep research operations, brand styling systems, visual polish, typography craft, frontend architecture, or persuasion/growth tactics unless those choices directly affect user understanding, control, or recovery.

##### Core principles

1. **Start with goals, not screens.** Identify the user’s goal, task, context, and likely knowledge before changing controls or layout. Design requirements describe needs before widgets.
2. **Make the next action obvious.** Prefer self-evident interfaces. If the task is inherently novel or complex, make it self-explanatory with structure, labels, examples, and feedback.
3. **Show what is possible.** Interactive elements must look interactive. Read-only elements must not look editable. Hidden gestures need visible alternatives.
4. **Match the user’s mental model.** Use the concepts, names, and sequence users understand; do not expose database tables, file paths, internal IDs, or arbitrary system states unless users need them.
5. **Favor recognition over recall.** Keep needed options, context, examples, and state visible or easy to retrieve.
6. **Reduce work and excise.** Remove tasks that serve the system rather than the user’s goal: retyping, transferring data, hunting for controls, configuring obvious defaults, or answering inferable questions.
7. **Guide choices without overloading users.** Use progressive disclosure, sensible defaults, grouping, and prioritization.
8. **Give immediate, informative feedback.** Every consequential action needs a response that says whether the system received it, what changed, whether waiting is required, and what can happen next.
9. **Prevent errors before explaining them.** Use constraints, safe defaults, previews, tolerant input, inline validation, and undo where feasible.
10. **Blame the design, not the user.** Errors reveal a mismatch in expectations or an unsupported edge case. Preserve work and guide recovery.
11. **Respect platform and convention.** Use familiar patterns when they fit. Break convention only when the user’s goal clearly benefits and the new behavior can be discovered and recovered from.
12. **Accessibility is usability under pressure.** Design for perceptibility, operability, simplicity, and forgiveness across varied abilities, devices, literacy, stress, and environments.

See [references/principle-cards.md](references/principle-cards.md) for each principle as a reusable card.

##### Default recommendations

###### Product goal
Default to optimizing the primary user task before secondary business asks. Override only for legal, safety, fraud, privacy, or business-critical requirements. Ask: “Which obligation must interrupt or constrain the primary task, and what is the consequence of hiding or delaying it?”

###### Audience
Default to motivated but distracted users with average domain knowledge and imperfect memory. Override for trained expert operators using the product frequently under stable conditions. Ask: “Is this primarily for first-time/infrequent users, frequent intermediates, or trained experts?”

###### Platform and input
Default to platform conventions and support pointer, touch, keyboard, and assistive technology where relevant. Ask when platform/input constraints are unknown.

###### Information density
Default to enough context for recognition and decision-making, while hiding rare advanced controls behind clear entry points. Override for comparison, monitoring, or expert workflows. Ask: “Do users need overview density for monitoring/comparison, or step-by-step focus for completion?”

###### Navigation
Default to clear location, current object/state, access to major areas, and a visible route back or onward. Override only for intentional guided flows. Ask: “Should users be free to move around, or should this flow intentionally constrain navigation?”

###### Labels and language
Default to plain, task-oriented labels from the user’s vocabulary. Ask before using internal, clever, legal, or domain-specific terms.

###### Forms
Default to persistent labels, appropriate input types, upfront constraints, inline validation where helpful, preserved data, and a clear primary action. Ask only when density/speed for experts may be more important than first-time clarity.

###### Error handling
Default to prevention first; if error occurs, explain what happened, why it matters, and how to fix it without losing work. Ask when error details are sensitive, regulated, or security-relevant.

###### Destructive actions
Default to visually secondary destructive actions until the final review/confirmation step. Prefer undo for reversible actions; use confirmation for irreversible, costly, legal, or safety actions. Ask about reversibility and harm.

###### Feedback and status
Default to instant receipt feedback, progress for delays, visible completion, and persistent state for long-running or consequential operations. Ask which status changes should interrupt.

###### Accessibility
Default to WCAG-oriented basics: semantic controls, keyboard operation, focus visibility, programmatic labels, sufficient contrast, no color-only meaning, readable copy, and screen-reader-friendly state updates. Do not override basics.

##### Required user questions

Do not ask routine best-practice questions. Ask one focused question only when the answer changes the recommendation:

- The primary user/task is unclear.
- The action has safety, financial, legal, privacy, medical, or irreversible consequences.
- Novices and experts need different behaviors.
- Platform/input constraints are unknown.
- Required terminology or compliance copy may apply.
- The user requests a nonstandard, hidden, or manipulative pattern.
- There is a real tradeoff between density and clarity or between guided flow and free navigation.

Use this pattern:

```js
question({
  question: "What is the primary task this interface must help users complete?",
  recommended_default: "Optimize for the most common successful task first, then make secondary actions available but visually quieter.",
  options: [
    "Complete one focused task",
    "Compare or monitor multiple items",
    "Explore and choose among options",
    "Other / custom"
  ]
})
```

Use the question-tool-ready prompts in [references/decision-prompts.md](references/decision-prompts.md) for the full decision set.

##### Workflow for critiquing an existing UI

Inspect in this order:

1. User goal and task fit.
2. First-glance comprehension.
3. Orientation: current place, object, state, and path onward/back.
4. Action discoverability.
5. Choice quality and priority.
6. Labels and language.
7. Feedback and status.
8. Error prevention and recovery.
9. Recognition versus memory burden.
10. Accessibility and input coverage.
11. Frontend feasibility and edge states.
12. Prioritization by task impact, frequency, severity, and fix effort.

Report critique as: highest-impact usability issues, quick wins, behavior/spec details, accessibility notes, and risks/tradeoffs.

##### Workflow for creating or improving an interface

1. Clarify the user, goal, success condition, and risk.
2. Choose the simplest useful flow.
3. Map user concepts and vocabulary.
4. Create visible structure and action hierarchy.
5. Select standard patterns unless a task reason justifies custom behavior.
6. Design default, hover, focus, active, loading, success, empty, validation, error, offline, disabled, and permission states.
7. Add constraints, validation, and recovery.
8. Support first use and repeated use.
9. Verify accessibility.
10. Explain decisions in terms of task progress, cognitive load, expectations, and risk.

##### Decision framework

Ask yourself:

1. Is the problem comprehension, choice, control, feedback, navigation, or recovery?
2. Can the design prevent the problem rather than explain it?
3. Can the interface use recognition instead of recall?
4. Can a standard pattern solve this without new learning?
5. Which elements are primary, secondary, tertiary, or dangerous?
6. Does the user need more information, fewer choices, or a better sequence?
7. Will the user notice the state change?
8. What happens if the user is distracted, rushed, using touch, using keyboard, using assistive tech, or recovering from an error?
9. What is reversible, costly, or irreversible?
10. Is this serving the user’s task or the system’s convenience?

##### Practical rules

###### Obviousness and scanning
- Make each screen’s purpose visible in its heading, structure, and primary action.
- Use descriptive buttons: “Send invoice,” “Save changes,” or “Book appointment,” not “Submit.”
- Make click/tap targets look like controls without relying on hover.
- Use headings, grouping, whitespace, and lists so users can scan.
- Remove copy and decorative elements that compete with the task.

###### Affordances, signifiers, and controls
- Use native controls when behavior fits.
- Use icons with labels for unfamiliar or consequential actions.
- Preserve distinctions between links, buttons, selected items, disabled items, editable fields, and static text.
- Do not hide essential actions behind gestures, long press, hover, or tiny overflow menus unless visible alternatives exist.

###### Choices and progressive disclosure
- Limit initial choices to the current decision.
- Use safe, likely defaults.
- Reveal advanced options near the point of need.
- Use comparison structures when users must choose among similar plans, products, records, or settings.

###### Feedback and state
- Give immediate micro-feedback for command receipt.
- Show progress for delays and async operations.
- Confirm completion when the result is not visible.
- Make current selection, current page, current filter, unsaved changes, and offline/sync status visible.
- Avoid noisy feedback for routine non-events.

###### Errors and recovery
- Validate constraints before submission when feasible.
- Keep invalid user input visible and editable.
- Place errors next to affected controls and summarize long-form errors.
- Use undo for reversible actions and confirmation for irreversible or high-risk actions.
- Never make users start over after a recoverable problem.

###### Navigation and orientation
- Show current section, object, state, and available next/back paths.
- Use breadcrumbs for deep hierarchy, not as a substitute for clear navigation.
- Use tabs only for peer sections of the same context.
- Use drawers/menus for infrequent or space-constrained actions; avoid hiding frequently needed primary navigation.
- Preserve route, filters, and scroll position when users return from detail to list.

###### Learnability
- Make first-run help temporary and task-focused.
- Prefer inline examples and empty-state guidance over separate help documents.
- Let repeated successful use reduce beginner guidance.
- Design for “perpetual intermediates”: users know the basics but do not remember everything.

##### Accessibility and inclusion requirements

- Use semantic HTML and native elements before custom widgets.
- Ensure all interactive elements have accessible names.
- Keep focus order aligned with visual/task order.
- Provide visible focus indicators.
- Support keyboard operation for all actions.
- Associate labels, hints, and errors with form controls.
- Do not rely on placeholder text as the only label.
- Do not rely on color alone.
- Announce async status and errors appropriately.
- Ensure dialogs trap focus while open and restore focus when closed.
- Respect reduced motion.
- Make target sizes suitable for touch and motor variability.
- Write at the simplest level compatible with the task and domain.

##### Frontend implementation guidance

###### Semantic structure
- Use `<button>` for actions and `<a>` for navigation.
- Use persistent programmatic labels for inputs.
- Use fieldsets/legends for related radio/checkbox groups.
- Use headings in logical order.
- Use tables for tabular data, not layout.

###### State and feedback
- Include default, hover, focus-visible, active, selected, expanded/collapsed, disabled, loading, success, warning, error, empty, offline, and read-only states where relevant.
- Use `aria-expanded`, `aria-controls`, `aria-selected`, `aria-current`, `aria-invalid`, `aria-describedby`, and live regions as needed.
- Disable controls only when the reason is obvious or explained; otherwise allow the action and guide the user.
- Prevent duplicate submissions with pending state and idempotent server handling.

###### Forms
- Use `type`, `autocomplete`, `inputmode`, `min`, `max`, `step`, and constraints appropriately.
- Keep input flexible when users may enter equivalent formats.
- Validate on blur or submit for complex fields; validate on input only when stable and helpful.
- Preserve entries across errors, refreshes, authentication interruptions, and network failures whenever possible.

###### Responsive and input behavior
- Do not assume hover.
- Keep primary actions reachable without hiding context on small screens.
- Ensure text can zoom/reflow without loss of function.
- Test with keyboard only, screen reader basics, touch, narrow viewport, slow network, and high zoom.

##### Quality checklist

- The primary user goal is stated.
- The screen’s purpose is clear at a glance.
- The primary action is stronger than secondary actions.
- Labels use user language.
- Interactive elements are discoverable without hover.
- Required choices are minimized and grouped.
- The interface provides status feedback after consequential actions.
- Errors are prevented where possible and recoverable where not.
- Destructive actions are reversible or clearly confirmed.
- Users do not lose work due to validation, auth, network, or navigation issues.
- Navigation answers “where am I?” and “where can I go?”
- Accessibility fundamentals are included.
- Frontend behavior is implementable.

Use the full checklists in [references/checklists.md](references/checklists.md).

##### Common mistakes to avoid

- Starting with app chrome before the task.
- Treating “easy to use” as a checklist item.
- Hiding primary actions behind menus, gestures, or icons.
- Using clever labels where obvious labels would work.
- Making all actions equally important.
- Asking users questions the system can infer safely.
- Forcing users to remember hidden instructions or state.
- Replacing undo with constant confirmations.
- Blaming the user in error copy.
- Using disabled controls without explanation.
- Relying on color alone.
- Designing custom controls without keyboard and assistive-tech behavior.
- Treating accessibility as a final audit.
- Confusing visual simplicity with reduced task complexity.

See [references/anti-patterns.md](references/anti-patterns.md) for the full anti-pattern list.
- Ignoring empty, loading, offline, validation, permission, and edge states.

##### How to explain recommendations to the user

Use this pattern:

```markdown
I recommend [change] because users are likely trying to [goal]. The current version makes them [think/remember/guess/recover] unnecessarily. This change makes [action/state/recovery] visible and reduces [specific risk or effort]. The main tradeoff is [cost], which is acceptable unless [context that would change the decision].
```

When disagreeing with a requested pattern:

```markdown
I would not hide this behind an icon-only menu because it is the primary path for the task. A better default is a visible labeled action. Use the menu only for secondary or infrequent actions.
```



---

### ux-writing-content-design
**Description:** "Use when writing, critiquing, or implementing product UX copy, microcopy, labels, CTAs, empty states, onboarding, errors, or notifications."


#### UX Writing & Content Design

##### Purpose

Help an AI agent write and evaluate product copy that helps people understand an interface, take action, recover from problems, and trust the product. Treat words as part of the design system and interaction model, not as decoration added after the interface is finished.

This skill covers product UX copy: microcopy, button labels, links, labels, hints, descriptions, empty states, onboarding, validation, errors, success messages, loading/progress states, notifications, terminology, voice, tone, and content strategy. It does not cover long-form marketing copy except when that copy directly affects product comprehension, action, trust, onboarding, or conversion inside a product experience.

##### When to use this skill

Use this skill when the user asks you to:

- Write, rewrite, or critique UI text, product copy, UX copy, microcopy, form copy, navigation labels, CTAs, onboarding, empty states, errors, confirmations, loading states, notifications, help text, or design-system content guidance.
- Review a UI, mockup, screenshot, frontend component, flow, prototype, or design system for clarity, tone, usability, trust, recovery, or accessibility.
- Design or implement frontend states where copy affects user understanding or behavior.
- Create content rules, voice and tone guidance, terminology, content patterns, or a UX writing checklist.

##### When not to use this skill

Do not use this skill as the primary skill for:

- Long-form marketing pages, ads, brand campaigns, PR, SEO articles, or sales copy unless they affect an in-product UX flow.
- Pure visual styling, layout, illustration, or animation tasks where no interface text, state, or comprehension issue is involved.
- Legal, medical, financial, or compliance wording that requires a licensed professional. You may improve clarity, but flag the need for expert review.
- Translation/localization itself. Use this skill to make source copy localizable and context-safe, then use translation/localization expertise separately.

##### Core principles

1. **Words are design material.** Do not merely choose “nice words.” Use words to solve user problems and shape interaction behavior.
2. **Start with the user task and product purpose.** Copy is effective only when it supports what the user is trying to do and what the product legitimately needs.
3. **Prefer useful over clever.** Personality and delight are secondary to comprehension, action, trust, and recovery.
4. **Design the conversation, not isolated strings.** Inspect the entry point, action, system response, next step, inverse action, and failure path.
5. **Use the right pattern for the state.** A label, hint, tooltip, inline error, banner, empty state, notification, or confirmation each has a different job.
6. **Write in context.** Draft and evaluate text where it appears, with surrounding UI, component constraints, state, platform, and device.
7. **Make actions consequence-revealing.** Buttons and links should say what happens, not describe the input method.
8. **Errors are stress cases.** Avoid the error when possible, explain clearly when it happens, and help the user resolve it.
9. **Respect people on the margins.** Sensitive questions, forced choices, default suggestions, and “harmless” quick replies can exclude or hurt people.
10. **Be concise, not cryptic.** Short copy is valuable only when users can still understand it immediately.
11. **Measure when the stakes justify it.** Use usability testing, behavioral metrics, support data, and A/B tests when copy changes affect activation, conversion, retention, recovery, or trust.
12. **Make copy implementable.** Content should work with semantic HTML, accessibility APIs, localization, design tokens, component states, and design-system patterns.

See [references/principle-cards.md](references/principle-cards.md) for each principle as a reusable card.

##### Default recommendations

Use these defaults unless the user provides stronger product-specific context.

| Area | Default recommendation | Why it is usually best | Override when | Ask before overriding |
|---|---|---|---|---|
| Product goal | Help the user complete the immediate task with minimal uncertainty. | Most product copy is functional and users are not there to read. | The flow intentionally teaches, warns, or changes a high-stakes decision. | Ask what outcome matters most: comprehension, conversion, completion, retention, safety, or support reduction. |
| Audience | Write for a broad, busy, mixed-ability audience using plain language. | It reduces cognitive load and improves accessibility/localization. | The product serves a specialized expert audience with necessary domain terms. | Ask whether the audience expects domain-specific terminology. |
| Voice | Professional, warm, direct, and human. | Works for most SaaS, productivity, commerce, and public-service products. | A documented brand voice or regulated tone exists. | Ask for the brand personality or voice chart. |
| Tone | Calm and helpful. Match emotional stakes. | Users often encounter copy during uncertainty or interruption. | Success/delight states can support more warmth; severe or sensitive states require restraint. | Ask how stressful or sensitive the moment is. |
| CTA labels | Verb-led, specific, 1–3 words where possible; include object or consequence when needed. | Users make decisions at buttons and links. | Legal, destructive, paid, or irreversible actions need more specificity. | Ask what exactly happens after the action. |
| Form labels | Persistent visible labels above or beside fields; hints only for extra guidance. | Labels remain available after entry and support accessibility. | Very constrained UI already has a tested accessible pattern. | Ask about platform/component constraints. |
| Placeholder text | Use only for examples or formatting, never as the only label. | Placeholders disappear, can be low contrast, and are weak accessibility support. | A design system provides accessible floating labels. | Ask whether the component has accessible labels and error associations. |
| Help/instruction copy | Put guidance near the action only when the label alone is insufficient. | Extra text can help, but unnecessary instruction creates reading burden. | The task is unfamiliar, high-risk, or constrained by policy/format. | Ask what users commonly misunderstand. |
| Sensitive data requests | Explain why the data is needed and how it will be used. | Context improves trust and reduces harm for users who do not fit simple categories. | The reason is obvious and the data is not sensitive. | Ask why the product needs the information and whether users can skip it. |
| Error handling | Avoid first, explain second, resolve third. | Prevention reduces friction; recovery copy must still help when prevention fails. | A backend or legal constraint prevents prevention. | Ask what recovery actions are technically available. |
| Disabled controls | Do not rely on disabled UI as the only instruction. | Disabled controls can be inaccessible and leave users stuck. | Progressive activation is supplemented with accessible status/help. | Ask whether the disabled control has an accessible explanation. |
| Empty states | State what is empty, why it matters, and the next useful action. | Empty states are onboarding and recovery opportunities. | The absence is self-evident and no action is available. | Ask what the user can do next. |
| Success messages | Confirm what happened and, when useful, the next step or consequence. | Users need closure and sometimes need to know visibility, delivery, or reversibility. | The UI state itself clearly shows completion. | Ask whether success changes visibility, billing, permissions, or data. |
| Loading/progress | Say what is happening and set expectation if delay is noticeable. | Feedback reduces anxiety during wait states. | The delay is imperceptible. | Ask whether duration is known or variable. |
| Notifications | Send only timely, relevant, actionable messages. | Notifications interrupt; value must exceed interruption cost. | Compliance or operational needs require non-actionable notice. | Ask what user action or decision the notification supports. |
| Delight | Add personality only after the copy is functional, useful, and emotionally appropriate. | Humor can help in success or low-stress moments and harm in error/stress moments. | Brand voice is intentionally playful and the state is safe. | Ask whether the moment is stressful, sensitive, or irreversible. |
| Metrics | Use task success and comprehension first; use conversion only when aligned with user benefit. | Copy should not manipulate users away from their goals. | The business goal is the explicit optimization target. | Ask which metric and guardrail metric matter. |
| Accessibility level | Meet WCAG-aligned product basics: labels, programmatic errors, focus, keyboard, screen-reader states, readable text. | Accessibility is usability and exclusion is a design choice. | Higher conformance is required by policy. | Ask about required accessibility standard if compliance matters. |
| Localization | Avoid idioms, culture-specific jokes, compact strings that cannot expand, and ambiguous variables. | Product copy often becomes UI strings; localization can break layout and meaning. | Product is single-locale and will remain so. | Ask whether the product will be translated. |

##### Required user questions

Do not ask routine best-practice questions such as whether text should be clear, concise, or accessible. Apply the defaults.

Ask only when the answer materially changes the copy, pattern, tone, or implementation. Ask one focused question at a time unless the user explicitly asks for a full discovery pass.

Ask when any of these are missing and necessary:

- The **primary user task** or feature outcome is unclear.
- The **audience** is specialized, vulnerable, multilingual, very young/old, regulated, or otherwise context-dependent.
- The flow asks for **sensitive personal data**, legal consent, payment, health, identity, security, or irreversible action.
- The requested tone conflicts with user stress, inclusion, accessibility, or trust.
- The copy depends on a **technical constraint**, backend validation, recovery path, design-system pattern, or localization requirement.
- The user asks to optimize for a metric, but the metric or guardrail is unclear.
- A decision requires legal/compliance approval.

Default question pattern:

```js
question({
  question: "What is the primary user task this copy needs to support?",
  recommended_default: "Assume the user wants to complete the immediate visible action with as little uncertainty as possible.",
  options: [
    "Complete a task",
    "Learn how something works",
    "Recover from a problem",
    "Make a high-stakes decision",
    "Other / custom"
  ]
})
```

Use the question-tool-ready prompts in [references/decision-prompts.md](references/decision-prompts.md) for the full decision set.

##### Workflow

###### A. Critique existing UI copy

Inspect in this order:

1. **Task fit:** What is the user trying to do? Does the copy help that task or distract from it?
2. **User/business alignment:** Does the copy serve a legitimate product goal without forcing, hiding, or manipulating?
3. **Conversation flow:** Entry point → instruction → action → feedback → next step → inverse action → failure path.
4. **Pattern choice:** Is each string using the right component/state: label, hint, CTA, tooltip, inline validation, banner, modal, empty state, confirmation, notification?
5. **Action clarity:** Do buttons and links name the outcome?
6. **Comprehension:** Is the copy plain, specific, scannable, and free of unnecessary jargon?
7. **Stress and recovery:** Do errors avoid blame, explain the issue, and offer a realistic next step?
8. **Trust and inclusion:** Are sensitive asks explained? Are choices inclusive? Are defaults and suggestions safe?
9. **Voice and consistency:** Does wording follow product principles, terminology, grammar, capitalization, and tone?
10. **Accessibility and frontend feasibility:** Are labels, descriptions, errors, status updates, focus behavior, and localization implementable?
11. **Measurement:** If stakes are high, identify how to test or measure whether the copy works.

When reporting a critique, group findings by severity:

- **Blocking:** prevents comprehension, action, accessibility, trust, or recovery.
- **Important:** increases cognitive load, uncertainty, or inconsistency.
- **Polish:** improves tone, flow, or delight after core usability is fixed.

For each issue, provide: current problem, better copy or pattern, reason, and any implementation note.

###### B. Create or improve new UX copy

Proceed in this order:

1. **Clarify the product moment.** Identify user, task, state, platform, constraints, and success criteria. Ask only if missing context changes the recommendation.
2. **Map the conversation.** What does the user know now? What do they need to know? What action can they take? What does the system do next?
3. **Select the pattern.** Decide whether the copy belongs in a title, label, hint, body text, CTA, inline validation, banner, modal, empty state, toast, notification, loading message, or help entry.
4. **Draft useful copy first.** Make the copy accurate, task-focused, and outcome-specific before making it shorter or more branded.
5. **Edit in four passes.**
   - Purposeful: Does it serve the user and product goal?
   - Concise: Can anything be removed without losing meaning?
   - Conversational: Does it sound like a human interaction, not a system log?
   - Clear: Would the intended user understand it immediately?
6. **Handle edge and stress states.** Include empty, loading, success, validation, failure, permission, offline, destructive, and undo/retry states as relevant.
7. **Make it implementable.** Provide component/state mapping, semantic labels, error associations, ARIA live-region guidance where needed, string tokens if useful, and localization notes.
8. **Test or validate.** Recommend usability test prompts, comprehension checks, support-data review, or A/B tests when stakes justify it.
9. **Explain decisions.** Tie recommendations to task completion, comprehension, trust, recovery, accessibility, and product goals.

##### Decision framework

Use this framework to choose the content pattern:

| User need | Prefer this pattern | Default content structure |
|---|---|---|
| Know where they are | Page title / section heading | Object or task name; avoid generic “Details” when specificity matters. |
| Know what a field is | Visible label | Noun phrase: “Work email,” “Deposit amount.” |
| Know format or constraint | Hint / helper text | Constraint or example: “Use 8–64 characters.” |
| Decide what happens | Button / link | Verb + object/consequence: “Create post,” “Pay $24,” “Download report.” |
| Understand a sensitive ask | Contextual explanation | Why needed + how used + whether optional. |
| Know something is happening | Loading/progress | Current operation + duration/expectation if known. |
| Know action succeeded | Confirmation/toast | What happened + important consequence + next step if useful. |
| Know nothing is here yet | Empty state | What is empty + why/when + next action. |
| Recover from a problem | Inline error or error page | What happened + why if useful + how to fix/retry/escape. |
| Learn without blocking | Inline help / documentation link | Short in-context guidance + link to deeper help. |
| Respond to timely change | Notification | Timely reason + user benefit + clear action or dismissal. |
| Prevent harm | Confirmation dialog / interstitial | Consequence + irreversible scope + safe cancel + specific confirm action. |

##### Practical rules

###### Buttons and links

- Use the action outcome, not the interaction method. Prefer “Download report,” “Create post,” or “View pricing” over “Click here,” “Submit,” or vague “Save” when the object/action matters.
- Put the most important consequence in the label for payment, deletion, sending, publishing, sharing, permissions, and irreversible actions.
- Make primary and secondary actions meaningfully different. Avoid pairs like “OK / Cancel” when users need consequence clarity.
- Use “Back,” “Cancel,” “Undo,” “Remove,” and “Delete” carefully; they imply different reversibility.

###### Forms

- Use persistent labels for every input. Do not rely on placeholders as labels.
- Use helper text for unusual constraints, examples, privacy concerns, or why the information is needed.
- Put errors near the field and summarize at the top only when the form is long or submission failed.
- Use examples that match required formatting, but avoid examples that look like actual saved data.
- Prefer progressive disclosure over long instructions, but do not hide information required to complete the task.

###### Sensitive questions and personal data

- Before asking for identity, demographics, health, finance, location, contacts, or legal information, explain the reason in plain language.
- Do not force binary, overly narrow, or culturally specific categories unless legally required.
- Offer “Prefer not to say,” “Self-describe,” “Not listed,” or skip options when appropriate and feasible.
- Never use playful tone to soften surveillance, coercion, or a data grab.

###### Errors and validation

Use **Avoid → Explain → Resolve**.

1. **Avoid:** Prevent errors through clear labels, constraints, input masks, examples, progressive validation, and better interaction design.
2. **Explain:** State what went wrong in human language. Avoid raw error codes, stack traces, or blame.
3. **Resolve:** Tell the user what to do next: fix, retry, undo, contact support, use an alternative path, or wait.

Error message structure:

```text
[Problem in user terms]. [Specific fix or next step].
```

Examples of structures, not fixed copy:

- “Enter a valid email address.”
- “Your file is too large. Upload a file under 10 MB.”
- “We couldn’t save your changes. Check your connection and try again.”

For high-stress, legal, financial, medical, identity, security, or destructive states, use calm, explicit, non-humorous copy.

###### Empty states

Use empty states to orient and move the user forward.

Default structure:

```text
Title: No [objects] yet
Description: [What will appear here or why it matters]
Action: [Next useful action]
```

Do not turn every empty state into a marketing pitch. If there is no useful next action, explain the state and provide a path back.

###### Loading and progress states

- If a wait is noticeable, tell users what is happening.
- If duration is predictable, set expectation.
- If the process may fail, prepare recovery paths.
- Use brand personality sparingly; never let playful loading copy hide risk, cost, or uncertainty.

###### Success and confirmation

- Confirm the completed action in specific terms.
- Include important consequences: publication, visibility, payment, delivery, permissions, data changes, or email sent.
- Add next steps only when they help the current task.
- Avoid celebratory tone for sensitive successes.

###### Notifications

- Send fewer, better notifications.
- Make them timely, relevant, and actionable.
- Avoid vague engagement bait.
- Use the user’s language and current context.
- Provide controls for frequency and opt-out when appropriate.

###### Voice and tone

Build voice from product principles, not from adjectives alone.

Define:

- **Concepts:** what the product should consistently emphasize.
- **Vocabulary:** preferred and avoided terms.
- **Verbosity:** how much explanation is appropriate by state.
- **Grammar:** sentence structure, point of view, contractions, tense.
- **Punctuation and capitalization:** consistent mechanics.
- **Tone shifts:** how the voice changes in success, error, legal, privacy, onboarding, and high-stress moments.

When no voice is supplied, use a professional, warm, direct voice.

###### Editing

Use the four-pass edit:

1. Purposeful
2. Concise
3. Conversational
4. Clear

Do not start by shortening. First confirm that the copy solves the right problem. Then shorten without removing necessary meaning.

##### Accessibility and inclusion requirements

- Use visible labels and programmatic labels for inputs.
- Associate helper text and errors with fields using accessible descriptions.
- Do not rely on color, icon, position, or animation alone to communicate status.
- Ensure error, success, and loading updates are announced appropriately for assistive technologies.
- Preserve focus and keyboard access through dialogs, errors, and state changes.
- Avoid disabled controls as the only instruction. If a control is disabled, explain why and how to enable it in accessible text.
- Use readable plain language, short sentences, and familiar terms.
- Avoid idioms, jokes, metaphors, and culture-specific references in functional copy unless tested for the audience.
- Provide inclusive options for identity-related questions and explain why the information is needed.
- Consider emotional context: people may be stressed, grieving, sick, locked out, financially worried, or under time pressure.
- Support localization with string expansion, variables that can move, pluralization, and context notes for translators.

##### Frontend implementation guidance

When giving frontend recommendations, include copy as part of component behavior.

###### Semantic HTML and ARIA

- Use real `<label>` elements connected to inputs.
- Use `<button>` for actions and `<a>` for navigation.
- Use headings that reflect information hierarchy.
- Use `aria-describedby` to connect helper and error text to fields.
- Use `aria-invalid="true"` when validation fails.
- Use `role="alert"` or an appropriate live region for urgent validation/status updates, but avoid excessive announcements.
- Manage focus after modal opens, form submission fails, route changes, and destructive confirmations.
- Do not remove focus outlines.

###### Component/state structure

Document copy for each relevant state:

- default
- hover/focus where text changes, if any
- loading
- empty
- partial
- success
- warning
- error
- offline
- permission denied
- disabled
- destructive confirmation
- undo/retry

###### Design-system integration

- Name reusable content patterns, not only individual strings.
- Store preferred terms and forbidden terms.
- Provide examples for labels, CTA labels, helper text, errors, empty states, loading, confirmations, and notifications.
- Use content tokens or string IDs when implementation requires reuse, but avoid abstract IDs that hide context.
- Keep source strings localizable. Avoid concatenating sentence fragments in code.

###### Responsive and localization considerations

- Expect copy expansion in translation.
- Avoid layouts that only work for very short English strings.
- Do not encode meaning solely in line breaks.
- Test truncation behavior for CTAs, tabs, nav, toasts, and table headers.
- Provide translator comments for variables, tone, and context.

##### Quality checklist

Before finalizing UX copy, verify:

- The user’s primary task is clear.
- Each string has a job: orient, instruct, motivate, confirm, warn, recover, or explain.
- The copy does not compensate for a broken interaction that should be redesigned.
- Buttons and links describe outcomes.
- Forms have visible labels and helpful constraints.
- Sensitive asks explain why the data is needed.
- Errors state the problem and the next step without blame.
- Empty states include a useful next action when one exists.
- Success states confirm important consequences.
- Tone matches emotional stakes.
- Voice and terminology are consistent.
- Copy is concise but not cryptic.
- Accessibility states are implementable.
- Localization will not break the UI.
- High-impact copy has a validation or measurement plan.
- Recommendations include frontend notes when implementation matters.

Use the full checklists in [references/checklists.md](references/checklists.md).

##### Common mistakes to avoid

- Treating UX writing as wordsmithing after the UI is done.
- Asking users “Should I make it clear?” instead of applying clarity by default.
- Using “Submit,” “Continue,” “OK,” or “Save” when the action consequence matters.
- Replacing visible labels with placeholder text.
- Explaining a broken UI instead of fixing the UI.
- Hiding manipulative business goals in friendly language.
- Using humor in errors, denial, payment failure, identity, legal, security, medical, or financial states.
- Asking sensitive demographic or personal questions without explaining why.
- Using technical error codes or backend terms in user-facing copy.
- Over-branding navigation, forms, instructions, and errors.
- Creating empty states that are dead ends.
- Sending notifications that do not help the user act.
- Writing strings that cannot be localized or announced by assistive technology.

See [references/anti-patterns.md](references/anti-patterns.md) for the full anti-pattern list.
- Delivering copy without states, constraints, or implementation context.

##### How to explain recommendations to the user

Explain recommendations in terms of user impact, not personal taste.

Use this structure:

```text
I recommend [copy/pattern] because [user goal or risk]. It improves [comprehension/action/trust/recovery/accessibility]. Use [alternative] only if [context/constraint].
```

When giving multiple options, label them by purpose:

- **Clear/default**
- **Warmer**
- **More formal**
- **Higher-trust**
- **Shorter for constrained UI**
- **Accessible/error-safe**
- **Legal/compliance-safe pending review**

Avoid saying “this sounds better” without explaining the task, state, or user need.



---

### forms-inputs-checkout
**Description:** "Use when designing, critiquing, or implementing forms, inputs, validation, checkout, registration, payment, or any data-entry flow."


#### Forms, Inputs, and Checkout

##### Purpose

Help an agent design, critique, and implement clear, accessible, high-conversion forms, inputs, validation, and checkout flows.

Treat every form as a barrier between a person and a goal. The agent's job is to reduce that barrier without collecting bad data, hiding meaningful choices, or weakening accessibility, privacy, legal, or business requirements.

##### When to use this skill

Use this skill for:

- Checkout, cart, payment, shipping, billing, promo-code, account, registration, sign-in, onboarding, subscription, lead-capture, support, survey, settings, profile, upload, and data-entry forms.
- Critiquing screenshots, wireframes, Figma descriptions, HTML/CSS/React components, design-system components, or product flows involving forms.
- Choosing labels, input controls, grouping, progress indicators, defaults, validation, error messages, help text, submit states, and success states.
- Making frontend guidance for semantic HTML forms, accessible names, focus, keyboard flow, validation, and responsive behavior.

##### When not to use this skill

Do not use this skill for:

- General page layout, landing pages, navigation, marketing content, or visual brand work unless the page contains a form or checkout decision.
- Backend data modeling, fraud detection, tax, legal, PCI/security implementation, or payment processor integration details beyond UX/frontend implications.
- General conversion-copy work outside form context.
- Native platform-specific form controls when the user explicitly asks for a platform guideline not covered by the source material. In that case, ask or use the appropriate platform skill/source.

##### Core principles

1. **Start outside-in.** Begin with the user's goal and the moment in their journey, not with the database fields the organization wants.
2. **Remove, defer, infer, or default before designing another field.** Every question creates effort and the possibility of error.
3. **Make the path to completion visually obvious.** A form should have a clear scan line from title to first question to final action.
4. **Use controls that match the question.** Prefer native, semantic form controls and visible options when the number of options is small.
5. **Use labels as durable context.** Do not rely on placeholder-only labels for anything longer than a trivial, familiar, one-field interaction.
6. **Validate to help, not to scold.** Validate after a person has finished an answer, prevent avoidable errors, and provide remedies in context.
7. **Design for mistakes.** People will omit steps, choose the wrong action, mistype, misunderstand labels, and miss information under stress.
8. **Do not use color alone.** Errors, success, required/optional status, disabled states, and payment/security cues need text and/or shape in addition to color.
9. **Keep checkout focused.** Remove distractions, avoid forced account creation, show costs and consequences clearly, and keep the primary action aligned with the buyer's goal.
10. **Make progress honest.** Use progress indicators only when the sequence and scope are stable enough that the indicator will not mislead.

See [references/principle-cards.md](references/principle-cards.md) for each principle as a reusable card.

##### Default recommendations

Use these defaults unless the user provides a product-specific constraint or the skill's decision prompts indicate a question is needed.

###### Form purpose and scope

Default: optimize for successful completion of the user's current goal with the minimum trustworthy data required.

Override when: regulatory, security, fraud, identity, eligibility, support, or fulfillment requirements demand additional data. Ask for the requirement and consequence.

###### Question set

Default: remove nonessential questions; postpone optional or marketing questions until after the core submission; infer answers from known context when confidence is high.

Override when: optional answers are critical to personalization, eligibility, pricing, compliance, or operational routing.

###### Structure

Default: use a single page for short forms with a few coherent topics; use multiple pages or one-thing-per-page for long forms, branching flows, mobile-first flows, or high-focus tasks.

Override when: users need to review many related answers together, compare choices, or complete a dense expert workflow.

###### Labels

Default: use visible, concise, natural-language labels above fields. Top labels usually minimize completion time, handle localization better, and work well on mobile.

Override when: a dense desktop form has severe vertical constraints, or when a complex settings form needs label scanning more than speed.

###### Required and optional fields

Default: avoid optional fields. When most fields are required, mark the few optional fields with text such as "Optional." When most fields are optional, mark the few required fields with text such as "Required." Do not mark every field required.

Override when: organizational standards require asterisks; still provide a legend and associate the indicator with the label.

###### Input controls

Default: use native controls and semantic HTML. Use radio buttons for one choice among a small set, checkboxes for yes/no or multiple choices, text inputs for free-form answers, and select/combobox patterns only when they reduce effort for long option sets.

Override when: the design system has tested accessible custom controls that preserve keyboard, screen reader, focus, and error behavior.

###### Select boxes

Default: use select boxes as a last resort. Prefer visible radio options for a short list, autocomplete/combobox for long searchable lists, or sensible defaults when the likely answer is known.

Override when: platform conventions or limited space make a select control the simplest accessible solution.

###### Input width

Default: make field width communicate expected answer length when the answer has a known size, such as postal code or security code. Use consistent practical widths when length does not carry meaning.

Override when: responsive constraints, localization, or auto-formatting make exact width misleading.

###### Help text

Default: provide short, adjacent help only for unfamiliar data, privacy/security concerns, unusual formats, sensitive questions, optional/required exceptions, or recommended answer formats.

Override when: expert, repeated-use, or complex workflows require a persistent contextual help panel.

###### Validation

Default: validate after the user finishes a field, usually on blur or after selection, not while they are still typing. Use inline validation for fields with high error rates, strict formats, uniqueness checks, limits, or large valid answer sets.

Override when: a live counter or meter directly supports answer construction, such as character limits or password strength; make the feedback nonblocking while typing.

###### Error messages

Default: provide a top-level error summary for long forms or multiple errors and inline field-level remedies for each problematic field. Mark error fields with text plus visual emphasis, not color alone.

Override when: a very short form has only one obvious error and the inline message is in view.

###### Submit button and submission state

Default: keep the primary action visible and enabled; when clicked, clearly show processing and prevent duplicate submission. Avoid hiding or disabling the submit button before submission unless the reason is communicated and the next fix is obvious.

Override when: a destructive, irreversible, or legally sensitive action requires explicit prerequisites; explain what is missing and move focus to the first blocker.

###### Checkout

Default: support guest checkout or account-after-purchase, keep order summary and total visible, minimize offramps, ask for delivery/payment information in a sensible order, and postpone account/profile questions.

Override when: the product cannot fulfill the transaction without an account, identity verification, eligibility, or saved relationship.

###### Progress indicators

Default: omit progress bars for short, uncertain, or dynamically branching forms. Show scope, position, and save/status only for stable multi-step flows.

Override when: long forms need reassurance but steps are dynamic; use general progress language such as "Almost done" or section completion rather than precise step counts.

###### Accessibility level

Default: design to WCAG-style expectations: semantic controls, visible labels, keyboard access, meaningful focus, sufficient contrast, text alternatives, no color-only cues, scalable text, and error messaging announced to assistive technology.

Override: do not lower accessibility. For high-risk domains, ask whether additional accessibility, testing, or legal conformance is required.

###### Frontend implementation

Default: use semantic HTML first; style the native controls when possible; prefer design-system components that preserve native semantics; build form state around field value, touched/dirty status, validation status, submission status, and server error status.

Override when: a custom interaction is necessary; require keyboard, focus, screen reader, and mobile input behavior before recommending it.

##### Required user questions

Ask a focused question only when the answer changes the recommended form design. Do not ask routine best-practice questions.

Ask when any of the following are unknown and materially affect the work:

- The form's business/user goal is ambiguous.
- The flow involves checkout, payment, identity, legal consent, healthcare, finance, government, minors, accessibility compliance, or irreversible consequences.
- The form has many fields and it is unclear which are required, optional, inferable, or deferrable.
- The audience, locale, language, device mix, or assistive technology needs are likely to change label length, input formats, keyboard behavior, or trust messaging.
- A tradeoff exists between one-page versus multi-page, speed versus careful review, visible options versus compact controls, or guest checkout versus account creation.
- Existing analytics/research are needed to diagnose drop-off, error rates, or conversion problems.

Use the question-tool-ready prompts in [references/decision-prompts.md](references/decision-prompts.md).

##### Workflow for critiquing existing forms

Inspect in this order:

1. **Goal fit:** What is the user trying to accomplish, and does the form delay or block it unnecessarily?
2. **Question necessity:** Which fields can be removed, inferred, defaulted, made optional, or postponed?
3. **Flow and sequence:** Does the order match how people think about the task? Are sensitive or high-effort questions delayed until trust/context exists?
4. **Structure and grouping:** Are related questions grouped with the least visual noise necessary? Is branching handled without disorientation?
5. **Scan line and layout:** Can a person move steadily from label to input to action without zigzagging, jumping columns, or missing important information?
6. **Labels and controls:** Are labels visible, succinct, durable, and associated with the right semantic controls?
7. **Help and microcopy:** Is help contextual and minimal? Does it explain only what design cannot make obvious?
8. **Validation and errors:** Are errors prevented where possible, shown at the right time, and written as actionable remedies?
9. **Submission and success:** Is the primary action clear? Are loading, duplicate-submit prevention, success, and next steps handled?
10. **Accessibility and implementation:** Does the form work by keyboard, screen reader, touch, mobile keyboard, zoom, and without color-only cues?
11. **Measurement:** Recommend testing or analytics for completion rate, drop-off, error locations, time to complete, support contacts, and qualitative frustration.

When presenting critique, group findings by severity: blockers, high-friction issues, accessibility issues, conversion opportunities, polish.

##### Workflow for creating or improving a form

1. **Clarify the task.** Identify the user's goal, business goal, required output, audience, device mix, and constraints.
2. **Define the minimum successful submission.** List fields as required, optional, inferable, defaultable, and deferrable.
3. **Choose the flow shape.** Single page, multi-step, one-question-per-page, progressive disclosure, or gradual engagement.
4. **Order the questions.** Start with low-friction/context-setting questions; delay account, sensitive, legal, or high-effort questions until they are justified.
5. **Group fields by user topic.** Use headings, whitespace, fieldsets, and legends; avoid decorative dividers that add visual noise.
6. **Select controls and labels.** Choose the simplest native control that matches the question; use visible labels and expected input attributes.
7. **Add defaults and help.** Default only when likely correct; keep help adjacent, brief, and specific.
8. **Design validation and errors.** Prevent errors, validate at humane timing, summarize when needed, and provide field-level remedies.
9. **Design submission states.** Make primary, secondary, loading, duplicate-submit prevention, success, and next steps explicit.
10. **Check accessibility and frontend feasibility.** Verify semantic HTML, focus, keyboard order, ARIA where needed, responsive behavior, and design-system fit.
11. **Explain tradeoffs.** State the chosen default, why it is appropriate, and what would change under different constraints.

##### Decision framework

Use this order of preference before adding complexity:

1. **Remove** the question.
2. **Infer** the answer from known context or system data.
3. **Default** the answer when the default aligns with most users' goals and is easy to change.
4. **Defer** the question until after the core task or until the answer becomes relevant.
5. **Ask** the question in the simplest possible way.
6. **Explain** why the question is needed when people may wonder, worry, or lack context.
7. **Validate** at the least disruptive time.
8. **Recover** gracefully when the answer is missing, wrong, or rejected by the server.

##### Practical rules

###### Structure and flow

- Name the form with a title that matches the user's expected task, not the internal database object.
- For checkout, avoid sign-in walls. Let people proceed as guests or create an account after purchase whenever feasible.
- Break long forms into meaningful topics; do not split a short form into many pages just to simulate engagement.
- Use one thing per page when focus, branching, mobile ergonomics, or comprehension matter more than visible overview.
- Use progress indicators only when they honestly communicate scope, current position, and status.
- Provide save/resume for long, high-effort forms.

###### Labels and questions

- Write labels as short, concrete questions or noun phrases in the user's language.
- Use consistent capitalization. Avoid all caps except for narrow warning contexts.
- Keep labels visible after the user types. Placeholder text can supplement, not replace, labels.
- Do not mix label alignments within the same form.
- Prefer top-aligned labels for familiar data and mobile-first work.
- Prefer left-aligned labels only when scanning unfamiliar or many optional fields matters more than speed.

###### Grouping and visual hierarchy

- Use proximity and whitespace before lines, panels, or alternating backgrounds.
- Use fieldsets and legends for groups of radio buttons, checkboxes, and related controls.
- Give the primary action a clear visual relationship to the fields it submits.
- Avoid two-column layouts unless tab order, responsive collapse, and scanning remain obvious.

###### Controls

- Use radio buttons when one option among a small set must be selected and all options should be visible.
- Use checkboxes for independent choices or a single yes/no consent/option.
- Avoid select boxes for small option sets; they hide choices and add interaction cost.
- For long lists, consider autocomplete/combobox with accessible keyboard behavior and clear valid suggestions.
- Make option labels clickable; ensure the input and its label share the same activation target.
- Use mobile-appropriate input types and attributes: `email`, `tel`, `url`, `number` only when numeric behavior is truly appropriate, `autocomplete`, `inputmode`, `autocapitalize`, `spellcheck`, and `aria-describedby` as needed.

###### Required, optional, and deferrable inputs

- Remove optional fields unless they serve a clear user or business purpose.
- Mark the minority case: optional when most are required, required when most are optional.
- Use text over symbols for clarity. If using an asterisk, provide a legend and accessible label.
- Ask for promo codes, account creation, marketing preferences, and profile enrichment only when contextually useful; otherwise defer.

###### Defaults and personalization

- Use defaults to reduce work only when the default is likely correct, reversible, and aligned with user interests.
- Do not default to hidden costs, marketing opt-ins, premium plans, or risky permissions.
- Personalize defaults for returning users when the information is likely stable and easy to change.
- Be careful with country, delivery, and payment defaults: wrong defaults can cause costly errors.

###### Help text

- Use help for unfamiliar terms, sensitive data, privacy/security reassurance, unusual formatting, answer limits, or why a field is needed.
- Place help adjacent to the relevant label/input or in a consistent help area for complex repeated-use forms.
- Avoid long instruction blocks before the form; people often jump directly into fields.
- Do not use help text to compensate for bad labels, wrong controls, arbitrary formats, or unnecessary questions.

###### Validation, errors, and success

- Accept flexible human input where possible, such as varied phone/credit card spacing, then normalize after entry.
- Validate uniqueness, availability, strict formats, and limits at the point they are useful.
- Do not show errors while the user is still typing a normal answer.
- Explain the problem, the location, and the remedy.
- On long forms, provide an error summary and link/focus to each field error.
- Use text, icon/shape, and styling for errors; reserve red/warning icons for errors so they retain meaning.
- After successful submission, confirm what happened and provide the next logical action. Avoid dead-end success screens.

###### Checkout-specific rules

- Keep checkout visually calmer than browsing. Remove unrelated navigation, offers, and links that lead away from completion.
- Preserve cart context: item count, editable order summary, shipping/billing/payment totals, taxes/fees when known, and delivery expectations.
- Ask questions in a sequence people expect: contact/email, delivery/location, delivery method, payment, review/confirm. Adjust when the product context requires another order.
- Defer account creation, password, preferences, and marketing until after purchase whenever possible.
- Make payment/security reassurance specific and verifiable, not generic decoration.
- Keep promo-code entry available but visually secondary unless discounts are central to the business model.
- Ensure the final action communicates consequence: place order, pay, subscribe, submit application, save changes.

##### Accessibility and inclusion requirements

Always check:

- Every field has an accessible name, preferably a visible `<label>` associated with `for`/`id` or a wrapping label.
- Related controls use semantic grouping: `<fieldset>` and `<legend>` for radio/checkbox groups.
- Error and help text are programmatically associated with fields via `aria-describedby` or equivalent.
- Error summaries are focusable, announced, and provide links to invalid fields.
- Focus order follows visual/task order; no keyboard traps; all controls and help triggers work without a mouse.
- Focus states are visible and not removed by CSS.
- The form works at zoom and with larger text; mobile layouts do not hide labels or error messages.
- Color is never the only signal. Add text, icon/shape, and programmatic state.
- Motion, flashing, and automatic changes are minimized; dynamic validation is polite and not disruptive.
- Timeouts provide warning, extension, and no loss of work when possible.
- Copy avoids references that depend only on physical location, color, or visual shape, such as "the green button on the right."
- Test with intended users, including users with disabilities, when the flow is critical.

##### Frontend implementation guidance

Use semantic HTML before adding JavaScript complexity.

```html
<form novalidate>
  <fieldset>
    <legend>Delivery method</legend>
    <label><input type="radio" name="delivery" value="ship"> Ship to address</label>
    <label><input type="radio" name="delivery" value="pickup"> Pick up in store</label>
  </fieldset>

  <label for="email">Email address</label>
  <input id="email" name="email" type="email" autocomplete="email" autocapitalize="none" spellcheck="false" aria-describedby="email-help email-error">
  <p id="email-help">We will send your receipt and delivery updates here.</p>
  <p id="email-error" role="alert" hidden>Enter an email address, like name@example.com.</p>

  <button type="submit">Continue to payment</button>
</form>
```

Implementation rules:

- Do not replace native controls with custom controls unless the custom version preserves keyboard and assistive technology behavior.
- Keep DOM order aligned with the visual order, especially in multi-column layouts.
- Avoid positive `tabindex`; fix DOM order instead. Use `tabindex="-1"` only to programmatically focus summaries or headings.
- Model form state explicitly: value, dirty/touched, client validity, server validity, loading/submitting, success, and recoverable failure.
- For server validation, preserve user-entered values and return field-level errors keyed to stable field names.
- Disable or guard against duplicate submission after click; communicate processing state and keep the label/consequence understandable.
- Do not hide the only submit path because a validation condition is unmet unless the UI also explains the blocker and how to fix it.
- Use `autocomplete` tokens for common checkout fields: name, email, tel, street-address, address-line1, address-level2, postal-code, country, cc-name, cc-number, cc-exp, cc-csc where appropriate.
- Use `inputmode` for numeric-looking text values that should not be number inputs, such as postal codes, phone numbers, and card numbers.
- Format after input when possible rather than rejecting common human formats.
- Component APIs should accept visible label, help text, error text, required/optional text, described-by IDs, and design tokens for spacing/state.

##### Quality checklist

Before finalizing a recommendation, verify:

- The form has a clear user goal and a clear primary action.
- Every field has a reason to exist now.
- Optional fields are removed, deferred, or marked as the minority case.
- The question order matches the user's mental model of the task.
- The layout provides a single readable path to completion.
- The controls match the data type and decision type.
- Labels remain visible and are programmatically associated.
- Help is contextual, concise, and not compensating for poor design.
- Validation timing is humane and field errors are actionable.
- Error and success states are designed, not left to defaults.
- Checkout avoids account walls and unnecessary offramps unless required.
- Keyboard, focus, screen reader, color contrast, zoom, and mobile keyboards are covered.
- The implementation is feasible within the design system and frontend stack.

Use the full checklists in [references/checklists.md](references/checklists.md).

##### Common mistakes to avoid

- Designing from database fields instead of the user's task.
- Asking optional/profile/marketing/account questions before the core task.
- Using placeholders as labels.
- Using select boxes for short lists.
- Marking every field required.
- Using red text for normal labels or help, weakening error meaning.
- Validating while the user is still typing.
- Hiding or disabling submit without an obvious remedy.
- Using progress bars for dynamic or unknown steps.
- Making secondary/destructive actions visually equal to the primary action.
- Adding decorative grouping that interrupts scanning.
- Showing all dependent fields at once and overwhelming the user.
- Ending with a success page that offers no confirmation or next step.

See [references/anti-patterns.md](references/anti-patterns.md) for the full anti-pattern list.

##### How to explain recommendations to the user

Explain in terms of completion, confidence, error prevention, and trust.

Use this pattern:

1. **State the recommendation.** "Use visible top-aligned labels and keep help text under the field."
2. **Tie it to the user's goal.** "This keeps the checkout path easy to scan on mobile and reduces the chance of people losing context while typing."
3. **Mention the tradeoff.** "It uses more vertical space, but the form is short enough that clarity is more valuable than density."
4. **Name the exception.** "For dense expert settings screens, left-aligned labels may be better because users scan labels before editing."
5. **Give implementation detail only when useful.** "Use a real `<label>` and associate help/error text with `aria-describedby`."



---

### information-architecture-navigation
**Description:** "Use when organizing, critiquing, or implementing navigation, labels, taxonomy, hierarchy, search, content grouping, or wayfinding for a digital product."


#### Information Architecture Navigation

##### Purpose

Help an agent make information easier to find, navigate, and understand. Treat information architecture as a product system made from organization, labeling, navigation, search, metadata, content structure, and wayfinding. Optimize for user tasks and comprehension before visual styling.

##### When to use this skill

Use this skill when the user asks you to:

- Critique or redesign navigation, menus, breadcrumbs, tabs, sidebars, search, filters, faceted browsing, category pages, documentation structure, content hubs, settings IA, onboarding flows, product dashboards, or information-dense pages.
- Create an information model, sitemap, taxonomy, label set, navigation model, content grouping, search UX, metadata schema, or IA style guide.
- Improve findability, discoverability, wayfinding, content hierarchy, cross-linking, or search result quality.
- Translate a content inventory or product feature set into a usable structure.
- Implement IA-related frontend components such as nav landmarks, search forms, breadcrumbs, filters, result lists, menus, tabs, and content templates.

##### When not to use this skill

Do not use this skill as the main skill when the user is only asking for:

- Visual styling, brand expression, color, illustration, or motion with no navigation/findability impact.
- Persuasive marketing copy that does not involve content structure or labels.
- Backend search ranking algorithms, database indexing, or IR tuning beyond UX-level requirements.
- Pure content writing unless structure, headings, labels, or navigation are part of the task.

##### Core principles

1. **Design for finding and understanding together.** A structure that helps users locate information should also help them understand what the product contains, where they are, and what they can do next.
2. **Start from users, content, and context.** Do not design from the company org chart alone. Inspect user tasks, actual content, business constraints, platform constraints, governance, and vocabulary.
3. **Support multiple paths when content is multidimensional.** Use hierarchy for stable, mutually exclusive structures; use facets, tags, search zones, and contextual links when users approach the same content from different angles.
4. **Make the invisible IA explicit.** Metadata, controlled vocabularies, aliases, result tuning, redirects, and editorial best bets shape the user experience even when users cannot see them.
5. **Use labels as promises.** Every label should accurately predict the content or action behind it. Prefer familiar user language over internal terms or clever branding.
6. **Give users a sense of place.** Every screen should answer: Where am I? What is here? Where can I go? What just changed? How do I get back?
7. **Treat search as a system, not a box.** Search includes the indexed content, query entry, suggestions, spelling/synonym support, result presentation, ranking/sorting/filtering, no-results recovery, and analytics.
8. **Structure content from the bottom up.** Headings, chunks, metadata, related links, and content templates should help users who enter deep from search, notifications, external links, or social sharing.
9. **Document decisions for reuse.** IA must be maintained. Capture label rules, taxonomy rules, metadata fields, navigation placement rules, and exceptions in a style guide or design-system guidance.
10. **Accessibility is part of findability.** Semantic structure, headings, landmarks, keyboard operation, visible focus, readable labels, and screen-reader names are IA requirements, not polish.

See [references/principle-cards.md](references/principle-cards.md) for each principle as a reusable card.

##### Default recommendations

Use these defaults unless the user's product context makes another choice clearly better.

###### Product goal

Default to organizing around the user's primary tasks and mental model, then reconcile business priorities second.

Override when the product is a regulated, archival, legal, or reference system where formal domain structure is the user expectation.

Ask before overriding: "Is this product primarily task-driven, reference/lookup-driven, commerce-driven, or compliance/archive-driven?"

###### Audience and vocabulary

Default to plain, familiar, user-centered labels. Use internal terminology only when the target audience already uses it.

Override when the audience is expert, regulated, or domain-specific and precision matters more than beginner familiarity.

Ask before overriding: "Who is the primary audience, and what terms do they already use for these concepts?"

###### Navigation model

Default to a small global navigation, local navigation for deep sections, contextual links for related content, and breadcrumbs when hierarchy is deeper than two levels.

Override when the product is a single-purpose app, a flat marketing site, or a workflow where progress navigation matters more than place navigation.

Ask before overriding: "Do users usually browse by category, perform a task step-by-step, search for a known item, or compare/filter many items?"

###### Hierarchy depth

Default to broad-and-shallow enough to expose major choices without overwhelming users. Avoid deep trees unless categories are stable and predictable.

Override when the domain naturally requires hierarchy, such as documentation, file systems, policies, or catalog taxonomies.

Ask before overriding: "Are the categories stable and mutually exclusive, or do items naturally belong in multiple groups?"

###### Content grouping

Default to one dominant organizing principle per view: task, topic, audience, lifecycle, chronology, geography, format, or alphabetic. Do not mix schemes in the same menu unless sections are clearly separated.

Override when a landing page intentionally offers multiple entry modes, such as "By role," "By task," and "By topic."

Ask before overriding: "Which entry mode matters most for this user at this moment?"

###### Labels

Default to concise text labels with nouns for destinations and verbs for actions. Pair icons with text for primary navigation.

Override only when space is severely constrained and icons are universally recognized, tested, and accessible.

Ask before overriding: "Does the product already have validated terminology or a controlled vocabulary I should preserve?"

###### Search

Default to adding search when content is large, dynamic, heterogeneous, or when users often know the thing they want. Provide a simple search box first, with scoped search or filters when content types differ.

Do not add search merely to compensate for poor organization. Fix labels, grouping, and metadata first.

Ask before implementing search-heavy UX: "What content should search cover, and are there content types that should be searched separately?"

###### Facets and filters

Default to facets when users need to narrow many items by stable attributes such as type, topic, date, location, audience, status, price, format, owner, or compatibility.

Override when the set is small, the attribute data is unreliable, or filtering would create empty/meaningless combinations.

Ask before adding facets: "Which attributes do users actually use to decide among results?"

###### Metadata and controlled vocabulary

Default to a lightweight controlled vocabulary for high-value fields, plus aliases/synonyms for common user language.

Override when content is low-volume, short-lived, or manually curated enough that formal vocabulary management would add more overhead than value.

Ask before formalizing vocabulary: "Who will maintain terms, aliases, metadata fields, and deprecated labels after launch?"

###### Responsive and cross-channel behavior

Default to preserving the same conceptual structure across web, mobile, and other channels while adapting presentation and interaction to each device.

Override when channel context changes the user's task, such as quick mobile lookup versus desktop bulk management.

Ask before changing IA across channels: "Do users need the same tasks on every platform, or does each platform support a different job?"

###### Accessibility

Default to WCAG-aware semantic structure, visible focus, keyboard navigation, accessible names, text alternatives for icons, valid heading order, and state announcements for dynamic search/filter changes.

Do not ask whether accessibility matters. Ask only when a legal or internal compliance target must be named.

###### Frontend state

Default to making navigation, search queries, selected filters, sort order, and pagination shareable/restorable in URLs for web products.

Override for privacy-sensitive, ephemeral, or native-only contexts.

Ask before overriding: "Should users be able to share, bookmark, or return to this exact filtered/search state?"

##### Required user questions

Ask only when the answer changes the IA. Recommend a default in the question.

Use a `question` tool or equivalent for these cases:

1. **Goal ambiguity.** If the user has not supplied the product, feature, user task, or content domain.
2. **Audience ambiguity.** If labels or taxonomy depend on specialist versus general-public vocabulary.
3. **Navigation model uncertainty.** If it is unclear whether users browse, search, filter, compare, or complete a sequence.
4. **Content/model uncertainty.** If you need to know content types, metadata, scale, lifecycle, or ownership.
5. **Search scope uncertainty.** If adding or redesigning search and the indexed content is not defined.
6. **Governance uncertainty.** If the recommendation requires ongoing taxonomy, metadata, redirects, or editorial maintenance.
7. **Platform/accessibility constraints.** If the implementation differs substantially across web, native, kiosk, voice, or assistive technology contexts.
8. **Legacy constraints.** If migration, existing URLs, analytics, SEO, or design-system compatibility may constrain the structure.

Do not ask routine questions such as whether labels should be clear, whether the design should be accessible, or whether users should understand navigation. Apply the default.

Use the question-tool-ready prompts in [references/decision-prompts.md](references/decision-prompts.md).

##### Workflow

###### A. Critique existing IA or UI

Inspect in this order:

1. **User goal and entry point.** Identify the user's job, prior context, and likely entry route: homepage, deep link, search result, notification, ad, bookmark, or internal workflow.
2. **Content inventory and content types.** List the main objects, actions, metadata, states, and relationships visible or implied.
3. **Organization scheme.** Determine the dominant grouping principle. Flag mixed, overlapping, or org-chart-driven groupings.
4. **Hierarchy and structure.** Check whether the depth, breadth, sequence, and parent-child relationships match user expectations.
5. **Labels and language.** Evaluate clarity, consistency, specificity, distinctiveness, and vocabulary fit.
6. **Navigation and wayfinding.** Check global, local, contextual, supplemental, and process navigation. Verify that the screen answers "where am I, what is here, where can I go?"
7. **Search and discovery.** Inspect query entry, scope, suggestions, results, filters, sorting, ranking cues, snippets, empty/no-results states, and recovery paths.
8. **Metadata and invisible IA.** Identify missing fields, synonyms, aliases, content ownership, redirects, result tuning, and analytics needs.
9. **Accessibility and keyboard behavior.** Check semantic landmarks, headings, links/buttons, focus order, menu behavior, ARIA names, and dynamic announcements.
10. **Frontend feasibility.** Check URL/state persistence, component reuse, responsive behavior, performance, localization, and design-system fit.
11. **Prioritize fixes.** Separate blocking findability problems from polish. Recommend the smallest structural change that solves the user's task.

Output critiques as: finding → evidence → impact → recommendation → implementation note.

###### B. Create or redesign an IA

Proceed in this order:

1. **Clarify the product problem.** Identify primary users, top tasks, content scope, business goals, platform, constraints, and success signals.
2. **Choose the simplest useful structure.** Prefer a clear hierarchy for simple/stable domains; add facets/search/contextual links only where content scale or user behavior requires it.
3. **Define content objects.** Name each object type, required fields, optional metadata, states, owners, and relationships.
4. **Pick organization schemes.** Choose task/topic/audience/etc. per view. Avoid mixing schemes unless you create distinct entry sections.
5. **Draft hierarchy and navigation.** Produce primary nav, local nav, breadcrumbs/process steps, contextual links, and supplemental aids.
6. **Draft labels.** Use user vocabulary, consistent grammatical patterns, and distinct labels. Include aliases for common alternate terms.
7. **Design search/discovery.** Define searchable content, zones, query support, filters/facets, result snippets, sort order, and empty states.
8. **Design bottom-up structure.** Add page templates, headings, related links, metadata, "next best" links, and content chunks for deep-entry users.
9. **Validate against scenarios.** Walk through at least three tasks: known-item lookup, exploratory browsing, and recovery from a wrong turn/no result.
10. **Specify frontend behavior.** Define semantic markup, URL state, keyboard behavior, focus management, loading/error/empty states, and analytics events.
11. **Document governance.** Note who maintains labels, taxonomy, metadata, redirects, and search tuning.

Output design recommendations as a structured IA proposal, not a decorative layout.

##### Decision framework

###### Choose hierarchy when

- Content has clear parent-child relationships.
- Users expect a table-of-contents, policy, documentation, file, or catalog structure.
- Items mostly belong in one place.
- The path itself helps users understand the domain.

###### Choose facets when

- Items can be described along multiple independent dimensions.
- Users compare, narrow, and combine attributes.
- Content volume is high enough that flat lists are unhelpful.
- Metadata quality can be maintained.

###### Choose search when

- Users often know the name, ID, keyword, location, or attribute of the target.
- Content changes too quickly for manual navigation alone.
- The content set is too large or heterogeneous for browsing alone.
- Search logs can be used to improve labels, synonyms, and result tuning.

###### Choose contextual navigation when

- Users enter deep pages from search or external links.
- Related content is more useful than a full hierarchy.
- A workflow needs "next step," "related," "also applies to," or "learn more" links.
- Content models can reliably express relationships.

###### Choose supplemental navigation when

- Users need overview, alternative access, or recovery tools.
- The system has long-tail content or multiple audiences.
- A-Z indexes, sitemaps, guides, glossaries, onboarding tours, or wizards reduce cognitive load.

##### Practical rules

- Each navigation region needs a clear purpose. Do not duplicate the same links in multiple regions unless repetition helps orientation or task completion.
- Do not expose all taxonomy levels at once. Reveal depth progressively.
- Keep sibling labels parallel in grammar and granularity.
- Use category labels that describe the group, not marketing priorities.
- Avoid "Resources," "Solutions," "Learn," and "More" unless the contained items are genuinely coherent and users can predict what belongs there.
- Place high-frequency, high-value tasks in visible navigation; do not hide them behind search, footers, or catch-all menus.
- Use breadcrumbs for location in hierarchy, not as a record of the user's click history.
- Use tabs for peer views of the same object, not for unrelated destinations.
- Use filters to narrow a result set, not as primary navigation across unrelated sections.
- Provide result counts and active filter summaries when filtering.
- Always provide a recovery path for empty states and no-results states.
- Use analytics as evidence, not as the only source of truth. Pair search logs and click data with user research or task analysis.
- Document deprecated labels and redirects during migrations.

##### Accessibility and inclusion requirements

- Use semantic landmarks: `header`, `nav`, `main`, `aside`, `footer`, and descriptive `aria-label` values when multiple nav regions exist.
- Use a logical heading hierarchy that reflects the content structure, not just visual size.
- Use real links for navigation and real buttons for actions.
- Provide visible focus states and predictable keyboard order.
- Menus, comboboxes, tabs, accordions, and disclosure navigation must follow expected keyboard patterns.
- Do not rely on icon-only navigation for primary tasks unless accessible text labels are present and the icon meaning is validated.
- Make search inputs programmatically labeled. Use `type="search"` when appropriate.
- Announce dynamic result updates, filter changes, loading, and errors with appropriate live regions when the page does not reload.
- Ensure labels and instructions do not rely only on color, position, or shape.
- Maintain readable target sizes and spacing across touch devices.
- Support localization: avoid labels that break when translated, and expect category order, alphabetical indexes, and sort logic to vary by locale.

##### Frontend implementation guidance

###### Semantic structure

- Primary navigation: `<nav aria-label="Primary">` containing lists of links.
- Breadcrumbs: `<nav aria-label="Breadcrumb"><ol>...` with the current page identified by `aria-current="page"`.
- Search: `<form role="search">` or a labeled search form, with a visible label or accessible name.
- Results: use headings, list semantics, result titles as links, meaningful snippets, metadata, and source/type indicators.
- Filters/facets: use fieldsets/legends for groups, checkboxes for multi-select facets, radios for exclusive options, and buttons/links for applying/removing filters depending on behavior.
- Pagination: use navigation landmarks and `aria-current` for current page.

###### Responsive behavior

- Preserve conceptual navigation across breakpoints.
- Do not hide essential primary tasks in a mobile drawer without an equivalent visible path.
- For complex side navigation, collapse sections while preserving current location and search/filter access.
- Keep filter state visible or easily resumable on mobile.

###### State and URLs

- Encode search query, selected facets, sort, pagination, and active category in the URL for shareable web states unless privacy or security prevents it.
- Use canonical URLs and redirects during IA migrations.
- Keep route names and slugs stable, readable, and aligned with labels where possible.

###### Componentization

Create reusable components for:

- Primary navigation
- Section/local navigation
- Breadcrumbs
- Tabs for object subviews
- Search form
- Suggestions/autocomplete
- Result list/card
- Facet/filter group
- Active filter chips
- Empty/no-results states
- Related-content modules
- Content templates with metadata slots

###### Performance and maintainability

- Do not render huge navigation trees or facet lists unbounded; virtualize, paginate, group, or search within long lists.
- Lazy-load secondary navigation only if the current location remains clear.
- Cache taxonomy and vocabulary data carefully, with invalidation for editorial updates.
- Instrument search queries, no-results queries, filter usage, top exits, and navigation dead ends.

##### Quality checklist

Before finalizing an IA recommendation, verify:

- The structure supports at least one known-item task, one exploratory task, and one recovery task.
- Primary navigation represents user priorities, not only internal departments.
- Labels are distinct, predictable, and consistent.
- Content can be found by more than one path when user mental models differ.
- Deep-entry users can orient themselves without visiting the homepage.
- Search has defined scope, indexed fields, result presentation, and no-results recovery.
- Facets use reliable metadata and do not produce many meaningless empty states.
- Accessibility semantics and keyboard behavior are specified.
- Frontend state, URLs, responsive behavior, and design-system reuse are addressed.
- Maintenance responsibilities are explicit.

Use the full checklists in [references/checklists.md](references/checklists.md).

##### Common mistakes to avoid

- Designing a sitemap before understanding user tasks and content types.
- Treating the homepage or main menu as the whole IA.
- Copying the organization chart into navigation.
- Using brand slogans or internal project names as labels.
- Adding search as a substitute for fixing taxonomy and labels.
- Exposing advanced search controls before users need them.
- Creating too many top-level items or too many hierarchy levels.
- Mixing topic, audience, task, format, and lifecycle labels in the same undifferentiated menu.
- Relying on hover-only menus.
- Failing to design no-results and empty states.
- Forgetting redirects, aliases, and deprecated terms during migrations.
- Ignoring bottom-up IA inside content templates.

See [references/anti-patterns.md](references/anti-patterns.md) for the full anti-pattern list.
- Creating a taxonomy without governance.

##### How to explain recommendations to the user

Explain IA recommendations in task-centered language:

- Start with the user problem: "Users need to compare plans by price and feature without knowing internal product families."
- Name the structural choice: "Use a task-first primary nav and faceted comparison on the listing page."
- State why it helps: "This supports both browsing and narrowing without forcing one category path."
- Mention tradeoffs: "This requires reliable metadata for plan type, audience, and feature set."
- Give the implementation implication: "Persist selected filters in the URL and expose them as accessible checkbox groups."
- Identify validation: "Test with known-item lookup, exploratory browsing, and no-results recovery."

Avoid saying "this is best practice" without tying it to the user's task, content, and constraints.



---

### interaction-patterns-components
**Description:** "Use when choosing, critiquing, or designing UI interaction patterns and reusable components for web, mobile, SaaS, dashboards, or design systems."


#### Interaction Patterns Components

##### Purpose

Help an agent choose, critique, and design effective UI interaction patterns and reusable product components.

The skill covers navigation patterns, menus, cards, tables, dashboards, modals, flows, states, and component behavior. It treats visual polish only where it affects interaction clarity, hierarchy, accessibility, or component usability.

##### When to use this skill

Use this skill when the user asks for any of the following:

- Critique, redesign, or UX review of an app screen, website, product flow, wireframe, component, or frontend implementation.
- Selection of UI patterns such as navigation, menus, breadcrumbs, dashboards, cards, tables, forms, modals, wizards, split panes, tabs, accordions, toolbars, hover tools, lists, grids, or feedback states.
- Design of reusable components or design-system behavior.
- Frontend guidance for interaction behavior, accessibility, responsive behavior, component APIs, or UI state handling.
- Creation of product UX recommendations where the best answer depends on tasks, user skill, device context, data complexity, or risk.

##### When not to use this skill

Do not use this skill as the main framework when the user primarily needs:

- Brand identity, illustration, mood boards, or visual polish not tied to interaction clarity.
- Deep copywriting, messaging strategy, or content design beyond labels, help text, errors, and microcopy.
- Pure graphic design, logo design, or marketing creative.
- Native voice, AR/VR, spatial, or non-screen interaction design unless the task also includes screen-based controls or companion UI.
- Backend architecture, database design, or API design except where implementation constraints affect component behavior.

##### Core principles

###### 1. Start with people, goals, and context

Identify what the user is trying to accomplish before choosing a component. A form, menu, table, modal, or dashboard is only a means to a user goal. Ask “why” until the job, risk, and success criteria are clear enough to design the simplest useful interface.

Default: infer the user goal from the feature and proceed. Ask only when the missing context changes the pattern choice, such as expert vs novice users, mobile vs desktop, or high-risk vs low-risk actions.

###### 2. Treat interaction as a conversation

Every UI should respond as if it is a considerate partner: it listens, acknowledges input, shows progress, prevents confusion, and makes the next step clear. Encode this into components through visible states, feedback, labels, focus behavior, and recovery paths.

Default: every interactive component must define at least default, hover/pressed where applicable, focus, loading, disabled, success, empty, and error states.

###### 3. Choose the simplest pattern that preserves context

Prefer patterns that keep the user oriented and reduce unnecessary navigation. Keep tools close to the object they affect, but do not hide critical actions behind hover-only affordances or ambiguous icons.

Default: use in-place editing, contextual tools, inline validation, and same-page previews when they reduce context switching and remain discoverable.

###### 4. Preserve wayfinding

Users need to know where they are, where they can go, what changed, and how to recover. Navigation is not just chrome; it includes signposts, hierarchy, breadcrumbs, progress indicators, deep links, escape hatches, and stable screen regions.

Default: provide a stable primary navigation model, a clear page title, visible current location, and a reversible route back to the previous or parent context.

###### 5. Let information structure drive layout

Layout should reflect task structure, not decoration. Use grouping, proximity, alignment, visual hierarchy, progressive disclosure, and screen regions to show relationships and priorities.

Default: use a single clear primary action per task area; group related controls; make the most important content or object the center of attention.

###### 6. Match the pattern to the data and task

A table, card grid, list, dashboard, feed, wizard, or detail page is correct only when it fits what users compare, scan, select, create, monitor, or edit.

Default: for structured, comparable, sortable data, use a table or dense list. For heterogeneous, visually recognizable items, use cards or thumbnails. For stepwise unfamiliar tasks, use a wizard. For expert repeated work, use a denser workspace with shortcuts and visible tools.

###### 7. Make actions safe

Support safe exploration through preview, undo, cancel, clear labels, confirmation only for consequential actions, and strong recovery. Avoid blocking confirmations for routine reversible actions.

Default: prefer undo over confirmation when the action is reversible. Use a confirmation or buffer step only for destructive, costly, irreversible, privacy-sensitive, financial, or broadly propagating actions.

###### 8. Design for interruption, re-entry, and repetition

Users change direction, pause, resume, repeat actions, and rely on memory. Keep state stable, avoid rearranging controls unexpectedly, remember safe progress, and bring forward recent/repeated actions when helpful.

Default: preserve unsaved work where possible, retain filters and scroll position after detail views, and do not move controls after users begin a task.

###### 9. Make forms short, purposeful, and forgiving

Ask only for information needed now. Use labels, hints, appropriate input types, smart defaults, validation, examples, and error recovery. Do not rely on placeholder text as the only label or instruction.

Default: use visible labels, one-column flow for most forms, inline errors tied to fields, forgiving formats where possible, and smart prefills only when confidence is high and users can edit them.

###### 10. Build patterns as reusable systems

Do not create one-off components unless the context demands it. Define component responsibilities, variants, states, accessibility behavior, responsive behavior, content rules, and escape hatches.

Default: start from the existing design system or common UI framework, then extend intentionally. Treat libraries as a floor, not a ceiling.

See [references/principle-cards.md](references/principle-cards.md) for each principle as a reusable card.

##### Default recommendations

Use these defaults unless the user’s context justifies an override.

| Area | Default recommendation | Why it is usually best | Override when |
|---|---|---|---|
| Product goal | Optimize for the user’s task completion, not feature exposure. | Users use UI as a means to an end. | The screen is primarily exploratory, educational, or promotional. |
| Audience | Design for capable but busy users with mixed expertise. | Most products serve beginners and repeat users simultaneously. | The product is explicitly expert-only, kiosk-like, or one-time use. |
| Platform | Start responsive/mobile-aware, then enhance for larger screens. | Small screens force prioritization and reusable content units. | The tool is a dense desktop-only professional workspace. |
| Navigation | Use stable global navigation plus local signposts. | Predictability lowers cognitive load. | The product is a single-task flow or immersive canvas. |
| Information density | Use moderate density with progressive disclosure. | It supports scanning without overwhelming. | Expert workflows require dense data and keyboard efficiency. |
| Screen structure | Choose one dominant screen type: overview, focus, make, or do. | Clear organizing principles make screens learnable. | A dashboard/workbench genuinely requires multiple regions. |
| Lists | Use a list/table for comparison; cards for rich or visual items. | Pattern follows the user’s scanning task. | Items have unusual content or selection behavior. |
| Primary action | One visually dominant primary action per task region. | Prevents split attention and supports next-step clarity. | Multiple actions are truly equal and frequent. |
| Modals | Avoid modals for complex workflows; use them for focused, interruptive, bounded tasks. | Modals interrupt context and complicate navigation/focus. | A lightweight overlay preserves context better than page navigation. |
| Wizards | Use only for unfamiliar, ordered, multi-step tasks. | They reduce cognitive burden for sequential setup. | Expert users need nonlinear editing or comparison. |
| Dashboards | Show actionable monitoring, not decorative metrics. | Dashboards should support decisions and triage. | The dashboard is explicitly for ambient awareness. |
| Forms | Minimize fields, label everything, group sections, validate inline. | Reduces effort and prevents errors. | Legal, compliance, or operational requirements force extra fields. |
| Defaults | Prefill only when likely correct and easy to change. | Smart defaults reduce effort without removing control. | Incorrect defaults would be costly or misleading. |
| Error handling | Prevent errors first, then explain and recover. | Error recovery is part of the interaction. | Real-time prevention would interrupt expert flow. |
| Motion | Use transitions to preserve orientation, not to decorate. | Motion can show cause, continuity, and change. | User has reduced-motion preference or motion adds delay. |
| Accessibility | Treat keyboard, focus, labels, contrast, and screen-reader semantics as baseline. | Accessibility is interaction quality. | Never override; only adapt implementation. |
| Design system | Reuse existing components and document variants/states. | Reduces inconsistency and UX debt. | Existing components are inaccessible or do not fit the task. |

##### Required user questions

Ask a focused question only when the answer changes the pattern choice or risk model. Do not ask routine best-practice questions.

Ask when any of these are unknown and materially relevant:

1. **Primary task and success outcome**: when multiple goals compete.
2. **Audience skill level and frequency**: when choosing between guided flow and expert workspace.
3. **Platform/device context**: when mobile, touch, desktop density, keyboard use, or responsive behavior matters.
4. **Data shape and scale**: when choosing list, table, card grid, dashboard, feed, filter, pagination, or visualization.
5. **Action risk/reversibility**: when choosing undo, confirmation, preview, or buffer step.
6. **Navigation depth and information architecture**: when choosing flat, hub-and-spoke, tree, pyramid, wizard, or workspace model.
7. **Design-system/frontend constraints**: when the user needs implementation-ready guidance.
8. **Accessibility or compliance constraints**: when domain-specific requirements may exceed baseline accessibility.

Use this pattern:

```js
question({
  question: "What is the primary task users must complete on this screen?",
  recommended_default: "Optimize for the most frequent task and make secondary actions available but less prominent.",
  options: [
    "Find or browse items",
    "Compare and select items",
    "Create or edit something",
    "Monitor status or metrics",
    "Complete a step-by-step process",
    "Other / custom"
  ]
})
```

Use the question-tool-ready prompts in [references/decision-prompts.md](references/decision-prompts.md) for the full decision set.

##### Workflow

###### A. Critiquing existing UI

Inspect in this order:

1. **User goal and task fit**  
   Identify what the screen is trying to help users accomplish. Flag controls, copy, or screens that serve the product before the user.

2. **Information architecture and screen type**  
   Determine whether the screen is an overview, focus, make, do, dashboard, flow, or workspace. Check whether the pattern matches the task.

3. **Wayfinding and navigation**  
   Check location cues, entry points, exit paths, breadcrumbs, progress indicators, deep links, and whether the user can recover from dead ends.

4. **Hierarchy, grouping, and layout**  
   Check whether the main object/action is obvious; related elements are grouped; visual weight matches priority; and progressive disclosure is used appropriately.

5. **Interaction clarity and component behavior**  
   Inspect affordances, labels, action placement, feedback, state changes, hover/touch behavior, keyboard behavior, loading, empty, and error states.

6. **Safety and recovery**  
   Check undo, cancel, preview, confirmation, error prevention, and resilience to interrupted workflows.

7. **Forms and input behavior**  
   Check labels, required/optional indicators, input types, hints, defaults, validation, and error wording.

8. **Data display and scanning**  
   Check whether tables, cards, dashboards, filters, sorting, datatips, and visualizations support comparison and decision-making.

9. **Accessibility and inclusion**  
   Check keyboard use, focus order, semantics, labels, contrast, reduced motion, target size, non-color cues, and screen-reader behavior.

10. **Frontend feasibility and design-system fit**  
   Check component reuse, responsive layout, tokenization, state complexity, performance, and maintainability.

Return critique in this format:

```markdown
##### Overall diagnosis
[1-3 sentence summary]

##### Highest-impact fixes
1. [Fix] — [why it matters] — [pattern/component recommendation]
2. ...

##### Component-level notes
- [Component]: [issue] → [recommended behavior]

##### Accessibility and implementation notes
- [Specific requirement or constraint]

##### Tradeoffs
- [When another pattern might be better]
```

###### B. Creating or improving a design

Proceed in this order:

1. Clarify the user problem and success outcome.
2. Identify audience skill, platform, data scale, and action risk only if needed.
3. Choose the screen type: overview, focus, make, do, dashboard, flow, or workspace.
4. Choose the navigation model and wayfinding cues.
5. Establish layout hierarchy and grouping.
6. Select components and define their responsibilities.
7. Define behavior: interactions, feedback, states, validation, transitions, keyboard/focus, and recovery.
8. Define responsive behavior and design-system variants.
9. Run the quality checklist.
10. Explain recommendations as user-task benefits, not as style preferences.

Return new recommendations in this format:

```markdown
##### Recommended pattern
[Pattern and why it fits]

##### Structure
[Regions, navigation, hierarchy]

##### Component behavior
[States, actions, feedback, validation]

##### Accessibility and frontend notes
[Semantics, keyboard, responsive, state management]

##### Alternatives considered
[Why not the likely alternatives]
```

##### Decision framework

Use these pattern choices as starting points:

###### Screen and flow patterns

- **Overview screen**: Use for lists, grids, search results, feeds, dashboards, or collections where users choose what to inspect next.
- **Focus screen**: Use when one object, media item, record, canvas, or map is the center of attention.
- **Make workspace**: Use when users create or manipulate content; use toolbars, palettes, inspectors, and direct manipulation carefully.
- **Do screen**: Use for one bounded task such as payment, booking, import, export, setup, or confirmation.
- **Wizard**: Use for unfamiliar, ordered steps with dependencies. Avoid for expert repeated tasks.
- **Dashboard**: Use for monitoring, triage, and decision-making. Avoid as a decorative metric collage.
- **Modal/overlay**: Use for bounded tasks that must interrupt or preserve the underlying page context. Avoid for deep flows, large forms, or content users need to compare with the page behind it.
- **Many workspaces / split view**: Use for expert or high-context tasks that require comparing and editing multiple objects.
- **Settings editor**: Use for persistent preferences and configuration; group by mental model, not implementation model.

###### Navigation patterns

- **Flat navigation**: Use for a small set of peer destinations.
- **Hub-and-spoke**: Use when users return to a central place between tasks.
- **Tree / multilevel**: Use for large hierarchical information spaces.
- **Pyramid**: Use when top-level exploration leads to more specific pages while retaining routes across branches.
- **Step-by-step**: Use for ordered flows.
- **Fat menu / menu page**: Use when users need overview and direct access to many destinations.
- **Breadcrumbs**: Use for deep hierarchy, not as the only primary navigation.
- **Progress indicator**: Use when users need orientation in a multistep process.
- **Escape hatch**: Always provide a safe exit from modal, wizard, or deep navigation contexts.

###### List and content patterns

- **Table**: Use for structured data where users compare rows by attributes, sort, filter, scan exact values, or perform bulk actions.
- **Dense list**: Use for text-heavy items or inbox-like triage.
- **Cards**: Use for items with image/title/summary/actions where each item is a self-contained object.
- **Thumbnail grid**: Use for visually recognizable items where scanning by image matters.
- **Carousel**: Use sparingly for small, optional, visually rich sets; do not hide essential choices in a carousel.
- **Pagination**: Use when position, finite sets, SEO, or performance matter.
- **Infinite list**: Use for feeds/exploration where exact position is less important; preserve loading and return position.
- **Two-panel selector / split view**: Use when users browse a list and inspect details without losing list context.
- **List inlay**: Use to show detail without full navigation when detail is short and related.

###### Actions and commands

- Put frequent actions close to the object they affect.
- Keep destructive and high-risk actions visually and spatially distinct from routine actions.
- Use button groups for small related action sets; avoid mixing unrelated priorities.
- Use smart menu labels that name the affected object or operation.
- Provide preview for changes with uncertain outcomes.
- Provide cancelability for long-running operations.
- Provide undo/history for reversible actions and exploration.
- Use macros or saved actions only for repeated expert tasks.

###### Forms and controls

- Prefer the input method that matches the data: select/radio for finite choices, checkbox for multiple choices, slider for approximate ranges, stepper for small numeric increments, text field for open text, autocomplete for large known sets.
- Use forgiving formats for known structured strings when the system can parse them safely.
- Use structured formats when precision, error prevention, or compliance is more important than flexibility.
- Provide hints adjacent to the relevant field.
- Keep placeholders supplemental; visible labels must remain.
- Use dynamic validation without punishing users mid-typing.
- Use smart defaults and prefills when likely correct, visible, and editable.

###### Feedback and microinteractions

- Show the result of direct manipulation immediately.
- Show progress for operations that take noticeable time.
- Use notifications only when they are timely, relevant, and actionable.
- Visualize quantitative status when it helps compare, predict, or act.
- Keep notification actions minimal and direct.
- Use transitions to show continuity, not to slow the task.
- Respect reduced-motion settings.

##### Practical rules

1. Never recommend a component without stating what user task it serves.
2. Prefer removing a step over making the step prettier.
3. Do not hide the primary action in a menu, hover-only control, or ambiguous icon.
4. Do not use a modal when the user must compare, reference, or navigate behind it.
5. Do not use a wizard when users need nonlinear editing or expert speed.
6. Do not use cards for data that users need to sort, compare, or bulk-edit by multiple attributes.
7. Do not use a table for visually rich browsing when image recognition is the primary behavior.
8. Do not rely on color alone to communicate status or selection.
9. Do not rearrange controls after the user has learned their location unless the benefit is large and tested.
10. Do not use placeholder text as a substitute for labels.
11. Do not block reversible actions with confirmations; provide undo.
12. Do not auto-advance, auto-submit, or auto-delete without clear feedback and recovery.
13. Do not expose every possible action at once; reveal advanced actions where context makes them relevant.
14. Do not make keyboard shortcuts the only way to complete a task.
15. Do not treat a component library as a complete UX solution; define task-specific behavior and states.

##### Accessibility and inclusion requirements

Baseline requirements for every recommendation:

- Use semantic HTML or platform-native semantics first.
- Provide visible labels for inputs and accessible names for controls.
- Ensure keyboard access to all interactive elements.
- Define logical focus order and visible focus states.
- Trap focus only inside true modals; restore focus to the trigger after closing.
- Use appropriate ARIA only when native semantics are insufficient.
- Make error messages programmatically associated with fields.
- Do not rely on hover-only interactions; provide click/tap/keyboard alternatives.
- Do not rely on color alone; pair color with text, icon, shape, or position.
- Respect reduced-motion preferences.
- Use target sizes appropriate for touch when designing mobile or touch interfaces.
- Ensure loading, empty, success, and error states are announced where necessary.
- Make disabled controls understandable; when possible, explain why an action is unavailable.
- Avoid interaction patterns that require advanced desktop conventions unless the target audience is known to use them.

##### Frontend implementation guidance

When the output includes implementation guidance, specify:

###### Component anatomy

Define subparts: root, label, trigger, content, item, action, helper text, error text, icon, badge, overlay, backdrop, footer, and any slots.

###### States

For each component, define:

- Default
- Hover, pressed, selected, expanded, collapsed where applicable
- Focus-visible
- Disabled and read-only
- Loading and skeleton
- Empty
- Success
- Warning
- Error
- Offline or stale data, if relevant
- Reduced-motion alternative

###### Semantic structure

Prefer native elements:

- `button` for actions, not clickable `div`.
- `a` for navigation.
- `label` associated with inputs.
- `table`, `thead`, `tbody`, `th`, `td` for true tabular data.
- `dialog` or accessible modal pattern for true modals.
- Lists (`ul`, `ol`) for list structures.
- Landmarks (`nav`, `main`, `aside`, `header`, `footer`) for page regions.

###### Keyboard behavior

Specify keyboard behavior for menus, dialogs, tabs, accordions, tables, grids, autocompletes, and draggable interactions. Provide a non-drag fallback for drag-and-drop actions.

###### Responsive behavior

Define how the component adapts:

- Stack or collapse secondary regions.
- Preserve primary task and action.
- Avoid hiding required navigation with no discoverable substitute.
- Keep touch targets large enough.
- Preserve state across viewport changes.

###### Design-system integration

- Reuse existing tokens for spacing, color, typography, elevation, radius, and motion.
- Create variants only for meaningful behavioral or semantic differences.
- Avoid one-off styling overrides that change component meaning.
- Document content limits, truncation, wrapping, and long/empty values.
- Document when a component should not be used.

###### Performance and maintainability

- Use virtualization only when needed and when accessibility/position recovery are handled.
- Avoid infinite loading without a way to recover position or reach footer content.
- Avoid excessive animations and layout shifts.
- Keep expensive data visualizations and dashboards progressively loaded.
- Make loading states useful: show stable regions first and prioritize readable content.

##### Quality checklist

Before finalizing a recommendation, verify:

- The user task is explicit.
- The recommended pattern fits the task, data shape, user skill, platform, and risk.
- The primary action is clear and not competing with equal-weight actions.
- Navigation and escape routes are visible.
- State changes have immediate, understandable feedback.
- Empty, loading, error, success, and disabled states are defined.
- Destructive or costly actions have appropriate prevention or recovery.
- Forms minimize input, show labels, provide hints, validate helpfully, and recover gracefully.
- Components are keyboard accessible and screen-reader understandable.
- Responsive behavior preserves the primary task.
- The recommendation can be implemented with reusable components and tokens.
- Tradeoffs and alternatives are explained.

Use the full checklists in [references/checklists.md](references/checklists.md).

##### Common mistakes to avoid

- Designing from component preference instead of user task.
- Treating the home page or dashboard as a catch-all.
- Overusing modals for complex tasks.
- Hiding important actions behind hover-only tools.
- Making every action visually primary.
- Choosing cards when users need comparison.
- Choosing tables when users need visual browsing.
- Using a wizard for expert workflows.
- Using confirmation dialogs for routine reversible actions.
- Using clever icons without labels for unfamiliar actions.
- Using skeletons/spinners without preserving layout or showing progress.
- Forgetting keyboard and focus behavior.
- Creating one-off components that bypass the design system.
- Optimizing for novelty at the expense of familiar interaction.

See [references/anti-patterns.md](references/anti-patterns.md) for the full anti-pattern list.

##### How to explain recommendations to the user

Explain in terms of:

1. **User task**: “Users need to compare rows by status and date, so a table is stronger than cards.”
2. **Cognitive load**: “This keeps the next step visible and avoids making users remember what they selected.”
3. **Context preservation**: “A split view keeps the list visible while details change.”
4. **Safety**: “Undo is better than a confirmation here because the action is reversible and frequent.”
5. **Accessibility**: “The action must be reachable by keyboard and not depend on hover.”
6. **Implementation**: “This can reuse the existing table component with added empty/error/loading states.”

Avoid saying “it looks better” unless the visual change directly improves hierarchy, readability, affordance, or accessibility.



---

