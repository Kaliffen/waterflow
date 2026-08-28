---
name: waterflow
description: Route work by risk. Sets lane, model tier, agent topology, proof, and owner.
argument-hint: "<what you want to do>"
disable-model-invocation: true
---

# Waterflow

Route work into the smallest shape that can finish it. **The agent gathers
facts; the owner takes decisions.**

## Route

Set five dials and report them before starting.

| Dial | Question | Values |
|---|---|---|
| **Lane** | How much process? | `direct` / `align` / `shape` / `build` |
| **Tier** | How much model? | `best` / `good` / `normal` / `low` |
| **Topology** | How many agents, what shape? | `inline` / `subagent` / `fan-out` / `background` / `fresh` |
| **Proof** | What closes this? | a named command, test, artifact, review, or human check |
| **Owner** | Who decides? | `agent` / `agent recommends` / `human` |

**Escalate** Lane, Tier, and Owner together on product direction, architecture,
an unclear seam, conflicting evidence, or expensive rework. **Downgrade** only
when the decision is made, the change is mechanical, and the result is easy to
verify. Re-route out loud when the work turns out to be other than what was
routed. Rules: [dials.md](references/dials.md).

## Flow

`align` → `shape` → `build` → `land`. The lane names where the work enters;
everything downstream still runs.

- **`align`** — recall what is known, interrogate the gaps, define the terms.
- **`shape`** — choose the proof seam, cut vertical slices with blocking edges.
- **`build`** — one failing test at the seam, make it pass, prove, critique.
- **`land`** — critique, prove, integrate.

Lane `direct` enters no composite: run the atoms the work needs, then prove.

## Memory

Atoms emit **impressions**: typed records of what the flow settled, written as a
byproduct and read back by `recall`. Context is queried, not loaded — brief a
cold agent with records, never a transcript.

## References

Load one when its dial is in play, not before.

| File | For |
|---|---|
| [dials.md](references/dials.md) | routing, escalation, re-routing |
| [lanes.md](references/lanes.md) | choosing an entry point |
| [model-tiers.md](references/model-tiers.md) | tier meanings and moves |
| [topology.md](references/topology.md) | boundaries, subagents, fan-out |
| [proof.md](references/proof.md) | proof kinds, states, freshness |
| [decision-rights.md](references/decision-rights.md) | what is always the owner's |
| [impressions.md](references/impressions.md) | the emission contract |
| [state-surface.md](references/state-surface.md) | where work items live |

Atoms, all model-invoked: `recall`, `interrogate`, `define`, `seam`, `slice`,
`probe`, `dig`, `test`, `prove`, `critique`. Composites, all typed by hand:
`/align`, `/shape`, `/build`, `/land`. There is no setup step: the paths are
conventions, overridable by a hand-written `.waterflow/config.md`.
