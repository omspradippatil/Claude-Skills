#!/usr/bin/env python3
"""Acceptance checks for registry consistency and representative route examples."""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
registry = json.loads((ROOT / "skills-lock.json").read_text())
errors = []

active = registry["skills"]
if "ralph" in json.dumps(registry).lower():
    errors.append("Ralph appears in the skill configuration")
if "frontend-design" in active or (ROOT / ".agents/skills/frontend-design").exists():
    errors.append("the replaced general UI skill is still active")
if len(active) != len(set(active)):
    errors.append("duplicate active skill names")

for name, entry in active.items():
    skill = ROOT / entry["skillPath"]
    if not skill.is_file():
        errors.append(f"{name}: registered SKILL.md missing: {entry['skillPath']}")
    mirror = ROOT / ".claude/skills" / name
    canonical = ROOT / ".agents/skills" / name
    if not mirror.is_dir():
        errors.append(f"{name}: Claude mirror missing")
    elif sorted(p.relative_to(canonical) for p in canonical.rglob("*") if p.is_file()) != sorted(
        p.relative_to(mirror) for p in mirror.rglob("*") if p.is_file()
    ):
        errors.append(f"{name}: complete skill tree differs between platforms")
    else:
        for source in canonical.rglob("*"):
            if source.is_file() and source.read_bytes() != (mirror / source.relative_to(canonical)).read_bytes():
                errors.append(f"{name}: mirror content differs at {source.relative_to(canonical)}")
                break

examples = [
    ("show the contents of this folder and count the files", set(), {"core"}),
    ("redesign a responsive website with accessible typography and layout", {"ui-ux-pro-max"}, {"core", "frontend"}),
    ("add a REST API endpoint in the backend", {"api-architecture"}, {"core"}),
    ("secure the authentication endpoint against injection", {"security-auditor", "api-architecture"}, {"core", "security"}),
    ("build a responsive frontend for a REST API and add a Postgres migration", {"ui-ux-pro-max", "api-architecture", "postgres-ecosystem"}, {"core", "frontend"}),
    ("validate user input before storing customer profiles", {"security-auditor"}, {"core", "security", "testing"}),
    ("debug a failing API handler", {"api-architecture"}, {"core", "engineering"}),
    ("deploy a Docker image", {"devops-cicd"}, {"core"}),
    ("plan and execute a complex feature milestone with spec driven roadmap", {"gsd-core"}, {"core"}),
    ("fix a simple typo in the readme", set(), {"core"}),
    ("research official documentation and compare libraries for caching", {"agent-research"}, {"core"}),
    ("refactor to eliminate abstractions and apply minimal code principles", {"ponytail"}, {"core", "engineering"}),
    ("summarize test logs in concise mode with token compression", {"caveman"}, {"core", "testing"}),
    ("enforce verification gates and evidence based reliability checks", {"gravitas"}, {"core", "testing"}),
    ("migrate domain URLs, update sitemap, and secure authentication against injection", {"seo-marketing", "security-auditor"}, {"core", "seo", "security"}),
]
for task, expected_skills, expected_policies in examples:
    proc = subprocess.run(
        [sys.executable, str(ROOT / "scripts/route-task.py"), "--task", task],
        text=True, capture_output=True, check=True,
    )
    routed = json.loads(proc.stdout)
    names = {item["name"] for item in routed["candidateSkills"]}
    policies = {item["name"] for item in routed["policies"]}
    if not expected_skills.issubset(names):
        errors.append(f"route missed expected skills for {task!r}: {expected_skills - names}")
    if not expected_policies.issubset(policies):
        errors.append(f"route missed expected policies for {task!r}: {expected_policies - policies}")
    if task.startswith("show the contents") and names:
        errors.append(f"unrelated specialist skill loaded for simple task: {names}")
    if task.startswith("fix a simple typo") and names:
        errors.append(f"unrelated specialist skill loaded for simple fix: {names}")
    if "gsd-core" in names and ("simple" in task or task.startswith("show the contents")):
        errors.append(f"GSD Core loaded on simple non-milestone task: {task!r}")
    if {"3d-visuals", "web-gamedev"} & names and "3d" not in task and "game" not in task:
        errors.append(f"unrelated visual/game skill loaded for {task!r}")
    if task == "deploy a Docker image" and "seo-marketing" in names:
        errors.append("SEO skill loaded for deployment with no domain or URL work")
    if task == "deploy a Docker image" and "assets-media" in names:
        errors.append("media skill loaded for a Docker container image")
    if not errors:
        print(f"PASS: {task}")

if errors:
    for error in errors:
        print(f"FAIL: {error}", file=sys.stderr)
    raise SystemExit(1)
print(f"PASS: registry, full skill mirrors, and {len(examples)} task routes")
