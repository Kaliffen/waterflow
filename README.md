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

## How to use

### 0. Spawn a new .NET solution, already bound

One command produces a git repository with a solution, a library, an xunit test
project, the Waterflow config, the impression store, the proof gate installed as
a pre-commit hook, and a `CLAUDE.md` pointing at the router — committed, with
nothing left to answer:

```sh
sh path/to/waterflow/skills/setup-waterflow/new-dotnet-repo.sh Checkout
```

It takes an optional second argument for the parent directory, and needs
`dotnet` and `git`. The default proof is recorded as `dotnet test`.

```
Checkout/
  Checkout.slnx
  src/Checkout/                  library
  tests/Checkout.Tests/          xunit, referencing the library
  .waterflow/config.md           state surface, store, authority label, proof
  .waterflow/items/              work items
  .waterflow/impressions/        what the flow learns
  .git/hooks/pre-commit          the proof gate
  CLAUDE.md                      points at the router
  wf.sh, wf.cmd                  start Claude with this checkout loaded
```

Waterflow is not copied into the new repository. The launchers hold an absolute
path to the checkout you ran the script from, so an edit to a skill here is live
in the new solution on the next session:

```sh
cd Checkout
./wf.sh
```

They are gitignored, since the path is true on one machine only. For any other
stack, or an existing repository, use the two steps below instead.

### 1. Load it into an existing repository

Waterflow is one Claude Code plugin, loaded from a checkout on disk:

```sh
claude --plugin-dir /path/to/waterflow
```

The flag is per-session and reads the working tree directly — nothing is copied
or pinned, so the skills are whatever the checkout currently says. Worth an alias
or a two-line launcher in any repository you route work in regularly.

Codex reads `.codex-plugin/plugin.json` from the same checkout.

### 2. Bind it to the repository

Once per repository, before routing anything:

```
/setup-waterflow
```

It reads the repo first, then asks one question at a time about the four things
it cannot guess:

| It resolves | Default |
|---|---|
| **State surface** — where work items live | local markdown, `.waterflow/items/` |
| **Impressions path** — where records are written | `.waterflow/impressions/`, committed |
| **Authority label** — what your team calls the deciding role | "the owner" |
| **Proof gate** — the pre-commit hook | offered, never installed silently |

It writes `.waterflow/config.md` and adds a Waterflow block to your `CLAUDE.md`
or `AGENTS.md`. Waterflow needs a git repository: `revision` is the freshness
anchor on every record.

### 3. Route a piece of work

```
/waterflow add rate limiting to the public API
```

The router reports all five dials before it starts, so the routing is reviewable
rather than implicit:

```
Lane      shape      slices do not exist yet
Tier      good       bounded implementation, real risk
Topology  inline     implementation wants this reasoning verbatim
Proof     npm test -- rate-limit
Owner     agent recommends
```

Disagree with a dial and say so — re-routing out loud is the flow working. If
the router escalates mid-work, it says why.

### 4. Run the loop

Composites are typed by hand. Each declares a sequence of atoms and an exit
condition, nothing else. Enter at the lane the router named; everything
downstream still runs.

| Command | Runs | Done when |
|---|---|---|
| `/align <subject>` | `recall` → `interrogate` → `define` | the owner confirms shared understanding and the answers exist as records |
| `/shape <subject>` | `recall` → `seam` → `slice` | at least one item can start now, and a seam record exists |
| `/build [slice id]` | `recall` → `test`×n → `prove` → `critique` | a `pass` recorded at the current revision, plus a critique |
| `/land <what>` | `critique` → `prove` → integrate | every slice closed, proof `pass` against the integrated revision |

`/build` takes one slice per run. With no argument it takes one off the frontier
whose blockers are all closed.

Lane `direct` enters no composite at all: run the atoms the work needs, then
`prove`.

### 5. Let the atoms fire on their own

The ten atoms are model-invoked — you do not type them. They fire from their
descriptions when the work calls for them, and the ones worth knowing by name:

- **`recall`** runs *before* exploring. It answers "did we already settle this?"
- **`prove`** runs the named proof and records the state and the revision.
- **`seam`** blocks any test being written at a place nobody confirmed.
- **`critique`** reviews on two axes in parallel subagents, never merged.

You can also just ask for one in plain language — "check whether we already
decided this" reaches `recall`.

### 6. Read what the flow learned

Impressions are plain files, committed beside the code, and retrieval is `grep`.
Ask `recall` for a subject, or look yourself:

```sh
# live records tagged checkout, newest first
grep -rl 'tags:.*checkout' .waterflow/impressions/ | sort -r

# ids that have been superseded — exclude these
grep -rh '^supersedes:' .waterflow/impressions/

# is a record stale? non-empty output means yes
git log --oneline <revision>..HEAD -- <scope paths>
```

The payoff is briefing: when you send work to a subagent, pass the live gists
for the subject instead of the conversation.

### 7. The proof gate

If you accepted it at setup, `.git/hooks/pre-commit` refuses a commit whose
staged files are covered by a live `fail` record, and warns when a commit makes
a recorded `pass` stale. It reads the store directly and asks no model anything.

```sh
WATERFLOW_GATE=warn git commit      # downgrade a refusal to a warning
WATERFLOW_IMPRESSIONS=path/to/store # if impressions are not at the default
```

### A day in it

```
/setup-waterflow                    once per repo
/waterflow <the work>               get the five dials
/align <subject>                    if the terms or facts are not settled
/shape <subject>                    cut it into slices with blocking edges
/build                              one slice, test-first, proved, critiqued
/build                              the next slice
/land <subject>                     final critique, fresh proof, integrate
```

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
references, ten atoms, four composites, the proof gate, and CI. Nothing has been
carried through the flow on real work yet, which is the next thing that matters
and the only thing that can tell us whether the impression schema is right — see
Gate 1 and Gate 2 in the build plan.

Design reasoning is in `docs/pre-plan-analysis.md`, which teardowns the two
repositories Waterflow learns from and records the decisions behind every rule
here. Borrowed material is credited in `ATTRIBUTION.md`.

## Development

```
npm test                             # check.mjs + the proof-gate fixtures
claude plugin validate . --strict
```

`check.mjs` covers structure, links, manifests, the description budget, BOMs and
control characters. `scripts/test-proof-gate.sh` drives the pre-commit gate
against a throwaway repository. CI runs both on every push, on Linux — which is
where a gate authored on Windows fails, since msys grep hides a trailing CR and
Windows reports every file as executable.

## Distribution

`--plugin-dir` is the way Waterflow is used. `.claude-plugin/marketplace.json`
exists so it *can* be published as an installable plugin
(`/plugin marketplace add Kaliffen/waterflow`), but that path copies a snapshot
of the checkout into the plugin cache, pinned to a commit, which is wrong for
anyone working on the skills themselves. Nothing in the flow above uses it.

MIT.
