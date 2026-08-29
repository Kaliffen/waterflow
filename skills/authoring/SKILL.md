---
name: authoring
description: Writing documents agents consume. Use when creating or editing a skill, a reference, or an AGENTS.md / CLAUDE.md.
source: mattpocock/skills @ 6654f6b — skills/productivity/writing-for-agents/SKILL.md (copied, extended)
---

# Authoring

Reference for writing any document an agent consumes: a skill, a reference, an
`AGENTS.md` / `CLAUDE.md`, a doc reached by a pointer. The packaging differs; the
writing does not. The same levers make each one predictable, since the agent
takes the same *process* every run rather than producing the same output.

When the document is a skill, read [mechanics.md](mechanics.md) for frontmatter,
the invocation choice, and Waterflow's atom and composite conventions.

## Context pointers

A **context pointer** is a reference held in the agent's context that names some
out-of-context material and encodes the condition for reaching it. A skill's
description is one; a line in `AGENTS.md` naming a doc is the same object. The
pointer's *wording*, not its target, decides when the agent reaches the material,
and how reliably. A must-have target behind a weakly worded pointer is a variance
bug: sharpen the wording first, and inline the material only if sharpening fails.

A pointer does two jobs: state what the material is, and list the **branches**
that should trigger reaching it. Every word of an always-loaded pointer costs on
every turn, so it earns harder pruning than the body:

- **Front-load the leading word.** The pointer is where it does its triggering
  work.
- **One trigger per branch.** Synonyms that rename a single branch are one branch
  written twice.
- **Cut identity the body already carries.**

## The two loads

Every document and pointer you add spends one of two budgets:

- **Context load** is the cost of always-loaded material on the agent's window:
  a skill description, an `AGENTS.md` line, anything sitting in context every
  turn, spending tokens and attention whether or not it fires.
- **Cognitive load** is the cost on the human: which documents exist and when to
  reach for each. The human is the index. Not a cost to minimise: it is the price
  of human agency. Spend it where human judgement matters, remove it where it
  does not.

Material reached only through a pointer escapes context load at the price of the
pointer's own line. Material with no pointer at all rides entirely on cognitive
load.

## Information hierarchy

A document is built from two content types: **steps** (the ordered actions the
agent performs) and **reference** (definitions, rules, facts consulted on
demand). They mix freely. The core decision is where each piece sits on the
**information hierarchy**, a ladder ranked by how immediately the agent needs it:

1. **In-file step** is the primary tier: what the agent does, in order.
2. **In-file reference** is consulted on demand. Often a legitimately flat
   peer-set, which is a fine arrangement, not a smell.
3. **Disclosed reference** is pushed into a separate file, reached by a pointer,
   loaded only when the pointer fires.

Push too little down and the top bloats; push too much and you hide material the
agent needs. That tension is the whole decision.

**Progressive disclosure** is the move down the ladder so the top stays legible.
Not primarily a token optimisation: it is how the hierarchy is protected.
Branching is the cleanest test: inline what every branch needs, push behind a
pointer what only some branches reach.

**Co-location** is the within-file companion. Where the ladder decides how far
down a piece sits, co-location decides what sits beside it: keep a concept's
definition, rules, and caveats under one heading rather than scattered, so
reading one part brings its neighbours with it.

**Sprawl** is the failure mode: a document simply too long, even when every line
is live. Attention thins across the excess. The cure is the ladder.

## Steps and completion criteria

Every step ends on a **completion criterion**, the condition telling the agent the
work is done. Two properties make it a lever:

- **Clarity**: can the agent tell done from not-done? A vague bound invites
  **premature completion**: ending the step before it is genuinely done, attention
  slipping to *being done*. Defend by sharpening the bound first; only if it is
  irreducibly fuzzy *and* you observe the rush, split the sequence so later steps
  are out of view.
- **Demand**: how much it requires. "Every modified model accounted for" forces
  thorough work where "produce a change list" does not. Demand drives the
  legwork the agent does within the work.

The strongest criteria are both checkable and exhaustive.

## Leading words

A **leading word** is a compact concept already living in the model's pretraining
that the agent thinks with while running the document (*seam*, *tracer bullet*,
*red*). Repeated as a token, never as a sentence, it anchors a whole region of
behaviour in the fewest tokens by recruiting priors the model already holds.

Coining your own works only if you define it clearly, and a made-up word recruits
no priors: you pay in definition tokens what a pretrained word gives free. Reach
for an existing word first. This is the reasoning behind the plain-verb rule
below, and behind refusing the water metaphor in the working vocabulary.

Hunt for passages that collapse into a single token: "fast, deterministic,
low-overhead" becomes *tight*; "a loop you believe in" becomes *red*.

**Negation** is the failure mode beside this lever. Steering by prohibition drags
the forbidden behaviour into context and makes it *more* available, not less.
Prompt the **positive**: state the target behaviour so the banned one is never
spoken. A prohibition earns its place only as a hard guardrail you cannot phrase
positively, and even then pair it with the positive target.

## Pruning

- Keep each meaning in a **single source of truth**. Duplication costs
  maintenance and tokens, and inflates a meaning's rank on the ladder past its
  real one. This is the same rule as Waterflow's "no rule lives in two places".
- The **environment** is a source of truth too (config files, directory layout,
  `--help` output). A document that restates it is a **cache**, earning its load
  only when the lookup is expensive. Cache what the agent cannot find by looking:
  the unwritten convention, the reason behind a choice, the gotcha no config
  confesses.
- Check every line for **relevance**. A line loses it by never bearing on the
  task, or by going stale. Without a pruning discipline the default fate is
  **sediment**: stale layers that settle because adding feels safe and removing
  feels risky.
- Hunt **no-ops** sentence by sentence: an instruction the model already obeys by
  default pays load to say nothing. The test is model-relative, and it is settled
  by running the document, not by debate. When a sentence fails, delete the whole
  sentence rather than trim words from it.

## Waterflow rules

These extend the above and govern any skill written in the Waterflow style.

1. **Plain verbs only.** An atom is named for the operation it performs. The
   product name may carry a metaphor; the working vocabulary may not.
2. **No project-specific roles.** Shipped prose says `the owner` or plain second
   person, never a role belonging to one consumer. Teams set their own label at
   setup.
3. **Composites are thin.** A composite declares a sequence of atoms. Judgement
   belongs in atoms.
4. **Every atom that settles something emits.** Against the single contract in
   [impressions.md](../waterflow/references/impressions.md), which also names
   the one read-half exception. No atom restates the schema.
5. **Borrowed files carry a `source:` line** in frontmatter, naming the upstream
   repository, the commit taken from, the path, and whether it was copied,
   adapted, or cited. The commit is what makes later upstream drift diffable.

A repository shipping these skills will have its own contributor instructions
and its own validation; those are the authority on anything above that is
mechanically checkable.
