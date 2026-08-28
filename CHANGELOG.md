# Changelog

## Unreleased

Correctness pass over the proof gate and the retrieval commands, after the first
end-to-end review.

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
- Added `skills/setup-waterflow/new-dotnet-repo.sh`: one command that spawns a
  .NET solution with Waterflow already bound — solution, library, xunit project,
  git repository, config, impression store, proof gate installed and executable,
  and `CLAUDE.md`, committed. A skill-owned asset rather than a `scripts/` entry,
  because consumers need it.
- The spawned repository loads Waterflow with `claude --plugin-dir`, via
  gitignored `wf.sh`/`wf.cmd` launchers holding the checkout's absolute path.
  Installing through the marketplace copies the checkout into the plugin cache
  pinned to a commit, so edits to a skill are invisible until a reinstall — the
  opposite of what someone developing the skills needs. `--plugin-dir` reads the
  working tree. The marketplace manifest stays, demoted to a Distribution note.
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
