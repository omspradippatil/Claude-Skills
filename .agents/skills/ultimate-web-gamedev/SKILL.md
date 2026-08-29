---
name: ultimate-web-gamedev
description: Consolidated ultimate skill containing expert knowledge for web gamedev. Use this for all tasks in this domain.
---

# Ultimate Web Gamedev

> **Agent Instruction:** This is a consolidated expert skill. Read the catalog below and apply the specific rules that match the user's request. Do not mix conflicting styles or rules.

## Skill Catalog

### author-game-levels
**Description:** Author or revise readable, flat-world Three.js game levels. Use for movement and camera routes, collision and navigation, encounter zones, landmarks, objectives, pickups, motivated lighting, visibility, deterministic level data, or desktop and mobile playthrough verification.


#### Author Game Levels

Treat architecture as gameplay communication. Every route, arena, gate, prop, and light must help the player read movement, threats, objectives, or state.

##### Enforce one gameplay plane

Keep all collision, navigation, encounter routes, objectives, pickups, and player movement on one accessible plane.

- Do not add stairs, ramps, raised platforms, drop-offs, cliffs, bridges, ledges, pits, or vertical traversal.
- Do not change gameplay elevation for shortcuts, arenas, hazards, rewards, or visual variety.
- If visual height is requested later, keep it non-walkable background dressing. It must not alter navigation, camera occlusion, threat visibility, targetability, or player movement.

##### Separate level systems

Maintain explicit, independently testable layers for:

- authored level data and stable zone/anchor IDs;
- visual geometry and non-walkable background dressing;
- simplified collision geometry;
- flat navigation data and movement clearance;
- encounter, enemy, gate, reset, pickup, objective, and exit zones.

Share stable IDs and transforms between layers, but never infer collision, navigation, or encounter boundaries from decoration alone.

##### Lay out readable play

1. Define the architectural purpose of each space: traversal, orientation, combat, recovery, reward, transition, or objective.
2. Preserve clear movement, camera, and dodge corridors at the intended play distance.
3. Keep threats, pickups, exits, gates, and interaction targets visible before commitment.
4. Telegraph encounters through visible arena shape, approach, state change, and stable zone anchors.
5. Deliberately place arenas, gates, checkpoints, retry spawns, and reset paths. Prevent soft locks, duplicate rewards, hidden re-entry, and enemies pursuing through unrelated zones.
6. Use landmarks, lighting, contrast, and composition to guide without hiding hazards or making the route ambiguous.

##### Motivate every local light

Attach every local torch, lantern, brazier, or similar light spatially to a visible emitter. Its position, range, color, intensity, shadowing, and occlusion behavior must match what that emitter appears able to produce.

- Forbid unexplained floating local lights.
- Keep a source-to-light inventory with emitter ID, light ID, attachment transform, type, range, color/intensity, occlusion intent, enabled state, and fallback behavior.
- Move the light with a moving emitter. Disable or remove its local contribution when the emitter is disabled, hidden, destroyed, or unloaded.
- Document ambient or world lighting separately. Use it for deliberate global visibility or mood, never to fake a torch or other local source.

##### Validate data and geometry

- Assert that all walkable collision, navigation vertices/links, encounter anchors, gates, objectives, pickups, exits, and reset points remain on the configured gameplay plane within a small tolerance.
- Reject walkable slopes, out-of-plane links, vertical shortcuts, elevated spawn points, and level data that implies height-changing traversal.
- Check collision/nav agreement, route clearance, zone containment, deterministic gate/reset behavior, stable anchor references, and persistence of level progress.
- Validate source-to-light inventory completeness, emitter/light attachment, range/color intent, and moving or disabled emitter state transitions.

##### Prove traversal in the browser

Run deterministic route, collision, navigation, encounter, reset, and lighting fixtures, then traverse every critical and optional route in the repository-approved browser.

- On desktop and mobile, verify uninterrupted flat movement, dodge clearance, camera framing, threat/pickup/exit visibility, encounter telegraphs, gates, retry paths, and touch controls.
- Exercise moving and disabled emitter cases and confirm no light remains detached or unexplained.
- Inspect dense views for occlusion, console health, frame time, draw calls, memory stability, and long-session lighting cost.
- Report new failures separately from existing baseline issues.


---

### design-action-combat
**Description:** Design, implement, tune, or test readable tactical action combat for web games. Use for attack timing, guard and dodge windows, hit contact, posture, lock-on, weapons, boss phases, combat feedback, and deterministic combat tests.


#### Design Action Combat

Treat combat as explicit state machines with visible, testable timing rather than animation-driven guesses.

##### Specify every combat verb

For each player or enemy action, define: startup, active window, recovery, cancellation rules, resource cost, contact shape, damage/posture outcome, cooldown, and feedback. Make telegraph, danger, contact, and recovery readable at normal camera distance.

##### Use authoritative outcomes

- Drive hits, blocks, parries, and interrupts from authoritative collision/contact events.
- Require direction, range, phase, and state validity before resolving an outcome.
- Apply each contact once using stable action and target identifiers.
- Keep visuals downstream of resolved simulation events.

##### Tune for decisions

Give each defense a distinct purpose: spacing, dodge, timed guard, interruption, or resource trade. Avoid unpunishable attacks, recovery loops, unavoidable damage, and dominant spam. Boss phases must alter decision pressure without invalidating learned timing.

##### Test combat deterministically

Cover early/late timing, wrong direction, out-of-range contact, multiple targets, interrupted actions, phase changes, cooldown boundaries, pause/frame step, equip swaps, and repeated inputs. Use seeded or queryable review scenarios instead of requiring long campaign playthroughs.

##### Verify in play

Test at realistic frame rate and camera distance. Confirm that player intent, contact feedback, health/posture changes, sound/VFX, and target state agree. Check reduced motion and input alternatives before release.


---

### design-game-encounters
**Description:** Design, implement, tune, or test Three.js action-game encounters. Use for arena layout, enemy composition, spawn pacing, objectives, boss phases, reward cadence, encounter fixtures, and difficulty validation.


#### Design Game Encounters

Design encounters as decisions, not actor counts.

##### Compose

Define objective, available space, enemy roles, spawn timing, hazards, player resources, exits, failure recovery, and reward. Add one pressure source at a time; require each archetype to create a distinct response.

##### Keep it fair

Protect readable paths, telegraphs, camera sight lines, and recovery windows. Cap simultaneous committed attackers and avoid offscreen damage, unavoidable chains, or encounter resets that duplicate rewards.

##### Validate

Create deterministic starts for low resources, each wave, boss phase, victory, and death/retry. Test desktop and mobile at the real camera distance, then adjust composition from observed decisions rather than raw completion time.


---

### optimize-threejs-games
**Description:** Profile, diagnose, and improve Three.js or WebGL game performance without regressing gameplay. Use for frame-time drops, CPU/GPU pressure, draw calls, texture and geometry budgets, animation loops, adaptive quality, mobile performance, and browser performance verification.


#### Optimize Three.js Games

Measure before changing behavior, then validate the same gameplay path after every optimization.

##### Establish a repeatable scene

Choose a deterministic representative encounter and record device, viewport, quality level, player position, enemies, active effects, frame-time sample, draw calls, triangles, texture count, and warnings. Compare like with like.

##### Diagnose the limiting side

- Suspect CPU when simulation, allocations, React work, pathfinding, or per-frame scans grow with actors.
- Suspect GPU when resolution, overdraw, shadows, transparent particles, post-processing, draw calls, geometry, or texture bandwidth dominate.
- Inspect before optimizing; do not lower quality blindly.

##### Apply low-risk fixes first

Reuse geometry/materials, pool transient effects, cull inactive/offscreen work, throttle noncritical UI updates, cap particle counts, avoid per-frame allocation, and update only changed transforms. Keep render quality settings explicit and reversible. Degrade decorative effects before combat readability or controls.

##### Guard the result

Re-run the original encounter and verify frame time, visual correctness, collision/contact behavior, memory stability, mobile controls, reduced motion, and console health. Close temporary servers, benchmarks, and browser tabs once they are no longer needed.


---

### ship-web-games
**Description:** Package, deploy, and verify a playable Three.js or web game. Use for release builds, asset delivery, private/public deployment, production smoke tests, browser proof, release notes, rollback readiness, and cleanup of temporary QA resources.


#### Ship Web Games

Release only a verified commit and prove the deployed game, not merely the local build.

##### Release sequence

1. Confirm the exact integration commit and preserve unrelated work.
2. Run focused tests, lint/type checks, production build, and diff checks.
3. Package and deploy the exact validated commit.
4. Poll deployment status and open the production game in the repository-approved browser.

##### Production proof

Verify load, first input, one combat or core interaction, assets, save/settings if applicable, responsive view, console health, and representative performance. Report the deployed state separately from local readiness.

##### Finish cleanly

Record release evidence and rollback target. Close temporary dev servers, benchmarks, and QA tabs once no longer needed; do not terminate resources owned by another active task.


---

### test-playable-web-games
**Description:** Test a playable browser game end to end with deterministic fixtures and real browser evidence. Use for gameplay QA, regression testing, controls, accessibility, responsive/mobile testing, save flows, console checks, performance smoke tests, and release verification.


#### Test Playable Web Games

Combine deterministic tests with short real playthroughs. Do not treat a green build as gameplay proof.

##### Start with a test matrix

Map the player journey: launch, new game, controls, core action, enemy encounter, reward, inventory/progression, save/continue, loss/retry, pause, settings, and completion. Add device variants for desktop keyboard/mouse, touch portrait, touch landscape, and reduced motion.

##### Prefer deterministic review states

Create seedable fixtures, debug routes, or query parameters for combat phase, inventory loadout, boss phase, tutorial step, save migration, low health, and error states. Test important transitions directly rather than grinding through the campaign.

##### Verify the player experience

Use the repository-approved browser surface and honor local browser restrictions. Confirm screen-visible feedback after each meaningful action: control response, target state, damage/resource state, UI update, and navigation. Inspect console warnings/errors and sample performance only on a representative live scene.

##### Report actionable evidence

Record reproduction steps, expected versus actual result, severity, device/viewport, and the shortest useful proof. Separate new regressions from pre-existing baseline issues. After testing, close idle browser pages, dev servers, and benchmarks while leaving active task resources alone.


---

### tune-enemy-ai
**Description:** Build, debug, balance, or test combat enemy AI for playable action games. Use for aggro, target selection, navigation, spacing, attack choices, telegraphs, retreats, boss behavior, behavior-state machines, and deterministic AI regression tests.


#### Tune Enemy AI

Make enemy choices legible, bounded, and reproducible.

##### Model decisions explicitly

Use a small state machine or utility layer with named states such as idle, investigate, pursue, reposition, windup, attack, recover, stagger, retreat, and defeated. State transitions must state their prerequisites, exit conditions, minimum dwell time, and cooldown effects.

##### Separate perception, intent, and motion

1. Gather observable inputs: distance, line of sight, target state, occupancy, threat, health, and timers.
2. Select one intention from constrained legal actions.
3. Move and animate toward that intent without rewriting the decision mid-action.

Use authoritative collision and navigation results for movement success. Do not derive them from rendered pose or assumed path completion.

##### Preserve fair combat

Telegraph attacks before their active window. Prevent instant turn-and-hit behavior, perpetual chase, clipped attacks through blockers, and repeated recovery spam. Add spacing and commitment so the player can read and answer each enemy archetype.

##### Test the decision surface

Create deterministic fixtures for target acquisition, target loss, obstruction, path failure, close-range pressure, multiple enemies, retaliation, interrupt, stagger, boss phase, and reset. Assert transitions and outcomes, not only final positions. Run a real browser encounter after automated tests.


---

