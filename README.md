# Waterflow

Waterflow is a public home for agent skills, role prompts, and workflow guidance for Creative Director-led software work.

The first design goal is simple: keep agent workflows efficient without hiding important decisions in chat. Skills should route work, references should load only when needed, and model strength should match the risk of the phase.

## What Ships

- `skills/waterflow/`: a router skill for planning workflow-shaped agent work.
- `skills/waterflow/references/`: deeper guidance loaded only when the active task needs it.
- `agents/`: custom agent prompts that can be adapted by host tools.
- `.codex-plugin/plugin.json`: Codex plugin packaging metadata.
- `plugin.json`: lightweight root metadata for hosts that discover skills and agents from repository paths.

## Design Principles

1. Creative direction belongs to the human owner.
2. Planning, implementation, review, and bookkeeping do not need the same model strength.
3. Skills should stay small and composable.
4. References should be explicit, phase-scoped, and progressively loaded.
5. Durable artifacts beat chat memory for decisions that matter later.

## Model Tiers

- `best`: strategic planning, architecture, contested scope, and hard-to-reverse decisions.
- `good`: review, coding judgment, and bounded implementation with meaningful risk.
- `normal`: ordinary implementation with clear acceptance criteria.
- `low`: bookkeeping, status updates, formatting, and deterministic maintenance.

Current preferred examples are Opus for `best`, Sonnet for `good`, and Haiku for `low`. Model names are examples, not the durable contract.

## Status

Initial scaffold. Expect the first few skills and agents to change as the workflow proves itself in real projects.
