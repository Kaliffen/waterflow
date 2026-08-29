# Waterflow Build Plan

Written 2026-08-29, replacing the plan for the phases that are now done. Their
task lists are in `CHANGELOG.md` and in git history.

## Where this stands

Verified today, not asserted: 16 skills, 11 of 11 model-invoked descriptions
against the budget, 43 files checked by `scripts/check.mjs`, 18 of 18 proof-gate
fixtures passing, and `claude plugin validate . --strict` clean.

What exists is the whole shape: the router, nine references, ten atoms,
`authoring`, four composites, the proof gate, and CI. The plugin loads with
`claude --plugin-dir <checkout>` and routes work.

---

## Settled decisions

These are the decisions the rules rest on. The teardown they were argued out of
has been deleted, so this table is now the record: it says what was settled, not
why, and a rule that no longer matches its decision is a contradiction to be
raised rather than quietly resolved.

| | Decision |
|---|---|
| D1 | Atomic composable operations, idea to integration, small loop. Workflow, not OS |
| D2 | State-surface adapter resolved by convention, overridden by `.waterflow/config.md` |
| D3 | One lean profile; lanes carry the variation |
| D4 | Neutral authority term, configurable label |
| D5 | Tier dial is advisory, not binding |
| D6 | User-invoked router, model-invoked atoms, **no reflex** |
| D7 | Cheap verification only: nothing in CI asks a model anything |
| D8 | No pilot consumer. A throwaway implementation is the test subject |
| D9 | Copy per the borrow ledger, `ATTRIBUTION.md` plus a `source:` line per file |
| D10 | Impression store, **full emission**, one shared emission contract |
| D11 | Plain verbs, no metaphor in the working vocabulary |
| D12 | The distribution unit is the plugin, not the skill |

Two of these carry consequences worth restating where they are read. D2 is why
there is no setup step: `setup-waterflow` was removed, and the adapter resolves
by convention on first write. D12 is what makes a shared emission contract legal
at all — skills may depend on anything under `skills/`, never on `scripts/`,
`docs/`, CI, or root manifests.

**Description budget: 11 model-invoked skills** (10 atoms plus `authoring`). The
only permanent context cost Waterflow imposes on a consumer. A twelfth must
displace one; `check.mjs` enforces the cap.

---

## Gate 1 — the store is worth querying

In a real repository, with no setup step: `/waterflow` routes three real pieces
of work and reports all five dials each time; atoms emit as a byproduct; `recall`
returns records by tag with superseded excluded, a stale record surfaced as
stale, and an orphaned anchor surfaced as freshness unknown.

Then read the store by hand and judge whether the records were worth querying.
**If they were not, fix the schema now**, while a handful of atoms depend on it
rather than all of them. This is the last cheap moment to change the record
shape.

Three things the gate must exercise that nothing has yet:

- **The fold.** Consolidation has never run. `history/` is empty in every
  checkout, so the watermark move, the superseded sweep, and the `kind` backfill
  are specified in detail and untested against a real store. It is the most
  intricate procedure in the design and the only one with no fixtures behind it.
- **Re-anchoring at integration.** `land` step 3 claims most records are anchored
  before the work they describe and brings them forward. Whether that is true,
  and whether a run can actually carry it out, is unknown.
- **Firing unrouted.** The rule that an atom fires without dials and takes the
  defaults was added on 2026-08-29 and has never run. It is the common path.

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
proof state, `land` integrates and consolidates. Then brief a subagent from
`recall` output alone and confirm it does not need the conversation.

Keep it throwaway, marked as such from the first commit, on its own branch, never
promoted to production by inertia. What survives is the impression store it
leaves behind and what the flow taught us, not the code.

**The honest measure:** compare the tokens needed to brief a subagent from
`recall` against pasting conversation. The prediction is roughly 500 against
5-15k. If it is not roughly that, the store's main justification is wrong and D10
should be revisited.

### Bring the evidence back

A gate run outside this repository proves nothing to this repository. Whatever
subject carries Gate 2, its verdict lands here: the token comparison, the schema
judgement, and any defect the run exposed, written where the next reader finds
them. A gate whose result lives only in a session that has ended has not been
passed, it has been performed.

---

## Phase 3 — what the gates unlock

Deliberately unspecified until the gates report. Candidates, in rough priority:

- **The capability reflex** — one model-invoked skill that fires when the agent
  is about to re-derive a fact the store already holds, and offers the record
  instead. Capability, not enforcement. It needs a populated store, which is
  exactly why it cannot come before Gate 1.
- **A GitHub Issues adapter** for the state surface, matching the local markdown
  one specified in `state-surface.md`. The contract exists; only the local
  binding is implemented.
- **`map`** — the fog case, excluded from v1 as the opposite of a small loop.
  Reconsider only if Gate 2 shows that splitting the fog genuinely fails.
- **Binding tier dispatch**, D5's alternative, if advisory proves too easy to
  ignore. The gates are what would show that.
- **Host portability hardening** and a docs surface.

---

## Known defects, carried

Small, real, and not blocking a gate. Fix each when the file is open anyway.

- **The proof gate is invisible from inside the flow.** `proof-gate.sh` ships in
  `skills/waterflow/` and is documented only in the README. No skill or reference
  mentions it, so an agent running Waterflow will never suggest it exists. Either
  the router names it, or it is not really part of the product.
- **The README quickstart hardcodes a personal checkout path.** Known and
  accepted for now; it is the first command a new reader copies.

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

Both must pass before publishing; CI runs the first on every push.
`check.mjs` covers structure, frontmatter, links, the plugin manifest, BOMs and
control characters, and the description budget; `scripts/test-proof-gate.sh`
drives the gate against a throwaway repository. A change to the gate adds its
fixture first.

Neither validator can tell you whether the flow works. That is what the gates are
for, and it is why nothing above treats a green check as progress toward them.
