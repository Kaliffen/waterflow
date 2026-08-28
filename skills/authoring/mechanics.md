# Skill mechanics

source: mattpocock/skills @ 6654f6b — skills/productivity/writing-for-agents/SKILL-MECHANICS.md (copied, extended)

The skill-specific branch of [authoring](SKILL.md): what changes when the
document is a skill. Everything else about writing it is the universal reference
in `SKILL.md`.

## Frontmatter

Known keys, and the only ones `scripts/check.mjs` accepts:

| Key | Meaning |
|---|---|
| `name` | Must match the directory name. |
| `description` | Model-facing pointer for a model-invoked skill; human-facing one-liner for a user-invoked one. |
| `argument-hint` | Optional. The shape of arguments the skill accepts. |
| `disable-model-invocation` | `true` makes the skill user-invoked. Omit for model-invoked. |
| `allowed-tools` | Optional tool restriction. |
| `source` | Required on borrowed files. See `ATTRIBUTION.md`. |

## Invocation

Two choices, trading the two loads:

- A **model-invoked** skill keeps a `description`, so the agent can fire it
  autonomously and other skills can reach it. The description is a top-level
  context pointer, forced to stay loaded at all times: permanent context load in
  exchange for reachability. Mechanics: omit `disable-model-invocation`, and
  write a description carrying the trigger branches.
- A **user-invoked** skill strips the description from the agent's reach: only
  the human typing its name can invoke it, and no other skill can. Zero context
  load, but it spends cognitive load. Mechanics: set
  `disable-model-invocation: true`; the `description` becomes a human-facing
  one-line summary with trigger lists stripped.

Pick model-invocation only when the agent must reach the skill on its own, or
another skill must. If it only ever fires by hand, make it user-invoked and pay
no context load.

## Atoms and composites

Waterflow's categories, and the mechanical consequence of each. **Two
user-invoked skills cannot call each other**, because neither has a description
for the other to reach. That single fact determines the whole table:

| Category | Invocation | Why |
|---|---|---|
| **Atom** | model-invoked | Composites must be able to call it. An atom without a description is not an atom. |
| **Composite** | user-invoked | An entry point the human types. Pays no context load. |
| **Router** | user-invoked | Also an entry point. It maps the skills; it does not fire them. |

An **atom** performs one operation. A **composite** declares a sequence of atoms
and nothing else: if it accumulates rules of its own, extract them into an atom
rather than letting the composite thicken.

## The description budget

Model-invoked descriptions are the only permanent cost Waterflow imposes on a
consumer's context, in every repo, on every turn. The budget is **11**, enforced
by `scripts/check.mjs`. A twelfth model-invoked skill must displace an existing
one, and that is a decision to take deliberately rather than by accretion.

Before adding one, check whether the material could instead be a reference that
an existing skill points at. A reference costs nothing until it is read.

## Writing a description

For a model-invoked skill the description is routing logic, not marketing copy.
Lead with what the user is trying to do, include phrasings they might actually
say, and add a non-use boundary only where misrouting is realistically common or
costly. A description so broad that it competes with unrelated skills is the
common failure; describing what the skill *contains* instead of when to use it is
the other.
