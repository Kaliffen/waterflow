---
name: setup-waterflow
description: Bind Waterflow to this repository. Run once, before routing anything.
argument-hint: ""
disable-model-invocation: true
source: mattpocock/skills @ 6654f6b — skills/engineering/setup-matt-pocock-skills/SKILL.md (adapted)
---

# Setup Waterflow

Resolve the four things Waterflow cannot know in advance, write them to
`.waterflow/config.md`, and point the repository's agent instructions at the
router.

Ask **one question at a time** and propose the default. A list of four questions
gets one answer.

## 1. Read the repository first

Before asking anything, look. The answers are usually on disk:

- Is this a git repository? Waterflow needs one — `revision` is the freshness
  anchor for every record.
- Is there existing agent instruction (`CLAUDE.md`, `AGENTS.md`)?
- Is work already tracked somewhere — a backlog file, `gh` configured with open
  issues, a `docs/` process?

Report what you found, then ask about only what is genuinely open.

## 2. State surface

Where work items live. See
[state-surface.md](../waterflow/references/state-surface.md).

| Option | Pick when |
|---|---|
| **local markdown** (default) | Nothing is tracked yet, or the existing tracker is not somewhere Waterflow can reach. |
| **GitHub Issues** | `gh` works here and issues are already how work is tracked. |
| **map onto existing** | There is a real process in this repository already. |

For **map onto existing**, resolve two things explicitly and record the answers:

- **Where blocking lives.** If the existing process has no way to say one item
  blocks another, `list_frontier` degenerates to "all open items". Say so, and
  offer to add a convention.
- **What closed means.** If closing happens in a tool you cannot reach,
  `close_item` records the proof state locally and reports what the human must
  do. Never claim a close you did not perform.

If the mapping cannot be made honestly, say so and fall back to local markdown.

## 3. Impressions location

Default `.waterflow/impressions/`. Confirm it is **committed**, not ignored —
check `.gitignore` and fix it if `.waterflow/` is excluded. Impressions are
claims about the code and have to travel with a clone.

## 4. Authority label

Waterflow says **the owner**. If the team calls that role something else, record
their term and use it in reports. Cosmetic only: the rule that the agent gathers
facts and the owner takes decisions does not change.

## 5. Write the config

```markdown
# Waterflow config

| Setting | Value |
|---|---|
| state surface | local markdown |
| items path | .waterflow/items/ |
| impressions path | .waterflow/impressions/ |
| authority label | the owner |

## Mapping notes

Blocking: <how one item blocks another, or "not represented">
Closed: <what closing means here, and who does it>
```

Create the items and impressions directories. Add a `.gitkeep` to each so they
survive a clone.

## 6. Offer the proof gate

`proof-gate.sh` is a deterministic pre-commit check: it refuses a commit that
touches code covered by a live `fail` record, and warns when a commit makes a
recorded `pass` stale. It reads the store directly, asks no model anything, and
costs nothing on any turn.

Offer it; do not install it silently — a hook that appears without being asked
for is the fastest way to get Waterflow uninstalled. If accepted, copy it into
`.git/hooks/pre-commit`, or call it from the existing hook if there is one. Say
that `WATERFLOW_GATE=warn` downgrades a refusal to a warning.

## 7. Point the agent instructions at the router

Add this block to the repository's `CLAUDE.md` or `AGENTS.md`, creating the file
if there is none. Replace an existing Waterflow block rather than appending a
second one.

```markdown
## Waterflow

Route non-trivial work with `/waterflow` before starting it. It sets lane, model
tier, agent topology, proof, and owner, and reports all five.

Before deriving a fact about an area, `recall` it. After a change, `prove` it.
Configuration is in `.waterflow/config.md`.
```

## 8. Report

Say what was written, what was chosen, and the one next command: `/waterflow`
with the work in hand. If anything was left unresolved — an unreachable tracker,
a blocking convention the team has to agree — say that too, rather than leaving
it in the config as if it were settled.
