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

**Also:** `authoring` is the standard every skill here is written against,
`proof-gate.sh` is the optional deterministic pre-commit hook, and
`.claude-plugin/plugin.json` is the host manifest.

There is no setup step. The paths below are conventions, not configuration.

Skills arrive as one plugin: they share contracts, so they travel together. The
permanent context cost is eleven model-invoked descriptions, and that is the
budget, enforced by `scripts/check.mjs`.

## How to use

### 1. Load it

Waterflow is one Claude Code plugin, loaded from a checkout on disk. In the
repository you want to route work in — a new solution or an old one:

```sh
dotnet new sln -n Checkout          # or whatever your stack makes
dotnet new console -o src/Checkout
dotnet sln add src/Checkout/Checkout.csproj
git init
claude --plugin-dir C:/Users/aboes/repos/waterflow
```

The flag is per-session and reads the working tree directly — nothing is copied
or pinned, so the skills are whatever the checkout currently says. That is what
makes it the right way to work *on* Waterflow: edit a skill, restart, done.
Worth an alias in any repository you use regularly.

Waterflow needs a git repository: `revision` is the freshness anchor on every
record.

### 2. Conventions, not configuration

Nothing to bind. The skills assume these, and create what they need on first
write:

| | |
|---|---|
| `.waterflow/items/` | work items, local markdown |
| `.waterflow/impressions/` | records, committed beside the code |
| "the owner" | what the prose calls whoever decides |
| the repo's own test command | the default proof |

Override any of them by writing `.waterflow/config.md` yourself — a repository
that already tracks work in Jira or GitHub Issues says so there. Most do not
need the file, and the skills read the conventions when it is absent.

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
# Live records tagged checkout, newest first. Anchored on the list separators
# because tags are kebab-case: a loose match also hits 'checkout-flow'.
grep -rlE 'tags: *\[([^]]*, *)?checkout( *,|\])' .waterflow/impressions/ | sort -r

# ids that have been superseded — exclude these
grep -rh '^supersedes:' .waterflow/impressions/

# is a record stale? non-empty output means yes
git log --oneline <revision>..HEAD -- <scope paths>
```

The payoff is briefing: when you send work to a subagent, pass the live gists
for the subject instead of the conversation.

### 7. The proof gate

Optional, and one copy away. It refuses a commit whose staged files are covered
by a live `fail` record, and warns when a commit makes a recorded `pass` stale.
It reads the store directly and asks no model anything.

```sh
cp /path/to/waterflow/skills/waterflow/proof-gate.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

```sh
WATERFLOW_GATE=warn git commit      # downgrade a refusal to a warning
WATERFLOW_IMPRESSIONS=path/to/store # if impressions are not at the default
```

### A day in it

```
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
ground rules, the authoring standard, validation, the router, the nine
references, ten atoms, four composites, the proof gate, and CI. Nothing has been
carried through the flow on real work yet, which is the next thing that matters
and the only thing that can tell us whether the impression schema is right — see
Gate 1 and Gate 2 in the build plan.

The decisions the rules rest on are tabled in `docs/build-plan.md`, along with
what is still open. Borrowed material is credited in `ATTRIBUTION.md`.

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

MIT.
