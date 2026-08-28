---
name: waterflow
description: Route agent work through Creative Director-led planning, model-tier selection, progressive references, implementation, review, and bookkeeping. Use when designing, updating, or applying an agent workflow or skill system.
argument-hint: "plan | route | model-tiers | skill-interactions | review"
user-invocable: true
disable-model-invocation: false
---

# Waterflow

Use this skill to route work into the smallest effective workflow shape while keeping human creative authority explicit.

## Core Contract

1. Identify the phase: intake, planning, discovery, implementation, review, closeout, or bookkeeping.
2. Select the model tier that matches the risk of the phase.
3. Load only the references needed for the active phase.
4. Keep decisions in durable artifacts when they matter beyond the current turn.
5. Ask the human owner for product, creative, or contested tradeoff decisions.

## Model Tier Routing

Read `references/model-tiers.md` when selecting or explaining model strength.

Default mapping:

- `best`: strategic planning, architecture, contested scope, and hard-to-reverse decisions.
- `good`: review, coding judgment, and bounded implementation with meaningful risk.
- `normal`: ordinary implementation with clear acceptance criteria.
- `low`: bookkeeping, status updates, formatting, and deterministic maintenance.

## Workflow Shape Routing

Read `references/workflow-shape.md` when planning a workflow, splitting work, defining agent/skill interactions, or deciding whether a task needs discovery before implementation.

## Output Requirements

For non-trivial workflow guidance, report:

1. phase;
2. model tier;
3. owner of the decision;
4. references loaded or intentionally skipped;
5. next action.
