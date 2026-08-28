# Agent Instructions

This repository builds Waterflow: atomic, composable agent skills that carry
work from idea to integration in a small feedback loop.

Design decisions live in `docs/pre-plan-analysis.md` (D1-D11). The build
sequence lives in `docs/build-plan.md`. Read the decision that governs a rule
before changing the rule.

## Distribution Boundary

**The distribution unit is the plugin, not the individual skill.** Waterflow
ships as one plugin, so any skill may reference any file under `skills/`. That
is what makes a single shared emission contract legal.

Shipped surfaces, which travel to consumers:

- `skills/**` — every `SKILL.md`, `references/`, `assets/`, and skill-owned
  script.
- `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`,
  `.codex-plugin/plugin.json` — host manifests.

Factory surfaces, which stay here:

- `scripts/`, `docs/`, `README.md`, `CHANGELOG.md`, `AGENTS.md`,
  `ATTRIBUTION.md`, `.review/`, CI configuration.
- `.waterflow/` — this repository's own impression store and work items.

Rules:

1. A shipped skill may depend on anything under `skills/`. It may not depend on
   `scripts/`, `docs/`, CI, root manifests, or this file.
2. A shipped skill may not assume this repository's layout exists in the
   consumer's repo.
3. Factory surfaces may know about shipped surfaces. The reverse is a defect.
4. If a consumer needs behaviour that lives in a factory surface, bundle it as a
   skill-owned asset or describe how to detect it in the target project.

## Authoring Rules

`skills/authoring/SKILL.md` is the standard. Read it before writing or editing
any skill. The rules below are the ones that are checkable, and
`scripts/check.mjs` enforces what it can.

1. **Plain verbs only (D11).** Every atom and composite is named for the
   operation it performs. No water metaphor in skill names, reference names, or
   dial values. The metaphor is confined to the product name.
2. **No project-specific roles (D4).** Shipped prose says `the owner` or plain
   second person. It never names a role belonging to one consumer, such as
   Creative Director, Product Owner, or Scrum Master. Consumers set their own
   label through `setup-waterflow`.
3. **Atoms are model-invoked, composites are user-invoked (D6).** Two
   user-invoked skills cannot call each other, so anything another skill must
   reach carries a description. Anything a human types does not.
4. **Composites are thin.** A composite declares a sequence of atoms, plus at
   most the state-surface calls that open and close the work (`list_frontier`,
   `close_item`) and the integration step itself, which no atom owns. Judgement
   belongs in an atom: if a composite grows a rule about *how* to decide
   something, that rule is in the wrong file.
5. **No rule lives in two places.** If two skills need the same rule, it becomes
   a reference both point at, never text copied into both.
6. **Every atom that settles something emits (D10).** Atoms write impression
   records against the single shared contract in
   `skills/waterflow/references/impressions.md`. No atom restates the schema.
   `recall` is the sole exception, being the store's read half; the contract
   names it.
7. **Description budget: 11 model-invoked skills.** This is the only permanent
   context cost Waterflow imposes on a consumer. A twelfth must displace one.
8. **Borrowed files carry provenance.** See `ATTRIBUTION.md`.
9. **No BOMs.** `.idea/encodings.xml` is set to write none; keep it that way.

## Validation

```
npm test                             # check.mjs + the proof-gate fixtures
claude plugin validate . --strict
```

Both must pass before publishing, and CI runs the first on every push.

`check.mjs` verifies that every skill has a `SKILL.md`, that frontmatter keys are
known, that relative links resolve, that the plugin manifest lists exactly the
skills on disk, that the two manifests agree on version, and that no file carries
a BOM or a stray control character.

`scripts/test-proof-gate.sh` runs the gate against a throwaway repository, one
case per behaviour. Add a case there before changing the gate: the msys tooling
on a Windows workstation strips a trailing CR and reports every file as
executable, so a gate defect can be invisible locally and still break every
consumer on macOS or Linux.

## Building Waterflow With Waterflow

This repository uses the flow it ships. `.waterflow/impressions/` holds real
records about this codebase; `recall` a subject before deriving it again, and
emit when an atom settles something here, exactly as a consumer would.

Two things this buys and one it costs. It surfaces contract defects that fixtures
cannot — the gate warned about a stale proof on its own store before any consumer
hit it. It keeps the vocabulary honest, because a subject that is awkward to name
here will be awkward everywhere. The cost is that the store is another surface to
keep truthful: a record left behind after the code moved is the exact failure
`recall` exists to prevent, and it is worse here than anywhere because this is
where the contract is supposed to be demonstrated.

The store is a factory surface. It does not ship, and no shipped skill may read
it. `.waterflow/` is a convention every consumer repository shares, not this
repository's layout.
