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

Ask the whole frontier in one round. Number each question and give your
recommended answer. Then wait.

```
❓ **Q1** — **<question title>**: <body, including options where there are any>

➡️ <your recommendation, and why>

---

❓ **Q2** — **<question title>**: <body>

➡️ <your recommendation, and why>
```

Each round's answers reshape the tree: settled decisions push the frontier
outward and unblock what depended on them. Recompute and ask the next round. A
question whose answer depends on another question still open in this round
belongs to a **later** round, not this one.

Done when the frontier is empty. Do not act on the result until the owner
confirms you have reached shared understanding.

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
