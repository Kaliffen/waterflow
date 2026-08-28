# Waterflow Build Plan

## Where this stands

Phases 0-2 are done: the ground rules, the authoring standard, validation, the
router, the eight references, ten atoms, four composites, the proof gate, and CI.
The plugin installs and both validators pass.

**Gate 1 and Gate 2 are still open.** Nothing has been carried through the flow
on real work, which is the next thing that matters and the only thing that can
tell us whether the impression schema is right. The task lists for the completed
phases have been removed; they are in the changelog and in git history.

## Settled decisions

| | Decision |
|---|---|
| D1 | Atomic composable operations, idea → integration, small loop. Workflow, not OS |
| D2 | State-surface adapter resolved at setup |
| D3 | One lean profile; lanes carry the variation |
| D4 | Neutral authority term, configurable label |
| D5 | Tier dial is advisory |
| D6 | User-invoked router, model-invoked atoms, **no reflex** |
| D7 | Cheap verification only |
| D8 | No pilot consumer. A throwaway implementation is the test subject |
| D9 | Copy per the ledger, `ATTRIBUTION.md` + provenance lines |
| D10 | Impression store, **full emission**, one shared emission contract |
| D11 | Plain verbs, no metaphor in the working vocabulary |

The reasoning behind each is in `docs/pre-plan-analysis.md` §8. Read the decision
that governs a rule before changing the rule.

**D12, made by this plan: the distribution unit is the plugin, not the skill.**
A per-skill portability rule would forbid atoms from sharing the emission
contract. Skills may depend on anything under `skills/`, never on `scripts/`,
`docs/`, CI, or root manifests. This is what makes a single shared emission
contract legal.

**Description budget: 11 model-invoked skills** (10 atoms + `authoring`). The
only permanent context cost Waterflow imposes on a consumer. A twelfth must
displace one; `scripts/check.mjs` enforces the cap.

---

## Gate 1 — the store is worth querying

In a real repository: `/setup-waterflow` completes and writes config; `/waterflow`
routes three real pieces of work and reports all five dials each time; `prove`
writes records; `recall` returns them by tag with superseded excluded, a stale
record surfaced as stale, and an orphaned anchor surfaced as freshness unknown.

Then read `.waterflow/impressions/` by hand and judge whether the records were
worth querying. **If they were not, fix the schema now**, while a handful of
atoms depend on it rather than all of them.

## Gate 2 — the flow carries real work

A **throwaway implementation**: a small program written to exercise the flow and
then discarded, not a real product. Picking it badly is how this gate passes
without proving anything, so the subject must

- have a real domain, so `define` has terms worth settling;
- carry three to five vertical slices with genuine blocking edges;
- have a testable seam, so `seam`, `test`, and `prove` are all exercised;
- integrate somewhere, so `land` means something;
- be finishable in a sitting or two.

Concretely: `align` produces settled decisions, `shape` produces sliced items on
the state surface with blocking edges, `build` closes each slice with a recorded
proof state, `land` integrates. Then brief a subagent from `recall` output alone
and confirm it does not need the conversation.

Keep it throwaway — marked as such from the first commit, on its own branch,
never promoted to production by inertia. What survives is the impression store it
leaves behind and what the flow taught us, not the code.

**The honest measure:** compare the tokens needed to brief a subagent from
`recall` against pasting conversation. The analysis predicts ~500 against 5-15k.
If it is not roughly that, the store's main justification is wrong and D10 should
be revisited.

---

## Phase 3 — Reach

Intent level. Deliberately unspecified: Gate 2 is what specifies it. Candidates,
in rough priority:

- **`map`** — the fog case, excluded from v1 as the opposite of a small loop.
- **The capability reflex** — one model-invoked skill that fires when the agent is
  about to re-derive a fact the store already holds, and offers the record
  instead. Capability, not enforcement. It needs a populated store, which is why
  it cannot come earlier.
- **A GitHub Issues adapter** for the state surface, matching the local markdown
  one now specified in `state-surface.md`.
- **Host portability hardening**, a docs surface, and binding tier dispatch
  (D5's option B) if advisory proves too easy to ignore.

## v1 non-goals

Stated so scope creep is a visible decision, not drift.

- Technology specialists.
- A governance skill, ADR registry, or claim register. The D1 seam is left open
  so governance can arrive later as a sibling, not a rewrite.
- Deterministic scaffold scripts beyond `check.mjs` and the gate fixtures.
- A docs site.
- `map`.
- Any reflex.
- Binding tier dispatch.
- Embeddings or a vector index for retrieval.

---

## Verification

```
npm test                             # check.mjs + the proof-gate fixtures
claude plugin validate . --strict
```

Both must pass before publishing; CI runs the first on every push. See
`AGENTS.md` for what each covers and for the rule about adding a gate fixture
before changing the gate.
