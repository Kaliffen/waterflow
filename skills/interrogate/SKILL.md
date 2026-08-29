---
name: interrogate
description: Interview the owner in rounds until every open decision is settled. Use before committing to a plan, when facts or decisions are missing, or on any request to stress-test thinking.
source: mattpocock/skills @ 6654f6b — skills/productivity/grilling/SKILL.md (copied, adapted)
---

# Interrogate

One operation: turn a vague intent into a settled set of decisions, by asking
until nothing is silently assumed.

Map the work as a **design tree**: every decision branches into the decisions
hanging off it. The **frontier** is every decision whose prerequisites are
already settled — the questions answerable *now*, without guessing at answers
you have not heard yet.

## Rounds

Ask the whole frontier in one round, through `AskUserQuestion`. The owner walks
the questions in the client, picks per question, and writes free text on any of
them; you get every answer back together. Prose questions in the transcript are
the fallback for a client without the tool.

- **Four per call.** A wider frontier is more calls, back to back, before you
  wait. Answers to a batch never feed the next batch of the same round — that
  dependency makes it a later round.
- **A question is one decision.** `header` is its short label, the question
  itself one sentence.
- **Options are the real candidates**, two to four, each described by what it
  costs and what it buys. Put your recommendation first and mark its label
  `(Recommended)`. Leave the escape hatch to the client, which always offers it.
- **`multiSelect` when the options stack** rather than exclude each other.
- **`preview`** carries the thing being chosen between when it is concrete — a
  layout, a signature, two phrasings of a rule — so the choice is read rather
  than imagined.

Each round's answers reshape the tree: settled decisions push the frontier
outward and unblock what depended on them. Recompute and ask the next round.

## Sweep for doubt

The frontier running dry means the obvious questions are spent, not that the
work is settled. Before you can close, sweep the whole tree once more and name
what each source yields. Every hit is a question in the next round.

| Source | What to hunt |
|---|---|
| **Assumption** | Anything you would act on that the owner never said. |
| **Contradiction** | An answer sitting badly against an earlier one, or against what `recall` returned. |
| **Ambiguity** | A word doing two jobs. Hand it to `define`. |
| **Unoffered** | The candidate you kept off the ballot because it looked unlikely. |
| **Boundary** | What is out of scope, what happens at the edge, what happens when it fails. |
| **Reversibility** | Each decision that will be expensive to undo, confirmed rather than inferred. |

A sweep that yields questions means another round, and the round after it sweeps
again. Ask the uncomfortable one: the cost of a question the owner finds obvious
is one keystroke, and the cost of the assumption it would have replaced is the
rework.

## Closing

Done when a full sweep yields nothing and the owner confirms a readback: the
whole plan in one paragraph, every hard-to-reverse decision in it traceable to
an answer you heard. Do not act on the result until that confirmation lands.

## Facts are yours, decisions are the owner's

Never ask for something you could find. When a frontier question needs a fact
from the environment, go and get it — dispatch a subagent if it is slow. Do not
block on it: a running exploration is an unsettled prerequisite, so only the
questions downstream of it wait. Ask the rest of the frontier now.

Not blocking is not forgetting. The round that needs the fact is the join
point, and the interrogation does not close with an agent still running. The
return leg: [topology.md](../waterflow/references/topology.md).

What is always the owner's, and how to hand a decision over:
[decision-rights.md](../waterflow/references/decision-rights.md).

## Before you start

`recall` the subject. A question the owner already answered is the most
expensive thing you can ask — it spends the one resource the flow cannot
generate. Open the round by saying what is already settled.

## Emit

One record per **settled decision**, `atom: interrogate`, `subject` the thing
decided, `scope: []`. The gist is the decision in one sentence; the detail is
the reasoning and the options rejected. Supersede any earlier record the answer
overturns.

Do not emit for a question that was asked and not answered. Contract:
[impressions.md](../waterflow/references/impressions.md).
