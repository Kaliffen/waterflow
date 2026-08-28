# Waterflow: Pre-Plan Analysis

Status: **decision-complete.** D1-D11 settled in grilling rounds on 2026-08-28
(§8). This document is the input the build plan is written from.

No open inputs.

Sources read in full or in depth:

- `.review/uncle-bob/` (robert-hoffmann/uncle-bob)
- `.review/mattpocock-skills/` (mattpocock/skills)
- `plan for skills.md`
- the current Waterflow scaffold

---

> `plan for skills.md` was the captured Crow City source. It was removed once
> its insights had been absorbed here; recover it with
> `git show 434f5c4:"plan for skills.md"`.

## 1. The Framing Bug In `plan for skills.md`

`plan for skills.md` is a good document aimed at the wrong repository.

It is written as a plan to improve **Crow City's** Scrum process: it names
`vision.md`, `backlog.md`, `sprints/sprint-<n>.md`, `tech-decisions.md`,
`.codex/agents/product-owner.md`, and Crow City domain terms (`Tenancy`,
`Journey`, `Projection`, `Durable Event`). Its migration plan is "update
`scrum-conventions.md`, then apply to the next sprint."

Waterflow is a different kind of thing. It is a **distributable workflow
product**: skills, role prompts, and references that install into *other*
people's repositories and drive how software gets built there. It has no
sprints of its own to apply anything to.

That distinction changes almost every design conclusion:

| | Consuming repo (Crow City) | Publishing repo (Waterflow) |
|---|---|---|
| Domain terms | Concrete, project-specific | Must be domain-agnostic |
| State artifacts | Fixed paths the team agreed | Must be an *adapter contract*, since consumers differ |
| Roles | Creative Director / PO / SM / Dev | Roles must be optional overlays, not required |
| Success test | Did the next sprint go better? | Did it install cleanly and change agent behaviour in someone else's repo? |
| Ceremony budget | Whatever the team tolerates | Near zero, or nobody adopts it |
| Validation | Human sign-off | Deterministic checks, because there is no human in the consumer's loop |

**What survives the reframe** (the durable insights, which are good):

- lane selection before planning
- decisions separated from delivery
- vertical slices with explicit blockers and test seams
- named, fresh proof before "done"
- two-axis review (spec fidelity vs design quality)
- model tiers behind stable names
- routers plus trigger-loaded references
- prototypes as decision evidence

**What must be dropped or rewritten:**

- every Crow City path, role name, and glossary term
- "Creative Director" as a hardcoded role (see §8, Decision 4)
- the migration plan (steps 1-7), which has no meaning here
- `CONTEXT.md` as a *Waterflow* artifact; it is a thing Waterflow tells
  consumers to keep, not a thing Waterflow keeps

**Recommendation:** keep `plan for skills.md` as a captured source, and write
the build plan as a new document. Do not edit it into shape; the framing is
load-bearing and rewriting in place will leave sediment.

---

## 2. Current Scaffold: Inventory And Defects

Seven content files, ~5.6 KB total.

```
skills/waterflow/SKILL.md              router, 1.7 KB
skills/waterflow/references/model-tiers.md
skills/waterflow/references/workflow-shape.md
skills/waterflow/agents/openai.yaml
agents/waterflow-planner.agent.md
docs/design.md                         398 bytes
scripts/list-skills.ps1
plugin.json / .codex-plugin/plugin.json
```

The shape is right: one router, references beside it, agents separate, thin
manifests. The content is a placeholder. Concrete defects found:

1. **Every file carries a UTF-8 BOM** (`EF BB BF`), including `plugin.json`
   and `.codex-plugin/plugin.json`. A BOM in JSON breaks strict parsers. This
   is a hard blocker on any host that validates the manifest.
2. **No `.claude-plugin/` directory.** Claude Code reads
   `.claude-plugin/plugin.json` with `skills` as an **array of skill paths**
   (see `.review/mattpocock-skills/.claude-plugin/plugin.json`), plus an
   optional `.claude-plugin/marketplace.json` so the repo is its own
   single-plugin marketplace. Waterflow's root `plugin.json` uses
   `"skills": "skills/"`, a directory string. As it stands the repo is not
   installable as a Claude Code plugin.
3. **`SKILL.md` frontmatter carries both `user-invocable: true` and
   `disable-model-invocation: false`.** These say the same thing twice, one of
   them in a non-standard key. Pick the documented one.
4. **The router description has no non-use boundary.** Uncle Bob's authoring
   convention (`.agents/skills/ub-authoring/references/authoring-conventions.md`
   §1) and Matt's `writing-for-agents` both treat the description as routing
   logic. "Use when designing, updating, or applying an agent workflow or skill
   system" will misfire on ordinary planning requests.
5. **`references/workflow-shape.md` and `SKILL.md` duplicate the lane list and
   the tier mapping verbatim.** Duplication of *meaning* (as opposed to
   deliberate repetition of a leading word) is the pruning failure
   `writing-for-agents` names: two places to edit, inflated prominence.
6. **`agents/waterflow-planner.agent.md` uses `tools: [read, search, web]`**,
   which is a Copilot-flavoured agent schema. No host contract is documented
   for `agents/`, so it is currently decorative.
7. **`scripts/list-skills.ps1` is Windows-only.** Fine for a private repo,
   a portability smell for a public one.

None of this is expensive to fix. It is listed so the plan can carry a
"scaffold hygiene" task rather than discovering it mid-build.

---

## 3. Reference Teardown

### 3.1 Uncle Bob

**Shape.** Ten skills under `.agents/skills/`: two control skills
(`ub-workflow`, `ub-governance`), one always-on companion (`ub-quality`), an
authoring skill (`ub-authoring`), a customizations skill, and six technology
specialists (python, ts, vue, nuxt, css, tailwind).

**Workflow model.** A product-agile hybrid living in a scaffolded tree at
`./.ub-workflows/`:

```
Product Vision -> Product Options -> Outcome Waves -> Initiatives -> Discoveries -> Sprints
```

Declared influences: dual-track agile, goal-oriented roadmapping, Scrum sprint
execution, Kanban flow controls, Shape Up appetite and circuit breakers.

**What is genuinely excellent here, and worth taking:**

- **Trigger-token reference loading.** Load instructions are tagged
  machine-legibly: `[phase:gate-eval|closeout|readiness]`,
  `[edge:trace-token|trace-lookup|workflow-search]`. This is a real advance
  over "read X when relevant". It makes progressive disclosure auditable, and
  it is checkable by a script.
- **Explicit distribution boundary.** `AGENTS.md` names distributable surfaces
  vs factory surfaces and forbids skills from depending on repo tooling, CI,
  root `Taskfile.yml`, or the repo's own workflow tree. A skills product needs
  exactly this rule, written down, before the first skill ships.
- **Gate states as a closed set:** `pass | fail | blocked`. Three words that
  make status machine-readable and stop "mostly done".
- **Profiles.** `lean` by default, `advanced` only with explicit rationale.
  Ceremony as a dial, not a constant.
- **The Objective-Complete Rule.** "When a sprint says `smallest` or `narrow`,
  interpret it as the smallest objective-complete vertical slice, not the
  smallest patch that makes the first focused test pass." This is a direct
  patch for a real and common agent failure mode.
- **Evidence freshness.** Blocking artifacts must map to the current evaluated
  revision; stale proof must be regenerated or explicitly excepted. Matt's repo
  has no equivalent.
- **The testing signal taxonomy** (`TG001`-`TG011`): type-redundancy tests,
  interaction-without-outcome, pass-through tests, happy-path-only suites,
  mock-dominant tests, snapshot/coverage-only proof. A mechanizable test-smell
  vocabulary.
- **The repo validates itself.** `scripts/repo-maintenance/` checks skill
  schema, skill integrity, repo paths, catalog sync, package metadata; `tests/`
  runs pytest over the scaffold and governance scripts; CI enforces docs sync.

**What to refuse:**

- **The 45-clause embedded contract in `ub-workflow/SKILL.md`.** It is 325
  lines of always-loaded rules, in a skill whose own doctrine is progressive
  disclosure. The skill breaks its own rule at the top level.
- **Vocabulary weight.** "Appetite-Boxed forecasting", "T4 claim-to-proof
  router", "Discovery Triage is a fail-closed Routing Preflight",
  `context_tier`, `summary_budget_lines`, trace tokens. Each may be
  individually defensible; together they are a language a new user must learn
  before doing anything. Measured against `writing-for-agents`' leading-word
  test, most of these are coined words that recruit no priors, so they are paid
  for in definition tokens.
- **The `.ub-workflows/` tree.** A bespoke directory the consumer must scaffold
  and maintain, parallel to whatever they already use. High adoption cost, and
  it competes with the issue tracker they already have.
- **Six technology specialists.** Out of scope for a workflow product, and they
  are the part that ages fastest.

**One-line verdict:** the most *rigorous* of the two, and the least
*adoptable*. Its ceremony floor is above what a solo or small team will pay.

### 3.2 Matt Pocock

**Shape.** 25 promoted skills across `engineering/` and `productivity/`, plus
`misc/`, `in-progress/`, and `deprecated/` buckets that ship in neither the
plugin nor the docs. Bucket membership *is* the release channel.

**Stated thesis** (README): "Approaches like GSD, BMAD, and Spec-Kit try to
help by owning the process. But while doing so, they take away your control and
make bugs in the process hard to resolve." The skills are deliberately small,
composable, and hackable.

**The main flow**, per the `ask-matt` router:

```
grill-with-docs  ->  [prototype detour via handoff]  ->  to-spec  ->  to-tickets
                                                                          |
                                                       implement (per ticket, /clear between)
                                                                          |
                                                            tdd (red/green slices)
                                                                          |
                                                            code-review (2 parallel axes)
```

On-ramps that merge onto it: `triage` (incoming issues), `diagnosing-bugs`
(something broke), `wayfinder` (fog too thick for one session). Underneath:
`domain-modeling` and `codebase-design` as vocabulary layers.

**What is genuinely excellent here, and worth taking:**

- **`writing-for-agents` is the best theory of agent-document design in either
  repo.** Its levers: context pointers and their branch triggers; the two loads
  (**context load** on the agent's window vs **cognitive load** on the human,
  who is the index); the information hierarchy (in-file step -> in-file
  reference -> disclosed reference); completion criteria graded on *clarity*
  and *demand*; premature completion and post-completion pull; leading words
  that recruit pretraining priors; negation as a failure mode ("don't think of
  an elephant"); pruning against no-ops, duplication, caches, and sediment.
  Waterflow should adopt this wholesale as its authoring standard.
- **The invocation trade.** Model-invoked = permanent context load, buys agent
  discovery. User-invoked = zero context load, spends cognitive load. Router
  skills exist to pay down accumulated cognitive load. This is the sharpest
  single idea in either repository.
- **Grilling.** Rounds over a design tree; ask the whole *frontier* at once,
  numbered, each with a recommended answer; **facts are the agent's job,
  decisions are the user's**; done when the frontier is empty. Dispatch
  subagents for facts, never ask the user something you could look up.
- **Phase boundaries.** An ordered five-option tree (continue / clear / handoff
  / subagent / compact) with primary-vs-secondary-source reasoning and the
  smart-zone budget. Context-window engineering treated as a first-class
  engineering decision. Nothing comparable exists in Uncle Bob.
- **Vertical tracer-bullet slicing** with explicit **blocking edges**, plus a
  named exception: wide mechanical refactors run **expand -> migrate in
  blast-radius batches -> contract** instead.
- **Seams agreed before tests are written.** "No test is written at an
  unconfirmed seam." Use the highest seam that still gives specific proof;
  fewer seams is better; the ideal number is one.
- **Two-axis review with deliberate non-merging.** Standards and Spec run as
  parallel subagents so they cannot pollute each other, and the aggregator is
  explicitly forbidden from re-ranking across axes, because that is the masking
  the separation exists to prevent.
- **`diagnosing-bugs` Phase 1.** Refuse to theorise until one command exists
  that has already been run and goes **red** on this bug. A binary, observable
  completion criterion in place of a fuzzy one.
- **Setup as an adapter.** `setup-matt-pocock-skills` writes per-repo config to
  `docs/agents/*.md` and an `## Agent skills` block in the consumer's
  `CLAUDE.md`/`AGENTS.md`. State lives in the tracker the consumer already has
  (GitHub / GitLab / local `.scratch/`), never in a bespoke tree.

**What to refuse or repair:**

- **No proof model.** A ticket closes when the agent says so. There is no
  evidence state, no named artifact, no freshness rule. `implement` says "run
  the full test suite once at the end" and that is the whole contract.
- **No gate vocabulary.** Nothing corresponds to `pass | fail | blocked`.
- **No cost or model awareness anywhere** (see §4).
- **Subagents used ad hoc.** Nine skills dispatch them, each with private
  conventions; there is no shared briefing contract, no rule for merging
  conflicting reports, no guard against overspawn.
- **`ask-matt` can only hint.** Being user-invoked, it cannot fire the skills
  it routes to; the human is still the executor of the route.
- **Repo self-validation is thin** compared to Uncle Bob: `claude plugin
  validate` and a dev-only symlink script.

**One-line verdict:** the most *adoptable* and best-written of the two, and the
least *accountable*. It tells you how to think; it does not check whether the
work was actually proven.

### 3.3 Side By Side

| Axis | Uncle Bob | Matt Pocock |
|---|---|---|
| Core bet | Durable artifacts survive context loss | Composable primitives keep the human in control |
| Process ownership | Owns the process | Explicitly refuses to |
| State home | Bespoke `.ub-workflows/` tree | The consumer's existing issue tracker |
| Ceremony floor | High | Very low |
| Entry cost | Learn a vocabulary first | Type one slash command |
| Proof discipline | Strong (states, freshness, taxonomy) | Absent |
| Decision rights | Implied by interaction mode | Stated: facts agent, decisions human |
| Reference loading | Trigger tokens, machine-legible | Prose pointers, well-written |
| Context engineering | `context_tier`, budgets | Phase boundaries, smart zone, primary sources |
| Self-validation | Scripts + pytest + CI | `plugin validate`, docs conventions |
| Prose quality | Dense, bureaucratic | Excellent |
| Model tiering | **None** | **None** |
| Agent topology contract | **None** | Practice without doctrine |
| Adoption risk | Nobody pays the ceremony | Nobody proves the work |

The two failure modes are mirror images. That symmetry is the opening.

---

## 4. What Neither Repository Has

Verified by grep across both trees:

- **Model tiering: zero hits in Uncle Bob.** One incidental mention in one of
  Matt's docs pages, none in any skill. Neither repo's workflow contract knows
  that models differ in strength or price.
- **Agent topology: no shared contract in either.** Uncle Bob mentions
  subagents only in customizations and docs, never as a workflow decision.
  Matt dispatches them in nine skills, each on its own terms.

Four gaps follow, and they are Waterflow's actual contribution:

**Gap 1: Risk-to-tier routing.** A phase has a *price*. Planning a disputed
architecture and renaming a config key should not run on the same model. The
plan document already has the durable framing (stable tier names
`best`/`good`/`normal`/`low`, concrete model names as current examples only),
and it is unclaimed by both references.

**Gap 2: Agent topology as a routing decision.** Alongside "which tier", a
workflow now has to answer "which shape": inline, one scoped subagent, parallel
fan-out (Matt's two-axis review and design-it-twice are both this),
background/AFK, or a fresh session. There is a real cost curve here (each cold
spawn re-derives context) and a real failure mode (overspawn). Nobody has
written the contract.

**Gap 3: Proof that is light enough to use.** Uncle Bob's evidence machinery is
correct and too heavy; Matt has none. The middle is small: four states
(`not run | pass | fail | blocked`), evidence named as a command or artifact
rather than described, and a freshness rule tied to the current revision. That
is roughly one page, and it closes Matt's biggest hole without importing Uncle
Bob's weight.

**Gap 4: Decision rights, written as a table.** Both gesture at it. Neither
writes down which decisions the agent takes alone, which it recommends and the
human settles, and which it must never take. For a workflow whose premise is
human creative authority, that table is the product.

---

## 5. Proposed Thesis: Route By Risk

One sentence: **Waterflow is a router that sizes the process, the model, the
agent topology, and the proof to the risk of the work, and never silently takes
a decision that belongs to the human.**

Every non-trivial request gets five dials set explicitly, and reported:

| Dial | Question | Values (draft) |
|---|---|---|
| **Lane** | How much process? | `direct` / `discovery` / `spec` / `build` / `map` |
| **Tier** | How much model? | `best` / `good` / `normal` / `low` |
| **Topology** | How many agents, in what shape? | `inline` / `subagent` / `fan-out` / `background` / `fresh session` |
| **Proof** | What closes this? | named command, test, artifact, review, human check |
| **Owner** | Who decides? | `agent` / `agent recommends, human decides` / `human` |

Matt has Lane implicitly and Owner in prose. Uncle Bob has Lane and Proof.
Nobody has Tier or Topology. All five in one contract is new, and it is small
enough to state on one page, which is the test that matters.

The escalation rule the plan document already drafted is the right shape and
generalises to all five dials: escalate when product direction, architecture,
unclear seams, conflicting evidence, or hard-to-reverse decisions are involved;
downgrade when the decision is already made, the change is mechanical, and the
output is deterministically verifiable.

**Naming note.** "Waterflow" reads against "waterfall": flow finds the path the
terrain allows. There is a metaphor available (channels, catchment, watershed).
`writing-for-agents` argues both ways on this: a leading word that recruits
priors is free leverage, but a coined vocabulary is paid for in definition
tokens. **Settled in D11: use the name, resist the metaphor.** Dial values, atom
names, and composite names are all plain verbs.

---

## 5.1 The Impression Store

Loose idea under evaluation: *water has memory*. What travels through the flow
leaves impressions; the accumulated impressions **are** the state; indexed and
tagged, every actor pulls only what it needs instead of loading everything.

**Verdict: this is coherent, and it is probably the keystone rather than a
feature.** It is the answer to the problem both references fail at, and it makes
the rest of the architecture pay off.

### Why it is the keystone

Both reference repos are solving one problem, context loss across sessions, with
opposite and equally unsatisfying answers:

- **Uncle Bob** writes everything down in a heavy scaffolded tree. Durable, but
  the content is *narrative* (closeouts, decision logs, retros), so retrieving
  one fact means reading prose.
- **Matt** keeps it in one window and, when he cannot, compacts or hands off.
  `PHASE-BOUNDARIES.md` is explicit that every move except Continue turns a
  primary source into a lossy secondary one.

The impression store is a genuine third answer: **do not store narrative, store
indexed impressions.** Context stops being *loaded* and becomes *queried*, which
converts compaction from lossy-summary into selective-retrieval.

Four ways it locks into decisions already made:

1. **D1 enables it.** A phase-shaped monolith emits mush; an **atom** is one
   well-defined operation with one well-defined output, so it can emit one typed
   record. The atomic paradigm is what makes structured emission possible. These
   two ideas are load-bearing for each other.
2. **It generalises the proof ledger rather than adding a subsystem.** `prove`
   already has to record state, evidence, and revision. Proof becomes one
   impression type among several; no new machinery.
3. **It is the real answer to force 3.** The description budget problem is that
   always-loaded text is scarce. An index makes references retrievable instead
   of loaded. Uncle Bob's trigger tokens are a manual approximation of exactly
   this.
4. **It gives the Topology dial teeth.** Subagents are expensive because every
   cold spawn re-derives context. Briefing one with a query result instead of a
   re-derivation is what makes fan-out cheap. This is the strongest single
   argument for the idea.

### Concrete shape

Each atom emits one record. Roughly thirty lines of contract, no dependencies:

```
---
id:         2026-08-28-a4f2
atom:       seam           # which operation left this impression
subject:    checkout       # what it was about
lane:       build
tier:       good
state:      pass           # proof records only
revision:   <git sha>      # freshness anchor
scope:      [src/checkout/]    # paths the claim depends on; [] if none
supersedes: [2026-08-14-c81b]  # ids replaced; [] if none
tags:       [seam, checkout, payment]
---
One-line gist, then detail.
```

The properties that matter:

- **`supersedes` gives eviction without deletion.** The shape of the record set
  changes as new impressions displace old ones, which is the metaphor working
  correctly rather than decoratively.
- **`revision` plus `scope` buys Uncle Bob's freshness rule for free.** An
  impression is stale by construction, not by judgement, once a file under its
  `scope` has changed since its `revision`. Anchoring on `revision` alone was
  the first draft and was wrong: every record would go stale on the next commit,
  and a label that is always on is a label nobody reads.
- **The tag axes are `atom` and `subject`**, both already named elsewhere in the
  system. No new vocabulary, which is the UB tax this avoids.
- **Retrieval is grep over frontmatter.** Portable, dependency-free, and it
  survives force 1.

Killer use case to name in the plan: **briefing a subagent.** Not "here is the
conversation" but "here are the six live impressions tagged `checkout`,
newest first, superseded ones excluded."

### Where it breaks

Five failure modes, all real:

1. **An index that lies is worse than no index.** Impressions drift from reality
   when code changes and the record does not. *Mitigation:* `revision` plus a
   hard rule that a stale impression is surfaced as stale, never silently
   served.
2. **It can become the sediment it exists to prevent.** Monotonic growth is
   Uncle Bob's tree with extra steps. *Mitigation:* `supersedes` must be
   mandatory, not optional, and retrieval must exclude superseded records by
   default.
3. **Tag vocabulary is a vocabulary tax.** Freeform tags are useless for
   retrieval; controlled tags are a taxonomy to learn. *Mitigation:* tags derive
   from the dials and atom names only. Nothing invented.
4. **Retrieval mechanism is a portability decision.** Filesystem plus grep is
   portable. Embeddings or a vector store is not, and would violate force 1.
   *Recommend* frontmatter plus grep for v1, with the record schema designed so
   a richer index could be layered later without a rewrite.
5. **Scope risk.** This could balloon into "build a knowledge graph", which is
   not idea-to-integration in a small loop. *Mitigation:* it stays a
   **byproduct with a schema**, never a curation task. If any step asks a human
   to maintain the store, the design has failed.

### One distinction to keep straight

The impression store is **not** the state surface from D2. The tracker (GitHub
Issues, local markdown) holds *work items*; the impression store holds *what the
flow learned*. They can and probably should differ: impressions want to be local
files, greppable and versioned alongside the code, even when the tracker is
remote. The plan should name them as two surfaces with one adapter each.

### On the metaphor

"Water has memory" is also a homeopathy claim, so the phrase will draw a joke if
it ships as public-facing branding. The engineering claim underneath is narrower
and better: *the flow leaves structured residue; residue is queryable; queries
beat loading.* Keep the metaphor for thinking, ship the plain statement. D11 settles the
general rule: the metaphor never enters the working vocabulary.

---

## 6. Architectural Forces

Constraints the plan has to satisfy, whatever it decides:

1. **Portability is a hard boundary, not an aspiration.** Adopt Uncle Bob's
   rule verbatim in spirit: a shipped skill may depend only on its own
   `SKILL.md`, its `references/`, its `assets/`, its `scripts/`, and explicitly
   named sibling skills. Never on Waterflow's CI, root scripts, docs, or
   manifests. Write this into `AGENTS.md` before the first skill.
2. **Multi-host from day one.** Claude Code (`.claude-plugin/plugin.json`,
   skills array), Codex / Agent Skills (`~/.agents/skills`,
   `agents/openai.yaml`), and plain `AGENTS.md` consumers. Frontmatter that
   only one host understands is a portability bug.
3. **Always-loaded text is the scarce resource.** Every model-invoked
   description costs on every turn in every consumer repo, forever. The
   description budget is the real design constraint on how many skills ship.
4. **The consumer's state surface varies.** GitHub Issues, Linear, local
   markdown, or an existing bespoke Scrum tree. Skills must talk to a *state
   contract*, resolved once at setup, and must never hardcode a path. Because no
   pilot consumer is named (D8), the adapter must handle the greenfield case and
   the map-onto-existing-artifacts case from the start, not one then the other.
5. **Ceremony must be a dial with a near-zero floor.** Uncle Bob's `lean` /
   `advanced` profile idea, applied to the whole product: a one-line fix must
   cost one line of process.
6. **The repo must validate itself,** because the consumer has no way to tell a
   broken skill from a working one until it misfires. Minimum: every skill has
   `SKILL.md`; every relative link resolves; every frontmatter field is in the
   host's schema; manifests list exactly the shipped skills; no BOMs.
7. **Dogfooding is the only honest test.** Waterflow's own build must run on
   Waterflow's own workflow. If the conventions are painful to author under,
   that is the finding.

---

## 7. Candidate Surface (Sketch, Not A Decision)

Settled by D1: the paradigm is **atomic operations that compose into larger
ones**, covering **idea to integration** in a small repo-local feedback loop.
Workflow, not operating system. That is a stronger constraint than "fewer
skills", and it dictates the shape below.

### 7.1 The composition model

An atom does **one operation** and can be called by anything. A composite is a
**thin declaration of a sequence of atoms**, not a bigger skill with its own
embedded rules. Matt proves the pattern at its limit: `grill-with-docs` is, in
full, "Call the Skill tool twice, for `grilling` and `domain-modeling`." A
composite costs about five lines.

The rule that follows: **no rule lives in two places.** If a composite needs
behaviour, it invokes the atom that owns it. If two atoms need the same rule, it
becomes a reference file both point at, never text copied into both.

### 7.2 Invocation follows from composition

Matt's 25 promoted skills sort cleanly into three categories, and the category
determines the frontmatter mechanically:

| Category | Invocation | Reason | Matt's examples |
|---|---|---|---|
| **Entry point** | user-invoked | the human types it to start a loop | `ask-matt`, `to-spec`, `to-tickets`, `implement`, `wayfinder`, `triage` (14 total) |
| **Primitive** | model-invoked | *another skill must be able to call it* | `grilling`, `tdd`, `code-review`, `domain-modeling`, `prototype`, `research`, `codebase-design`, `writing-for-agents` |
| **Reflex** | model-invoked | must fire on a condition without being asked | `diagnosing-bugs`, `wizard`, `resolving-merge-conflicts` |

This is a hard mechanical constraint, not a preference. A user-invoked skill has
no description, so nothing but the human can reach it: two user-invoked skills
can never compose. An atomic-and-composable product therefore **must** ship its
atoms model-invoked, or they are not atoms.

The context-load budget (force 3) is then spent almost entirely on primitives,
which is the right place to spend it: each description bought is a composition
edge enabled.

### 7.3 Sketch

Names are placeholders; the categories are the durable part.

**Atoms (model-invoked primitives)**

- `interrogate` - frontier rounds; facts are the agent's job, decisions the
  human's. The grilling primitive.
- `name` - domain language: challenge terms, settle the glossary, record
  hard-to-reverse decisions.
- `seam` - choose and confirm the proof seam and module shape before any test
  is written.
- `slice` - cut work into vertical tracer bullets with blocking edges;
  expand/migrate/contract for wide refactors.
- `prove` - run named proof and record its state (`not run | pass | fail |
  blocked`) against the current revision. **Waterflow's own; neither reference
  has it.**
- `critique` - two-axis review in parallel, never re-ranked across axes.
- `probe` - throwaway prototype answering exactly one question.
- `dig` - research against primary sources, dispatched to the background.

**Composites (user-invoked entry points), tracing idea to integration**

- `waterflow` - the router: the five dials, the escalation rule, the map of
  everything above. See D6.
- `align` = `interrogate` + `name`
- `shape` = `align` + `seam` + `slice`
- `build` = red/green at the agreed seam + `prove` + `critique`
- `land` = `critique` + `prove` + integrate (commit / PR / merge)

**Policy references** (plain files, pointed at, never copied)

- `lanes.md`, `model-tiers.md`, `topology.md`, `proof.md`,
  `decision-rights.md`

**Underneath**

- `authoring` - the Waterflow port of `writing-for-agents`. Also the skill
  Waterflow uses on itself.
- `setup-waterflow` - resolve the state surface, host, tier availability, and
  ceremony profile for this consumer repo.

**Deliberately out of scope for v1:** technology specialists, a governance
skill, an ADR registry, deterministic scaffold scripts, a docs site. Also
`map`/wayfinder: multi-session fog is the opposite of a small feedback loop, so
it belongs to Phase 3 at the earliest.

### 7.4 Borrow Ledger

All three repos are **MIT** (Waterflow, uncle-bob, mattpocock-skills, verified
in each `LICENSE`). Copying is permitted; MIT requires the copyright and
permission notice to travel with copies or substantial portions. So borrowing is
a licensing task as well as a design one: the plan needs a
`NOTICE`/`ATTRIBUTION.md` and a per-file provenance convention before the first
copy lands, not after.

Three tiers, and the tier is the decision:

- **Copy** - general, already right, not Waterflow-specific. Rewriting would be
  strictly worse. Carries upstream attribution.
- **Adapt** - the technique transfers, the expression does not: it names another
  repo's vocabulary, paths, or paradigm. Credit upstream.
- **Cite** - take the idea, reimplement, because Waterflow's atomic paradigm
  changes the shape.

| Source | Tier | Lands as |
|---|---|---|
| `writing-for-agents` + `SKILL-MECHANICS.md` (MP) | **Copy** | `authoring`. The best single copy candidate in either repo. |
| `grilling` (MP) | **Copy** | `interrogate`. Already an atom; near-verbatim. |
| `CONTEXT-FORMAT.md`, `ADR-FORMAT.md` (MP) | **Copy** | templates behind `name`. |
| `tdd/tests.md`, `tdd/mocking.md` (MP) | **Copy** | good/bad test examples behind `build`. |
| `codebase-design` glossary (MP) | **Copy** | the vocabulary `seam` needs (module, interface, depth, seam, adapter, leverage, locality). |
| `PHASE-BOUNDARIES.md` (MP) | **Adapt** | the **Topology** dial. Excellent, but Claude-Code-specific (`/compact`, `/clear`); needs generalizing across hosts. |
| `code-review` two axes + Fowler smell baseline (MP) | **Adapt** | `critique`. Strip the tracker dependency. |
| `to-tickets` expand/migrate/contract (MP) | **Adapt** | `slice`. |
| `diagnosing-bugs` Phase 1 red-loop (MP) | **Adapt** | strongest **reflex** candidate (see D6). |
| `prototype` rules (MP) | **Adapt** | `probe`. |
| Trigger-token notation `[phase:a\|b]` (UB) | **Adopt** | the reference-loading convention repo-wide. A notation, not prose. |
| `pass \| fail \| blocked` (UB) | **Adopt** | `proof.md`. |
| Objective-Complete Rule (UB) | **Adapt** | short, sharp, and it patches a real agent failure. |
| Evidence freshness rule (UB) | **Adapt** | `prove`. |
| Distribution boundary (UB `AGENTS.md`) | **Adapt** | Waterflow's own `AGENTS.md`, Phase 0. |
| Testing signals `TG001`-`TG011` (UB) | **Cite** | too heavy for v1; mine the names for `critique` later. |
| `ask-matt` router structure (MP) | **Cite** | the flow differs; the *shape* of a router that maps flows is the lesson. |

**Two traps, both verified:**

1. **Copied Matt skills carry hidden setup dependencies.** `to-spec`,
   `to-tickets`, `code-review`, `wayfinder`, and `triage` all contain some form
   of "The issue tracker should have been provided to you. If not, tell the user
   to run `/setup-matt-pocock-skills`." Copy any of them verbatim and Waterflow
   ships a dangling pointer to a skill the consumer does not have. Every borrow
   must be audited for references to upstream skills, upstream config paths
   (`docs/agents/*.md`), and upstream label vocabularies.
2. **Borrowing phase-shaped skills breaks the atomic paradigm.** Most of Matt's
   entry points (`to-spec`, `implement`, `wayfinder`) are compound by
   construction. Adopting them wholesale would re-import the phase model that D1
   just replaced. Filter every candidate through: *does this decompose into one
   operation?* If not, it is a composite to be re-declared, not a skill to be
   copied.

On `grill-with-docs` specifically: it is a five-line composite
(`grilling` + `domain-modeling`). It is worth taking as a *pattern*, and §7.3
already lands it as `align` = `interrogate` + `name`. The value is the
composition, and the composition is one line to write.

---

## 8. The Decision Frontier

**All decisions settled.** Recorded in grilling rounds on 2026-08-28. Each
entry states the decision and its consequence for the plan.

**D1. Product scope. SETTLED: atomic + composable.**
Atomic operations that compose into more complex ones. Not an operating system:
a workflow covering **idea to integration** in a small repo-local feedback loop.
Consequences folded into §7: the composition model, the invocation taxonomy, and
`map`/wayfinder pushed out of v1 as the opposite of a small loop.

**D2. Durable state. SETTLED: adapter.**
State-surface adapter resolved at setup, defaulting to local markdown, with a
GitHub adapter. Skills talk to the contract, never to a path. Consequence: the
adapter contract is a Phase 1 deliverable, and it gates `slice`, `prove`, and
`land`. Note §5.1: the impression store is a *second* surface, and probably
always local files even when the tracker is remote.

**D3. Ceremony floor. SETTLED: one lean profile.**
No `lean`/`strict` split. Lanes carry the variation. Two profiles would double
the rules to keep consistent before anything is proven. Revisit only if real use
shows a consistent set of rules people skip.

**D4. Authority term. SETTLED: neutral, configurable.**
Skills ship a plain role-free term (`the owner`, or plain second person).
`setup-waterflow` offers an optional label so a consumer can render it as
whatever their team calls that role. Consequence: no Waterflow prose may name a
project-specific role, and the authoring standard carries this as a rule so it
is checkable.

**D5. Tier dial. SETTLED: advisory.**
Skills *report* the tier a phase warrants and the human switches models. No
dispatch-at-tier in v1. Chosen because tiering is the axis Waterflow invents,
with no prior art in either reference, and host model-selection capabilities
vary and change. Consequence: the tier vocabulary must be designed so binding
dispatch could layer on later without rewriting skills.

**D6. Router invocation. SETTLED: user-invoked router, model-invoked atoms, no
reflex.**

The router half was mechanical (§7.2): two user-invoked skills cannot call each
other, so atoms must be model-invoked to be composable, and the router is an
entry point, so it is user-invoked.

The reflex half was examined and rejected, on a better argument than the
reversibility one first offered:

- A proof-gate reflex triggers on impressions showing unproven work. But work
  never routed through Waterflow **has no impressions**, so the reflex is
  *inert* on exactly the unrouted work it exists for, and *redundant* on routed
  work, where `land` already checks proof.
- The version that escapes this triggers on a repo condition (about to commit)
  rather than on the store. That is a pre-commit hook wearing a skill costume,
  and a hook does it better: deterministic, no context cost, no misfires.
- Matt's three reflexes (`diagnosing-bugs`, `wizard`,
  `resolving-merge-conflicts`) all fire on a condition evident in the
  conversation and all offer **capability**. None **enforce**. That is the line:
  reflexes are good for offering capability, bad for policing. Policing belongs
  in deterministic tooling.

Consequences: **v1 ships zero always-loaded descriptions outside the atoms.**
The proof gate becomes a Phase 2 hook/CI note, not a skill. One capability
reflex is worth revisiting in Phase 3: one that fires when the agent is about to
re-derive a fact the impression store already holds, and offers the record
instead. That needs a populated store, so it cannot be v1.

**D7. Verification depth. SETTLED: cheap checks only.**
Skill schema, relative-link resolution, manifest sync, no BOMs. No pytest suite,
no CI docs-sync enforcement until there is something worth protecting.

**D8. Pilot consumer. SETTLED: none named, deliberately.**
No consumer is designated. Waterflow is a distributable product, and designing
the adapter against one known repo is how that repo's assumptions get baked in,
which is the framing bug §1 diagnoses. Consequences: the state adapter handles
the greenfield case and the map-onto-existing case from the start rather than
one then the other; gates are stated as consumer-agnostic proofs; and Waterflow
dogfoods its own build, using Phase 1 to build Phase 2.

**The test subject is a throwaway implementation**, written to exercise the
flow and then discarded. This is `probe`'s own doctrine turned on the workflow
itself: throwaway code answering one question, here "does the flow actually
carry work from idea to integration?"

It is a better instrument than a real pilot on both counts. It bakes in no
consumer's assumptions, and unlike dogfooding it exercises the
software-building path rather than only the authoring path. That retires the
dogfooding-blindness risk in §10.

**Choosing the subject is the part that can go wrong.** Too trivial and `slice`
has nothing to slice, `seam` has nothing to choose, and the gates pass without
proving anything. Too large and it stops being throwaway. It must:

- have a real domain, so `define` has terms worth settling;
- carry three to five vertical slices with genuine blocking edges between them;
- have a testable seam, so `seam`, `test`, and `prove` are all exercised;
- integrate somewhere, so `land` means something;
- be finishable in a sitting or two.

And it must stay throwaway: marked as such from the first commit, on its own
branch, never allowed to become production by inertia.

**D9. Borrow and attribution. SETTLED: copy per the ledger, with attribution.**
All three repos are MIT (verified). Copy freely where §7.4 says Copy, with a
repo-level `ATTRIBUTION.md` plus a provenance line in each borrowed file.
Rejected: adapt-everything (costs real quality on `writing-for-agents` and
`grilling`, better than anything written fresh in a first pass) and cite-only
(straightforwardly worse). Provenance lines also make upstream drift auditable:
they are what lets you diff against the source later.

**D10. Impression store. SETTLED: full emission.**
Every atom emits; retrieval is a first-class step in composites. Chosen over the
minimal two-atom version because this is core, not a feature.

**The one constraint that de-risks it**, and it must be written into Phase 0:
atoms emit through a **single shared emission contract** they all point at,
never eight copies of the field list. This is §7.1's own rule ("no rule lives in
two places") applied, and it turns schema churn from eight rewrites into a
one-file edit.

**Token economics, since this is the store's main justification.** The honest
answer is that it is a within-session cost and a cross-loop saving:

- **Cost:** roughly 100 tokens per record, so about 800 tokens of emission per
  full loop. Inside one context window the return is near zero, because
  everything is already present.
- **Saving 1, subagent briefing:** a cold spawn today means pasting conversation
  or re-deriving by grep, call it 5-15k tokens. With an index it is six records,
  about 500. One fan-out per loop repays emission six to eighteen times over.
- **Saving 2, resumption:** same shape after a compact, and it buys fidelity
  rather than a lossy summary.
- **Saving 3, avoided re-derivation:** the expensive part of agent work is
  rarely reading an answer, it is *finding* it. A record naming a confirmed seam
  kills an exploration loop, which is thousands of tokens of tool output.

**The tension, named honestly:** D1's small feedback loop narrows the
cross-*session* payoff, since more work fits in one window. The resolution is
that compounding is cross-*loop*, not cross-session. Loop 47 benefits from what
loops 1-46 settled about seams, naming, and existing proof, while emission cost
stays flat per loop. Small loops are the compounding case, not the exception.

**D11. Naming convention. SETTLED: plain verbs, no metaphor.**
Every atom and composite is named for the operation it performs. No water
vocabulary in skill names, reference names, or dial values. The metaphor is
confined to the product name itself and stays out of the working vocabulary.

Rationale: `writing-for-agents`' leading-word test. A plain verb recruits
pretraining priors for free and needs no definition; a coined word is paid for
in definition tokens and forces users to learn a dictionary before doing
anything. That vocabulary tax is Uncle Bob's most visible failure (§3.1), and
this rule is the defence against repeating it.

Consequences: the authoring standard carries this as a checkable rule, and the
`name` atom in §7.3 needs a better plain verb before the plan freezes the
inventory (`define` is the obvious candidate; it reads correctly next to
`prove`, `slice`, and `seam`).

---

## 9. Can It Be Done In One Plan?

**One plan document: yes. One build pass: no, and it should not be.**

The architecture is decidable now. Both references have been read, the gaps are
identified, and the eight open decisions in §8 are answerable in a single
grilling round. There is no research left that would change the plan's shape.

The build cannot be one pass, for three reasons that are all evidence rather
than caution:

1. **Both references are the product of iteration under real use.** Matt's
   `in-progress/` and `deprecated/` buckets and Uncle Bob's `.out-of-scope/`
   notes are the visible residue. A v1 authored straight through will be
   authored against imagined use.
2. **Waterflow's own doctrine forbids it.** Lane selection, smallest durable
   rule set, split references only under real pressure, apply and then inspect.
   A plan that ships twelve skills and nine references before one has been used
   is the ceremony risk the plan document itself names.
3. **The description budget can only be sized empirically.** How many
   model-invoked skills a consumer repo tolerates is a question you answer by
   installing it somewhere, not by reasoning.

**Recommended plan shape: one document, one spine, three phases, with a written
gate between each.**

- **Phase 0 - Ground.** Scaffold hygiene (BOMs, `.claude-plugin/`, frontmatter,
  de-duplication), the `AGENTS.md` distribution boundary, the authoring
  standard, `ATTRIBUTION.md` plus the provenance convention (D9), and the cheap
  validation script. Small, and everything after it depends on it.
- **Phase 1 - Spine.** The router with the five dials, the five references, and
  `setup-waterflow`. Installable and usable. **Gate: install it into one real
  repo and route three real pieces of work through it.**
- **Phase 2 - Flow.** `align`, `spec`, `slice`, `build`, `review`, `close`.
  Authored in dependency order, each proven on real work before the next.
  **Gate: one complete piece of software built end to end through the flow.**
- **Phase 3 - Reach.** `map`, portability hardening across hosts, docs, and
  whatever Phase 2 proved was missing. Deliberately unspecified in detail,
  because Phase 2 is what specifies it.

The plan document should specify Phase 0 and Phase 1 to task level, Phase 2 to
outcome level, and Phase 3 to intent level. Specifying Phase 3 to task level now
would be a forecast presented as a commitment, which is the exact failure Uncle
Bob's appetite-boxing is a defence against.

---

## 10. Risks

**Reinventing a middle nobody wants.** Waterflow sits between a rigorous system
and an adoptable one. It could land as more ceremonial than Matt's and less
rigorous than Uncle Bob's. *Mitigation:* the five dials must fit on one page. If
the router cannot be explained in one screen, the thesis has failed.

**Description-budget blowout.** Twelve model-invoked skills is a permanent tax
on every consumer turn. *Mitigation:* D6. One model-invoked router; everything
else user-invoked unless it earns otherwise.

**Vocabulary tax.** Uncle Bob's most visible failure. *Mitigation:* every coined
term must beat its plain-English alternative in a specific, statable way, or it
does not ship.

**Evidence theater.** Proof states become checkboxes. *Mitigation:* evidence
must be a command or an artifact path, never a description, and stale evidence
must not close a task.

**Dogfooding blindness.** Waterflow is a workflow repo, so it is an unusual
consumer of its own workflow: building skills exercises the authoring path and
almost nothing else. *Mitigation:* D8's throwaway implementation, which is real
software and therefore exercises `seam`, `test`, `prove`, and `land` as they
would actually be used. Residual risk: a throwaway is not a codebase with
history, so it under-tests `recall` against an aged store.

**Reference drift.** Both sources are live repos and will move. *Mitigation:*
`.review/` checkouts are pinned sources for this analysis, cited by path. Treat
their contents as of today, not as a live dependency, and re-read before
claiming they still say something.

**Scope creep back toward Uncle Bob.** Governance, specialists, and registries
are each individually reasonable. *Mitigation:* D1's seam. Adding them later is
cheap; removing them later is not.

**Borrowing imports the wrong paradigm.** Most of Matt's entry points are
phase-shaped composites; copying them wholesale would re-import the phase model
that D1 replaced, and would drag in dangling pointers to his setup skill and
config paths. *Mitigation:* §7.4's filter (does it decompose into one
operation?) and a dependency audit on every borrowed file.

**Attribution debt.** MIT permits the copying but requires the notice to
travel. A borrow ledger written after the fact is a licensing cleanup job.
*Mitigation:* `ATTRIBUTION.md` and the provenance convention land in Phase 0,
before the first copy.

---

## 11. What The Plan Document Must Contain

For the plan to be writable in one pass after the §8 decisions are settled:

1. What Waterflow is, in one paragraph, and what it is not.
2. The five dials, defined, with the escalation and downgrade rule.
3. The decision-rights table.
4. The distribution boundary (shipped vs factory surfaces).
5. The authoring standard, ported from `writing-for-agents`, including the
   description-writing and invocation rules.
6. The state-surface contract that skills talk to.
7. The skill inventory, each with: name, **category** (atom / composite /
   reflex), invocation, one-line description budget, references it owns, and
   the dials it sets. Composites listed as the atom sequence they declare.
8. The borrow ledger and attribution mechanics: what is copied, what is
   adapted, where `ATTRIBUTION.md` lives, and the per-file provenance line.
9. Phase 0 and Phase 1 to task level; Phase 2 to outcome level; Phase 3 to
   intent level.
10. The gate between each phase, stated as a proof, not as a date.
11. The v1 non-goals, listed explicitly, so scope creep is a visible decision
    rather than a drift.

---

## Appendix: Source Index

Uncle Bob:

- `.review/uncle-bob/.agents/skills/ub-workflow/SKILL.md` - lanes, 45-clause contract, interaction modes, objective-complete rule, trigger tokens
- `.review/uncle-bob/.agents/skills/ub-governance/SKILL.md` - profiles, gate states, TG001-TG011 testing signals
- `.review/uncle-bob/.agents/skills/ub-governance/references/gate-and-report-contract.md` - gate semantics, report sections
- `.review/uncle-bob/.agents/skills/ub-governance/references/evidence-lifecycle.md` - evidence roots, freshness, anti-patterns
- `.review/uncle-bob/.agents/skills/ub-authoring/references/authoring-conventions.md` - descriptions as routing logic
- `.review/uncle-bob/AGENTS.md` - distribution boundary, docs-sync policy
- `.review/uncle-bob/docs/guide/` - routing model, skill system, progressive disclosure, portability

Matt Pocock:

- `.review/mattpocock-skills/skills/engineering/ask-matt/SKILL.md` - the flow map
- `.review/mattpocock-skills/skills/engineering/ask-matt/PHASE-BOUNDARIES.md` - the five-option tree, primary vs secondary sources
- `.review/mattpocock-skills/skills/productivity/writing-for-agents/` - the authoring theory, invocation mechanics
- `.review/mattpocock-skills/skills/productivity/grilling/SKILL.md` - frontier rounds, facts vs decisions
- `.review/mattpocock-skills/skills/engineering/to-spec/SKILL.md` - spec template, seams confirmed with user
- `.review/mattpocock-skills/skills/engineering/to-tickets/SKILL.md` - tracer bullets, blocking edges, expand-contract
- `.review/mattpocock-skills/skills/engineering/tdd/SKILL.md` - seams, anti-patterns, loop rules
- `.review/mattpocock-skills/skills/engineering/code-review/SKILL.md` - two axes, parallel subagents, no re-ranking
- `.review/mattpocock-skills/skills/engineering/wayfinder/SKILL.md` - decision tickets, fog of war, out of scope
- `.review/mattpocock-skills/skills/engineering/diagnosing-bugs/SKILL.md` - the red loop as completion criterion
- `.review/mattpocock-skills/skills/engineering/codebase-design/SKILL.md` - deep modules, seams, leverage, locality
- `.review/mattpocock-skills/skills/engineering/setup-matt-pocock-skills/SKILL.md` - the setup adapter pattern
- `.review/mattpocock-skills/CLAUDE.md` - buckets as release channels, docs sync rules
