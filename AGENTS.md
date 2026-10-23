# Agent Entry Point

This adapter applies to Codex and Antigravity-compatible agents. Before every new task, read [`CLAUDE.md`](CLAUDE.md), which is the canonical router, then follow `policies/core.md` and only the relevant policies and skills it routes you to.

The canonical skill source is `.agents/skills/<name>/SKILL.md`. Read selected skills in full and any references they require. Do not load the whole catalog. Shared policy lives in `policies/`; do not create conflicting copies here.

Antigravity and Codex discover instructions and skills differently by product/version. This adapter and the static checks do not prove live discovery. See `docs/platform-compatibility.md`.
