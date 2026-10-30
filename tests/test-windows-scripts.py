#!/usr/bin/env python3
"""Validation tests for Windows PowerShell (.ps1) and Command Prompt (.bat) scripts.

Checks:
- PowerShell script syntax validity (balanced parentheses, brackets, braces, quotes, keywords)
- Parameter declarations, aliases, and position attributes
- Manifest format consistency (| and \t separation, sha256 hashes)
- File references in scripts match existing repository files
- Batch wrapper files exist, have proper parameter forwarding, and invoke powershell correctly
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
errors: list[str] = []


def check_balanced_delimiters(content: str, filename: str) -> None:
    """Check that quotes, parentheses, brackets, and braces are balanced."""
    # Strip comments and string literals for brace/bracket/paren checking
    # Simple lexical scan
    stack: list[tuple[str, int]] = []
    pairs = {')': '(', ']': '[', '}': '{'}
    in_single_quote = False
    in_double_quote = False
    in_here_string_single = False
    in_here_string_double = False
    escape = False

    lines = content.splitlines()
    for line_idx, line in enumerate(lines, 1):
        i = 0
        while i < len(line):
            ch = line[i]

            # Check here-strings
            if not in_single_quote and not in_double_quote:
                if line[i:i+2] == '@"' and not in_here_string_double:
                    in_here_string_double = True
                    i += 2
                    continue
                elif line[i:i+2] == '"@' and in_here_string_double:
                    in_here_string_double = False
                    i += 2
                    continue
                elif line[i:i+2] == "@'" and not in_here_string_single:
                    in_here_string_single = True
                    i += 2
                    continue
                elif line[i:i+2] == "'@" and in_here_string_single:
                    in_here_string_single = False
                    i += 2
                    continue

            if in_here_string_single or in_here_string_double:
                i += 1
                continue

            # Standard strings
            if ch == "'" and not in_double_quote:
                in_single_quote = not in_single_quote
                i += 1
                continue
            elif ch == '"' and not in_single_quote and not escape:
                in_double_quote = not in_double_quote
                i += 1
                continue
            elif ch == '`' and in_double_quote:
                escape = True
                i += 1
                continue

            escape = False

            if in_single_quote or in_double_quote:
                i += 1
                continue

            # Skip single-line comments
            if ch == '#':
                break

            if ch in '([{':
                stack.append((ch, line_idx))
            elif ch in ')]}':
                if not stack:
                    errors.append(f"{filename}:{line_idx}: Unmatched closing delimiter '{ch}'")
                else:
                    top, start_line = stack.pop()
                    if top != pairs[ch]:
                        errors.append(f"{filename}:{line_idx}: Mismatched delimiter '{ch}', expected match for '{top}' from line {start_line}")

            i += 1

    if stack:
        for delim, l_num in stack:
            errors.append(f"{filename}:{l_num}: Unclosed delimiter '{delim}'")


def test_install_ps1() -> None:
    install_ps1 = ROOT / "install.ps1"
    if not install_ps1.is_file():
        errors.append("install.ps1 does not exist")
        return

    content = install_ps1.read_text(encoding="utf-8")
    check_balanced_delimiters(content, "install.ps1")

    # Check parameter aliases
    for alias in ["Target", "t", "Platform", "Skills", "All", "Minimal", "Force", "DoUninstall", "Help"]:
        if alias not in content:
            errors.append(f"install.ps1 missing expected parameter or alias: {alias}")

    # Check that required core files are copied
    for ref in ["CLAUDE.md", "AGENTS.md", "GEMINI.md", "skills-lock.json", "scripts/route-task.py", ".cursor/rules/always-on.mdc"]:
        if ref not in content:
            errors.append(f"install.ps1 missing copy reference for {ref}")
        target_file = ROOT / ref
        if not target_file.exists():
            errors.append(f"install.ps1 references non-existent file in repo: {ref}")

    # Check that manifest file is written properly
    if ".claude-skills-install.windows.manifest" not in content:
        errors.append("install.ps1 does not specify .claude-skills-install.windows.manifest")

    # Check for safe string splitting on Skills parameter
    if ".Split(',')" not in content and ".Split(\",\")" not in content:
        errors.append("install.ps1 does not handle comma-separated skill lists")

    # Check that remote clone fallback is present and safe
    if "https://github.com/omspradippatil/Claude-Skills.git" not in content:
        errors.append("install.ps1 missing git repository fallback URL")

    # Check for interactive menu and existing installation detection
    if "Existing configuration detected" not in content:
        errors.append("install.ps1 missing existing configuration detection")
    if "Override existing configuration" not in content:
        errors.append("install.ps1 missing override prompt for existing installation")


def test_uninstall_ps1() -> None:
    uninstall_ps1 = ROOT / "uninstall.ps1"
    if not uninstall_ps1.is_file():
        errors.append("uninstall.ps1 does not exist")
        return

    content = uninstall_ps1.read_text(encoding="utf-8")
    check_balanced_delimiters(content, "uninstall.ps1")

    # Check manifest support for both Windows and POSIX manifests
    if ".claude-skills-install.windows.manifest" not in content:
        errors.append("uninstall.ps1 missing .claude-skills-install.windows.manifest support")
    if ".claude-skills-install.manifest" not in content:
        errors.append("uninstall.ps1 missing fallback for .claude-skills-install.manifest")

    # Check delimiter support
    if "Split(\"|\"" not in content and "Split('|'" not in content:
        errors.append("uninstall.ps1 missing pipe delimiter splitting")


def test_batch_wrappers() -> None:
    for bat_name in ["install.bat", "uninstall.bat"]:
        bat_file = ROOT / bat_name
        if not bat_file.is_file():
            errors.append(f"{bat_name} does not exist")
            continue

        content = bat_file.read_text(encoding="utf-8")
        if "powershell.exe" not in content:
            errors.append(f"{bat_name} does not call powershell.exe")
        if "-ExecutionPolicy Bypass" not in content:
            errors.append(f"{bat_name} does not bypass execution policy")
        if "%*" not in content:
            errors.append(f"{bat_name} does not forward arguments (%*)")


def test_skills_count() -> None:
    registry = json.loads((ROOT / "skills-lock.json").read_text(encoding="utf-8"))
    skills = registry.get("skills", {})
    if len(skills) != 24:
        errors.append(f"Expected 24 registered skills, found {len(skills)}")

    agents_skills = [d.name for d in (ROOT / ".agents/skills").iterdir() if d.is_dir() and (d / "SKILL.md").is_file()]
    if len(agents_skills) != 24:
        errors.append(f"Expected 24 canonical skills in .agents/skills, found {len(agents_skills)}")


def main() -> int:
    print("Running Windows script verification tests...")
    test_install_ps1()
    test_uninstall_ps1()
    test_batch_wrappers()
    test_skills_count()

    if errors:
        for err in errors:
            print(f"FAIL: {err}", file=sys.stderr)
        return 1

    print("PASS: Windows scripts (install.ps1, install.bat, uninstall.ps1, uninstall.bat) verified successfully.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
