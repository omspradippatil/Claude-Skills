# Platform compatibility

Platform support describes documented file formats and repository adapters. The
automated checks validate this repo's files and candidate routes; they do not
launch each agent or prove that its model selected a skill.

| Agent | Instruction adapter | Native project skill path | This repository's support |
|---|---|---|---|
| Claude Code | CLAUDE.md | .claude/skills/<name>/SKILL.md | Full skill mirror; documented native path |
| Antigravity | GEMINI.md and AGENTS.md | .agents/skills/<name>/SKILL.md | Canonical folder; documented native path |
| Codex | AGENTS.md | .agents/skills/<name>/SKILL.md | Canonical folder; documented native path |
| Cursor | .cursor/rules/always-on.mdc and AGENTS.md | .agents/skills/, .cursor/skills/ | Canonical path documented by Cursor; adapter provided |

Global skill directories differ by product: Claude Code uses
~/.claude/skills/. The Antigravity app and IDE use ~/.gemini/config/skills/,
while Antigravity CLI documents ~/.gemini/antigravity-cli/skills/. Cursor
documents ~/.agents/skills/ and ~/.cursor/skills/. For Codex, this repository
documents the repo-local .agents/skills/ location; its app/CLI global install
behavior is not claimed as tested here.

The installer offers agents (.agents/skills), claude, cursor, and antigravity
destinations. Its global agents path is ~/.agents/skills; use antigravity for
the Antigravity app/IDE global path. Native discovery still depends on product
version, settings, and execution mode.

## What the adapters do

- CLAUDE.md contains the full canonical task router for Claude Code and
  downstream adapters.
- AGENTS.md directs Codex and Antigravity to the canonical router.
- GEMINI.md points Antigravity at the shared policies.
- .cursor/rules/always-on.mdc is a lightweight Cursor project rule.
- .agents/skills/ is the canonical cross-agent source. The
  .claude/skills/ tree mirrors its full folders, including support files.

Cursor recognizes .agents/skills/ and .cursor/skills/; it can also read
Claude and Codex skill directories according to current Cursor documentation.
The native .cursor/skills/ destination remains available for an explicit
Cursor-only install. Antigravity has its own .agents/skills and global
directory, while Codex documents .agents/skills plus AGENTS.md.

## Verify locally

```bash
bash scripts/validate.sh
npm test
python3 scripts/route-task.py --task "redesign a responsive website"
```

These checks establish repository consistency and route-candidate behavior,
not live discovery in Claude Code, Antigravity, Cursor, or Codex. No separate
desktop-app runtime matrix was run for this rebuild. See the current primary
documentation for [Claude Code skills](https://code.claude.com/docs/en/skills),
[Antigravity skills](https://antigravity.google/docs/skills),
[Codex skills](https://developers.openai.com/cookbook/examples/codex/iterating-development-workflows-with-codex),
and [Cursor skills](https://cursor.com/docs/skills).
