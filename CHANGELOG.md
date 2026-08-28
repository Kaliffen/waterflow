# Changelog

## Unreleased

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
