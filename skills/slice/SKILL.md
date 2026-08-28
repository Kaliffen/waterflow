---
name: slice
description: Cut work into vertical tracer-bullet slices with blocking edges and publish them. Use when a plan or spec needs breaking into implementable pieces.
source: mattpocock/skills @ 6654f6b — skills/engineering/to-tickets/SKILL.md (adapted)
---

# Slice

One operation: turn agreed work into items on the state surface, each a complete
narrow path, each declaring what blocks it.

## Draft the slices

- Each slice cuts a **narrow but complete** path through every layer — schema,
  API, interface, tests. Vertical, never a horizontal slice of one layer.
- A finished slice is **demoable or verifiable on its own**.
- Each is sized to fit in a single fresh context window.
- Prefactoring goes first. Make the change easy, then make the easy change.

Give each slice its **blocking edges**: the slices that must finish before it can
start. No blockers means it can start now. Edges are what make
`list_frontier` mean something — see
[state-surface.md](../waterflow/references/state-surface.md).

Two slices with no edge between them may be built at the same time, so an edge
is also how scope collisions get prevented. **Slices that can run in parallel
must touch disjoint paths.** Where two slices would edit the same files, either
draw the blocking edge or merge them — leaving both open and unblocked promises
a parallelism that resolves as a merge conflict. See the one-writer rule in
[topology.md](../waterflow/references/topology.md).

Use the project's own vocabulary in titles and descriptions. `recall` the
`define` records for the area first; a slice named in the wrong words is a slice
someone re-litigates.

## Wide refactors are the exception

A **wide refactor** is one mechanical change — rename a column, retype a shared
symbol — whose blast radius fans across the codebase, so a single edit breaks
thousands of call sites and no vertical slice can land green. Do not force it
into a tracer bullet. Sequence it as **expand → migrate → contract**:

1. **Expand.** Add the new form beside the old. Nothing breaks.
2. **Migrate.** Move call sites over in batches sized by blast radius — per
   package, per directory. Each batch is its own item, blocked by the expand.
   The old form still exists, so each batch stays green.
3. **Contract.** Delete the old form once no caller remains. Blocked by every
   migrate batch.

When even the batches cannot stay green alone, keep the sequence but let them
share an integration branch that blocks a final integrate-and-verify item. Green
is promised only there, and saying so is the point.

## Confirm before publishing

Present the breakdown as a numbered list: title, blocked by, and what it
delivers end to end. Then ask three questions:

- Is the granularity right — too coarse, too fine?
- Does each item depend only on what genuinely gates it?
- Should anything merge or split?

Iterate until the owner approves. Publish only after that.

## Publish

`create_item` per slice, in dependency order so blockers have ids to reference.
Titles and bodies describe **behaviour**, from the caller's point of view, never
a layer-by-layer implementation list.

Avoid file paths and code snippets — they go stale fast. The exception is a
snippet from `probe` that encodes a decision more precisely than prose can: a
state machine, a schema, a type shape. Inline the decision-rich part only, and
say where it came from.

## Emit

One record, `atom: slice`, `subject` the feature, `scope: []`. The gist is how
the work was cut and how many items; the detail is the blocking shape and any
sequencing that is not obvious, such as an expand–migrate–contract chain.
Supersede the previous slice record for the same subject. Contract:
[impressions.md](../waterflow/references/impressions.md).
