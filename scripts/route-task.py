#!/usr/bin/env python3
"""Show candidate policies and skills from skills-lock.json for a task description.

This is a transparent keyword aid, not a replacement for the agent's semantic
judgment or native skill-loading behavior.
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REGISTRY = ROOT / "skills-lock.json"


def words(value: str) -> list[str]:
    return re.findall(r"[a-z0-9]+", value.lower())


def contains_phrase(task_words: list[str], cue: str) -> bool:
    cue_words = words(cue)
    if not cue_words:
        return False
    width = len(cue_words)
    return any(task_words[i : i + width] == cue_words for i in range(len(task_words) - width + 1))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--task", required=True, help="Plain-language task description")
    args = parser.parse_args()
    registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
    task_words = words(args.task)

    policies = []
    skills = []
    for name, entry in registry.get("policies", {}).items():
        cues = entry.get("activateFor", [])
        if entry.get("mandatory") or any(contains_phrase(task_words, cue) for cue in cues):
            policies.append({"name": name, "path": entry["path"]})
    for name, entry in registry.get("skills", {}).items():
        if any(contains_phrase(task_words, cue) for cue in entry.get("activateFor", [])):
            path = ROOT / entry["skillPath"]
            if path.is_file():
                skills.append({"name": name, "path": entry["skillPath"]})

    print(json.dumps({
        "task": args.task,
        "policies": policies,
        "candidateSkills": skills,
        "note": "Candidates are cue matches. Use judgment, read selected skills fully, and omit unrelated matches.",
    }, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
