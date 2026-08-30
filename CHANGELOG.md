# Changelog

## 0.4.0

One change, found by reading a store beside the code it was written about. The
record settling what a type meant and the doc comment on that type were the same
document, written twice in the same pass, and only one of the two could go
stale. The store now keeps the address instead of the second copy.

### Grafting

- **A claim about one declaration now lives at that declaration, and the record
  keeps only its address.** The store was holding second copies of things the
  code already said. Driving the flow against real work produced a record
  settling what a type means and a doc comment on that type that were one
  document written twice, by the same agent in the same pass — because settling
  a thing and documenting it are the same act. Both copies stood, and the one
  anchored to a revision was the one that would go stale while the code said the
  truth beside it.
- The address is carried in `scope` as `path#Symbol`. No new field: `scope`
  already points store to code and is what every freshness check runs on, so a
  graft is that field narrowed to the exact site. The direction that would rot —
  a comment naming a record — stays impossible, because records are superseded
  and folded and a comment would not know.
- **Nothing is invented in the code.** The graft uses the host codebase's own
  doc idiom, with no marker and no tag, and the symbol name lives in the record,
  so a store copied into any repository leaves that repository's source
  untouched. The comment carries the claim and never the process: no id, no
  revision, no atom or lane, no date, no "this used to be".
- **Grafted during the build, never by the fold.** A fold that wrote into source
  would edit the tree after the proof that closed it had run, and where doc
  comments are compiled it could turn a proven build red after the run reported
  the subject landed. So the comment is written with the slice and proven with
  it; the fold only notices and empties the record.
- The fold gained a step for it, and empties the record **in place — not
  superseded and not moved.** Superseding says a claim was replaced, moving says
  it was spent, and this claim was neither: it was transplanted and is still the
  current answer. Git holds the pre-graft body at the commit that wrote it and
  the same commit shows the reasoning arriving in the code, so the trail reads as
  the transplant it was rather than as an ending.
- **Freshness collapses rather than growing.** A grafted record's claim is read
  live from the code, so it cannot drift and carries no freshness verdict; only
  its address can be wrong. Three states become two — the declaration resolves,
  or the record is **broken**, which `recall` now reports beside stale and
  freshness unknown, and which is answered by going and looking rather than by
  trusting either side.
- `recall` follows a graft: it reads the claim from the declaration instead of
  from the record's body. This is the one place retrieval is not `grep` alone —
  one targeted read per graft, which is still a query rather than a transcript.
- **The proof gate was failing open on grafted scope, silently.** A `scope`
  entry of `packages/api/b.ts#Thing` matched no staged path, so the gate printed
  nothing and exited clean: the subject ungated, with no error anywhere. The
  gate and `recall` now strip the symbol before any path is matched or handed to
  `git log`, and the case is pinned in `test-proof-gate.sh` beside the `api/`
  prefix cases that were also real defects once.
- Most records do not graft, and that is the healthy shape. A record with
  `scope: []`, a decision not to build something, a claim about the shape
  *between* modules, a `watermark` and a `goal` all keep their full expression.
  A store loses the records that were going to duplicate a declaration, not its
  contents.

## 0.3.0

Everything from driving the flow against real work. The store learns what kind
of knowledge each record holds and how a finished subject is folded up; the flow
learns to report itself and to collect the agents it dispatches; anchors stop
claiming a freshness they do not have; and a review pass over the whole shipped
surface repairs what the first end-to-end runs found.

### The store ontology

- Records gained a `kind`: `fact`, `observation`, `idiom`, `goal`,
  `watermark`. The problem was contamination rather than volume — a trace and a
  truth come back from `recall` looking identical, so the older one wins by
  sounding certain. One question decides the only ambiguous pair, and it is a
  rule the repository already owned: did something run that could have failed?
  If nothing did, it is an observation. A number does not settle it — a timing
  against a named budget is a verdict, a timing with nothing to fail against is
  a reading.
- Only a `fact` carries a verdict, so among the records the proof gate reads,
  only a `fact` can refuse a commit. A record predating the field is still
  gated, and so is one whose `kind` is not a name on the list: the gate used to
  fail open on a typo, which was the quietest possible mistake and the most
  dangerous.
- One table in the contract maps atom to kind, so no atom decides twice.
  `prove` is the only atom emitting two, splitting on whether it reported a
  verdict or a bare measurement. `goal` is the kind nothing emits — a target is
  set deliberately by the owner — so a `goal` record carries no `atom`, which
  the field table now excepts. Until it did, the one kind a person adds by hand
  was the one kind the contract forbade.
- **A goal never closes.** It is met or unmet, it names the statistic that
  decides it and under what conditions, and a goal with no observation against
  it is reported *unmeasured* — never as met, and never silently.
- **Spent watermarks live beside the store, not in it.** A watermark whose
  process is over moves to a `history` directory that is the impressions
  directory's sibling. A sibling rather than a subdirectory because retrieval is
  `grep -r`: a subdirectory would still be walked, and the exclusion would be a
  convention every reader had to remember instead of a fact about where the file
  is. Nothing is deleted, so `git blame` still answers who claimed what; only
  reachability changes.
- **Superseded records follow them.** A record something else replaced is spent
  in exactly the sense a watermark is. They outnumber watermarks in every store
  looked at so far, and they are the clearer case — not current by definition
  rather than by classification.
- Added **the fold**. When integration leaves a subject with no open items,
  `land` consolidates it: watermarks and superseded records move to `history`,
  and the facts, observations, idioms and goals they established stay as the
  subject's live state, with the `kind` of any survivor that carries none
  settled by the same atom mapping. Claims, anchors and supersession are never
  rewritten — a fact nothing re-ran is not made truer by being restated at a
  newer revision. The trigger is the state surface rather than a judgement, so
  an active subject is never touched and a nine-slice build consolidates once,
  at the end; and a subject that never had items is untracked, not finished.
- Watermarks are found by atom as well as by `kind`, because most records in any
  existing store predate the field: a query for `kind: watermark` alone moves
  nothing and reports success. An atom not in the mapping means leave the record
  alone — an unmoved record costs a line of retrieval, a wrongly moved one is
  knowledge that has silently left the store.
- `recall` stops returning one flat list and reports four groups: known,
  believed, governs, aiming at. Flattening them is how a reading gets read as a
  result. Idioms come oldest first, because the ones that have survived longest
  are the ones most likely to still be true; goals come unmeasured first. The
  believed group can be queried alone, which answers a question the store could
  not answer before — what would this subject have to prove to be sure of
  itself? Records predating `kind` are grouped by their emitting atom, and the
  inference is declared.

### Reporting, and the agent lifecycle

- Added `references/reporting.md`. Nothing reported what ran: one line per atom,
  a block per composite, five markers and no sixth, no ANSI. The emission
  contract owns the atom's line, because an atom reports and emits in the same
  beat.
- **Every dispatched agent is joined**, at or before the boundary that spawned
  it. `topology.md` described how to choose a shape and said nothing about the
  return leg. Dispatch now names a deliverable, a budget and a join point; a
  timeout is either waited on or stopped, and which one is said out loud. A
  dispatched agent does not dispatch, and a finding is not a mandate. Agents
  dispatched and joined are counted in every composite block, including the runs
  that dispatched none — reporting it only when it is interesting makes a
  forgotten agent and a quiet run look identical.
- Nothing said how parallel work reconciles. Fan-out branches stay separate, an
  overlap is corroboration reported once, and a contradiction between branches
  is escalated rather than averaged. At most one **writer** touches the working
  tree — a writer, not an agent, because the collision that prompted the rule
  was two peer sessions each reading an agent-shaped rule as satisfied.
- Four rules that had two homes each now have one, with the skill keeping its
  own action and pointing at the reference for the rule. The test that settles
  it, and the boundary `authoring` was missing: does removing the text lose an
  instruction, or a restatement?

### Anchors and conditions

- `unborn` is a named value of `revision` for a record emitted before any commit
  exists, and it reads as *freshness unknown* rather than fresh. Three states,
  not two.
- **An anchor can be a real revision and still be wrong.** A record emitted
  while the work is uncommitted anchors to the commit *before* the work, in
  which its subject may not exist at all — the `unborn` problem wearing a real
  sha, and quieter, because `unborn` at least announces itself. Two defences:
  `land` re-anchors every record and item in the work it integrates, and
  `recall` reports a record whose whole `scope` was created after its anchor as
  freshness unknown rather than stale.
- A measurement may carry `conditions`, the parameters it depends on, and
  `recall` shows them beside the gist rather than in the detail. The write side
  had landed and the read side had not, so a measurement was still read as a
  bare number. `prove` asks for them at the point the number is taken rather
  than at the emit step, which is where the discipline had been failing.

### Interrogation

- Rounds go through the client's structured prompt instead of a prose template:
  four questions per call, one decision each, real options carrying cost and
  benefit, the recommendation first. The client already offers the escape hatch
  and the navigation, so the template was paying tokens to imitate them badly.
- Added the **doubt sweep**. An empty frontier only means the obvious questions
  are spent, so closing a round now requires a pass over six named sources —
  assumption, contradiction, ambiguity, unoffered candidate, boundary,
  reversibility — and a readback the owner confirms.
- The one-decision-at-a-time rule is scoped to prose, which is where it was
  true. It was never a property of decision-making; it is what prose does to a
  list, and a structured prompt walks a batch one by one.

### Review pass

- An atom firing without `/waterflow` had no dials, and `prove` stopped dead
  when the Proof dial was unset. That is the common path, not an error: the
  atoms are model-invoked and the router is not. `dials.md` gained **Firing
  unrouted** — take the defaults, report only the dial the operation turns on,
  hand routing back on an escalate condition — and `proof.md` gained the one
  default an atom may not invent for itself, the repository's own test command,
  reported as inferred. `prove` falls back to it instead of refusing to run.
- The README's retrieval example used a loose `tags:.*checkout`, the exact
  pattern `impressions.md` and `recall` go out of their way to forbid because it
  also matches `checkout-flow`. It is the anchored ERE now, with the reason
  beside it.
- The fold's superseded-id pipeline in `impressions.md` carried a literal
  carriage return and a literal newline inside its `tr` arguments. Invisible in
  review, and gone the moment anyone copies the block. It mirrors
  `proof-gate.sh` exactly now, escapes written as escapes.
- `check.mjs` claimed a seventh check — "the Claude and Codex manifests agree on
  version" — that was never implemented, and carried a `warn` helper and a
  report loop nothing called.
- Removed the last pointers to an `AGENTS.md` that does not exist, from
  `check.mjs` and the build plan, and the factory-side `(D11)` and `(D7)`
  identifiers from `authoring` and `check.mjs`. `authoring` ships to consumers;
  a decision id they cannot resolve is noise.
- Corrected the README: nine references, not eight, and the git-repository
  requirement stated once rather than twice.
- `.gitattributes` pinned `*.sh`, `*.mjs`, and `*.md` to LF but not `*.json` or
  `*.yml`, so with `core.autocrlf` on those drifted to CRLF in the worktree
  while the repo stored LF. Named the rest of the text and normalized what had
  already drifted.

### Documentation

- Deleted `docs/pre-plan-analysis.md` and the references to it. The decisions it
  argued out are settled and tabled in `docs/build-plan.md`; the teardown of the
  two reference repositories had done its job, and 53KB behind a single pointer
  was going to rot rather than be read. `ATTRIBUTION.md` no longer cites it for
  the borrow ledger or the review checkouts, both of which it already carries
  itself.
- Rewrote `docs/build-plan.md` for what is next rather than what is done. Gate 1
  now names the three things nothing has exercised — the fold, re-anchoring at
  integration, and firing unrouted — and Gate 2 gained a rule that a gate run
  outside this repository lands its verdict inside it.

### Correctness pass

- `proof-gate.sh`: scope entries now match a staged path as a whole path or a
  directory prefix, not as a substring — scope `api/` no longer fires on
  `packages/api/b.ts`. The `pass` branch reads `revision` and distinguishes at
  HEAD, behind HEAD, and not reachable from HEAD, instead of asserting "older
  revision" without checking. The store is resolved from
  `$WATERFLOW_IMPRESSIONS`, then the `impressions path` row of config, then the
  default. Every field read tolerates a trailing CR. Shipped mode is now `755`.
- `setup-waterflow` says `chmod +x` explicitly. Windows reports every file as
  executable, so a gate installed there works while the same install on macOS or
  Linux was skipped by git in silence.
- Added `.gitattributes` pinning `*.sh`, `*.mjs`, and `*.md` to LF, so a Windows
  contributor cannot commit a CRLF hook or a CRLF record.
- Tag retrieval anchors on the list separators rather than `\b`, which also
  matched `checkout-flow` for subject `checkout`, and was GNU-only. Staleness
  now checks the anchor is reachable first: a rebased or amended revision reads
  as **freshness unknown**, not as fresh.
- `state-surface.md` gained the full local-markdown adapter: item record, field
  table, id scheme, and a working `list_frontier`. The four operations had a
  contract but no implementation.
- Corrected two contradictions: `recall` does not emit, so the blanket "every
  atom emits" is now stated with its exception in the contract that owns it; and
  the thin-composite rule now admits the state-surface calls and the integration
  step that `build` and `land` genuinely need.
- `authoring` no longer points at `AGENTS.md`, `ATTRIBUTION.md`, or
  `scripts/check.mjs`. It ships to consumers, and those are factory surfaces.
- Added CI and a fixture suite for the proof gate.
- Waterflow is loaded with `claude --plugin-dir <checkout>`, and that is now the
  only documented way in. Installing through the marketplace copies the checkout
  into the plugin cache pinned to a commit, so an edit to a skill stays invisible
  until a reinstall — the opposite of what developing the skills needs.
  `--plugin-dir` reads the working tree. The marketplace manifest stays, demoted
  out of the flow into a Distribution note.
- Removed the `setup-waterflow` skill. Four of the five things it resolved were
  its own defaults being read back to you; the fifth, the test command, is
  detectable. The paths are conventions now, created on first write, and a
  hand-written `.waterflow/config.md` still overrides them for a repository that
  tracks work elsewhere. `proof-gate.sh` moved to `skills/waterflow/` and is
  installed with one `cp`, which is the only part that ever needed consent.
- A `new-dotnet-repo.sh` scaffold was added and removed again in the same cycle.
  It wrote the config, installed the gate and wrote the `CLAUDE.md` block: a
  second implementation of what `setup-waterflow` did, against principle 4. Then
  `setup-waterflow` went too. `dotnet new sln` plus `--plugin-dir` is the whole
  story, and neither half is Waterflow's to own.
- Deleted `.claude-plugin/marketplace.json` and `.codex-plugin/`. `--plugin-dir`
  needs only `.claude-plugin/plugin.json` — verified: with the manifest a skill
  resolves, without it none do — and the marketplace path is gone entirely.
- `.waterflow/config.md` gained a `default proof` row, and `setup-waterflow` now
  detects the project's test command. The Proof dial had no answer until it was
  asked for one, which is backwards: `proof.md` requires it be named at routing
  time.
- Removed `plan for skills.md`, superseded by `docs/pre-plan-analysis.md`, and
  trimmed the completed phases out of `docs/build-plan.md`. Pinned both upstream
  review commits in `ATTRIBUTION.md`; uncle-bob's had never been recorded.

## 0.2.0

Phase 2 (Flow) of `docs/build-plan.md`.

- Added the remaining eight atoms: `interrogate`, `define`, `seam`, `slice`,
  `test`, `critique`, `probe`, `dig`. All model-invoked, all emitting against
  the shared contract. The description budget is now exactly full at 11.
- Added the four composites: `align`, `shape`, `build`, `land`. User-invoked and
  thin — each declares a sequence of atoms and an exit condition, nothing else.
- Added `skills/setup-waterflow/proof-gate.sh`: a deterministic pre-commit check
  that refuses a commit covered by a live `fail` record and warns when a commit
  makes a recorded `pass` stale. A hook, not a skill, so it costs no context.
  `setup-waterflow` offers it rather than installing it silently.
- `define` records terms and decisions as impressions rather than maintaining a
  `CONTEXT.md` and a `docs/adr/` tree. One store, not three.
- Audited every borrow for upstream pointers that do not travel: references to
  `/setup-matt-pocock-skills`, `docs/agents/*`, `.scratch/`, and upstream label
  vocabularies are all gone.

Phase 1 (Spine) of `docs/build-plan.md`.

- Added `skills/waterflow/references/impressions.md`: the single emission
  contract every atom writes against.
- Added `references/dials.md`, `lanes.md`, `topology.md`, `proof.md`,
  `decision-rights.md`, `state-surface.md`; rewrote `model-tiers.md`.
- Removed `references/workflow-shape.md`, split into `lanes.md` and
  `topology.md`.
- Replaced the `skills/waterflow/SKILL.md` placeholder with the router.
- Added `skills/prove/` and `skills/recall/`, the store's write and read halves.
- Added `skills/setup-waterflow/`, which binds the state surface, the impressions
  path, and the authority label, and handles greenfield or an existing process.
- Lane values are now `direct` / `align` / `shape` / `build`, named for the
  composite each enters at. `map` is not a lane in v1.
- Removed `agents/waterflow-planner.agent.md`, `skills/waterflow/agents/openai.yaml`,
  and `docs/design.md`. The first used an undocumented host schema and said what
  `dials.md`, `model-tiers.md`, and `decision-rights.md` now say; the second
  duplicated the Codex manifest's interface block; the third was a stub
  superseded by `docs/pre-plan-analysis.md`.
- Impression records gained `scope`, and `supersedes` became a list. Staleness is
  now "a file under `scope` changed since `revision`" rather than "`revision` is
  behind HEAD", which would have marked every record stale on the next commit.

Phase 0 (Ground) of `docs/build-plan.md`.

- Added `docs/pre-plan-analysis.md`: teardown of the two reference repositories
  and the decisions D1-D11 that govern the build.
- Added `docs/build-plan.md`: the phased build sequence with proof gates.
- Added `skills/authoring/`, the standard every skill is written against
  (ported from `writing-for-agents`, MIT).
- Added `AGENTS.md` distribution boundary: shipped `skills/` versus factory
  surfaces, and the rule that the plugin is the distribution unit.
- Added `ATTRIBUTION.md` and the per-file `source:` provenance convention.
- Added `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`. The
  repo is now installable as a Claude Code plugin.
- Added `scripts/check.mjs`, replacing the Windows-only `list-skills.ps1`.
- Removed root `plugin.json`: it used a schema no supported host reads, and
  duplicated the two host-specific manifests.
- Stripped UTF-8 BOMs from all tracked files, and set `.idea/encodings.xml` to
  stop writing them.
- Removed the project-specific authority role from all shipped prose. Consumers
  set their own label at setup.

## 0.1.0

- Initial public scaffold for Waterflow.
- Added the `waterflow` router skill.
- Added model-tier and workflow-shape references.
- Added initial planner agent prompt.
