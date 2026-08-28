# Topology

source: mattpocock/skills @ 6654f6b — skills/engineering/ask-matt/PHASE-BOUNDARIES.md (adapted)

The Topology dial answers **how many agents, in what shape**. It is decided at a
**boundary**: the gap between one chunk of work and the next. Mid-chunk there is
no decision to make, and switching shape mid-thought loses the thread.

| Value | What it does |
|---|---|
| `inline` | Stay in this context. No switch at all. |
| `subagent` | Send one bounded task to its own context; get a report back. |
| `fan-out` | Several subagents in parallel on independent questions. |
| `background` | A long task that runs while you keep working. |
| `fresh` | Start a new context, seeded deliberately. |

## The tree

Work top to bottom at a boundary. First **yes** wins.

1. **Can you stay inline?** Yes when the next chunk needs this one verbatim, or
   there is simply room. `align` → `build` is the standard yes: implementation
   wants the reasoning as it happened, not a summary of it. Inline costs nothing
   and loses nothing, so rule it out first.
2. **Is this context irrelevant to what comes next?** Then go `fresh` and drop
   it. Cheapest move on the board. Getting it wrong is one-way: you lose the
   *why*, and reading the diff back does not return it.
3. **Are the questions independent?** Two or more things that do not need each
   other's answers go `fan-out`. Dependent questions do not — a fan-out over
   dependent work produces confident, conflicting reports.
4. **Can it run with nobody steering?** Tightly scoped, no judgement calls
   mid-flight, you are not needed while it runs: `subagent`, or `background` if
   it is long enough that waiting wastes your time. Automated review is the
   standard case.
5. **Otherwise stay `inline`** and split the remaining work instead.

## Why the store changes this tree

Every shape except `inline` normally turns a **primary source** — the session as
it happened — into a **secondary** one: a summary, lossy by construction. That
lossiness is the reason step 1 comes first.

Impressions blunt it. What mattered was emitted as a typed record at the moment
it was settled, so it survives the boundary at full fidelity regardless of what
happens to the conversation. The practical effect is that `subagent`, `fan-out`,
and `fresh` are **cheaper than they look**: a cold agent is briefed with the live
records for the subject rather than a pasted transcript.

That is the whole economic argument for the store — see
[impressions.md](impressions.md). Brief with `recall` output, and treat needing
the transcript instead as a signal that something was settled without being
emitted.

## These are judgement calls

None of the questions is objective, and the same boundary can go two ways on two
days. The value is in asking them **in order, at the boundary**, rather than
picking a shape by habit in the middle of the work.
