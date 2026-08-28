# Agent Instructions

This repository publishes reusable agents and skills. Keep changes small, reviewable, and explicit about what ships versus what is local design work.

## Boundaries

- `skills/` contains distributable skills.
- `skills/*/references/` contains progressively loaded supporting guidance.
- `agents/` contains custom agent prompts.
- `docs/` contains human-facing design notes.
- `.codex-plugin/plugin.json` contains Codex plugin metadata.
- `plugin.json` contains root repository metadata for hosts that read skills and agents directly.

## Authoring Rules

- Skills are routers or focused capabilities, not dumping grounds for every rule.
- Put large or phase-specific guidance in `references/` and link it from the owning skill.
- Do not duplicate the same workflow rule across multiple skills; move shared guidance into a reference.
- Keep model names behind stable tier names: `best`, `good`, `normal`, `low`.
- Public files must not contain private repo paths, secrets, or local machine assumptions.

## Validation

Before publishing changes, check:

1. Every skill has `SKILL.md`.
2. Every local reference path linked from a skill exists.
3. Plugin manifests contain no placeholders.
4. Public docs describe the current shipped structure.
