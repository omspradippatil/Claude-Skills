#!/usr/bin/env python3
"""Skill routing evaluation, collision detection, and invariant test suite.

Inspired by Google Skill Reach (google/skill-reach) evaluation concepts:
- Skill discovery and collision detection across candidate cues.
- Routing specificity and false-trigger prevention.
- Mandatory policy and domain-skill coupling.
- Multi-skill composition accuracy.
- Gravitas reliability invariant verification (read-before-write, scope, fresh evidence, retry backoff).
- Cross-platform mirror fidelity.
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY_PATH = ROOT / "skills-lock.json"
ROUTER_SCRIPT = ROOT / "scripts/route-task.py"

errors: list[str] = []


def run_route(task: str) -> dict:
    proc = subprocess.run(
        [sys.executable, str(ROUTER_SCRIPT), "--task", task],
        text=True,
        capture_output=True,
        check=True,
    )
    return json.loads(proc.stdout)


def test_registry_and_mirrors(registry: dict) -> None:
    """Verify all registered skills exist, have YAML frontmatter, and mirror identically."""
    skills = registry.get("skills", {})
    if not skills:
        errors.append("Registry contains no skills")
        return

    for name, data in skills.items():
        canonical = ROOT / data["skillPath"]
        if not canonical.is_file():
            errors.append(f"Skill file missing: {canonical}")
            continue

        mirror = ROOT / ".claude/skills" / name / "SKILL.md"
        if not mirror.is_file():
            errors.append(f"Claude mirror missing for skill {name}: {mirror}")
        elif canonical.read_bytes() != mirror.read_bytes():
            errors.append(f"Content divergence between canonical and mirror for {name}")

        content = canonical.read_text(encoding="utf-8")
        if not re.search(r"^name:\s*" + re.escape(name), content, re.MULTILINE):
            errors.append(f"{name}: SKILL.md missing matching YAML name frontmatter")
        if not re.search(r"^description:", content, re.MULTILINE):
            errors.append(f"{name}: SKILL.md missing description in YAML frontmatter")


def test_collision_detection(registry: dict) -> None:
    """Analyze cue overlap to detect collisions between disjoint skills."""
    skills = registry.get("skills", {})
    cue_map: dict[str, list[str]] = {}

    for skill_name, data in skills.items():
        for cue in data.get("activateFor", []):
            cue_map.setdefault(cue, []).append(skill_name)

    # Check for direct phrase collisions between skills with different categories
    for cue, owners in cue_map.items():
        if len(owners) > 1:
            categories = {skills[o].get("category") for o in owners}
            # Cues shared across fundamentally different categories without exclusion rules are collisions
            if len(categories) > 1 and cue not in {"canvas"}:  # canvas shared by 3d and gamedev by design
                errors.append(f"Collision: cue '{cue}' shared across distinct categories: {owners}")


def test_mandatory_policies_and_skills() -> None:
    """Ensure mandatory policies and policy-coupled skills are triggered unconditionally or upon domain entry."""
    # 1. Core policy must be in EVERY task output
    test_cases = [
        "just a random query",
        "show files",
        "check weather",
        "implement a microservice",
    ]
    for q in test_cases:
        res = run_route(q)
        policies = {p["name"] for p in res["policies"]}
        if "core" not in policies:
            errors.append(f"Core policy missing for query {q!r}")

    # 2. Domain-coupled mandatory skills
    domain_tests = [
        ("audit user authorization and secrets", "security", "security-auditor"),
        ("optimize canonical tags and robots indexing", "seo", "seo-marketing"),
        ("build responsive UI layout with accessible typography", "frontend", "ui-ux-pro-max"),
    ]
    for task, expected_policy, expected_skill in domain_tests:
        res = run_route(task)
        policies = {p["name"] for p in res["policies"]}
        skills = {s["name"] for s in res["candidateSkills"]}
        if expected_policy not in policies:
            errors.append(f"Task {task!r} missed mandatory policy {expected_policy!r}")
        if expected_skill not in skills:
            errors.append(f"Task {task!r} missed coupled mandatory skill {expected_skill!r}")


def test_false_positive_prevention() -> None:
    """Ensure minimal, ambiguous, or generic tasks do NOT trigger specialist skills."""
    benign_tasks = [
        "what is the current time",
        "list files in the current directory",
        "count the number of words in this document",
        "check git status",
        "read the first 10 lines of file",
        "fix a simple typo in readme",
    ]
    for task in benign_tasks:
        res = run_route(task)
        skills = {s["name"] for s in res["candidateSkills"]}
        if skills:
            errors.append(f"False-positive activation for benign task {task!r}: {skills}")


def test_multi_skill_composition() -> None:
    """Verify that complex multi-disciplinary tasks activate all relevant capabilities without collision."""
    multi_task = "plan a complex feature milestone to add an authenticated REST API and Postgres database"
    res = run_route(multi_task)
    skills = {s["name"] for s in res["candidateSkills"]}
    policies = {p["name"] for p in res["policies"]}

    expected_skills = {"gsd-core", "api-architecture", "postgres-ecosystem", "security-auditor"}
    expected_policies = {"core", "security"}

    if not expected_skills.issubset(skills):
        errors.append(f"Multi-skill task missed expected skills: {expected_skills - skills}")
    if not expected_policies.issubset(policies):
        errors.append(f"Multi-skill task missed expected policies: {expected_policies - policies}")


def test_gravitas_invariants() -> None:
    """Verify the 6 reliability invariants are codified and verifiable."""
    core_text = (ROOT / "policies/core.md").read_text(encoding="utf-8")
    eng_text = (ROOT / "policies/engineering.md").read_text(encoding="utf-8")
    test_text = (ROOT / "policies/testing.md").read_text(encoding="utf-8")

    invariants = [
        "Ground before mutating",
        "Stay within scope",
        "Require fresh evidence",
        "Recover intelligently",
        "Meet acceptance criteria",
        "Report honestly",
    ]
    for inv in invariants:
        if inv.lower() not in core_text.lower():
            errors.append(f"Core policy missing Gravitas invariant: {inv}")
        if inv.lower() not in (eng_text + test_text).lower():
            errors.append(f"Engineering/Testing policies missing coverage of Gravitas invariant: {inv}")


def test_platform_compatibility_disclaimer() -> None:
    """Verify platform compatibility explicitly distinguishes static checks from live agent discovery."""
    compat_text = (ROOT / "docs/platform-compatibility.md").read_text(encoding="utf-8")
    if "does not prove live discovery" not in compat_text and "not prove that its model" not in compat_text:
        errors.append("docs/platform-compatibility.md missing live discovery disclaimer")


def main() -> int:
    registry = json.loads(REGISTRY_PATH.read_text(encoding="utf-8"))

    print("Running Skill Reach Evaluation Suite...")
    test_registry_and_mirrors(registry)
    test_collision_detection(registry)
    test_mandatory_policies_and_skills()
    test_false_positive_prevention()
    test_multi_skill_composition()
    test_gravitas_invariants()
    test_platform_compatibility_disclaimer()

    if errors:
        for err in errors:
            print(f"FAIL: {err}", file=sys.stderr)
        return 1

    print("PASS: Skill Reach Evaluation Suite: all routing, collision, invariant, and mirror checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
