# Waterflow v1 Build Plan

## Context

Waterflow is a distributable agent-workflow product: skills that install into
other repositories and drive how software gets built there. The repo currently
holds a placeholder scaffold (one router skill, two references, ~5.6 KB).

`plan for skills.md` was written to improve **Crow City's** Scrum process, not to
build Waterflow. Its insights survive; its framing does not. `docs/pre-plan-analysis.md`
(950 lines, decision-complete) replaces it as the source: it tears down both
reference repos, identifies what neither has, and records D1-D11.

The thesis: **Waterflow is a router that sizes the process, the model, the agent
topology, and the proof to the risk of the work, and never silently takes a
decision that belongs to the human.** Two things make it different from the
references. First, model tiering and agent topology as routing dimensions, which
neither Uncle Bob nor Matt Pocock has at all (grep-verified: zero hits). Second,
the **impression store**: atoms emit typed records as a byproduct, so context is
*queried* rather than *loaded*. That is the third answer to the context-loss
problem both references solve badly, and it is why briefing a cold subagent
costs ~500 tokens instead of 5-15k.

Outcome: an installable plugin that carries work from idea to integration in a
small feedback loop, leaving a queryable trail behind it.

**Read `docs/pre-plan-analysis.md` before executing.** This plan assumes it.

---

## Settled decisions (from §8)

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

**One new decision this plan makes: the distribution unit is the plugin, not the
skill.** Uncle Bob's portability rule assumes per-skill install, which would
forbid atoms from sharing the emission contract. Matt ships all 25 skills as one
plugin. Waterflow follows Matt: skills may depend on anything under `skills/`,
never on `scripts/`, `docs/`, CI, or root manifests. This is what makes a single
shared emission contract legal.

---

## Target layout

```
AGENTS.md                      distribution boundary + authoring rules
ATTRIBUTION.md                 D9
.claude-plugin/plugin.json     skills array
.claude-plugin/marketplace.json
.codex-plugin/plugin.json
skills/
  waterflow/                   router (user-invoked)
    SKILL.md
    references/
      dials.md                 the five dials + escalation rule
      lanes.md
      model-tiers.md
      topology.md
      proof.md
      decision-rights.md
      impressions.md           THE SHARED EMISSION CONTRACT
      state-surface.md
  interrogate/ define/ seam/ slice/ test/                atoms
  prove/ critique/ probe/ dig/ recall/                   (model-invoked)
  align/ shape/ build/ land/                             composites (user-invoked)
  authoring/                                             model-invoked
  setup-waterflow/                                       user-invoked
scripts/check.mjs              cheap validation (D7)
docs/pre-plan-analysis.md
docs/build-plan.md             this file, copied in
```

**Description budget:** 11 model-invoked skills (10 atoms + `authoring`), the
same count Matt ships. This is the only permanent context cost. Cap it at 11;
any further atom must displace one.

---

## Phase 0 — Ground

Everything downstream depends on this. Task level.

1. **Strip BOMs** from every tracked file. All currently carry `EF BB BF`;
   `plugin.json` and `.codex-plugin/plugin.json` are the blocking cases, since a
   BOM breaks strict JSON parsers.
2. **Create `.claude-plugin/plugin.json`** with `skills` as an array of skill
   paths, mirroring `.review/mattpocock-skills/.claude-plugin/plugin.json`. Add
   `.claude-plugin/marketplace.json` so the repo is its own single-plugin
   marketplace. Decide whether root `plugin.json` stays (it uses
   `"skills": "skills/"`, a directory string no host documented here reads); if
   kept, it must not contradict the Claude manifest.
3. **Fix `skills/waterflow/SKILL.md` frontmatter.** Drop the non-standard
   `user-invocable` key; keep `name`, `description`, `disable-model-invocation`,
   `argument-hint` — the set Matt's repo uses and validates with
   `claude plugin validate . --strict`.
4. **Write `AGENTS.md`**: the distribution boundary (shipped `skills/` vs.
   factory `scripts/`, `docs/`, manifests, CI), the plugin-as-distribution-unit
   rule, and the D4 rule that no shipped prose may name a project-specific role.
   Adapt from `.review/uncle-bob/AGENTS.md` §"Repository And Distribution
   Boundaries".
5. **Write `ATTRIBUTION.md`** and fix the provenance convention (D9): a
   `source:` line in each borrowed file's frontmatter or header naming the
   upstream path and the commit it was taken at, so drift is diffable later. All
   three repos are MIT, verified.
6. **Write `skills/authoring/SKILL.md`** — the port of `writing-for-agents`
   (**Copy** tier) plus `SKILL-MECHANICS.md`, extended with Waterflow's own
   rules: plain verbs only (D11), no project-specific roles (D4), atom/composite/
   description-budget conventions, and the emission requirement.
7. **Write `scripts/check.mjs`** (Node, no dependencies, replaces the
   Windows-only `list-skills.ps1`): every skill has `SKILL.md`; every relative
   link resolves; frontmatter keys are in the known set; the manifest lists
   exactly the shipped skills; no BOMs anywhere.
8. **Copy this plan to `docs/build-plan.md`.** Leave `plan for skills.md`
   untouched as the captured Crow City source.

**Gate 0:** `node scripts/check.mjs` passes and
`claude plugin validate . --strict` passes on a repo that ships one skill.

---

## Phase 1 — Spine

The router, the contracts, and the store's read/write pair. Task level.

9. **`skills/waterflow/SKILL.md`** — the router. User-invoked (D6). Carries the
   five dials, the escalation/downgrade rule, and the map of every skill below.
   **Hard constraint: it must fit on one screen.** §10 names this as the test of
   the whole thesis; if the router cannot be explained in one screen, the
   product has failed. Everything else goes in `references/`.

10. **`references/dials.md`** — the five dials, one table:

    | Dial | Question | Values |
    |---|---|---|
    | Lane | How much process? | `direct` / `align` / `shape` / `build` |
    | Tier | How much model? | `best` / `good` / `normal` / `low` (advisory, D5) |
    | Topology | How many agents, what shape? | `inline` / `subagent` / `fan-out` / `background` / `fresh session` |
    | Proof | What closes this? | named command, test, artifact, review, human check |
    | Owner | Who decides? | `agent` / `agent recommends, human decides` / `human` |

    Plus the escalation rule (escalate on product direction, architecture,
    unclear seams, conflicting evidence, hard-to-reverse decisions) and its
    inverse.

11. **`references/impressions.md`** — **the single shared emission contract.**
    The highest-value file in the repo and the one thing that must be right
    before any atom is authored. Every atom points at it; none restates it (D10's
    de-risking constraint). Record shape:

    ```
    ---
    id:         2026-08-28-a4f2
    atom:       seam
    subject:    checkout
    lane:       build
    tier:       good
    state:      pass            # prove records only
    revision:   <git sha>       # freshness anchor
    scope:      [src/checkout/]   # paths the claim depends on; [] if none
    supersedes: [2026-08-14-c81b] # ids replaced; [] if none
    tags:       [seam, checkout, payment]
    ---
    One-line gist, then detail.
    ```

    Rules the file must carry: `supersedes` is **mandatory**, not optional
    (this is the eviction mechanism, and without it the store becomes the
    sediment it exists to prevent); retrieval excludes superseded records by
    default; a record is **stale** when a file under its `scope` has changed
    since its `revision`, and a stale record is surfaced as stale, never
    silently served; tags derive only from `atom` and `subject`, nothing
    invented (D11). Retrieval is grep over frontmatter — no embeddings, no
    vector store, since that would break portability.

12. **`references/state-surface.md`** — the D2 adapter contract. Skills call
    operations, never paths: `create_item`, `get_item`, `list_frontier` (items
    whose blockers are all closed), `close_item`. Two adapters: local markdown
    (default) and GitHub Issues. **Keep it distinct from the impression store**:
    the tracker holds *work items*, the store holds *what the flow learned*, and
    impressions stay local files even when the tracker is remote.

13. **Remaining references**: `lanes.md`, `model-tiers.md` (rewrite the existing
    one; de-duplicate against `SKILL.md`), `topology.md` (**Adapt** from
    `PHASE-BOUNDARIES.md`, generalised off `/compact` and `/clear` so it works on
    any host), `proof.md` (`not run | pass | fail | blocked` + UB's freshness
    rule), `decision-rights.md`.

14. **`skills/prove/`** and **`skills/recall/`** — the store's write and read
    halves, the first two atoms. `prove` runs named proof and records state +
    revision. `recall` queries the store by tag, newest-first, superseded
    excluded. These two ship first because they are what makes the store
    testable at all.

15. **`skills/setup-waterflow/`** — user-invoked. **Adapt** from
    `setup-matt-pocock-skills`. Resolves: state surface (D2), host, ceremony
    profile, the D4 authority label, and where impressions live. Writes config
    plus an `## Agent skills` block into the consumer's `CLAUDE.md`/`AGENTS.md`.
    Must handle the greenfield case **and** mapping onto a repo that already has
    a process (a `vision.md` / `backlog.md` / `sprints/` tree, or similar) from
    the start. No consumer is named (D8), so neither case can be deferred as
    "the one we do second".

**Gate 1:** install into a real repo, route three real pieces of work through
the router, then read the impressions left behind and judge whether they were
worth querying. If they were not, fix the schema now, while two atoms depend on
it rather than twelve.

---

## Phase 2 — Flow

Idea to integration, end to end. Outcome level: authored in dependency order,
each atom proven on real work before the next, each emitting against the Phase 1
contract. By the end of this phase, emission is complete (D10).

**Remaining atoms** (model-invoked, each one operation):

- `interrogate` — frontier rounds; facts are the agent's job, decisions the
  human's. **Copy** from `grilling`.
- `define` — domain language: challenge terms, settle the glossary, record
  hard-to-reverse decisions. **Copy** `CONTEXT-FORMAT.md` and `ADR-FORMAT.md`.
  (Renamed from the analysis's `name` per D11's consequence.)
- `seam` — choose and confirm the proof seam before any test is written.
  **Copy** the `codebase-design` glossary.
- `slice` — vertical tracer bullets with blocking edges. **Adapt** `to-tickets`,
  including expand/migrate/contract for wide refactors.
- `test` — write one failing test at the agreed seam, make it pass. **Copy**
  `tdd/tests.md` and `mocking.md`. **Required:** both `test/SKILL.md` and
  `prove/SKILL.md` must open with a one-line disambiguation — `test` *writes* a
  test, `prove` *runs and records* evidence. The name was chosen over `tdd` for
  D11 compliance in full knowledge that it needs this line; if the confusion
  shows up in real use anyway, rename to `tdd` rather than adding more prose.
- `critique` — two-axis review in parallel subagents, never re-ranked across
  axes. **Adapt** `code-review`, stripping its tracker dependency.
- `probe` — throwaway prototype answering one question. **Adapt** `prototype`.
- `dig` — research against primary sources, dispatched to background. **Adapt**
  `research`.

**Composites** (user-invoked, thin declarations only — if one grows rules of its
own, the rules belong in an atom):

- `align` = `recall` + `interrogate` + `define`
- `shape` = `align` + `seam` + `slice`
- `build` = `recall` + `test`(×n) + `prove` + `critique`
- `land` = `critique` + `prove` + integrate

**Also in Phase 2:** the proof gate as a **pre-commit hook or CI check**, not a
skill. D6 rejected the reflex because a proof-gate reflex is inert on unrouted
work (no impressions exist) and redundant on routed work (`land` already checks).
A hook does the job deterministically at zero context cost.

**Every borrow must be audited on copy** for references to upstream skills,
upstream config paths (`docs/agents/*.md`), and upstream label vocabularies.
`to-spec`, `to-tickets`, `code-review`, `wayfinder`, and `triage` all contain
"run `/setup-matt-pocock-skills`" and would ship a dangling pointer.

**Gate 2:** the **throwaway implementation** (see below) carried idea →
integration through the flow, with the impression store queried at least once to
brief a subagent instead of pasting context.

### The throwaway implementation

Phase 2's proof is a small program written to exercise the flow and then
discarded, not a real product. Picking it badly is how this gate passes without
proving anything, so the subject must:

- have a real domain, so `define` has terms worth settling;
- carry three to five vertical slices with genuine blocking edges;
- have a testable seam, so `seam`, `test`, and `prove` are all exercised;
- integrate somewhere, so `land` means something;
- be finishable in a sitting or two.

Keep it throwaway: marked as such from the first commit, on its own branch, and
never promoted to production by inertia. What survives is the impression store
it leaves behind and what the flow taught us, not the code.

---

## Phase 3 — Reach

Intent level. Deliberately unspecified: Phase 2 is what specifies it.

Candidates, in rough priority: `map` (the wayfinder-shaped fog case, excluded
from v1 as the opposite of a small loop); the **capability reflex** — one
model-invoked skill that fires when the agent is about to re-derive a fact the
store already holds, and offers the record instead (capability, not enforcement,
and it needs a populated store, which is why it cannot be earlier); host
portability hardening; a docs surface; binding tier dispatch (D5's option B) if
advisory proves too easy to ignore.

---

## Verification

**Per-phase, cheap:**

```
node scripts/check.mjs                 # skills, links, frontmatter, manifest, BOMs
claude plugin validate . --strict      # plugin manifest
```

**Gate 0:** both commands pass.

**Gate 1:** in a real repo — `/setup-waterflow` completes and writes config;
`/waterflow` routes three real pieces of work and reports all five dials each
time; `prove` writes records; `recall` returns them by tag with superseded
excluded and a stale record surfaced as stale. Inspect
`.waterflow/impressions/` by hand and judge the schema.

**Gate 2:** the throwaway implementation carried idea → integration. Concretely:
`align` produces settled decisions, `shape` produces sliced items on the state
surface with blocking edges, `build` closes each slice with a recorded proof
state, `land` integrates. Then brief a subagent from `recall` output alone and
confirm it does not need the conversation.

**Ongoing, honest measure:** compare tokens to brief a subagent from `recall`
against pasting conversation. The analysis predicts ~500 vs. 5-15k. If it is not
roughly that, the store's main justification is wrong and D10 should be
revisited.

---

## v1 non-goals

Stated so scope creep is a visible decision, not drift.

- Technology specialists (Uncle Bob's six).
- A governance skill, ADR registry, or claim register. The D1 seam is left open
  so governance can arrive later as a sibling, not a rewrite.
- Deterministic scaffold scripts beyond `check.mjs`.
- A docs site.
- `map` / wayfinder.
- Any reflex.
- Binding tier dispatch.
- Embeddings or a vector index for retrieval.
- Rewriting `plan for skills.md`.
