# Waterflow

Waterflow is a set of agent skills that carry work from idea to integration in a
small feedback loop.

It is a workflow, not an operating system. The skills are **atomic**: each one
performs a single operation, and larger operations are declared as sequences of
them rather than written as bigger skills. You keep the process you already have;
Waterflow routes work through it.

## Route by risk

Every non-trivial request sets five dials, explicitly and visibly:

| Dial | Question |
|---|---|
| **Lane** | How much process does this need? |
| **Tier** | How much model does this need? |
| **Topology** | How many agents, in what shape? |
| **Proof** | What evidence closes this? |
| **Owner** | Who decides? |

Two of those are unusual. **Tier** matches model strength to the risk of the
phase, so planning a contested architecture and renaming a config key do not run
on the same model. **Topology** decides between working inline, dispatching one
subagent, fanning out in parallel, or going background, because that choice has a
real cost and is usually made by accident.

The rule underneath all five: the agent gathers facts, the owner takes decisions.
Waterflow never silently settles something that belongs to you.

## Water has memory

Atoms leave **impressions**: small typed records of what the flow learned, tagged
and indexed as a byproduct of doing the work. Nobody curates them.

The point is that context stops being *loaded* and starts being *queried*.
Briefing a fresh subagent becomes "the six live records tagged `checkout`"
instead of pasting a conversation at it. Records supersede rather than
accumulate, and each is anchored to the revision it was true at, so a stale one
is surfaced as stale rather than quietly believed.

## What ships

**The router.** `waterflow` — the five dials and the map of everything else.

**Atoms**, model-invoked, one operation each:

| | |
|---|---|
| `recall` | query what the flow already settled |
| `interrogate` | rounds of questions until nothing is assumed |
| `define` | settle the words and the hard-to-reverse decisions |
| `seam` | choose and confirm where behaviour is observed |
| `slice` | cut vertical tracer bullets with blocking edges |
| `probe` | throwaway code that answers one question |
| `dig` | investigate against primary sources |
| `test` | one failing test at the seam, then make it pass |
| `prove` | run the named proof, record state and revision |
| `critique` | two-axis review in parallel, never merged |

**Composites**, user-invoked, thin declarations of atom sequences: `align`,
`shape`, `build`, `land`.

**Also:** `setup-waterflow` binds Waterflow to a repository and offers a
deterministic pre-commit proof gate. `authoring` is the standard every skill
here is written against. `.claude-plugin/` and `.codex-plugin/` are the host
manifests.

Skills arrive as one plugin: they share contracts, so they travel together. The
permanent context cost is eleven model-invoked descriptions, and that is the
budget, enforced by `scripts/check.mjs`.

## Design principles

1. Creative and product decisions belong to the owner.
2. Planning, implementation, review, and bookkeeping do not need the same model.
3. An atom does one thing. A composite declares a sequence of atoms and nothing
   else.
4. No rule lives in two places.
5. References load when a phase needs them, not on every turn.
6. What the flow learns outlives the conversation.

## Model tiers

Tier names are the durable contract. Model names are current examples and will
change.

- `best` — strategy, architecture, contested scope, hard-to-reverse decisions.
- `good` — review, coding judgement, bounded implementation with real risk.
- `normal` — ordinary implementation with clear acceptance criteria.
- `low` — bookkeeping, status, formatting, deterministic chores.

Tiers are advisory: Waterflow tells you what a phase warrants and you choose.

## Status

Early but complete in shape. Phases 0-2 of `docs/build-plan.md` are done: the
ground rules, the authoring standard, validation, the router, the eight
references, ten atoms, four composites, and the proof gate. Nothing has been
proven on real work yet, which is the next thing that matters.

Design reasoning is in `docs/pre-plan-analysis.md`, which teardowns the two
repositories Waterflow learns from and records the decisions behind every rule
here. Borrowed material is credited in `ATTRIBUTION.md`.

## Development

```
node scripts/check.mjs
claude plugin validate . --strict
```

MIT.
